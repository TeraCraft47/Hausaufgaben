-- Hausaufgaben V&M: Datenbank einrichten.
-- Komplett in Supabase unter "SQL Editor" einfügen und auf "Run" klicken.
-- Kann gefahrlos mehrmals ausgeführt werden.

-- 1) Alle Einträge liegen in einer Tabelle: path (z. B. "items/abc") -> data (JSON)
create table if not exists public.docs (
  path text primary key,
  coll text not null,
  data jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);
create index if not exists docs_coll_idx on public.docs (coll);

-- 2) Nur dieses eine Login-Konto darf lesen und schreiben (muss zu config.js passen)
create table if not exists public.app_users (email text primary key);
insert into public.app_users (email) values ('v-und-m@hausaufgaben.app') on conflict do nothing;
alter table public.app_users enable row level security;

create or replace function public.is_app_user() returns boolean
language sql stable security definer set search_path = public as $$
  select exists (select 1 from public.app_users where email = lower(coalesce(auth.jwt() ->> 'email', '')));
$$;

alter table public.docs enable row level security;
drop policy if exists docs_all on public.docs;
create policy docs_all on public.docs for all to authenticated
  using (public.is_app_user()) with check (public.is_app_user());

-- 3) Teil-Updates (z. B. nur das Häkchen von V), ohne Änderungen von M zu überschreiben
create or replace function public.jsonb_deep_merge(a jsonb, b jsonb) returns jsonb
language plpgsql immutable as $$
declare k text; v jsonb; r jsonb;
begin
  if a is null or jsonb_typeof(a) <> 'object' or jsonb_typeof(b) <> 'object' then return b; end if;
  r := a;
  for k, v in select * from jsonb_each(b) loop
    if jsonb_typeof(r -> k) = 'object' and jsonb_typeof(v) = 'object' then
      r := r || jsonb_build_object(k, public.jsonb_deep_merge(r -> k, v));
    else
      r := r || jsonb_build_object(k, v);
    end if;
  end loop;
  return r;
end $$;

create or replace function public.merge_doc(p_path text, p_patch jsonb) returns void
language plpgsql security invoker as $$
begin
  update public.docs set data = public.jsonb_deep_merge(data, p_patch), updated_at = now() where path = p_path;
  if not found then raise exception 'Eintrag % nicht gefunden', p_path; end if;
end $$;

-- 4) Live-Synchronisierung einschalten
do $$
begin
  if not exists (select 1 from pg_publication_tables where pubname = 'supabase_realtime' and schemaname = 'public' and tablename = 'docs') then
    alter publication supabase_realtime add table public.docs;
  end if;
end $$;

-- 5) Privater Speicher für Fotos und PDFs (max. 20 MB pro Datei)
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('files', 'files', false, 20971520, array['image/jpeg','image/png','image/webp','image/gif','application/pdf'])
on conflict (id) do update set public = false, file_size_limit = excluded.file_size_limit, allowed_mime_types = excluded.allowed_mime_types;

drop policy if exists files_read on storage.objects;
drop policy if exists files_insert on storage.objects;
drop policy if exists files_delete on storage.objects;
create policy files_read on storage.objects for select to authenticated using (bucket_id = 'files' and public.is_app_user());
create policy files_insert on storage.objects for insert to authenticated with check (bucket_id = 'files' and public.is_app_user());
create policy files_delete on storage.objects for delete to authenticated using (bucket_id = 'files' and public.is_app_user());
