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

//ruta para listar todos los empleados activos
router.get('/listarEmpleados', principalController.listarEmpleados);

//ruta para listar todos los empleados activos por nombre
router.post('/listarEmpleadosNombre', principalController.listarEmpleadosNombre);

//ruta para listar todos los empleados activos por documento de identificacion
router.post('/listarEmpleadosId', principalController.listarEmpleadosId);

//ruta para actualizar evento logout
router.post('/logout', principalController.logout)

export default router;