import sql from 'mssql';
import { conectarDB } from "../config/database.js";

// Ejecuta el sp para listar a todos los empleados activos
export async function listarEmpleados() {
    try {
        let pool = await conectarDB();

        let resultado = await pool.request()
            .output('outResultCode', sql.INT)
            .execute('ListarEmpleados');

        return [resultado.output.outResultCode, resultado.recordset];
    }
    catch (err) {
        console.error('Error ejecutando el SP ListarEmpleados:', err)
    }
}

// Genera la tabla traida de la BD en HTML
export function generarTabla(tabla) {
    let tableHTML = `
        <div class="relative overflow-hidden shadow-md rounded-lg">
            <table class="table-fixed w-full text-left">
                <thead class="uppercase bg-[#2856b3] text-[#ffffff]" style="background-color: #2856b3; color: #ffffff;">
                    <tr>
                        <td class="py-2 border border-gray-200 text-center  p-4" contenteditable="true">Documento de identidad</td>
                        <td class="py-2 border border-gray-200 text-center  p-4" contenteditable="true">NOMBRE</td>
                        <td class="py-2 border border-gray-200 text-center  p-4" contenteditable="true">FECHA DE INGRESO</td>
                        <td contenteditable="true" class="py-2 border border-gray-200 text-center  p-4">sELECCIONAR</td>
                    </tr>
                </thead>
            <tbody class="bg-white text-gray-500 bg-[#FFFFFF] text-[#6b7280]" style="background-color: #FFFFFF; color: #6b7280;">
    `;

    tabla.forEach(item => {
        tableHTML += `
            <tr class=" py-0">
                <td class=" py-0 border border-gray-200 text-center  p-4" contenteditable="true">${item.Identificacion}</td>
                <td class=" py-0 border border-gray-200 text-center  p-4" contenteditable="true">${item.Nombre}</td>
                <td class=" py-0 border border-gray-200 text-center  p-4" contenteditable="true">${item.Ingreso}</td>
                <td class=" py-0 border border-gray-200 text-center  p-4" contenteditable="true"><input type="checkbox" class="fila-checkbox" value="${item.Nombre}"></td>
            </tr>
        `;
    });

    tableHTML += `
                </tbody>
            </table>
        </div>
    `;

    return tableHTML;
}

export async function getDocumentId(nombre) {
    try {
        let pool = await conectarDB();

        let resultado = await pool.request()
            .input('inNombre', sql.VarChar(64), nombre)
            .output('outResultCode', sql.Int)
            .execute('ObtenerDocId');

            return resultado.recordset;
        
    } catch (err) {
        console.error('Error ejecutando el SP:', err)
    }
};

export async function eliminarEmpleado(nombre,username,ipAdress){
    try {
        let pool = await conectarDB();

        let resultado = await pool.request()
            .input('inNombre', sql.VarChar(64), nombre)
            .input('inUsername', sql.VarChar(64), username)
            .input('inIpAdress', sql.VarChar(64), ipAdress)
            .output('outResultCode', sql.Int)
            .execute('EliminarEmpleado');

            return resultado.output.outResultCode;
        
    } catch (err) {
        console.error('Error ejecutando el SP:', err)
    }   
};

export async function cancelEliminar(nombre,username,ipAdress){
    try {
        let pool = await conectarDB();
        console.log(nombre+username+ipAdress);
        let resultado = await pool.request()
            .input('inNombre', sql.VarChar(64), nombre)
            .input('inUsername', sql.VarChar(64), username)
            .input('inIpAdress', sql.VarChar(64), ipAdress)
            .output('outResultCode', sql.Int)
            .execute('EliminarCancelado');

            return resultado.output.outResultCode;
        
    } catch (err) {
        console.error('Error ejecutando el SP:', err)
    }   
};