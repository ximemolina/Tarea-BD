import sql from 'mssql';
import { conectarDB } from "../config/database.js";

//Pedir informacion de un empleado
export async function consultarEmpleado(nombre) {
    try {
        let pool = await conectarDB();

        let resultado = await pool.request()
            .input('inNombre', sql.VarChar(64), nombre)
            .output('outResultCode', sql.Int)
            .execute('ConsultarEmpleado');

        return [resultado.output.outResultCode, resultado.recordset];
    } catch (error) {
        console.error('Error ejecutando el SP ConsultarEmpleado:', error)
    }
}

//HTML con la informacion
export function generarInfoHTML(info) {
    let infoHTML = `
        <div class="text-lg mb-2.5 text-[#374151]">Nombre: ${info.Nombre}</div>
        <div class="text-lg mb-2.5 text-[#374151]">Documento de identidad: ${info.Cedula}</div>
        <div class="text-lg mb-2.5 text-[#374151]">Puesto: ${info.Puesto}</div>
        <div class="text-lg text-[#374151]">Saldo vacaciones: ${info.Vacaciones}</div>
    `;
    return infoHTML; // Retorna el HTML dinámico
}