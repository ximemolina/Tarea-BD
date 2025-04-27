import path from 'path';
import { fileURLToPath } from 'url';
import { dirname } from 'path';
import * as insertarDB from '../model/insertarDB.js'


const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

// Controlador para pasar a la pagina principal
export const insertarFile = async (req, res) => {
    res.sendFile(path.join(__dirname, '../views/insertar.html'));
};

//Controlador para calcular saldo vacacion
export const calcularVacaciones = async (req, res) => {
    try {
        const { fechaContratacion } = req.body;
        const response = await insertarDB.calcularVacaciones(fechaContratacion);

        const outResultCode = response[0];
        const outSaldoVacacion = response[1];

        if (outResultCode == 0) {
            console.log('Saldo calculado: ', outSaldoVacacion);
            res.json({ outSaldoVacacion });
        } else {
            res.status(404).json({ error: "No se encontraron datos para generar el HTML." });
        }
    } catch (error) {
        console.error("Error ejecutando calcularVacaciones:", error);
        res.status(500).json({ error: "Error interno en el servidor." });
    }
};

//Controlador para insertar empleado
export const insertarEmpleado = async (req, res) => {
    try {
        const {documentoIdentidad, nombre, puesto, fechaContratacion, 
                saldoVacacion, username, ipAdress } = req.body;
        const response = await insertarDB.insertarEmpleado(
                        documentoIdentidad, nombre, 
                        puesto, fechaContratacion, 
                        saldoVacacion, username, ipAdress);

        const outResultCode = response[0];

        res.json({ outResultCode });
    } catch (error) {
        console.error("Error ejecutando insertarEmpleado:", error);
        res.status(500).json({ error: "Error interno en el servidor." });
    }
};