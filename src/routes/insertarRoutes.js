import { Router } from 'express';
import * as insertarController from '../controllers/insertarController.js';

const router = Router();

//ruta para ir a la página modificar
router.get('/ventanaInsertar', insertarController.insertarFile);

export default router;