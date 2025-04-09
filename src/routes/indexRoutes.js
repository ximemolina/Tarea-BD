import { Router } from 'express';
import loginRoutes from './loginRoutes.js';

const rutas_init = () => {
  const router = Router()

  router.use('/', loginRoutes);
  router.use('/login', loginRoutes);

  return router
}

export default rutas_init;