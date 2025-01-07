import express from "express"
import { db } from "./models/db/db.js"

import userRouter from "./routes/UserRoute.js"

const PORT = 3930

const app = express()

app.use(express.json())

app.use('/users', userRouter)

app.get('/', (req, res) => {
    res.send('Hello World')
})

app.listen(PORT, () => {
    console.log('Server is running on port ' + PORT)
})