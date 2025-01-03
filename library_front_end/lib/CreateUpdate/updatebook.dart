import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Provider/bookprovider.dart';

class UpdateBookForm extends StatefulWidget {
  final String? bookId;
  final String? imageUrl;
  final String? title;
  final String? author;
  final int? quantity;
  final String? publicationDate;
  final String? description;

  UpdateBookForm({
    this.bookId,
    this.imageUrl,
    this.title,
    this.author,
    this.quantity,
    this.publicationDate,
    this.description,
  });

  @override
  _UpdateBookFormState createState() => _UpdateBookFormState();
}

class _UpdateBookFormState extends State<UpdateBookForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _publicationDateController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  String? _imageUrl;

  @override
  void initState() {
    super.initState();
    if (widget.bookId != null) {
      _imageUrl = widget.imageUrl;
      _titleController.text = widget.title ?? '';
      _authorController.text = widget.author ?? '';
      _quantityController.text = widget.quantity?.toString() ?? '';
      _publicationDateController.text = widget.publicationDate ?? '';
      _descriptionController.text = widget.description ?? '';
      _imageUrlController.text = widget.imageUrl ?? '';
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      final provider = Provider.of<BookProvider>(context, listen: false);

      final bookData = {
        'title': _titleController.text,
        'author': _authorController.text,
        'quantity': int.tryParse(_quantityController.text) ?? 0,
        'image': _imageUrlController.text.isNotEmpty ? _imageUrlController.text : null,
        'publicationDate': _publicationDateController.text,
        'description': _descriptionController.text,
      };

      try {
        if (widget.bookId == null) {
          await provider.addBook(bookData);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Book added successfully'),
              behavior: SnackBarBehavior.floating,
              margin: EdgeInsets.fromLTRB(20, 0, 20, 20),
            ),
          );
        } else {
          await provider.updateBook(widget.bookId!, bookData);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Book updated successfully'),
              behavior: SnackBarBehavior.floating,
              margin: EdgeInsets.fromLTRB(20, 0, 20, 20),
            ),
          );
        }

        Navigator.of(context).pop(); // Go back to the previous screen
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        title: Text(
          widget.bookId == null ? 'Add Book' : 'Update - ${widget.title}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 21,
            fontFamily: 'merriweatherdark',
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_imageUrl != null && _imageUrl!.isNotEmpty)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.network(
                          _imageUrl!,
                          width: 200,
                          height: 250,
                          fit: BoxFit.cover,
                        ),
                      ],
                    ),
                  SizedBox(height: 20),
                  Divider(thickness: 3, color: Colors.indigo[900]),
                  TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(labelText: 'Title'),
                    validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter a title' : null,
                  ),
                  TextFormField(
                    controller: _authorController,
                    decoration: InputDecoration(labelText: 'Author'),
                    validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter an author' : null,
                  ),
                  TextFormField(
                    controller: _quantityController,
                    decoration: InputDecoration(labelText: 'Quantity'),
                    keyboardType: TextInputType.number,
                    validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter a quantity' : null,
                  ),
                  TextFormField(
                    controller: _publicationDateController,
                    decoration: InputDecoration(labelText: 'Publication Date'),
                    validator: (value) => value?.isEmpty ?? true
                        ? 'Please enter a publication date'
                        : null,
                  ),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: InputDecoration(labelText: 'Description'),
                    validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter a description' : null,
                  ),
                  TextFormField(
                    controller: _imageUrlController,
                    decoration: InputDecoration(labelText: 'Image URL (Optional)'),
                    keyboardType: TextInputType.url,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _submitForm,
                    child: Text(widget.bookId == null ? 'Add Book' : 'Update Book'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo[900],
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
