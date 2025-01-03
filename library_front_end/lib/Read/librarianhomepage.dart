import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../CreateUpdate/updatebook.dart';
import '../Provider/bookprovider.dart';
// import 'package:google_fonts/google_fonts.dart';

class LibrarianHomepage extends StatefulWidget {
  const LibrarianHomepage({super.key});

  @override
  State<LibrarianHomepage> createState() => _LibrarianHomepageState();
}

class _LibrarianHomepageState extends State<LibrarianHomepage> with TickerProviderStateMixin {
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final bookProvider = Provider.of<BookProvider>(context, listen: false);
      bookProvider.fetchData();
    });
  }

  // User Sign out
  void signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  void deleteBook(BuildContext context, String bookId) async {
    try {
      final bookProvider = Provider.of<BookProvider>(context, listen: false);
      await bookProvider.deleteBook(bookId);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Book deleted successfully'),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.fromLTRB(20, 0, 20, 20),
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error deleting book: $error'),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.fromLTRB(20, 0, 20, 20),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          backgroundColor: Colors.grey[100],
          leading: Icon(
            Icons.library_books_rounded,
            color: Colors.indigo[900],
            size: 30,
          ),
          title: Text(
            'Books Available',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 21,
              fontFamily: 'merriweatherdark'
            ),
          ),
          actions: [
            IconButton(
              onPressed: signOut,
              icon: Icon(Icons.logout, color: Colors.red),
            ),
          ],
        ),
        body: Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Search by title or author...',
                  prefixIcon: Icon(Icons.search, color: Colors.indigo[900]),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onChanged: (value) {
                  Provider.of<BookProvider>(context, listen: false).searchBooks(value);
                },
              ),
            ),
            Expanded(
              child: Consumer<BookProvider>(
                builder: (context, bookProvider, child) {
                  final filteredArticles = bookProvider.filteredArticles;

                  return RefreshIndicator(
                    onRefresh: () async {
                      await bookProvider.fetchData();
                    },
                    color: Colors.indigo[900],
                    child: filteredArticles.isEmpty
                        ? Center(
                      child: bookProvider.articles.isEmpty
                          ? CircularProgressIndicator(
                        color: Colors.indigo[900],
                      )
                          : Text(
                        'No books found',
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                    )
                        : ListView.builder(
                      itemCount: filteredArticles.length,
                      itemBuilder: (context, index) {
                        final article = filteredArticles[index];
                        return Card(
                          color: Colors.white,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              article['image'] != null
                                  ? Image.network(
                                article['image'],
                                width: 100,
                                height: 150,
                                fit: BoxFit.cover,
                              )
                                  : Image.asset('lib/images/book.png',
                                  width: 100, height: 120, fit: BoxFit.cover),
                              SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      article['title'] ?? 'No title',
                                      style: TextStyle(
                                        color: Colors.indigo[900],
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Playfair',
                                      ),
                                    ),
                                    Text(
                                      'Author: ${article['author'] ?? 'Unknown'}',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                      ),
                                    ),
                                    Text(
                                      'Units Available: ${article['quantity']}',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => UpdateBookForm(
                                                  bookId: article['_id'],
                                                  imageUrl: article['image'],
                                                  title: article['title'],
                                                  author: article['author'],
                                                  quantity: article['quantity'],
                                                  publicationDate: article['publicationDate'],
                                                  description: article['description'],
                                                ),
                                              ),
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.orange,
                                          ),
                                          child: Text(
                                            'Update',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        ElevatedButton(
                                          onPressed: () => deleteBook(context, article['_id']),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red,
                                          ),
                                          child: Text(
                                            'Delete',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => UpdateBookForm()),
            );
          },
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          backgroundColor: Colors.green[900],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }
}
