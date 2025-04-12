const btnLogin = document.getElementById("btnLogin");
const username = document.getElementById("username").value;
const password = document.getElementById("password").value;

btnLogin.addEventListener("click", login)


async function fetchIp(){
    try {
        const response = await fetch('/login/getIp');
        const data = await response.text();
        return data;
    } catch (error) {
        alert('Error fetching IP: ' + error);
    }
}

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
            alert(data.resultado);
        })
    } catch (error) {
        alert("Login error: " + error.message);
    }

}