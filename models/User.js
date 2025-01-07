import { db } from './db/db.js'

export class User {

    // obtener todos los usuarios
    static async obtenerTodosUsuarios() {
        const users = await db.sequelize.query(
            'select idUsuario, nombre, apellido1, apellido2, correo, contrasena, estado from usuarios',
            {type: db.sequelize.QueryTypes.SELECT}
        )

        return users
    }

    // obtener un usuario por email
    static async obtenerUsuarioEmail({email}) {
        const user = await db.sequelize.query(
            'select idUsuario, nombre, apellido1, apellido2, correo, contrasena, estado from usuarios where correo = :email', {
                replacements: { email },
                type: db.sequelize.QueryTypes.SELECT
            }
        )

        return user
    }

    // verificar si el correo ya existe
    static async verificarCorreo({correo}) {
        const user = await db.sequelize.query(
            'select idUsuario from usuarios where correo = :correo', {
                replacements: { correo },
                type: db.sequelize.QueryTypes.SELECT
            }
        )

        return user.length > 0
    }

    // crear un usuario
    static async crearUsuario({nombre, apellido1, apellido2, correo, contrasena}) {
        const user = await db.sequelize.query(
            'insert into usuarios (nombre, apellido1, apellido2, correo, contrasena) values (:nombre, :apellido1, :apellido2, :correo, :contrasena)', {
                replacements: { nombre, apellido1, apellido2, correo, contrasena },
                type: db.sequelize.QueryTypes.INSERT
            }
        ).catch(error => {{
            console.log(error)
        }})

        return user
    }

}