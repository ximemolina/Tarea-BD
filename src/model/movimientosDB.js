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


export async function insertarMovimientos(nombreEmpleado, nombreMovimiento,monto,username,ipAdress) {
    try {
        let pool = await conectarDB();

        let resultado = await pool.request()
            .input('inNombre', sql.VarChar(64), nombreEmpleado)
            .input('inNombreMovimiento', sql.VarChar(64), nombreMovimiento)
            .input('inMonto', sql.INT, monto)
            .input('inUsername', sql.VarChar(64), username)
            .input('inIpAdress', sql.VarChar(64), ipAdress)
            .output('outResultCode', sql.INT)
            .execute('InsertarMovimiento');

        let codigoExito = resultado.output.outResultCode;

        return {codigoExito};
    }
    catch (err) {
        console.error('Error ejecutando el SP ListarEmpleados:', err)
    }   
}