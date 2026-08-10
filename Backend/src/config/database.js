const { Sequelize } = require('sequelize');
require('dotenv').config({ path: '../../.env' }); // pastikan bisa baca .env di root Backend

const sequelize = new Sequelize(
  process.env.DB_NAME,
  process.env.DB_USER,
  process.env.DB_PASSWORD,
  {
    host: process.env.DB_HOST,
    port: process.env.DB_PORT,
    dialect: 'mysql',
    logging: false, // ubah ke console.log jika ingin melihat raw SQL query
  }
);

module.exports = sequelize;
