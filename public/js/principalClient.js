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
    } 
    catch (error) {
        console.error("Error al obtener empleados:", error);
    }   
}
