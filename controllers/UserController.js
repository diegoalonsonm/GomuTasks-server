import { User } from '../models/User.js'

export class UserController {

    // obtener todos los usuarios
    static async obtenerTodosUsuarios(req, res) {
        try {
            const users = await User.obtenerTodosUsuarios()
            res.json(users)
        } catch (error) {
            console.log(error)
            res.send('Error: ' + error.message)
        }
    }

    // obtener un usuario por email
    static async obtenerUsuarioEmail(req, res) {
        try {
            const { email } = req.query
            const user = await User.obtenerUsuarioEmail({email})
            res.json(user)
        } catch (error) {
            res.status(500).send('Error: ' + error.message)
        }
    }

    // crear un usuario
    static async crearUsuario(req, res) {
        try {
            const user = req.body

            if (user.error) return res.status(400).json({error: JSON.parse(user.error.message)})

            const existeCorreo = await User.verificarCorreo({correo: user.correo})

            if (existeCorreo) return res.status(400).json({error: 'El correo ya existe'})

            const newUser = await User.crearUsuario(user)
            res.json(newUser)
        } catch (error) {
            console.log(error)
            res.status(500).send('Error: ' + error.message)
        }
    }

}