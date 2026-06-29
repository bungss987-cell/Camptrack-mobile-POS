@echo off
echo ======================================
echo   CampTrack Backend Setup Script
echo ======================================
echo.

:: 1. Check if .env exists
if not exist .env (
  echo [INFO] File .env tidak ditemukan. Membuat dari template...
  (
    echo DATABASE_URL="postgresql://postgres:admin123@localhost:5432/camptrack_db"
    echo PORT=3000
    echo WS_PORT=3001
    echo NODE_ENV=development
    echo JWT_SECRET=camptrack_jwt_secret_key_production_2024
  ) > .env
  echo [OK] File .env dibuat. EDIT password database jika perlu!
  echo.
) else (
  echo [OK] File .env sudah ada
)

:: 2. Install dependencies
echo.
echo [INFO] Installing dependencies...
call npm install

:: 3. Generate Prisma Client
echo.
echo [INFO] Generating Prisma Client...
call npx prisma generate

:: 4. Run migrations
echo.
echo [INFO] Running database migrations...
call npx prisma migrate deploy

:: 5. Run seed
echo.
echo [INFO] Seeding database...
call node prisma/seed.js

echo.
echo ======================================
echo   Setup Selesai!
echo ======================================
echo.
echo Jalankan backend dengan:
echo   npm run dev
echo.
echo Login demo:
echo   Email:    demo@camptrack.id
echo   Password: 123456
echo.
pause
