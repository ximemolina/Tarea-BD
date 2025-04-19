import path from 'path';
import { fileURLToPath } from 'url';
import { dirname } from 'path';
import * as functionsDB from '../model/principalDB.js'

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

// Controlador para pasar a la pagina principal
export const principalFile = async (req, res) => {
    res.sendFile(path.join(__dirname, '../views/principal.html'));
};

// Controlador para enviar la tabla del BD como HTML
export const listarEmpleados = async (req,res) => {
    const tabla = await functionsDB.listarEmpleados();
    if (tabla[0] == 0) {        //Revisa que el resultCode sea 0: exito
        let tableHTML = functionsDB.generarTabla(tabla[1]);
        res.send(tableHTML);
    }
    else {
        console.log("Error: " + table[0], "No se pudo cargar la tabla")
    }
};

export const getDocId = async (req,res) => {
    const { nombre } = req.body;
    const resultado = await functionsDB.getDocumentId(nombre);
    res.json({resultado});    
};

export const eliminarEmpleado = async (req,res) => {
    const {nombre,username,IpAdress} = req.body;
    const resultado = await functionsDB.eliminarEmpleado(nombre,username,IpAdress);
    res.json({resultado});
};

export const cancelEliminar = async (req,res) => {
    const {nombre,username,IpAdress} = req.body;
    const resultado = await functionsDB.cancelEliminar(nombre,username,IpAdress);
    res.json({resultado});   
};