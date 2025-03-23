import 'dart:convert';
import 'package:ebook_app/models/book_model.dart';
import 'package:http/http.dart' as http;
import '../models/book.dart';


class BookService {
  static const String _baseUrl = 'https://waka-api.example.com/api'; // Mock API endpoint

  // Fetch featured books
  Future<List<Book>> getFeaturedBooks() async {
    try {
      // In a real app, this would make an actual API call
      // await http.get(Uri.parse('$_baseUrl/books/featured'));
      
      // For now, return mock data
      await Future.delayed(const Duration(milliseconds: 800)); // Simulate network delay
      return _getMockFeaturedBooks();
    } catch (e) {
      print('Error fetching featured books: $e');
      return [];
    }
  }

  // Fetch books by category
  Future<List<Book>> getBooksByCategory(String categoryId) async {
    try {
      // In a real app, this would be:
      // final response = await http.get(Uri.parse('$_baseUrl/categories/$categoryId/books'));
      
      await Future.delayed(const Duration(milliseconds: 800));
      return _getMockBooksByCategory(categoryId);
    } catch (e) {
      print('Error fetching books by category: $e');
      return [];
    }
  }

  // Get book details
  Future<Book?> getBookDetails(String bookId) async {
    try {
      // In a real app: await http.get(Uri.parse('$_baseUrl/books/$bookId'));
      
      await Future.delayed(const Duration(milliseconds: 500));
      return _getMockBookById(bookId);
    } catch (e) {
      print('Error fetching book details: $e');
      return null;
    }
  }

  // Get user's library books
  Future<List<Book>> getUserLibrary(String userId) async {
    try {
      // In a real app: await http.get(Uri.parse('$_baseUrl/users/$userId/library'));
      
      await Future.delayed(const Duration(milliseconds: 700));
      return _getMockUserLibrary();
    } catch (e) {
      print('Error fetching user library: $e');
      return [];
    }
  }

  // Search books
  Future<List<Book>> searchBooks(String query) async {
    try {
      // In a real app: await http.get(Uri.parse('$_baseUrl/books/search?q=$query'));
      
      await Future.delayed(const Duration(milliseconds: 600));
      return _searchMockBooks(query);
    } catch (e) {
      print('Error searching books: $e');
      return [];
    }
  }

  // Mock data providers
  List<Book> _getMockFeaturedBooks() {
    return [
      Book(
        id: '1', 
        title: 'Đắc Nhân Tâm', 
        author: 'Dale Carnegie',
        cover: 'assets/images/book1.jpg',
        rating: 4.8,
        publisher: 'Simon & Schuster',
        year: '1936',
        pages: 320,
        readers: 12500,
        description: 'Đắc nhân tâm (được lòng người), tên tiếng Anh là How to Win Friends and Influence People là một quyển sách nhằm tự giúp bản thân bán chạy nhất từ trước đến nay. Quyển sách này do Dale Carnegie viết và đã được xuất bản lần đầu vào năm 1936.'
      ),
      Book(
        id: '2', 
        title: 'Nhà Giả Kim', 
        author: 'Paulo Coelho',
        cover: 'assets/images/book2.jpg',
        rating: 4.7,
        publisher: 'HarperOne',
        year: '1988',
        pages: 208,
        readers: 9800,
        description: 'Nhà giả kim là một cuốn tiểu thuyết được xuất bản lần đầu ở Brasil năm 1988, và được dịch ra 67 ngôn ngữ.'
      ),
      Book(
        id: '3', 
        title: 'Tư Duy Phản Biện', 
        author: 'Richard Paul',
        cover: 'assets/images/book3.jpg',
        rating: 4.5,
        publisher: 'Foundation for Critical Thinking',
        year: '2019',
        pages: 226,
        readers: 7300,
        description: 'Tư duy phản biện là quá trình phân tích và đánh giá thông tin một cách khách quan để đưa ra phán đoán chính xác.'
      ),
      Book(
        id: '4', 
        title: 'Đọc Vị Bất Kỳ Ai', 
        author: 'David J. Lieberman',
        cover: 'assets/images/book4.jpg',
        rating: 4.3,
        publisher: 'NXB Lao Động',
        year: '2014',
        pages: 286,
        readers: 6200,
        description: 'Cuốn sách hướng dẫn các kỹ năng và nghệ thuật phân tích tâm lý con người trong các tình huống khác nhau.'
      ),
    ];
  }

  List<Book> _getMockBooksByCategory(String categoryId) {
    // Just return the featured books for any category in this mock implementation
    return _getMockFeaturedBooks();
  }

  Book? _getMockBookById(String bookId) {
    final allBooks = _getMockFeaturedBooks();
    try {
      return allBooks.firstWhere((book) => book.id == bookId);
    } catch (e) {
      return null;
    }
  }

  List<Book> _getMockUserLibrary() {
    // Return first 2 books as if they're in the user's library
    return _getMockFeaturedBooks().take(2).toList();
  }

  List<Book> _searchMockBooks(String query) {
    final allBooks = _getMockFeaturedBooks();
    query = query.toLowerCase();
    
    return allBooks.where((book) => 
      book.title.toLowerCase().contains(query) || 
      book.author.toLowerCase().contains(query)
    ).toList();
  }
}