const btnRetornar = document.getElementById("btnAtras");
const btnInsertar = document.getElementById("btnInsertar");

const raw = localStorage.getItem('user');
const parsedUser = JSON.parse(raw);
const username = parsedUser.username
const ipAdress = parsedUser.IP
const empleado = localStorage.getItem('empleado');
const parsedEmpleado = JSON.parse(empleado);
const nombreEmpleado = parsedEmpleado.nombre;

btnRetornar.addEventListener("click", retornar);
btnInsertar.addEventListener("click", insertar);

window.addEventListener('DOMContentLoaded', () => {
    listarMovimientos();
  });


//despliega pag principal y vacía localStorage de empleado
function retornar(){
  localStorage.removeItem('empleado');
  window.location.href = 'http://localhost:3300/principal/ventanaPrincipal'; 
}

//despliega pag de insertar movimientos
function insertar(){
  window.location.href = 'http://localhost:3300/movimientos/scrInsertar';
}


//Muestra todos los movimientos del empleado de manera descendente de acuerdo a la fecha
async function listarMovimientos(){

    const response = await fetch('/movimientos/listarMovimientos', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({nombreEmpleado})
      });
  
      const data = await response.json();
      const texto = 'Nombre de empleado: ' 
                    + data.primerSelect[0].Nombre 
                    + ' Valor Documento Identidad: ' 
                    + data.primerSelect[0].ValorDocumentoIdentidad
                    + ' Saldo de Vacaciones: '
                    + data.primerSelect[0].SaldoVacaciones
      document.getElementById("contenedor-tabla").innerHTML += data.tabla;
      document.getElementById("datos").textContent = texto;
}
