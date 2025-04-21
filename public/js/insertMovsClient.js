const dropdownButton = document.getElementById('dropdownCheckboxButton');
const dropdownMenu = document.getElementById('dropdownDefaultCheckbox');
const btnAtras = document.getElementById('btnAtras');
const btnInsertar = document.getElementById('btnInsertar');
const inpInfo = document.getElementById("inpInfo");

const raw = localStorage.getItem('user');
const parsedUser = JSON.parse(raw);
const username = parsedUser.username
const ipAdress = parsedUser.IP
const empleado = localStorage.getItem('empleado');
const parsedEmpleado = JSON.parse(empleado);
const nombreEmpleado = parsedEmpleado.nombre;

btnAtras.addEventListener('click',devolver);
btnInsertar.addEventListener('click',insertarMovimientos);

dropdownButton.addEventListener('click', () => {
    dropdownMenu.classList.toggle('hidden');
  });

window.addEventListener('DOMContentLoaded', () => {
  desplegarInfo();
  limitarChecks();
});


//abre pagina de listar movimientos
function devolver(){
  window.location.href = 'http://localhost:3300/movimientos/scrMovimientos';
}

//obtener informacion de empleado a mostrar
async function desplegarInfo(){
  const response = await fetch('/movimientos/listarMovimientos', { 
    method: 'POST',                                                
    headers: {
      'Content-Type': 'application/json'
    },
    body: JSON.stringify({nombreEmpleado})
  });
  const data = await response.json();
  const texto = 'Nombre de empleado: '  //se utiliza fetch de listado pero solo se toma valores del primer Select que ejecuta
                + data.primerSelect[0].Nombre 
                + ' Valor Documento Identidad: ' 
                + data.primerSelect[0].ValorDocumentoIdentidad
                + ' Saldo de Vacaciones: '
                + data.primerSelect[0].SaldoVacaciones
  document.getElementById("datos").textContent = texto;
}

//Verifica que no haya más de un movimiento seleccionado
function limitarChecks(){
  const checkboxes = document.querySelectorAll('#dropdownDefaultCheckbox input[type="checkbox"]');
  checkboxes.forEach((checkbox) => {
    checkbox.addEventListener('change', () => {
      if (checkbox.checked) {

        checkboxes.forEach((cb) => {
          if (cb !== checkbox) cb.checked = false;
        });
      }
    });
  });
}

//Muestra descripcion de error
async function mostrarError(codigo){
  const response = await fetch('/general/getError', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({ codigo })
    });

    const data = await response.json();
    resultado = data.resultado[0].Descripcion;
    alert(resultado);
}

//Verifica que haya un movimiento checkeado y un monto numérico
function validarInsertar(){
  const marcado = document.querySelector('#dropdownDefaultCheckbox input[type="checkbox"]:checked');
  const valor = inpInfo.value.trim();

  if (!marcado) {
    return false
  } 
  if (valor === "" || isNaN(valor)) {
    return false
  }
  return true;
}

//Actualiza tablas con base al movimiento hecho por el empleado
async function insertarMovimientos(){
  if (validarInsertar()){
    const monto = inpInfo.value.trim()
    const checkboxMarcado = document.querySelector('#dropdownDefaultCheckbox input[type="checkbox"]:checked');
    const nombreMovimiento = checkboxMarcado.nextElementSibling.textContent;

    const response = await fetch('/movimientos/insertarMovimientos', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({nombreEmpleado,nombreMovimiento,monto,username,ipAdress})
      });
      const data = await response.json();

      if (data.codigoExito != 0) mostrarError(data.codigoExito);
      
      //limpiar input y checkboxes
      const checkboxes = document.querySelectorAll('#dropdownDefaultCheckbox input[type="checkbox"]');
      checkboxes.forEach(checkbox => {
        checkbox.checked = false;
      });
      dropdownMenu.classList.toggle('hidden');
      inpInfo.value=""

  }else {
    alert("Ingrese el monto numérico y el tipo de movimiento deseado")
  }
}