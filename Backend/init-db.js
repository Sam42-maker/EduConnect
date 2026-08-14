const mysql = require('mysql2/promise');
const fs = require('fs');
const path = require('path');
require('dotenv').config();

async function initializeDatabase() {
  try {
    console.log('⏳ Menyambungkan ke MySQL XAMPP...');
    
    // 1. Create a connection without selecting a DB first
    const connection = await mysql.createConnection({
      host: process.env.DB_HOST || '127.0.0.1',
      port: process.env.DB_PORT || 3306,
      user: process.env.DB_USER || 'root',
      password: process.env.DB_PASSWORD || '',
      multipleStatements: true
    });

    const dbName = process.env.DB_NAME || 'educonnect_db';

    // 2. Create the database if it doesn't exist
    console.log(`⏳ Membuat database ${dbName} (jika belum ada)...`);
    await connection.query(`CREATE DATABASE IF NOT EXISTS \`${dbName}\`;`);
    console.log(`✅ Database ${dbName} siap!`);

    // 3. Switch to the database
    await connection.query(`USE \`${dbName}\`;`);

    // 4. Read and execute init.sql (Raw SQL Migrations)
    console.log('⏳ Mengeksekusi init.sql (Lumiora Style Raw SQL)...');
    const sqlPath = path.join(__dirname, 'sql', 'init.sql');
    const sql = fs.readFileSync(sqlPath, 'utf8');

    await connection.query(sql);

    console.log('✅ Skema tabel berhasil dibangun dan seed data dimasukkan!');
    
    await connection.end();
    process.exit(0);
  } catch (error) {
    console.error('❌ Terjadi kesalahan saat inisialisasi:', error);
    process.exit(1);
  }
}

initializeDatabase();
