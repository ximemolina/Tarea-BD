import sql from 'mssql';
import dotenv from "dotenv";

dotenv.config(); //uso de variables de entorno

const config ={
    server: process.env.server,
    database: process.env.database,
    user: process.env.user,
    password: process.env.password,
    options:{
        encrypt: true,
        trustServerCertificate: true
    },
};

export async function conectarDB() { //conexión con base de datos
    try {
        let pool = await sql.connect(config);
        console.log('Conexión exitosa a SQL Server');
        return pool;
    } catch (err) {
        console.error('Error en la conexión a la base de datos:', err);
    }
}