import { Router } from 'express';
import loginRoutes from './loginRoutes.js';
import generalRoutes from './generalRoutes.js';
import principalRoutes from './principalRoutes.js';
import movimientosRoutes from './movimientosRoutes.js';

const rutas_init = () => {
  const router = Router()

  router.use('/', generalRoutes);
  router.use('/login', loginRoutes);
  router.use('/general', generalRoutes);
  router.use('/principal', principalRoutes);
  router.use('/movimientos', movimientosRoutes);

  return router
}

export default rutas_init;