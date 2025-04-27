import { Router } from 'express';
import * as modificarController from '../controllers/modificarController.js';

const router = Router();

//ruta para ir a la página modificar
router.get('/ventanaModificar', modificarController.modificarFile);

//ruta para obtener infromacion del empleado 
router.post('/datosEmpleado', modificarController.datosEmpleado);

//ruta para generar el menu dropdown
router.get('/generarMenuPuesto', modificarController.generarMenuPuesto);

//ruta para modificar empleado
router.post('/modificarEmpleado', modificarController.modificarEmpleado);

export default router;