import { Router } from 'express';
import * as loginController from '../controllers/loginController.js';

const router = Router();

//ruta principal apenas se inicializa el server
router.get('/', loginController.mainFile);

//consigue la el Ip del usuario
router.get('/getIp', loginController.getIp);

export default router;