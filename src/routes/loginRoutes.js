import { Router } from 'express';
import * as loginController from '../controllers/loginController.js';

const router = Router();

//consigue la el Ip del usuario
router.get('/getIp', loginController.getIp);

//valida datos del login
router.post('/revLogin',loginController.revisarLogin);

export default router;