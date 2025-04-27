import { Router } from 'express';
import * as insertarController from '../controllers/insertarController.js';

const router = Router();

//ruta para ir a la página modificar
router.get('/ventanaInsertar', insertarController.insertarFile);

//ruta para calcular saldo vacacion
router.post('/calcularVacaciones', insertarController.calcularVacaciones);

//ruta para insertar empleado
router.post('/insertarEmpleado', insertarController.insertarEmpleado);

export default router;