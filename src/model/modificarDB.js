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


/////////////////////////////////////////////////////////////////////////////////////////////////
// Ejemplo: Llamada a la función con las opciones dinámicas
async function cargarDropdownPuestos() {
    try {
      const response = await fetch('listarPuestos'); // Ruta del endpoint en el servidor
      const opciones = await response.json(); // Convierte la respuesta en JSON
  
      const htmlDropdown = construirMenuDropdown(opciones); // Genera el HTML con la función del modelo
      
      return htmlDropdown;
    } catch (err) {
      console.error('Error al cargar los puestos:', err);
    }
  }
  
  // Llama a la función
  //console.log(cargarDropdownPuestos());


  async function probarListarPuestos() {
    try {
      const [codigo, puestos] = await listarPuestos(); // Llama a la función listarPuestos()
  
      console.log('Código de resultado:', codigo);
  
      if (puestos && Array.isArray(puestos)) {
        // Convierte el JSON en un arreglo con los nombres de los puestos
        const nombresPuestos = puestos.map(puesto => puesto.Puesto);
        let html = construirMenuDropdown(nombresPuestos);
        //console.log('Lista de nombres de puestos:', nombresPuestos);
        console.log(html);
      } else {
        console.log('No se encontraron puestos o el formato es incorrecto.');
      }
    } catch (error) {
      console.error('Error al probar listarPuestos:', error);
    }
  }

probarListarPuestos();
