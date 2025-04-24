import path from 'path';
import { fileURLToPath } from 'url';
import { dirname } from 'path';
import * as consultarDB from '../model/consultarDB.js'

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

// Controlador para pasar a la pagina principal
export const consultarFile = async (req, res) => {
    res.sendFile(path.join(__dirname, '../views/consultar.html'));
};

//Controlador para pedir informacion de un empleado
export const consultarEmpleado = async (req, res) => {
    try {
        const { nombre } = req.body;
        const response = await consultarDB.consultarEmpleado(nombre);

        const outResultCode = response[0];
        const recordset = response[1];

        if (outResultCode == 0 && recordset.length > 0 && recordset[0].Nombre) {
            console.log("Recordset válido:", recordset[0]);
            const infoHTML = consultarDB.generarInfoHTML(recordset[0]);
            res.json({ infoHTML });
        } else {
            console.error("Error: No se encontraron datos válidos en el recordset.");
            res.status(404).json({ error: "No se encontraron datos para generar el HTML." });
        }
    } catch (error) {
        console.error("Error ejecutando consultarEmpleado:", error);
        res.status(500).json({ error: "Error interno en el servidor." });
    }
};