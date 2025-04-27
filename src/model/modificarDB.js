import sql from 'mssql';
import { conectarDB } from "../config/database.js";

//Obtener todos los puestos
export async function listarPuestos() {
    try {
        let pool = await conectarDB();

        let resultado = await pool.request()
            .output('outResultCode', sql.Int)
            .execute('ListarPuestos');

        return [resultado.output.outResultCode, resultado.recordset];
    } catch (error) {
        console.error('Error ejecutando el SP ListarPuestos:', error)
    }
}

//Generar menu dropdown
export function construirMenuDropdown(opciones) {
    let html = ''; // Construye las opciones como una cadena HTML

    opciones.forEach((opcion, index) => {
        html += `<a href="#" 
                  class="block px-4 py-2 text-lg text-gray-700 hover:bg-gray-100" 
                  role="menuitem" 
                  tabindex="-1" 
                  id="menu-item-${index}">
                  ${opcion}
                </a>`;
    });

    return html; // Retorna el HTML generado
}

//Modificar empleado
export async function modificarEmpleado(nombreActual, nombreNuevo, 
                                        DIActual, DINuevo, puestoNuevo, 
                                        username, ipAdress) {
  try {
          let pool = await conectarDB();
  
          let resultado = await pool.request()
              .input('inNombre', sql.VarChar(64), nombreActual)
              .input('inDocumentoIdentidad', sql.VarChar(64), DIActual)
              .input('inNuevoDI', sql.VarChar(64), DINuevo)
              .input('inNuevoNombre', sql.VarChar(64), nombreNuevo)
              .input('inNuevoPuesto', sql.VarChar(64), puestoNuevo)
              .input('inUsername', sql.VarChar(64), username)
              .input('inIpAdress', sql.VarChar(64), ipAdress)
              .output('outResultCode', sql.Int)
              .execute('ModificarEmpleado');
  
          return [resultado.output.outResultCode];
      } catch (error) {
          console.error('Error ejecutando el SP ModificarEmpleado:', error)
      }
}

