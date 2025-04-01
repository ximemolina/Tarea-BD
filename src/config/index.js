import express from 'express';
import * as database from "./database.js"

const configApi = (app) =>{
    app.use(express.json())
    app.use(express.urlencoded({extended: true}))
}

const init = () => {
    const app = express()
    configApi(app)
    app.listen(3300)
    console.log("Iniciado servidor")
    database.conectarDB()
}

//Inicializar servidor y conexión con base de datos
init(); 