# CampTrack Mobile POS

Aplikasi penyewaan alat camping dengan mobile app (Flutter) dan backend API (Node.js + Express + Prisma + PostgreSQL).

## Prasyarat

- **Node.js** v18+ 
- **PostgreSQL** v14+
- **Flutter** v3.7+
- **Dart** v3.0+

## Quick Start

### 1. Buat Database PostgreSQL

```bash
psql -U postgres
CREATE DATABASE camptrack_db;
\q
```

### 2. Setup Backend

```bash
cd backend

# Copy environment file
cp .env.example .env
# Edit .env sesuaikan password PostgreSQL kamu

# Install dependencies
npm install

# Jalankan setup (migrate + seed)
npm run setup

# Jalankan server
npm run dev
```

Server berjalan di `http://localhost:3000`

**Atau gunakan script otomatis:**
- Linux/Mac: `chmod +x setup.sh && ./setup.sh`
- Windows: double-click `setup.bat`

### 3. Setup Mobile App

```bash
cd mobile

# Install dependencies
flutter pub get

# Jalankan aplikasi
flutter run
```

### 4. Login Demo

| Field | Value |
|-------|-------|
| Email | `demo@camptrack.id` |
| Password | `123456` |

## Konfigurasi Base URL (Mobile)

Edit `mobile/lib/config/app_config.dart`:

| Device | URL |
|--------|-----|
| Android Emulator | `http://10.0.2.2:3000/api` (default) |
| iOS Simulator | `http://localhost:3000/api` |
| HP Fisik | `http://IP_KOMPUTER:3000/api` |

## API Endpoints

| Method | Endpoint | Auth | Deskripsi |
|--------|----------|------|-----------|
| POST | `/api/auth/register` | ❌ | Registrasi user baru |
| POST | `/api/auth/login` | ❌ | Login |
| GET | `/api/auth/profile` | ✅ | Get profile |
| PUT | `/api/auth/profile` | ✅ | Update profile |
| GET | `/api/assets` | ❌ | List semua aset |
| GET | `/api/assets/:id` | ❌ | Detail aset |
| GET | `/api/transactions` | ✅ | List transaksi user |
| POST | `/api/transactions` | ✅ | Buat transaksi baru |
| PUT | `/api/transactions/:id/pay` | ✅ | Proses pembayaran |
| PUT | `/api/transactions/:id/return` | ✅ | Proses pengembalian |
| GET | `/api/shipment/:tracking` | ❌ | Tracking pengiriman |
| GET | `/api/dashboard` | ❌ | Dashboard stats |

## Scripts Backend

```bash
npm run dev      # Jalankan development server
npm run setup    # Migrate + Seed
npm run migrate  # Buat migration baru
npm run seed     # Jalankan seed data
npm run reset    # Reset database + seed ulang
```

## Tech Stack

- **Mobile**: Flutter, Provider, SharedPreferences
- **Backend**: Node.js, Express 5, Prisma ORM
- **Database**: PostgreSQL
- **Auth**: bcrypt + JWT
- **Real-time**: WebSocket
