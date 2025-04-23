const btnRegresar = document.getElementById('btnRegresar');

btnRegresar.addEventListener('click', regresarPrincipal);

//Regresa a la pagina principal
function regresarPrincipal() {
    try {
        localStorage.removeItem('empleado');
        window.location.href = 'http://localhost:3300/principal/ventanaPrincipal'; // Redirige a la nueva página
    } catch (error) {
        console.error('Error:', error);
    }
}