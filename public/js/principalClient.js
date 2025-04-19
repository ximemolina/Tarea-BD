const btnInsertar = document.getElementById("btnInsertar");
const btnEliminar = document.getElementById("btnEliminar");
const btnModificar = document.getElementById("btnModificar");
const btnConsultar = document.getElementById("btnConsultar");
const btnListarMovi = document.getElementById("btnListarMovi");

btnInsertar.addEventListener("click", insertar);
btnEliminar.addEventListener("click", eliminar);
btnModificar.addEventListener("click", modificar);
btnConsultar.addEventListener("click", consultar);
btnConsultar.addEventListener("click", listarMovimientos);

window.addEventListener('DOMContentLoaded', () => {
    listarEmpleados();
  });

/////////////////////////// FUNCIONES PRINCIPALES ///////////////////////////
//Inserta un nuevo empleado
function insertar(){

}

//Elimina el empleado seleccionado
function eliminar(){
    //falta de alguna manera seleccionar empleado

    let respuesta = window.confirm('¿Está seguro de eliminar este empleado?');
    if (respuesta === true) {
        //fetch al SP de Eliminar
    } else { 
        window.alert('Eliminación cancelada');
    }
}

function modificar(){
    
}

function consultar(){
    
}

function listarMovimientos() {

}

/////////////////////////// FUNCIONES AUXILIARES ///////////////////////////
//Carga la tabla a la vista
async function listarEmpleados() {
    try {
        const response = await fetch('/principal/listarEmpleados');
        const tablaHTML = await response.text();
        document.getElementById("tablaEmpleados").innerHTML = tablaHTML; // Insertar en el HTML

        assignEvtCheckbox();
    } 
    catch (error) {
        console.error("Error al obtener empleados:", error);
    }   
}

//Restringe la a que solo 1 checkbox este seleccionado
function assignEvtCheckbox() {
    document.querySelectorAll(".fila-checkbox").forEach(checkbox => {
        checkbox.addEventListener("change", function() {
            document.querySelectorAll(".fila-checkbox").forEach(cb => {
                if (cb !== this) {
                    cb.checked = false; // Desmarca los otros checkboxes
                }
            });
            let empleadoSeleccionado = obtenerFilaSeleccionada();
            localStorage.setItem('empleado', JSON.stringify(empleadoSeleccionado[1]));
            //console.log("Local storage", localStorage.getItem('empleado'));
            return empleadoSeleccionado;
        });
    });
}

// Devuelve el nombre del empleado que ha sido seleccionado de la tabla
function obtenerFilaSeleccionada() {
    // Buscar el checkbox que está marcado
    const checkboxSeleccionado = document.querySelector(".fila-checkbox:checked");
    
    if (checkboxSeleccionado) {
        // Obtener la fila (`tr`) que contiene el checkbox
        const fila = checkboxSeleccionado.closest("tr");

        // Extraer los valores de las celdas (`td`)
        const datosFila = Array.from(fila.children).map(td => td.textContent.trim());

        console.log("Fila seleccionada:", datosFila);
        return datosFila; // Devuelve los datos de la fila en forma de array
    } else {
        localStorage.removeItem('empleado');
        console.log("No hay ninguna fila seleccionada.");
        return null;
    }
}
