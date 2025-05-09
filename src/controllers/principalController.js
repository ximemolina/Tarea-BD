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
        console.log("Error: " + tabla[0], "No se pudo cargar la tabla")
    }
};

// Controlador para enviar la tabla por nombre del BD como HTML
export const listarEmpleadosNombre = async (req,res) => {
    const { input, username, ipAdress } = req.body;
    const response = await functionsDB.listarEmpleadosNombre(input, username, ipAdress);
    const outResultCode = response[0];
    const recordset = response[1];
    if (outResultCode == 0) {        //Revisa que el resultCode sea 0: exito
        let tableHTML = functionsDB.generarTabla(recordset);
        res.json({outResultCode, tableHTML});
    }
    else {
        console.log("Error: " + outResultCode, "No se pudo cargar la tabla")
        res.json({outResultCode});
    }
};



// Controlador para enviar la tabla por documento de indentidad del BD como HTML
export const listarEmpleadosId = async (req,res) => {
    const { input, username, ipAdress } = req.body;
    let response = await functionsDB.listarEmpleadosId(input, username, ipAdress);
    const outResultCode = response[0];
    const recordset = response[1];
    if (outResultCode == 0) {        //Revisa que el resultCode sea 0: exito
        let tableHTML = functionsDB.generarTabla(recordset);
        res.json({outResultCode, tableHTML});
    }
    else {
        console.log("Error: " + outResultCode, "No se pudo cargar la tabla")
        res.json({outResultCode});
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


export const logout = async (req,res) => {
    const {username,ipAdress,nombreEvento} = req.body;
    const resultado = await functionsDB.logout(username,ipAdress,nombreEvento);
    res.json({resultado})
};