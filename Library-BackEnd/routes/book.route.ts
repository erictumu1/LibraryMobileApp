import express from 'express';
import {
    createBooks,
    deleteBook,
    readAllBooks,
    searchForBook,
    updateBook,
    viewBookDetails,
} from '../controllers/books.controller';
const router = express.Router();

router.post('/', createBooks);
router.get('/', readAllBooks);
router.get('/search', searchForBook);
router.get('/:id', viewBookDetails);
router.put('/:id', updateBook);
router.delete('/:id', deleteBook);

export default router;