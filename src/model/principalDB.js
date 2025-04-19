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
        <table>
            <thead>
                <tr>
                    <th>Documento de identificación</th>
                    <th>Nombre</th>
                    <th>Fecha de ingreso</th>
                    <th>Seleccionar</th>
                </tr>
            </thead>
            <tbody>
    `;

    tabla.forEach(item => {
        tableHTML += `
            <tr>
                <td>${item.Identificacion}</td>
                <td>${item.Nombre}</td>
                <td>${item.Ingreso}</td>
                <td><input type="checkbox" class="fila-checkbox" value="${item.Nombre}">></td>
            </tr>
        `;
    });

    tableHTML += `
            </tbody>
        </table>
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