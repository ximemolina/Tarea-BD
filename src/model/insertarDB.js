import sql from 'mssql';
import { conectarDB } from "../config/database.js";

//Obtener saldo vacaciones
export async function calcularVacaciones(fechaContratacion) {
    try {
        let pool = await conectarDB();

        let resultado = await pool.request()
            .input('inFechaContratacion', sql.VarChar(64), fechaContratacion)
            .output('outSaldoVacacion', sql.Int)
            .output('outResultCode', sql.Int)
            .execute('CalculoSaldoVacaciones');

        return [resultado.output.outResultCode, resultado.output.outSaldoVacacion];
    } catch (error) {
        console.error('Error ejecutando el SP CalculoSaldoVacaciones:', error)
    }
}

//Insertar empleado
export async function insertarEmpleado(documentoIdentidad, nombre, 
                                        puesto, fechaContratacion, 
                                        saldoVacacion, username, ipAdress) {
  try {
          let pool = await conectarDB();
  
          let resultado = await pool.request()
              .input('inValorDocumentoIdentidad', sql.VarChar(64), documentoIdentidad)
              .input('inNombre', sql.VarChar(64), nombre)
              .input('inNombrePuesto', sql.VarChar(64), puesto)
              .input('inFechaContratacion', sql.VarChar(64), fechaContratacion)
              .input('inSaldoVacaciones', sql.Int, saldoVacacion)
              .input('inUsername', sql.VarChar(64), username)
              .input('inIpAdress', sql.VarChar(64), ipAdress)
              .output('outResultCode', sql.Int)
              .execute('InsertarEmpleado');
  
          return [resultado.output.outResultCode];
      } catch (error) {
          console.error('Error ejecutando el SP InsertarEmpleado:', error)
      }
}