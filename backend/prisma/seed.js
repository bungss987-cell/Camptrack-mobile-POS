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
  // 3. Buat Contoh Transaksi + Shipment
  // ===========================
  const existingTransaction = await prisma.transaction.findFirst({
    where: { customerName: 'Demo User' },
  });

  if (!existingTransaction) {
    // Transaksi 1: Sedang berlangsung, sudah dibayar, dalam pengiriman
    const trx1 = await prisma.transaction.create({
      data: {
        invoiceNumber: 'INV-DEMO-001',
        customerName: 'Demo User',
        customerPhone: '081234567890',
        customerAddress: 'Jl. Camping No. 1, Bandung',
        assetId: 1, // Tenda Dome
        userId: demoUser.id,
        quantity: 1,
        startDate: new Date(),
        endDate: new Date(Date.now() + 3 * 24 * 60 * 60 * 1000), // 3 hari dari sekarang
        totalCost: 225000, // 75000 x 3 hari
        shippingCost: 15000,
        paymentMethod: 'QRIS',
        paymentStatus: 'SUCCESS',
        paidAmount: 225000,
        paymentTime: new Date(),
        transactionStatus: 'ONGOING',
      },
    });

    // Shipment untuk transaksi 1 - status IN_TRANSIT
    await prisma.shipment.create({
      data: {
        transactionId: trx1.id,
        trackingNumber: 'CT-DEMO-001',
        courierName: 'JNE',
        recipientName: 'Demo User',
        recipientPhone: '081234567890',
        deliveryAddress: 'Jl. Camping No. 1, Bandung',
        shippingCost: 15000,
        status: 'IN_TRANSIT',
        latitude: -6.9175,
        longitude: 107.6191,
        notes: 'Paket sedang dalam perjalanan ke Bandung',
      },
    });

    // Transaksi 2: Sudah selesai, sudah dikirim
    const trx2 = await prisma.transaction.create({
      data: {
        invoiceNumber: 'INV-DEMO-002',
        customerName: 'Demo User',
        customerPhone: '081234567890',
        customerAddress: 'Jl. Camping No. 1, Bandung',
        assetId: 2, // Sleeping Bag
        userId: demoUser.id,
        quantity: 2,
        startDate: new Date(Date.now() - 7 * 24 * 60 * 60 * 1000), // 7 hari lalu
        endDate: new Date(Date.now() - 4 * 24 * 60 * 60 * 1000), // 4 hari lalu
        actualReturnDate: new Date(Date.now() - 4 * 24 * 60 * 60 * 1000),
        totalCost: 210000, // 35000 x 3 hari x 2
        shippingCost: 10000,
        paymentMethod: 'Transfer',
        paymentStatus: 'SUCCESS',
        paidAmount: 210000,
        paymentTime: new Date(Date.now() - 7 * 24 * 60 * 60 * 1000),
        transactionStatus: 'COMPLETED',
        grandTotal: 210000,
      },
    });

    // Shipment untuk transaksi 2 - status DELIVERED
    await prisma.shipment.create({
      data: {
        transactionId: trx2.id,
        trackingNumber: 'CT-DEMO-002',
        courierName: 'SiCepat',
        recipientName: 'Demo User',
        recipientPhone: '081234567890',
        deliveryAddress: 'Jl. Camping No. 1, Bandung',
        shippingCost: 10000,
        status: 'DELIVERED',
        latitude: -6.9175,
        longitude: 107.6191,
        notes: 'Paket telah diterima oleh penerima',
      },
    });

    // Transaksi 3: Baru dibuat, belum bayar, pending shipment
    const trx3 = await prisma.transaction.create({
      data: {
        invoiceNumber: 'INV-DEMO-003',
        customerName: 'Demo User',
        customerPhone: '081234567890',
        customerAddress: 'Jl. Camping No. 1, Bandung',
        assetId: 5, // Hammock
        userId: demoUser.id,
        quantity: 1,
        startDate: new Date(Date.now() + 1 * 24 * 60 * 60 * 1000), // besok
        endDate: new Date(Date.now() + 4 * 24 * 60 * 60 * 1000), // 4 hari lagi
        totalCost: 80000, // 20000 x 4 hari
        shippingCost: 10000,
        paymentMethod: null,
        paymentStatus: 'PENDING',
        paidAmount: 0,
        paymentTime: null,
        transactionStatus: 'ONGOING',
      },
    });

    // Shipment untuk transaksi 3 - status PENDING
    await prisma.shipment.create({
      data: {
        transactionId: trx3.id,
        trackingNumber: 'CT-DEMO-003',
        courierName: 'JNT',
        recipientName: 'Demo User',
        recipientPhone: '081234567890',
        deliveryAddress: 'Jl. Camping No. 1, Bandung',
        shippingCost: 10000,
        status: 'PENDING',
        notes: 'Menunggu pembayaran sebelum pengiriman',
      },
    });

    console.log('✅ 3 contoh transaksi + shipment ditambahkan');
    console.log('   - CT-DEMO-001: Status IN_TRANSIT (dalam perjalanan)');
    console.log('   - CT-DEMO-002: Status DELIVERED (terkirim)');
    console.log('   - CT-DEMO-003: Status PENDING (menunggu)');
  } else {
    console.log('ℹ️  Contoh transaksi sudah ada, skip.');
  }

  // ===========================
  // Selesai
  // ===========================
  console.log('\n🎉 Seeding selesai!');
  console.log('─────────────────────────────────────────────');
  console.log('📧 Login demo:    demo@camptrack.id');
  console.log('🔑 Password:      123456');
  console.log('');
  console.log('📦 Tracking demo:');
  console.log('   CT-DEMO-001 → Dalam Perjalanan');
  console.log('   CT-DEMO-002 → Terkirim');
  console.log('   CT-DEMO-003 → Menunggu Pickup');
  console.log('─────────────────────────────────────────────');
}

main()
  .catch((e) => {
    console.error('❌ Error saat seeding:', e);
    process.exit(1);
  })
  .finally(() => prisma.$disconnect());
