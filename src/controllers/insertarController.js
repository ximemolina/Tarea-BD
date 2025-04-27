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