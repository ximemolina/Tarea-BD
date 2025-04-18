const btnInsertar = document.getElementById("btnInsertar");
const btnEliminar = document.getElementById("btnEliminar");
const btnModificar = document.getElementById("btnModificar");
const btnConsultar = document.getElementById("btnConsultar");

btnInsertar.addEventListener("click", insertar);
btnEliminar.addEventListener("click", eliminar);
btnModificar.addEventListener("click", modificar);
btnConsultar.addEventListener("click", consultar);

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