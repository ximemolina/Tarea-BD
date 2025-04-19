import { Router } from 'express';
import * as principalController from '../controllers/principalController.js';

const router = Router();

//ruta para ir a la página principal
router.get('/ventanaPrincipal', principalController.principalFile);

//ruta para obtener valor del doc de id de empleado
router.post('/getDocId', principalController.getDocId)

//ruta para eliminar el empleado
router.post('/eliminarEmpleado', principalController.eliminarEmpleado)

//ruta para actualizar evento de cancelar eliminacion
router.post('/cancelEliminar', principalController.cancelEliminar)

router.get('/listarEmpleados', principalController.listarEmpleados);

export default router;