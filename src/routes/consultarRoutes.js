import { Router } from 'express';
import * as consultarController from '../controllers/consultarController.js';

const router = Router();

//ruta para ir a la página principal
router.get('/ventanaConsultar', consultarController.consultarFile);

export default router;