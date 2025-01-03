import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BookProvider with ChangeNotifier {
  List<dynamic> articles = [];
  List<dynamic> filteredArticles = [];

  // Default search criteria
  String selectedCriteria = 'title';

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse('http://172.24.112.1:3000/books'));

    if (response.statusCode == 200) {
      articles = jsonDecode(response.body);

      // Sorts to ensure the newest book added comes up to the top
      articles.sort((a, b) => b['createdAt'].compareTo(a['createdAt']));

      // Update filteredArticles with the newly sorted data
      filteredArticles = List.from(articles);
      notifyListeners();
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> searchBooks(String keyword) async {
    if (keyword.isEmpty) {
      filteredArticles = articles;
    } else {
      try {
        final response = await http.get(
          Uri.parse('http://172.24.112.1:3000/books/search').replace(
            queryParameters: {
              'criteria': selectedCriteria,
              'keyword': keyword,
            },
          ),
        );

        if (response.statusCode == 200) {
          filteredArticles = jsonDecode(response.body);
        } else if (response.statusCode == 404) {
          filteredArticles = []; // No books found
        } else {
          throw Exception('Failed to search books');
        }
      } catch (error) {
        print('Search error: $error');
      }
    }
    notifyListeners();
  }

  Future<void> addBook(Map<String, dynamic> bookData) async {
    final uri = Uri.parse('http://172.24.112.1:3000/books');
    final response = await http.post(
      uri,
      body: json.encode(bookData),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final newBook = jsonDecode(response.body);

      // Ensures a book goes to the top when it is added
      articles.insert(0, newBook);
      filteredArticles.insert(0, newBook);

      notifyListeners();

    } else {
      throw Exception('Failed to add book');
    }
  }


  Future<void> updateBook(String bookId, Map<String, dynamic> bookData) async {
    final uri = Uri.parse('http://172.24.112.1:3000/books/$bookId');
    final response = await http.put(
      uri,
      body: json.encode(bookData),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      await fetchData();
    } else {
      throw Exception('Failed to update book');
    }
  }

  Future<void> deleteBook(String bookId) async {
    final url = Uri.parse('http://172.24.112.1:3000/books/$bookId');
    try {
      final response = await http.delete(url);

      if (response.statusCode == 200) {
        print('Book deleted successfully.');

        articles.removeWhere((book) => book['_id'] == bookId);
        filteredArticles = List.from(articles);

        notifyListeners();

      } else if (response.statusCode == 404) {
        print("The book you're trying to delete doesn't exist.");
      } else {
        print('Failed to delete the book. Error: ${response.statusCode}');
      }
    } catch (error) {
      print('Error while deleting the book: $error');
      throw Exception('Failed to delete book: $error');
    }
  }

  void removeBook(String bookId) {
    articles.removeWhere((article) => article['_id'] == bookId);
    filteredArticles.removeWhere((article) => article['_id'] == bookId);

    notifyListeners();
  }

  Future<void> refreshData() async {
    await fetchData();
  }
}
