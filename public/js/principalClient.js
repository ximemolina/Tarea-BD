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

//Conseguir el documento de identidad del empleado para poder desplegarlo en alerta de eliminar
async function getDocumentoIdentidad(nombre){
    try {
        const response = await fetch('/principal/getDocId', {
            method: 'POST',
            headers: {
              'Content-Type': 'application/json'
            },
            body: JSON.stringify({ nombre})
          });
      
          const data = await response.json();
          resultado = data.resultado[0].ValorDocumentoIdentidad;
          return resultado;
    } catch (error) {
        alert('Error fetching IP: ' + error);
    }    

}

//Elimina el empleado seleccionado
async function eliminar(){

    const raw = localStorage.getItem('user');
    const parsedUser = JSON.parse(raw);
    const username = parsedUser.username
    const ipAdress = parsedUser.IP

    const nombreEmpleado = 'Jeffrey Watson';  //falta de alguna manera seleccionar empleado este solo para prueba****************

    let docId = await getDocumentoIdentidad(nombreEmpleado); 

    let respuesta = window.confirm('Valor Documento Identidad: '
                                    + docId 
                                    + '\nNombre: '
                                    + nombreEmpleado 
                                    +'\n¿Está seguro de eliminar este empleado?');
    if (respuesta === true) {
        eliminarAfirmado(username,ipAdress,nombreEmpleado); 
    } else { 
        eliminarCancelado(username,ipAdress,nombreEmpleado);
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


//Modificar atributo 'EsActivo' del empleado en la BD por 0 para eliminarlo
async function eliminarAfirmado(username,IpAdress,nombre){
    try {
        const response = await fetch('/principal/eliminarEmpleado', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({nombre,username,IpAdress})
            });
          
        const data = await response.json();
    } catch (error) {
        alert('Error calling SP: ' + error);
    }

}

//Añadir evento a tabla evento
async function eliminarCancelado(username,IpAdress,nombre){
    try {
        const response = await fetch('/principal/cancelEliminar', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({nombre,username,IpAdress})
            });
          
        const data = await response.json();
        window.alert('Eliminación cancelada');
    } catch (error) {
        alert('Error calling SP: ' + error);
    }
}