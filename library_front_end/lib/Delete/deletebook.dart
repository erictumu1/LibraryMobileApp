import 'package:http/http.dart' as http;

class DeleteBook {
  static Future<bool> deleteBook(String bookId) async {
    final url = Uri.parse('http://172.30.208.1:3000/books/$bookId');
    try {
      final response = await http.delete(url);

      if (response.statusCode == 200) {
        print('Book deleted successfully.');
        return true;
      } else if (response.statusCode == 404) {
        print("The book you're trying to delete doesn't exist.");
      } else {
        print('Failed to delete the book. Error: ${response.statusCode}');
      }
    } catch (error) {
      print('Error while deleting the book: $error');
    }
    return false;
  }
}
