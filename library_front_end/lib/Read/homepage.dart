import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:library_front_end/Login/login.dart';
import 'package:library_front_end/Provider/bookprovider.dart';
import 'package:library_front_end/Read/bookdetails.dart';
import 'package:provider/provider.dart';
// import 'package:google_fonts/google_fonts.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homepage> {
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final bookProvider = Provider.of<BookProvider>(context, listen: false);
    bookProvider.fetchData();
  }

  // User Sign out
  void signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    final bookProvider = Provider.of<BookProvider>(context);

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
              fontFamily: 'merriweatherdark',
            ),
          ),
          actions: [
            IconButton(onPressed: signOut, icon: Icon(Icons.logout, color: Colors.red,))
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
                  bookProvider.searchBooks(value);
                },
              ),
            ),
            // Refresh Indicator with GridView
            Expanded(
              child: RefreshIndicator(
                onRefresh: bookProvider.refreshData,
                color: Colors.indigo[900],
                child: bookProvider.filteredArticles.isEmpty
                    ? Center(
                  child: bookProvider.articles.isEmpty
                      ? CircularProgressIndicator(
                    color: Colors.indigo[900],
                  )
                      : Text(
                    'No books found',
                    style: TextStyle(
                        color: Colors.black, fontSize: 16),
                  ),
                )
                    : GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Display two books per row
                    crossAxisSpacing: 10, // Horizontal spacing
                    mainAxisSpacing: 10, // Vertical spacing
                    childAspectRatio: 0.7, // Adjust the size of the tiles
                  ),
                  itemCount: bookProvider.filteredArticles.length,
                  itemBuilder: (context, index) {
                    final article = bookProvider.filteredArticles[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BookDetails(
                              bookId: article['_id'],
                            ),
                          ),
                        );
                      },
                      child: SingleChildScrollView(
                        child: Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          color: Colors.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  topRight: Radius.circular(12),
                                ),
                                child: article['image'] != null
                                    ? Image.network(
                                  article['image'],
                                  height: 150,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                )
                                    : Image.asset(
                                  'lib/images/book.png',
                                  height: 150,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // Book Title
                                      Text(
                                        article['title'] ?? 'No title',
                                        style: TextStyle(
                                            color: Colors.indigo[900],
                                            fontSize: 19,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Playfair'),
                                      ),
                                      SizedBox(height: 4),
                                      // Book Author
                                      Text(
                                        'Author: ${article['author'] ?? 'Unknown'}',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16),
                                      ),
                                      SizedBox(height: 8),
                                      // Book Quantity
                                      Text(
                                        'Units Available: ${article['quantity']}',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
