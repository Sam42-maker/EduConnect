const mysql = require('mysql2/promise');
require('dotenv').config();
const sequelize = require('./src/config/database');
const User = require('./src/models/User');
const bcrypt = require('bcryptjs');

async function initializeDatabase() {
  try {
    console.log('⏳ Menyambungkan ke MySQL XAMPP...');
    // 1. Buat koneksi ke MySQL XAMPP dasar (tanpa memilih database dulu)
    const connection = await mysql.createConnection({
      host: process.env.DB_HOST || 'localhost',
      port: process.env.DB_PORT || 3306,
      user: process.env.DB_USER || 'root',
      password: process.env.DB_PASSWORD || ''
    });

    // 2. Buat database jika belum ada
    console.log('⏳ Membuat database educonnect_db (jika belum ada)...');
    await connection.query(`CREATE DATABASE IF NOT EXISTS \`${process.env.DB_NAME || 'educonnect_db'}\`;`);
    console.log('✅ Database educonnect_db siap!');
    
    // 3. Sinkronisasi tabel menggunakan Sequelize
    console.log('⏳ Sinkronisasi tabel Users ke dalam database...');
    // 'force: true' akan mereset tabel jika sudah ada. Cocok untuk awal testing.
    await sequelize.sync({ force: true }); 
    console.log('✅ Tabel Users berhasil dibuat.');

    // 4. Memasukkan Data Dummy (Silakan ubah email/password di bawah ini jika mau)
    console.log('⏳ Memasukkan data akun testing...');
    const salt = await bcrypt.genSalt(10);
    
    // GANTI PASSWORD DI BAWAH INI SESUAI KEINGINAN ANDA:
    const hashedPassword = await bcrypt.hash('password123', salt); 

    await User.create({
      fullName: 'Shandy Developer',
      email: 'shandy@educonnect.com', // GANTI EMAIL DI SINI
      password: hashedPassword,
      role: 'Student',
      isVerified: true, // Langsung kita anggap terverifikasi agar bisa login
      university: 'Universitas Indonesia',
      major: 'Teknik Informatika',
      interestedSubjects: ['Machine Learning', 'Web Dev', 'Python']
    });

    console.log('✅ Selesai! Data akun berhasil dimasukkan:');
    console.log('   -> Email: shandy@educonnect.com');
    console.log('   -> Password: password123');
    
    process.exit(0);
  } catch (error) {
    console.error('❌ Terjadi kesalahan:', error);
    process.exit(1);
  }
}

initializeDatabase();
