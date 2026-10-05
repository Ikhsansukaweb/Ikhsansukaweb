#!/bin/bash
# One-shot: setup GitHub profile (repo Ikhsansukaweb/Ikhsansukaweb) + bio + topics
set -e
export PATH="$HOME/.local/bin:$PATH"
GH_TOKEN=$(cat /tmp/ghtoken.txt)
export GH_TOKEN

echo "=== 1. Auth check ==="
gh auth status 2>&1 | head -5 || true

echo
echo "=== 2. Buat repo profil (publik) ==="
if gh repo view Ikhsansukaweb/Ikhsansukaweb >/dev/null 2>&1; then
  echo "repo sudah ada"
else
  gh repo create Ikhsansukaweb/Ikhsansukaweb --public \
    --description "👋 Hi, I'm isan — Full-Stack Developer from Yogyakarta, Indonesia"
fi

echo
echo "=== 3. Push README profil ==="
cd /home/ikhsan/Documents/github-profile
git remote remove origin 2>/dev/null || true
git remote add origin git@github.com:Ikhsansukaweb/Ikhsansukaweb.git
git add -A
git commit -m "docs: profil GitHub README" 2>&1 | tail -2 || echo "(tidak ada perubahan)"
git push -u origin main --force 2>&1 | tail -5

echo
echo "=== 4. Update bio, name, blog, social ==="
gh api -X PATCH /user \
  -f name="isan" \
  -f bio="Full-Stack Developer · TypeScript, Next.js, Node.js, Flutter · Yogyakarta, Indonesia 🇮🇩" \
  -f blog="https://github.com/Ikhsansukaweb" \
  -f location="Yogyakarta, Indonesia" \
  -f hireable=true >/dev/null && echo "bio updated"

echo
echo "=== 5. Set topics repo unggulan ==="
gh repo edit Ikhsansukaweb/casino --add-topic minecraft --add-topic bot --add-topic casino --add-topic bedrock --add-topic javascript 2>&1 | tail -1
gh repo edit Ikhsansukaweb/skadesmart --add-topic typescript --add-topic nextjs --add-topic ecommerce 2>&1 | tail -1
gh repo edit Ikhsansukaweb/isan --add-topic typescript --add-topic streaming --add-topic nextjs 2>&1 | tail -1
gh repo edit Ikhsansukaweb/Portfolio --add-topic portfolio --add-topic javascript 2>&1 | tail -1

echo
echo "=== 6. Deskripsi repo yang kosong ==="
gh repo edit Ikhsansukaweb/skadesmart -d "Aplikasi marketplace / e-commerce (TypeScript + Next.js)" 2>&1 | tail -1
gh repo edit Ikhsansukaweb/isan -d "Platform streaming anime & film (TypeScript + Next.js)" 2>&1 | tail -1
gh repo edit Ikhsansukaweb/Portfolio -d "Website portofolio pribadi" 2>&1 | tail -1

echo
echo "=== 7. Hapus token dari disk ==="
shred -u /tmp/ghtoken.txt /tmp/ghdev.json 2>/dev/null || rm -f /tmp/ghtoken.txt /tmp/ghdev.json

echo
echo "SELESAI ✅"
