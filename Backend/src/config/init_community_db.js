require('dotenv').config();
const mysql = require('mysql2/promise');

async function initDb() {
  try {
    const connection = await mysql.createConnection({
      host: process.env.DB_HOST || 'localhost',
      user: process.env.DB_USER || 'root',
      password: process.env.DB_PASSWORD || '',
      database: process.env.DB_NAME || 'educonnect'
    });

    console.log("Connected to MySQL. Creating tables...");

    await connection.execute(`
      CREATE TABLE IF NOT EXISTS communities (
        id VARCHAR(50) PRIMARY KEY,
        name VARCHAR(255) NOT NULL,
        description TEXT,
        access_level VARCHAR(50) DEFAULT 'Publik',
        objective VARCHAR(100),
        icon_initial VARCHAR(5),
        created_by VARCHAR(50) NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      )
    `);

    await connection.execute(`
      CREATE TABLE IF NOT EXISTS community_channels (
        id VARCHAR(50) PRIMARY KEY,
        community_id VARCHAR(50) NOT NULL,
        name VARCHAR(100) NOT NULL,
        type ENUM('text', 'voice') DEFAULT 'text',
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (community_id) REFERENCES communities(id) ON DELETE CASCADE
      )
    `);

    await connection.execute(`
      CREATE TABLE IF NOT EXISTS community_members (
        id INT AUTO_INCREMENT PRIMARY KEY,
        community_id VARCHAR(50) NOT NULL,
        user_id VARCHAR(50) NOT NULL,
        role ENUM('admin', 'member') DEFAULT 'member',
        joined_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (community_id) REFERENCES communities(id) ON DELETE CASCADE
      )
    `);

    await connection.execute(`
      CREATE TABLE IF NOT EXISTS community_messages (
        id INT AUTO_INCREMENT PRIMARY KEY,
        channel_id VARCHAR(50) NOT NULL,
        sender_id VARCHAR(50) NOT NULL,
        sender_name VARCHAR(100) NOT NULL,
        text TEXT NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (channel_id) REFERENCES community_channels(id) ON DELETE CASCADE
      )
    `);

    console.log("Community tables created successfully!");
    await connection.end();
  } catch (error) {
    console.error("Error creating tables:", error);
  }
}

initDb();
