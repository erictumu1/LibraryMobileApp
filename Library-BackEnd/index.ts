import express from 'express';
import helmet from 'helmet';
import mongoose from 'mongoose';
import bookRoutes from './routes/book.route';


const app = express();

//Further Sanitation
app.use(helmet()); 

//middleware
app.use(express.json());

//Routes
app.use("/books", bookRoutes);

app.get("/", (req,res) => {
    res.send("Using Node JS now.")
});

mongoose.connect("mongodb+srv://mybestday971:WdiiVxoqTuMRwmcT@library.tlj8u.mongodb.net/Library-BackEnd?retryWrites=true&w=majority&appName=Library")
.then(() => {
    app.listen(3000, () =>{
    console.log("Connected to the Database.");
    });
})
.catch((error) =>{
    console.log("Error connecting to the DataBase.", error);
});