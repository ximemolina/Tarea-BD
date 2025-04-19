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

    const empleado = localStorage.getItem('empleado');
    const parsedEmpleado = JSON.parse(empleado);
    const nombreEmpleado = parsedEmpleado.nombre;

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

        assignEvtCheckbox();
    } 
    catch (error) {
        console.error("Error al obtener empleados:", error);
    }   
}

//Restringe a que solo 1 checkbox este seleccionado
function assignEvtCheckbox() {
    document.querySelectorAll(".fila-checkbox").forEach(checkbox => {
        checkbox.addEventListener("change", function() {
            document.querySelectorAll(".fila-checkbox").forEach(cb => {
                if (cb !== this) {
                    cb.checked = false; // Desmarca los otros checkboxes
                }
            });
            let empleadoSeleccionado = obtenerFilaSeleccionada();
            if (empleadoSeleccionado) {
                localStorage.setItem('empleado', JSON.stringify({nombre: empleadoSeleccionado[1]}));
            }
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