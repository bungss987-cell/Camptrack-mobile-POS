const { PrismaClient } = require('@prisma/client');
const bcrypt = require('bcrypt');

const prisma = new PrismaClient();

async function main() {
  console.log('🌱 Mulai seeding database...\n');

  // ===========================
  // 1. Buat User Demo
  // ===========================
  const hashedPassword = await bcrypt.hash('123456', 12);

  const demoUser = await prisma.user.upsert({
    where: { email: 'demo@camptrack.id' },
    update: {},
    create: {
      name: 'Demo User',
      email: 'demo@camptrack.id',
      password: hashedPassword,
      phone: '081234567890',
      address: 'Jl. Camping No. 1, Bandung',
    },
  });

  console.log(`✅ User demo dibuat: ${demoUser.email} (password: 123456)`);

  // ===========================
  // 2. Buat Data Aset Camping
  // ===========================
  const assets = [
    {
      name: 'Tenda Dome 4 Orang',
      description: 'Tenda kapasitas 4 orang, waterproof, mudah dipasang. Cocok untuk camping keluarga.',
      stock: 10,
      rentalPrice: 75000,
    },
    {
      name: 'Sleeping Bag Outdoor',
      description: 'Sleeping bag tebal untuk suhu dingin hingga 5°C. Bahan polar fleece.',
      stock: 15,
      rentalPrice: 35000,
    },
    {
      name: 'Kompor dan Gas',
      description: 'Kompor portable dengan tabung gas kecil. Nyala api stabil untuk masak outdoor.',
      stock: 8,
      rentalPrice: 25000,
    },
    {
      name: 'Carrier 60L',
      description: 'Tas carrier 60 liter untuk hiking. Dilengkapi rain cover dan frame aluminium.',
      stock: 12,
      rentalPrice: 50000,
    },
    {
      name: 'Hammock Outdoor',
      description: 'Hammock parasut dengan tali. Kapasitas hingga 150kg, ringan dan compact.',
      stock: 20,
      rentalPrice: 20000,
    },
    {
      name: 'Kursi Lipat',
      description: 'Kursi lipat portable untuk camping. Rangka aluminium, ringan dan kuat.',
      stock: 15,
      rentalPrice: 15000,
    },
    {
      name: 'Matras Camp',
      description: 'Matras foam anti air untuk tidur outdoor. Tebal 2cm, nyaman dan hangat.',
      stock: 18,
      rentalPrice: 20000,
    },
    {
      name: 'Senter',
      description: 'Senter LED terang tahan air. Baterai rechargeable, 3 mode cahaya.',
      stock: 25,
      rentalPrice: 10000,
    },
    {
      name: 'Jacket',
      description: 'Jaket outdoor waterproof windbreaker. Ringan, tahan angin dan hujan ringan.',
      stock: 10,
      rentalPrice: 40000,
    },
    {
      name: 'Tracking pool',
      description: 'Trekking pole adjustable untuk pendakian. Anti-shock, grip nyaman.',
      stock: 14,
      rentalPrice: 25000,
    },
  ];

  let assetCount = 0;
  for (const asset of assets) {
    await prisma.asset.upsert({
      where: { id: assetCount + 1 },
      update: asset,
      create: asset,
    });
    assetCount++;
  }

  console.log(`✅ ${assetCount} aset camping ditambahkan`);

  // ===========================
  // Selesai
  // ===========================
  console.log('\n🎉 Seeding selesai!');
  console.log('─────────────────────────────────');
  console.log('📧 Login demo: demo@camptrack.id');
  console.log('🔑 Password:   123456');
  console.log('─────────────────────────────────');
}

main()
  .catch((e) => {
    console.error('❌ Error saat seeding:', e);
    process.exit(1);
  })
  .finally(() => prisma.$disconnect());
