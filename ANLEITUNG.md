# Hausaufgaben V&M – einrichten

Einmalig ca. 20 Minuten. Danach braucht die andere Person **kein Konto**, nur den Link und euer Passwort.

Was du brauchst: einen Laptop, deine Gmail-Adresse und diesen Ordner `hausaufgaben-app`.

---

## Schritt 1: Datenbank (Supabase, kostenlos)

1. Geh auf **supabase.com** → „Start your project“ → mit GitHub oder E-Mail anmelden.
   (Am einfachsten: zuerst Schritt 2.1 machen und dich dann bei Supabase mit „Continue with GitHub“ anmelden.)
2. **New project**: Name `hausaufgaben`, ein beliebiges Datenbank-Passwort (brauchst du später nicht), Region **Central EU (Frankfurt)** → „Create new project“. Kurz warten.
3. Links **SQL Editor** → „New query“ → den kompletten Inhalt der Datei **`setup.sql`** hineinkopieren → **Run**. Es muss „Success“ erscheinen.
4. Links **Authentication** → **Users** → **Add user** → **Create new user**:
   - E-Mail: `v-und-m@hausaufgaben.app` (genau so, die gibt es nicht wirklich, das ist Absicht)
   - Passwort: **euer gemeinsames Passwort**, mindestens 10 Zeichen, z. B. drei Wörter
   - Haken bei **Auto Confirm User** setzen → „Create user“
5. **Authentication** → **Sign In / Providers** (oder „Settings“) → **Allow new users to sign up** ausschalten → Speichern.
   So kann sich niemand Fremdes ein eigenes Konto anlegen.
6. Links unten **Project Settings** → **API Keys** bzw. **Data API**. Kopiere:
   - die **Project URL** (sieht aus wie `https://abcdxyz.supabase.co`)
   - den **anon public** Key (falls nicht direkt sichtbar: Reiter **Legacy API Keys**; beginnt mit `eyJ`)
7. Öffne die Datei **`config.js`** mit dem Editor (Rechtsklick → Öffnen mit → Editor) und ersetze
   `https://DEIN-PROJEKT.supabase.co` und `DEIN-ANON-KEY` durch deine Werte. Speichern.

---

## Schritt 2: Website online stellen (GitHub Pages, kostenlos)

1. Auf **github.com** ein kostenloses Konto anlegen.
2. Oben rechts **+** → **New repository**: Name `hausaufgaben`, **Public**, → „Create repository“.
3. Auf der neuen Seite auf **„uploading an existing file“** klicken und **alle Dateien und Ordner** aus `hausaufgaben-app` in das Fenster ziehen
   (auch die Ordner `scripts` und `.github`) → unten **Commit changes**.
   - Falls der Ordner `.github` nicht mit hochgeladen wird: **Add file → Create new file**, als Namen
     `.github/workflows/erinnerungen.yml` eintippen, den Inhalt der gleichnamigen Datei hineinkopieren, **Commit changes**.
4. **Settings** → **Pages** → bei „Source“ **Deploy from a branch**, Branch **main**, Ordner **/ (root)** → **Save**.
5. Nach 1–2 Minuten steht oben der Link, z. B. `https://deinname.github.io/hausaufgaben/`. Das ist eure Website.

---

## Schritt 3: Tägliche Erinnerung einschalten

1. Im Repository: **Settings** → **Secrets and variables** → **Actions** → **New repository secret**
   - Name: `APP_PASSWORD`
   - Wert: euer gemeinsames Passwort aus Schritt 1.4 → „Add secret“
2. **Erst die Website einmal öffnen und anmelden** (dabei wird der Benachrichtigungs-Kanal angelegt).
3. Dann oben auf **Actions** → links **Tägliche Erinnerungen** → **Run workflow** → grün = klappt.
   (Falls GitHub fragt, ob Workflows erlaubt sind: bestätigen.)

Ab jetzt kommt jeden Nachmittag (ca. 17 Uhr im Sommer, 16 Uhr im Winter) eine Nachricht, aber nur, wenn etwas ansteht.

---

## Schritt 4: Benachrichtigungen aufs Handy (ntfy, kostenlos, ohne Konto)

Jede Person macht das auf ihrem eigenen Handy:

1. App **ntfy** installieren (Play Store oder App Store).
2. Website öffnen → Passwort eingeben → „Ich bin V“ bzw. „Ich bin M“ wählen.
3. **Einstellungen** (unten „Mehr“) → Abschnitt „Nachrichten aufs Handy“ → **Kopieren** beim Kanal.
4. In ntfy auf **+** tippen → Kanalnamen einfügen → **Subscribe**.
5. Zurück auf der Website: **Test-Nachricht an mich senden**. Die Nachricht muss nach ein paar Sekunden auf dem Handy erscheinen.

Am Laptop: den Link `ntfy.sh/…` aus den Einstellungen öffnen, abonnieren und Benachrichtigungen im Browser erlauben.

**Tipp:** Die Website lässt sich wie eine App auf den Startbildschirm legen
(iPhone: Safari → Teilen → „Zum Home-Bildschirm“; Android: Chrome → ⋮ → „App installieren“).

---

## Schritt 5: Mit der anderen Person teilen

Schick ihr den Link aus Schritt 2.5 und sag ihr das Passwort. Fertig, sie braucht kein Konto.

---

## Gut zu wissen

- **Kosten:** alles kostenlos. Supabase: 500 MB Daten und 1 GB Dateien. Fotos werden vor dem Hochladen verkleinert.
- **Supabase pausiert** kostenlose Projekte nach einer Woche ohne Nutzung. Die tägliche Erinnerung greift jeden Tag auf die Datenbank zu und hält sie dadurch wach.
- **GitHub stoppt** die tägliche Erinnerung, wenn 60 Tage lang nichts am Repository geändert wurde, und schickt dir dann eine E-Mail. Ein Klick auf „Enable workflow“ unter **Actions** schaltet sie wieder ein.
- **Passwort ändern:** Supabase → Authentication → Users → Nutzer → „Reset password“ bzw. neues Passwort setzen, und das Secret `APP_PASSWORD` auf GitHub anpassen.
- **Kanalnamen geheim halten:** Wer ihn kennt, könnte eure Benachrichtigungen mitlesen.
