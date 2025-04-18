import { Router } from 'express';
import loginRoutes from './loginRoutes.js';
import generalRoutes from './generalRoutes.js';
import principalRoutes from './principalRoutes.js';

const rutas_init = () => {
  const router = Router()

  router.use('/', generalRoutes);
  router.use('/login', loginRoutes);
  router.use('/general', generalRoutes);
  router.use('/principal', principalRoutes);

  return router
}

export default rutas_init;