# Add the brand film to the About page of wblegacyholdings.com

Approved by the site owner. Do every step; stop and report if any step fails twice.

## Facts
- Netlify project `preeminent-choux-76f41f`, site ID `420cc8f6-be0b-4e9a-99de-7bf07cc42acb`.
  Deploys page: https://app.netlify.com/projects/preeminent-choux-76f41f/deploys
- Plain static HTML, deployed by drag-and-drop (no Git, no build command).
  Current published deploy: `6b02f69de092c319f782780c`.
- The deploy has about 12 HTML pages plus `_redirects` (12 rules) and `_headers` (2 rules).
  **These must survive unchanged. Never rebuild the site from the public pages.**

## Files in this folder
- `assets/brand-film.mp4` (1080p), `assets/brand-film-720.mp4` (720p), `assets/brand-film-poster.jpg`
- `about-section.html`: the section to insert
- `about-section.css`: CSS to add to about.html's `<style>` block
- `SHA256SUMS`: verify with `shasum -a 256 -c SHA256SUMS` (run inside this folder)

Get them: `git clone --depth 1 -b website-brand-film https://github.com/WBLHLLC/WBLHLLC wb-brand-film`

## Steps
1. **Copy the live site exactly.** In Chrome (Claude in Chrome extension; the owner is logged in to Netlify),
   open the deploys page, open the top **Published** deploy, click **Download** then **Download ready**.
   Unzip into a new folder, e.g. `~/wb-site-current`. Confirm it has `about.html`, `index.html`,
   `_redirects` and `_headers`, and count the rules in each.
2. **Make the change in a copy** (`cp -R ~/wb-site-current ~/wb-site-new`):
   - copy the three files from `assets/` here into `~/wb-site-new/assets/`
   - in `about.html`, insert the contents of `about-section.html` immediately before the FIRST
     `<section class="band-stone">` (the "How we operate" section, right after the `page-hero` section)
   - append the contents of `about-section.css` just before the first `</style>` in `about.html`
3. **Check:** `diff -r ~/wb-site-current ~/wb-site-new` must show only `about.html` changed plus 3 new
   asset files; `_redirects` and `_headers` byte-identical.
4. **Draft deploy:** `npx netlify-cli deploy --dir ~/wb-site-new --site 420cc8f6-be0b-4e9a-99de-7bf07cc42acb`
   (run `npx netlify-cli login` first if asked). Open the draft URL in Chrome: `/about` shows the
   "Our story / Building what lasts." video and it plays; `/`, `/businesses` and `/contact` still load.
5. **Publish:** the same command with `--prod`. Don't use the dashboard rollback or publish older deploys.
6. **Verify live:** https://wblegacyholdings.com/about shows and plays the video; spot-check two rules
   from `_redirects`.
7. Report the draft and live URLs and what was verified. Close any browser tabs you opened.
