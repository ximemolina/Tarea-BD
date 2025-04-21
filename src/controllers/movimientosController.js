import * as functionsDB from '../model/movimientosDB.js';
import * as functionsSetup from '../model/movimientosSetup.js';
import path from 'path';
import { fileURLToPath } from 'url';
import { dirname } from 'path';

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);


export const scrMovimientos = async (req, res) => {
    res.sendFile(path.join(__dirname, '../views/movimientos.html'));
};

export const listar = async (req, res) => {
    const {nombreEmpleado} = req.body;
    const resultado = await functionsDB.listarMovimientos(nombreEmpleado);
    const tabla = functionsSetup.setearTabla(resultado.segundoSelect);
    const primerSelect = resultado.primerSelect
    res.json({tabla, primerSelect});       
};

export const scrInsertar = async (req, res) => {
    res.sendFile(path.join(__dirname, '../views/insertMovs.html'));
};

export const insertar = async (req, res) => {
    const {nombreEmpleado, nombreMovimiento,monto,username,ipAdress} = req.body;
    const resultado = await functionsDB.insertarMovimientos(nombreEmpleado, nombreMovimiento,monto,username,ipAdress);
    res.json(resultado);  
};