import mongoose, { Document, Schema } from 'mongoose';

export interface IBook extends Document{
    title: String;
    author: string;
    publicationDate: string;
    quantity: number;
    image?: string;
    description: string;
    color: String
    createdAt?: Date;
    updatedAt?: Date;
}

const BookSchema: Schema = new Schema({
    title: {
        type: String,
        required: [true, "Enter the book title"],
        index: true
    },
    author: {
        type: String,
        required: [true, "Enter the Author name"],
        index: true

    },
    publicationDate: {
        type: String,
        required:true
    },
    quantity: {
        type: Number,
        required: true,
        default: 0
    },
    image: {
        type: String,
        required : false
    },
    color: {
        type: String,
        required : false
    },
    description: {
        type: String,
        require: [true, "Enter the Book description"]
    },
},
{
    timestamps: true,
}
);

const Book = mongoose.model<IBook>('Book', BookSchema);
export default Book;