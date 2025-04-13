const btnLogin = document.getElementById("btnLogin");
const username = document.getElementById("username").value;
const password = document.getElementById("password").value;

btnLogin.addEventListener("click", login)

//Consigue el IpAdress del usuario
async function fetchIp(){
    try {
        const response = await fetch('/login/getIp');
        const data = await response.text();
        return data;
    } catch (error) {
        alert('Error fetching IP: ' + error);
    }
}

//Revisa los datos que ingresó el usuario a las casillas y verifica si el usuario ya está en la base de datos
async function login(){
    try {
        const ipAdress = await fetchIp();
        fetch('/login/revLogin', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({ username, password, ipAdress })
        })
        .then(response => response.json())
        .then(data => {
            revCodigo(data.resultado)
        })
        .catch(error => {
            console.error("Error parsing response:", error);
        })
    } catch (error) {
        alert("Login error: " + error.message);
    }

}

//Revisa codigo que retorna el SP y decide que accion realizar
function revCodigo(codigo) {
    if (codigo == 0) {
        //no hay error !! pasa a siguiente html
    }
    if (codigo == 50003) {
        bloqueoLogin();
    }
}


//Deshabilita el boton de Login en caso de que el user haya hecho +5 login fallidos
function bloqueoLogin() {
    //alert con mensaje de error
    btnLogin.disabled = true;

}