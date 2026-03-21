import sql from 'mssql';
import * as dotenv from 'dotenv';

dotenv.config();

const config = {
  user: "sa",
  password: process.env.MSSQL_SA_PASSWORD,
  server: process.env.DB_HOST, // "sqlserver" in Docker
  port: 1433,
  database: "mydb",
  options: {
    encrypt: false,
    trustServerCertificate: true
  },
  pool: {
    max: 10,
    min: 0,
    idleTimeoutMillis: 30000
  }
};

export async function conectarDB() {
  try {
    const pool = await sql.connect(config);
    console.log('✅ Conexión exitosa a SQL Server');
    return pool;
  } catch (err) {
    console.error('❌ Error en la conexión a la base de datos:', err);
  }
}