import path from 'path';
import { fileURLToPath } from 'url';
import { dirname } from 'path';
import * as principalFunc from '../model/principalDB.js'

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

// Controlador para pasar a la pagina principal
export const principalFile = async (req, res) => {
    res.sendFile(path.join(__dirname, '../views/principal.html'));
};

// Controlador para enviar la tabla del BD como HTML
export const listarEmpleados = async (req,res) => {
    const tabla = await principalFunc.listarEmpleados();
    if (tabla[0] == 0) {        //Revisa que el resultCode sea 0: exito
        let tableHTML = principalFunc.generarTabla(tabla[1]);
        res.send(tableHTML);
    }
    else {
        console.log("Error: " + table[0], "No se pudo cargar la tabla")
    }
};

export const obtenerFilaSeleccionada = async (req,res) => {
    try {
        let empleadoSeleccionado = principalFunc.obtenerFilaSeleccionada();
        return empleadoSeleccionado;
    }
    catch (err) {
        console.log("No se pudo obtener los datos de la fila seleccionada")
    }
}