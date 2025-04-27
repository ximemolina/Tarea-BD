const btnCancelar = document.getElementById("btnCancelar");
const btnInsertar = document.getElementById("btnInsertar");
const NombreEmpleado = document.getElementById("NombreEmpleado");
const DocumentoIdentidad = document.getElementById("DocumentoIdentidad");
const btnMenuPuesto = document.getElementById("btnMenuPuesto");
const DropdownPuesto = document.getElementById("DropdownPuesto");

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

//Para regresar a la pagina principal
function regresarPrincipal() {
    try {
        localStorage.removeItem('empleado');
        window.location.href = 'http://localhost:3300/principal/ventanaPrincipal'; // Redirige a la nueva página
    } catch (error) {
        console.error('Error:', error);
    }
}

//Insertar nuevo empleado
async function insertarEmpleado() {
    
}