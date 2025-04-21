import { Router } from 'express';
import * as movimientosController from '../controllers/movimientosController.js';

const router = Router();

//ruta para ir a la pagina de movimientos
router.get('/scrMovimientos', movimientosController.scrMovimientos);

//ruta para listar movimientos de un empleado
router.post('/listarMovimientos', movimientosController.listar);

//ruta para ir a la pagina de insertar movimientos
router.get('/scrInsertar', movimientosController.scrInsertar);

//ruta para insertar movimientos
router.post('/insertarMovimientos', movimientosController.insertar);

export default router;