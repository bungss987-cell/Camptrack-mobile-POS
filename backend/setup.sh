#!/bin/bash

echo "======================================"
echo "  CampTrack Backend Setup Script"
echo "======================================"
echo ""

# 1. Check if .env exists
if [ ! -f .env ]; then
  echo "📝 File .env tidak ditemukan. Membuat dari template..."
  cat > .env << EOF
DATABASE_URL="postgresql://postgres:admin123@localhost:5432/camptrack_db"
PORT=3000
WS_PORT=3001
NODE_ENV=development
JWT_SECRET=camptrack_jwt_secret_key_production_2024
EOF
  echo "✅ File .env dibuat. EDIT password database jika perlu!"
  echo ""
else
  echo "✅ File .env sudah ada"
fi

# 2. Install dependencies
echo ""
echo "📦 Installing dependencies..."
npm install

# 3. Generate Prisma Client
echo ""
echo "🔧 Generating Prisma Client..."
npx prisma generate

# 4. Run migrations
echo ""
echo "🗄️  Running database migrations..."
npx prisma migrate deploy

# 5. Run seed
echo ""
echo "🌱 Seeding database..."
node prisma/seed.js

echo ""
echo "======================================"
echo "  ✅ Setup Selesai!"
echo "======================================"
echo ""
echo "Jalankan backend dengan:"
echo "  npm run dev"
echo ""
echo "Login demo:"
echo "  Email:    demo@camptrack.id"
echo "  Password: 123456"
echo ""
