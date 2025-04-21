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
                        <td class="py-2 border border-gray-200 text-center  p-4" contenteditable="true">DOCUMENTO DE INDENTIDAD</td>
                        <td class="py-2 border border-gray-200 text-center  p-4" contenteditable="true">NOMBRE</td>
                        <td class="py-2 border border-gray-200 text-center  p-4" contenteditable="true">FECHA DE INGRESO</td>
                        <td contenteditable="true" class="py-2 border border-gray-200 text-center  p-4">SELECCIONAR</td>
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

// Ejecuta el sp para listar a todos los empleados activos por nombre
export async function listarEmpleadosNombre(input) {
    try {
        let pool = await conectarDB();

        let resultado = await pool.request()
            .input('inNombre', sql.VarChar(64), input)
            .output('outResultCode', sql.INT)
            .execute('ListarEmpleadosNombre');

        return [resultado.output.outResultCode, resultado.recordset];
    }
    catch (err) {
        console.error('Error ejecutando el SP ListarEmpleadosNombre:', err)
    }
}

// Ejecuta el sp para listar a todos los empleados activos por documento de identidad
export async function listarEmpleadosId(input) {
    try {
        let pool = await conectarDB();

        let resultado = await pool.request()
            .input('inId', sql.VarChar(64), input)
            .output('outResultCode', sql.INT)
            .execute('ListarEmpleadosId');

        return [resultado.output.outResultCode, resultado.recordset];
    }
    catch (err) {
        console.error('Error ejecutando el SP ListarEmpleadosId:', err)
    }
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

export async function logout(username,IpAdress,nombreEvento){
    try {
        let pool = await conectarDB();
        let resultado = await pool.request()
            .input('inUsername', sql.VarChar(64), username)
            .input('inIpAdress', sql.VarChar(64), IpAdress)
            .input('inNombreEvento', sql.VarChar(64), nombreEvento)
            .output('outResultCode', sql.Int)
            .execute('Logout');

            return resultado.output.outResultCode;
        
    } catch (err) {
        console.error('Error ejecutando el SP:', err)
    }      
};