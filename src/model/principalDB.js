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
        <div class="shadow-md rounded-lg relative">
            <table class="table-fixed w-full text-left">
                <thead class="uppercase bg-[#2856b3] text-[#ffffff]" style="background-color: #2856b3; color: #ffffff;">
                    <tr>
                        <td class="py-2 border border-gray-200 text-center p-4">DOCUMENTO DE IDENTIDAD</td>
                        <td class="py-2 border border-gray-200 text-center p-4">NOMBRE</td>
                        <td class="py-2 border border-gray-200 text-center p-4">FECHA DE INGRESO</td>
                        <td class="py-2 border border-gray-200 text-center p-4">SELECCIONAR</td>
                    </tr>
                </thead>
                <tbody class="bg-white text-gray-500 bg-[#FFFFFF] text-[#6b7280]" style="background-color: #FFFFFF; color: #6b7280;">
    `;

    tabla.forEach(item => {
        const fechaFormateada = new Date(item.Ingreso).toLocaleDateString('es-ES', {
            year: 'numeric',
            month: '2-digit',
            day: '2-digit'
        });

        tableHTML += `
            <tr class="py-0">
                <td class="py-0 border border-gray-200 text-center p-4">${item.Identificacion}</td>
                <td class="py-0 border border-gray-200 text-center p-4">${item.Nombre}</td>
                <td class="py-0 border border-gray-200 text-center p-4">${fechaFormateada}</td>
                <td class="py-0 border border-gray-200 text-center p-4"><input type="checkbox" class="fila-checkbox" value="${item.Nombre}"></td>
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
export async function listarEmpleadosNombre(input, username, ipAdress) {
    try {
        let pool = await conectarDB();
        let resultado = await pool.request()
        .input('inNombre', sql.VarChar(64), input)
        .input('inUsername', sql.VarChar(64), username)
        .input('inIpAdress', sql.VarChar(64), ipAdress)
        .output('outResultCode', sql.Int)
        .execute('ListarEmpleadosNombre');
        
        return [resultado.output.outResultCode, resultado.recordset];
    }
    catch (err) {
        console.error('Error ejecutando el SP ListarEmpleadosNombre:', err)
    }
}

// Ejecuta el sp para listar a todos los empleados activos por documento de identidad
export async function listarEmpleadosId(input, username, ipAdress) {
    try {
        let pool = await conectarDB();

        let resultado = await pool.request()
            .input('inId', sql.VarChar(64), input)
            .input('inUsername', sql.VarChar(64), username)
            .input('inIpAdress', sql.VarChar(64), ipAdress)
            .output('outResultCode', sql.Int)
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