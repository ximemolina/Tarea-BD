const btnCancelar = document.getElementById("btnCancelar");
const btnModificar = document.getElementById("btnModificar");
const btnMenuPuesto = document.getElementById("btnMenuPuesto");
const DropdownPuesto = document.getElementById("DropdownPuesto");
const DocumentoIdentidad = document.getElementById("DocumentoIdentidad");
const NombreEmpleado = document.getElementById("NombreEmpleado");
const Puesto = document.getElementById("Puesto");

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
        //console.log('Datos recibidos:', data.datos.Nombre);
        NombreEmpleado.textContent = `Nombre: ${data.datos.Nombre}`;
        DocumentoIdentidad.textContent = `Documento de identidad: ${data.datos.Cedula}`;
        Puesto.textContent = `Puesto: ${data.datos.Puesto}`;

        generarMenuPuesto();
    } catch (error) {
        console.log("No se pudo hacer consulta", error);
    }
}

//Modifica el empleado
async function modificarEmpleado(params) {
    
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
        } else {
            console.error("Error: No se encontró 'menuHTML' en la respuesta:", data);
        }
    } catch (error) {
        // Manejo de errores
        console.error("No se pudo generar el menú:", error);
    }
}