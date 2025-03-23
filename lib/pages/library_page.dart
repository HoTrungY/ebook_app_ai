import 'package:ebook_app/views/widgets/book_grid.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/auth_view_model.dart';
import '../view_models/book_view_model.dart';
import 'book_detail_page.dart';

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
    _tabController = TabController(length: 2, vsync: this);

    // Load user library on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserLibrary();
    });
  }

  void _loadUserLibrary() {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    final bookViewModel = Provider.of<BookViewModel>(context, listen: false);

    if (authViewModel.isLoggedIn && authViewModel.currentUser != null) {
      bookViewModel.loadUserLibrary(authViewModel.currentUser!.id);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thư viện của tôi'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [Tab(text: 'Đang đọc'), Tab(text: 'Đã lưu')],
        ),
      ),
      body: Consumer2<AuthViewModel, BookViewModel>(
        builder: (context, authViewModel, bookViewModel, child) {
          if (!authViewModel.isLoggedIn) {
            return _buildLoginPrompt();
          }

          if (bookViewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return TabBarView(
            controller: _tabController,
            children: [
              // Tab 1: Currently reading books
              _buildReadingBooksTab(bookViewModel),

              // Tab 2: Saved books
              _buildSavedBooksTab(bookViewModel),
            ],
          );
        },
      ),
    );
  }

  Widget _buildLoginPrompt() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.login_rounded, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            'Đăng nhập để xem thư viện của bạn',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              // Navigate to login page
              // In a real app, you'd navigate to the login screen
            },
            child: const Text('Đăng nhập'),
          ),
        ],
      ),
    );
  }

  Widget _buildReadingBooksTab(BookViewModel viewModel) {
    // Filter for books with progress > 0 and < 100
    final readingBooks =
        viewModel.userLibrary
            .where(
              (book) =>
                  book.progress != null &&
                  book.progress! > 0 &&
                  book.progress! < 100,
            )
            .toList();

    if (readingBooks.isEmpty) {
      return Center(
        child: Text(
          'Bạn chưa có sách nào đang đọc',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      );
    }

    return BookGrid(
      books: readingBooks,
      showProgress: true,
      onTap: (book) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => BookDetailPage(bookId: book.id),
          ),
        );
      },
    );
  }

  Widget _buildSavedBooksTab(BookViewModel viewModel) {
    // Filter for saved books (could be different logic in a real app)
    final savedBooks =
        viewModel.userLibrary
            .where((book) => book.progress == null || book.progress == 0)
            .toList();

    if (savedBooks.isEmpty) {
      return Center(
        child: Text(
          'Bạn chưa lưu sách nào',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      );
    }

    return BookGrid(
      books: savedBooks,
      onTap: (book) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => BookDetailPage(bookId: book.id),
          ),
        );
      },
    );
  }
}
