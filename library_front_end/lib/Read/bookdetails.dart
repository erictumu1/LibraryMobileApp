import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:library_front_end/Provider/bookprovider.dart';

class BookDetails extends StatelessWidget {
  final String bookId;

  const BookDetails({super.key, required this.bookId});

  @override
  Widget build(BuildContext context) {
    final bookProvider = context.watch<BookProvider>();
    final bookDetails =
    bookProvider.articles.firstWhere((book) => book['_id'] == bookId, orElse: () => null);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Book Details',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 21,
                fontFamily: 'merriweatherdark'),
          ),
          backgroundColor: Colors.grey[300],
        ),
        body: bookProvider.articles.isEmpty
            ? Center(
          child: CircularProgressIndicator(
            color: Colors.indigo[900],
          ),
        )
            : bookDetails == null
            ? Center(
          child: Text(
            "We don't have the book currently. Will be stocked shortly.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
        )
            : Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (bookDetails['image'] != null)
                  Center(
                    child: Image.network(
                      bookDetails['image'],
                      height: 200,
                    ),
                  ),
                Divider(
                  height: 60.0,
                  color: Colors.indigo[900],
                  thickness: 3,
                ),
                Text(
                  bookDetails['title'] ?? 'No Title',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo[900],
                    fontFamily: 'Playfair',
                  ),
                ),
                SizedBox(height: 40),
                Text(
                  'Author: ${bookDetails['author'] ?? 'Unknown'}',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 10),
                Text(
                  'Units Available: ${bookDetails['quantity'] ?? 0}',
                  style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 40),
                Text(
                  'Description:',
                  style: TextStyle(
                      fontSize: 25, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  bookDetails['description'] ??
                      'No description available.',
                  style: TextStyle(
                      fontSize: 20, fontFamily: 'merriweatherlight'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
