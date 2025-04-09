const btnLogin = document.getElementById("btnLogin")

btnLogin.addEventListener("click", prueba)


function prueba(){
    fetch('/login/getIp')
    .then(response => response.text())
    .then(data => {
    alert('Your IP is:'+ data);
    })
    .catch(error => {
    alert('Error fetching IP:'+ error);
    });
}