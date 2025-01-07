import { Router } from "express"
import { UserController } from "../controllers/UserController.js"

const userRouter = Router()

userRouter.get('/', UserController.obtenerTodosUsuarios)
userRouter.get('/email', UserController.obtenerUsuarioEmail)

userRouter.post('/', UserController.crearUsuario)

export default userRouter