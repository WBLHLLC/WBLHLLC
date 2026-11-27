#!/usr/bin/env bash
# Usage: apply-brand-film.sh <unzipped-current-deploy-dir> <brand-film-dir> <new-output-dir>
# Copies the current deploy, adds the 3 video assets, patches about.html, and runs the checks.
# Refuses to continue if _redirects or _headers are missing.
set -euo pipefail
CUR="$1"; BF="$2"; NEW="$3"

for f in about.html index.html _redirects _headers; do
  [ -f "$CUR/$f" ] || { echo "STOP: $CUR/$f missing - not a full deploy copy"; exit 1; }
done
echo "_redirects rules: $(grep -cvE '^\s*(#|$)' "$CUR/_redirects")  (expect 12)"
echo "_headers path blocks: $(grep -cE '^/' "$CUR/_headers")  (expect 2)"

(cd "$BF" && { sha256sum -c SHA256SUMS 2>/dev/null || shasum -a 256 -c SHA256SUMS; })
[ -e "$NEW" ] && { echo "STOP: $NEW already exists"; exit 1; }
cp -a "$CUR" "$NEW"
mkdir -p "$NEW/assets"
cp "$BF/assets/brand-film.mp4" "$BF/assets/brand-film-720.mp4" "$BF/assets/brand-film-poster.jpg" "$NEW/assets/"

python3 - "$NEW/about.html" "$BF/about-section.html" "$BF/about-section.css" <<'PY'
import sys
p, sec, css = sys.argv[1:]
h = open(p, encoding="utf-8").read()
sec = open(sec, encoding="utf-8").read().rstrip("\n") + "\n"
css = open(css, encoding="utf-8").read().strip()
a = '<section class="band-stone">'
assert 'class="film"' not in h, "film section already present"
assert a in h and '</style>' in h and '<section class="page-hero">' in h, "anchor missing"
assert h.index('<section class="page-hero">') < h.index(a), "hero not before band-stone"
h = h.replace(a, sec + a, 1).replace('</style>', css + '</style>', 1)
open(p, "w", encoding="utf-8").write(h)
print("about.html patched")
PY

echo "--- diff -rq (expect: about.html differs + 3 files only in new/assets) ---"
diff -rq "$CUR" "$NEW" || true
cmp "$CUR/_redirects" "$NEW/_redirects" && cmp "$CUR/_headers" "$NEW/_headers" && echo "_redirects/_headers byte-identical"
