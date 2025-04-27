import { Router } from 'express';
import * as consultarController from '../controllers/consultarController.js';

const router = Router();

//ruta para ir a la página consultar
router.get('/ventanaConsultar', consultarController.consultarFile);

//ruta para obtener infromacion del empleado consultado
router.post('/consultarEmpleado', consultarController.consultarEmpleado);

export default router;