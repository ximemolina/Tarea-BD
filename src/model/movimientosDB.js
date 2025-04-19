import sql from 'mssql';
import { conectarDB } from "../config/database.js";

export async function listarMovimientos(nombre) {
    try {
        let pool = await conectarDB();

        let resultado = await pool.request()
            .input('inNombre', sql.VarChar(64), nombre)
            .output('outResultCode', sql.INT)
            .execute('ListarMovimientos');

        let primerSelect = resultado.recordsets[0];
        let segundoSelect = resultado.recordsets[1]; 
        let codigoExito = resultado.output.outResultCode;

        return {codigoExito,primerSelect, segundoSelect};
    }
    catch (err) {
        console.error('Error ejecutando el SP ListarEmpleados:', err)
    }
}
