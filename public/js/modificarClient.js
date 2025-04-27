const btnCancelar = document.getElementById("btnCancelar");
const btnModificar = document.getElementById("btnModificar");
const btnMenuPuesto = document.getElementById("btnMenuPuesto");
const DropdownPuesto = document.getElementById("DropdownPuesto");
const DocumentoIdentidad = document.getElementById("DocumentoIdentidad");
const DocumentoIdentidadNuevo = document.getElementById("DocumentoIdentidadNuevo");
const NombreEmpleado = document.getElementById("NombreEmpleado");
const NombreNuevo = document.getElementById("NombreNuevo");
const Puesto = document.getElementById("Puesto");
const Seleccion = document.getElementById("Seleccion");

const raw = localStorage.getItem('user');
const parsedUser = JSON.parse(raw);
const username = parsedUser.username;
const ipAdress = parsedUser.IP;
const empleado = localStorage.getItem('empleado');
const parsedEmpleado = JSON.parse(empleado);
const nombre = parsedEmpleado.nombre;

btnCancelar.addEventListener('click', regresarPrincipal);
btnModificar.addEventListener('click', modificarEmpleado);
btnMenuPuesto.addEventListener('click', () => {
    const isExpanded = btnMenuPuesto.getAttribute('aria-expanded') === 'true';
    // Alterna el atributo aria-expanded
    btnMenuPuesto.setAttribute('aria-expanded', !isExpanded);
    // Alterna la visibilidad del menú
    DropdownPuesto.classList.toggle('hidden');
});



window.addEventListener('DOMContentLoaded', () => {
    mostrarEmpleado();
});

//Para regresar a la pagina principal
function regresarPrincipal() {
    try {
        localStorage.removeItem('empleado');
        localStorage.removeItem('DIActual');
        window.location.href = 'http://localhost:3300/principal/ventanaPrincipal'; // Redirige a la nueva página
    } catch (error) {
        console.error('Error:', error);
    }
}

//Muestra la info actual del empleado
async function mostrarEmpleado() {
    try {
        const response = await fetch('/modificar/datosEmpleado', {
            method: 'POST',
            headers: {
              'Content-Type': 'application/json'
            },
            body: JSON.stringify({ nombre })
        });

        const data = await response.json();

        NombreEmpleado.textContent = `Nombre: ${data.datos.Nombre}`;
        NombreNuevo.value = data.datos.Nombre;
        DocumentoIdentidad.textContent = `Documento de identidad: ${data.datos.Cedula}`;
        DocumentoIdentidadNuevo.value = data.datos.Cedula;
        Puesto.textContent = `Puesto: ${data.datos.Puesto}`;
        Seleccion.textContent = data.datos.Puesto;
        localStorage.setItem('DIActual', JSON.stringify({DI: data.datos.Cedula}));
        console.log(localStorage.getItem("DIActual"));
 
        generarMenuPuesto();
    } catch (error) {
        console.log("No se pudo hacer consulta", error);
    }
}

//Modifica el empleado
async function modificarEmpleado(params) {
    try {
        const rawDI = localStorage.getItem('DIActual');
        const parsedDI = JSON.parse(rawDI);
        const actualDI = parsedDI.DI;
        console.log(actualDI);
        const nombreActual = nombre;
        const nombreNuevo = NombreNuevo.value;
        const DIActual = String(actualDI);
        const DINuevo = DocumentoIdentidadNuevo.value;
        const puestoNuevo = Seleccion.textContent;

        const response = await fetch('/modificar/modificarEmpleado', {
            method: 'POST',
            headers: {
              'Content-Type': 'application/json'
            },
            body: JSON.stringify({ nombreActual, nombreNuevo, 
                                    DIActual, DINuevo, puestoNuevo, 
                                    username, ipAdress })
        });

        const data = await response.json();
        const code = data.outResultCode;
        console.log(code);

        if (code > 0) {
            descripcionError(code);
        }
        else {
            alert('Los datos del empleado han sido modificados exitosamente');
            
            let empleado = JSON.parse(localStorage.getItem('empleado'));
            empleado.nombre = nombreNuevo;
            localStorage.setItem('empleado', JSON.stringify(empleado));

            mostrarEmpleado();
        }
        
    } catch (error) {
        console.log("No se pudo hacer modificacion", error);
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
