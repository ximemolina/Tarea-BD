import path from 'path';
import { fileURLToPath } from 'url';
import { dirname } from 'path';
import * as modificarDB from '../model/modificarDB.js'
import * as consultarDB from '../model/consultarDB.js'

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

// Controlador para pasar a la pagina principal
export const modificarFile = async (req, res) => {
    res.sendFile(path.join(__dirname, '../views/modificar.html'));
};

//Controlador para pedir informacion de un empleado
export const datosEmpleado = async (req, res) => {
    try {
        const { nombre } = req.body;
        const response = await consultarDB.consultarEmpleado(nombre);

        const outResultCode = response[0];
        const recordset = response[1];

        if (outResultCode == 0 && recordset.length > 0 && recordset[0].Nombre) {
            console.log("Recordset válido:", recordset[0]);
            const datos = recordset[0];
            res.json({ datos });
        } else {
            console.error("Error: No se encontraron datos válidos en el recordset.");
            res.status(404).json({ error: "No se encontraron datos para generar el HTML." });
        }
    } catch (error) {
        console.error("Error ejecutando consultarEmpleado:", error);
        res.status(500).json({ error: "Error interno en el servidor." });
    }
};

//Controlador para configurar el menu dropdown
export const generarMenuPuesto = async (req, res) => {
    try {
        const [codigo, puestos] = await modificarDB.listarPuestos();

        if (codigo == 0 && puestos && Array.isArray(puestos)) {
            // Convierte el JSON en un arreglo con los nombres de los puestos
            const nombresPuestos = puestos.map(puesto => puesto.Puesto);
            let menuHTML = modificarDB.construirMenuDropdown(nombresPuestos);
            res.json({ menuHTML });
          } else {
            console.log('No se encontraron puestos o el formato es incorrecto.');
          }
    } catch (error) {
        console.error("Error ejecutando generarMenuPuesto:", error);
        res.status(500).json({ error: "Error interno en el servidor." });
    }
};

//Controlador para modificar empleado
export const modificarEmpleado = async (req, res) => {
    try {
        const { nombreActual, nombreNuevo, DIActual, DINuevo, puestoNuevo, username, ipAdress } = req.body;
        const response = await modificarDB.modificarEmpleado(nombreActual, nombreNuevo, DIActual, DINuevo, puestoNuevo, username, ipAdress);

        const outResultCode = response[0];

        res.json({ outResultCode });
    } catch (error) {
        console.error("Error ejecutando modificarEmpleado:", error);
        res.status(500).json({ error: "Error interno en el servidor." });
    }
};