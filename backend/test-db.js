require('dotenv').config();
const { Pool } = require('pg');

const pool = new Pool({
  host: process.env.DB_HOST,
  port: Number(process.env.DB_PORT || 5432),
  database: process.env.DB_NAME,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD
});

async function testConnection() {
  try {
    const result = await pool.query(
      'SELECT current_database() AS database, NOW() AS connected_at'
    );
    console.log('PostgreSQL connection successful:', result.rows[0]);
  } catch (error) {
    console.error('PostgreSQL connection failed:', error.message);
    process.exitCode = 1;
  } finally {
    await pool.end();
  }
}

testConnection();