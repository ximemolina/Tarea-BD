const btnCancelar = document.getElementById("btnCancelar");
const btnInsertar = document.getElementById("btnInsertar");
const NombreEmpleado = document.getElementById("NombreEmpleado");
const DocumentoIdentidad = document.getElementById("DocumentoIdentidad");
const FechaContratacion = document.getElementById("FechaContratacion");
const btnMenuPuesto = document.getElementById("btnMenuPuesto");
const DropdownPuesto = document.getElementById("DropdownPuesto");
const Seleccion = document.getElementById("Seleccion");

const raw = localStorage.getItem('user');
const parsedUser = JSON.parse(raw);
const username = parsedUser.username;
const ipAdress = parsedUser.IP;

btnCancelar.addEventListener('click', regresarPrincipal);
btnRegistrar.addEventListener('click', insertarEmpleado);
btnMenuPuesto.addEventListener('click', () => {
    const isExpanded = btnMenuPuesto.getAttribute('aria-expanded') === 'true';
    // Alterna el atributo aria-expanded
    btnMenuPuesto.setAttribute('aria-expanded', !isExpanded);
    // Alterna la visibilidad del menú
    DropdownPuesto.classList.toggle('hidden');
});

window.addEventListener('DOMContentLoaded', () => {
    configurarPagina();
});

//Para regresar a la pagina principal
function regresarPrincipal() {
    try {
        localStorage.removeItem('empleado');
        window.location.href = 'http://localhost:3300/principal/ventanaPrincipal'; // Redirige a la nueva página
    } catch (error) {
        console.error('Error:', error);
    }
}

//Hace el seteo de la pagina
function configurarPagina() {
    generarMenuPuesto();
    maxFecha();
}

//Insertar nuevo empleado
async function insertarEmpleado() {
    try {
        const documentoIdentidad = (String(DocumentoIdentidad.value)).trim();
        const nombre = (String(NombreEmpleado.value)).trim();
        const puesto = (btnMenuPuesto.textContent).trim();
        const fechaContratacion = (FechaContratacion.value).trim();

        if (documentoIdentidad == '' || nombre == '' ||
           puesto == 'Seleccionar puesto' || fechaContratacion == '') 
        {
            alert('Debe llenar todos los espacios solicitados.')
        } 
        else {
            const saldoVacacion = await calcularVacaciones(fechaContratacion);
            const response = await fetch('/insertar/insertarEmpleado', {
                method: 'POST',
                headers: {
                  'Content-Type': 'application/json'
                },
                body: JSON.stringify({ documentoIdentidad, nombre, puesto, 
                                        fechaContratacion, saldoVacacion, 
                                        username, ipAdress })
            });
    
            const data = await response.json();
            const code = data.outResultCode;
            console.log('Codigo resultado: ', code);
    
            if (code > 0) {
                descripcionError(code);
            }
            else {
                alert(`El empleado ha sido registrado de forma exitosa.\n
                        Nombre: ${nombre}\n
                        Documento identidad: ${documentoIdentidad}\n
                        Puesto: ${puesto}\n
                        Saldo vacaciones: ${saldoVacacion}\n
                        Fecha de ingreso: ${fechaContratacion}`);
    
                regresarPrincipal();
            }
        }
    } catch (error) {
        
    }
}

//Generar el menu dropdown
async function generarMenuPuesto() {
    try {
        const response = await fetch('/modificar/generarMenuPuesto');

        // Verifica que la respuesta sea exitosa
        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }

        const data = await response.json();

        // Verifica si el atributo menuHTML existe en la respuesta
        if (data.menuHTML) {
            DropdownPuesto.innerHTML = data.menuHTML; // Inserta el HTML en el elemento
            obtenerPuestoSeleccionado();
        } else {
            console.error("Error: No se encontró 'menuHTML' en la respuesta:", data);
        }
    } catch (error) {
        // Manejo de errores
        console.error("No se pudo generar el menú:", error);
    }
}

//Obtener el valor seleccionado
function obtenerPuestoSeleccionado() {
    document.querySelectorAll('#DropdownPuesto a').forEach(item => {
        item.addEventListener('click', (event) => {
          event.preventDefault(); // Evita que el enlace recargue la página
          const valorSeleccionado = event.target.textContent.trim(); // Obtiene el texto del elemento
          console.log('Valor seleccionado:', valorSeleccionado);
          Seleccion.textContent = valorSeleccionado;
          DropdownPuesto.classList.toggle('hidden');
        });
    });
}

//Muestra descripcion de error
async function descripcionError(codigo){
    const response = await fetch('/general/getError', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({ codigo })
      });
  
      const data = await response.json();
      resultado = data.resultado[0].Descripcion;
      alert('Error: ' + resultado);
}

//Restringe la seleccion de fecha 
function maxFecha() {
    // Obtener la fecha actual en formato yyyy-mm-dd
    const hoy = new Date().toISOString().split('T')[0];

    // Establecer el atributo max al input
    FechaContratacion.setAttribute('max', hoy);

}

//Obtener saldo vacacion
async function calcularVacaciones(fechaContratacion) {
    try {
        const response = await fetch('/insertar/calcularVacaciones', {
            method: 'POST',
            headers: {
              'Content-Type': 'application/json'
            },
            body: JSON.stringify({ fechaContratacion })
          });
      
          const data = await response.json();
          const saldoVacacion = data.outSaldoVacacion;
          console.log(saldoVacacion);
          
          return saldoVacacion;
    } catch (error) {
        console.log("No se pudo hacer calculo", error);
    }
}