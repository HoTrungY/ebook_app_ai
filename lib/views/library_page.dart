import 'package:ebook_app/models/book_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/auth_view_model.dart';
import '../view_models/book_view_model.dart';
import 'widgets/book_card.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({Key? key}) : super(key: key);

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadBooks();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadBooks() async {
    final bookViewModel = Provider.of<BookViewModel>(context, listen: false);
    await bookViewModel.loadBooks();
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    final bookViewModel = Provider.of<BookViewModel>(context);

    if (!authViewModel.isLoggedIn) {
      return const Scaffold(
        body: Center(child: Text('Vui lòng đăng nhập để xem thư viện của bạn')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Thư viện'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Sách của tôi'),
            Tab(text: 'Đã đọc'),
            Tab(text: 'Yêu thích'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Tab 1: My Books
          _buildBooksGrid(bookViewModel.books),

          // Tab 2: Read Books
          _buildEmptyState('Bạn chưa đọc sách nào'),

          // Tab 3: Favorites
          _buildEmptyState('Bạn chưa có sách yêu thích nào'),
        ],
      ),
    );
  }

  Widget _buildBooksGrid(List<Book> books) {
    if (books.isEmpty) {
      return _buildEmptyState('Không có sách nào trong thư viện của bạn');
    }

    return RefreshIndicator(
      onRefresh: _loadBooks,
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: books.length,
        itemBuilder: (context, index) {
          final book = books[index];
          return _buildBookGridItem(book);
        },
      ),
    );
  }

  Widget _buildBookGridItem(Book book) {
    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Xem sách ${book.title}')));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Book cover
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: Icon(Icons.book, size: 40, color: Colors.grey.shade700),
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Book title
          Text(
            book.title,
            style: const TextStyle(fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          // Book author
          Text(
            book.author,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.library_books, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              // Navigate to book discovery
            },
            child: const Text('Khám phá sách mới'),
          ),
        ],
      ),
    );
  }
}
