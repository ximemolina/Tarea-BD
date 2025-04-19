import { Router } from 'express';
import * as principalController from '../controllers/principalController.js';

const router = Router();

//ruta para ir a la página principal
router.get('/ventanaPrincipal', principalController.principalFile);

router.get('/listarEmpleados', principalController.listarEmpleados);

export default router;