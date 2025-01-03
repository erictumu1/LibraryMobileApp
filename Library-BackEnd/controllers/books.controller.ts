import { Request, Response } from 'express';
import { body, query, validationResult } from 'express-validator';
import mongoose from 'mongoose';
import Books from '../models/books.models';

//Create 
export const createBooks = [
    // Validation and sanitization
    body('title').isString().withMessage('Title should be a string').trim(),
    body('author').isString().withMessage('Author should be a string').trim(),
    body('publicationDate').isDate().withMessage('Date should be a string').trim(),
    body('quantity').isInt({ min: 0 }).withMessage('Quantity must be a positive number'),

    async (req: Request, res: Response) => {
        const errors = validationResult(req);
        if (!errors.isEmpty()) {
            return res.status(400).json({ errors: errors.array() });
        }
        
        try {
            const book = await Books.create(req.body);
            res.status(200).json(book);
        } catch (error) {
            res.status(500).json({ message: error.message, error });
        }
    }
];

//View all books
export const readAllBooks = async (req: Request, res: Response) => {
    try{
        const allBooks = await Books.find({});
        res.status(200).json(allBooks);
    }
    catch(error) {
        res.status(500).json({ message: error.message});
    }
}

//Search for a book
export const searchForBook = [
    // Validation and sanitization
    query('criteria').isIn(['title', 'author']).withMessage('Invalid criteria. Valid values are "title" or "author"'),
    query('keyword').isString().withMessage('Keyword must be a string').trim(),

    // Handle the request
    async (req: Request, res: Response) => {
        const errors = validationResult(req);
        if (!errors.isEmpty()) {
            return res.status(400).json({ errors: errors.array() });
        }

        const { criteria, keyword } = req.query;

        try {
            const books = await Books.find({
                [criteria]: { $regex: keyword, $options: 'i' }
            });

            if (books.length === 0) {
                return res.status(404).json({ message: "No books found matching your criteria." });
            }

            res.status(200).json(books);
        } catch (error) {
            res.status(500).json({ message: error.message });
        }
    }
];

//View Book details
export const viewBookDetails = async (req: Request, res: Response) => {
    try{
        const { id } = req.params;
        const book = await Books.findById(id)

        if(!book){
            res.status(404).json({message: "We don't have the book currently, Will be stocked shortly"});
        }
        res.status(200).json(book);
    }
    catch(error){
        res.status(500).json({ message: error.message });
    }
}

//Update
export const updateBook = [
    // Validation and sanitization
    body('title').optional().isString().withMessage('Title should be a string').trim(),
    body('author').optional().isString().withMessage('Author should be a string').trim(),
    body('publicationDate').optional().isDate().withMessage('Date should be a string').trim(),
    body('quantity').optional().isInt({ min: 0 }).withMessage('Quantity must be a positive integer'),

    // Handle the request
    async (req: Request, res: Response) => {
        const errors = validationResult(req);
        if (!errors.isEmpty()) {
            return res.status(400).json({ errors: errors.array() });
        }

        const { id } = req.params;
        try {
            const book = await Books.findByIdAndUpdate(id, req.body);
            
            if (!book) {
                return res.status(404).json({ message: "Book doesn't exist, Please try again" });
            }

            const updatedBook = await Books.findById(id);
            res.status(200).json(updatedBook);
        } catch (error) {
            res.status(500).json({ message: error.message });
        }
    }
];
//Delete
export const deleteBook = async (req: Request, res: Response) => {
    const { id } = req.params;

    // Validation of ObjectId
    if (!mongoose.Types.ObjectId.isValid(id)) {
        return res.status(400).json({ message: 'Invalid book ID' });
    }

    try {
        const book = await Books.findByIdAndDelete(id);
        if (!book) {
            return res.status(404).json({ message: "The book you are trying to delete doesn't exist." });
        }

        res.status(200).json(book);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};