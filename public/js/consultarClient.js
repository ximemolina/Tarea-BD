const btnRegresar = document.getElementById('btnRegresar');

btnRegresar.addEventListener('click', regresarPrincipal);

window.addEventListener('DOMContentLoaded', () => {
    consultarEmpleado();
  });

//Regresa a la pagina principal
function regresarPrincipal() {
    try {
        localStorage.removeItem('empleado');
        window.location.href = 'http://localhost:3300/principal/ventanaPrincipal'; // Redirige a la nueva página
    } catch (error) {
        console.error('Error:', error);
    }
}

//Muestra la informacion del empleado consultado
async function consultarEmpleado() {
    try {
        const empleado = localStorage.getItem('empleado');
        const parsedEmpleado = JSON.parse(empleado);
        const nombre = parsedEmpleado.nombre;
        
        const response = await fetch('/consultar/consultarEmpleado', {
            method: 'POST',
            headers: {
              'Content-Type': 'application/json'
            },
            body: JSON.stringify({ nombre })
        });

        const data = await response.json();
        console.log('Datos recibidos:', data);
        
        if (data.infoHTML) {
            document.getElementById("infoConsulta").innerHTML = data.infoHTML;
        } else {
            console.error("Error: No se encontró infoHTML en la respuesta:", data);
        }
    } catch (error) {
        console.log("No se pudo hacer consulta", error);
    }
}

