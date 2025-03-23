import 'package:flutter/material.dart';
import '../models/book.dart';
import '../services/book_service.dart';

class BookViewModel extends ChangeNotifier {
  final BookService _bookService = BookService();

  bool _isLoading = false;
  String _errorMessage = '';

  List<Book> _featuredBooks = [];
  List<Book> _userLibrary = [];
  List<Book> _searchResults = [];
  Book? _selectedBook;

  // Getters
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  List<Book> get featuredBooks => _featuredBooks;
  List<Book> get userLibrary => _userLibrary;
  List<Book> get searchResults => _searchResults;
  Book? get selectedBook => _selectedBook;

  // Load featured books
  Future<void> loadFeaturedBooks() async {
    _setLoading(true);
    try {
    } catch (e) {
      _errorMessage = 'Không thể tải sách nổi bật: $e';
    } finally {
      _setLoading(false);
    }
  }

  // Load books by category
  Future<List<Book>> loadBooksByCategory(String categoryId) async {
    _setLoading(true);
    try {
      final books = await _bookService.getBooksByCategory(categoryId);
      return books;
    } catch (e) {
      _errorMessage = 'Không thể tải sách theo danh mục: $e';
      return [];
    } finally {
      _setLoading(false);
    }
  }

  // Load user's library
  Future<void> loadUserLibrary(String userId) async {
    _setLoading(true);
    try {
      _userLibrary = (await _bookService.getUserLibrary(userId)).cast<Book>();
    } catch (e) {
      _errorMessage = 'Không thể tải thư viện người dùng: $e';
    } finally {
      _setLoading(false);
    }
  }

  // Search books
  Future<void> searchBooks(String query) async {
    if (query.isEmpty) {
      _searchResults = [];
      notifyListeners();
      return;
    }

    _setLoading(true);
    try {
      _searchResults =
          (await _bookService.searchBooks(
            query,
          )).map((item) => item as Book).toList();
    } catch (e) {
      _errorMessage = 'Không thể tìm kiếm sách: $e';
    } finally {
      _setLoading(false);
    }
  }

  // Load book details
  Future<void> loadBookDetails(String bookId) async {
    _setLoading(true);
    try {
      _selectedBook = await _bookService.getBookDetails(bookId);
      if (_selectedBook == null) {
        _errorMessage = 'Không tìm thấy thông tin sách';
      }
    } catch (e) {
      _errorMessage = 'Không thể tải thông tin sách: $e';
    } finally {
      _setLoading(false);
    }
  }

  // Helper method to set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Clear error message
  void clearError() {
    _errorMessage = '';
    notifyListeners();
  }

  // Clear search results
  void clearSearchResults() {
    _searchResults = [];
    notifyListeners();
  }
}
