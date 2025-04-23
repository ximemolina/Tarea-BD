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