# Shredder

Shared calorie/macro tracker for two people. Single-file app (`shredder.html`) backed by Supabase.

## Setup

1. **Database**: In your Supabase project, open SQL Editor → New query → paste the contents of `schema.sql` → Run.
   This creates the `config`, `foods`, and `logs` tables with public read/write policies.

2. **App**: `shredder.html` already points at your Supabase project URL and anon key (near the top of the `<script>` block, `SUPABASE_URL` / `SUPABASE_KEY`). No build step — open the file directly in a browser, or host it as a static file (e.g. GitHub Pages).

3. **First load**: on first run with an empty `foods` table, the app seeds it from the built-in spreadsheet import (`SEED_FOODS`). After that, all changes go straight to Supabase.

## Notes on this version vs the original

- **Data lives in Supabase, not `window.storage`.** Anyone with the anon key (i.e. anyone with the app URL) can read/write — there's no per-user auth, matching the original shared-storage behavior.
- **Plate logging is now split at the plate-total level.** Committing a plate creates one log row per person (their share of the whole plate's calories/macros), not one row per ingredient per person. Items assigned to one person only are added to their row; items marked "shared" are split by the slider percentage.
- **Honey-unit and one-off seeding fixes from the old version were dropped** — not needed once the data lives in a real database you can inspect/edit directly in Supabase's table editor.
- Everything else (config, targets, batch cook, today/week views, CSV export, JSON backup/restore) works the same as before, just reading/writing Supabase instead of local shared storage.

## Viewing/editing raw data like a spreadsheet

Supabase's dashboard → Table Editor gives you a spreadsheet-style grid view of `config`, `foods`, and `logs` — useful for bulk edits or spot-checking without going through the app UI.

## Backup/restore

The in-app "Data" tab still exports/imports a full JSON backup and CSV export, now reading from and writing to Supabase.
