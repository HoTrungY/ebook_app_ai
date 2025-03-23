import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/book.dart';
import '../view_models/book_view_model.dart';
import '../view_models/auth_view_model.dart';
import 'reader_page.dart';

class BookDetailPage extends StatefulWidget {
  final String bookId;

  const BookDetailPage({Key? key, required this.bookId}) : super(key: key);

  @override
  State<BookDetailPage> createState() => _BookDetailPageState();
}

class _BookDetailPageState extends State<BookDetailPage> {
  @override
  void initState() {
    super.initState();
    // Load book details on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final bookViewModel = Provider.of<BookViewModel>(context, listen: false);
      bookViewModel.loadBookDetails(widget.bookId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BookViewModel>(
      builder: (context, bookViewModel, _) {
        final book = bookViewModel.selectedBook;
        final isLoading = bookViewModel.isLoading;

        return Scaffold(
          appBar: AppBar(
            title: Text(book?.title ?? 'Chi tiết sách'),
            actions: [
              IconButton(
                icon: const Icon(Icons.bookmark_border),
                onPressed: () {
                  // Add to library functionality would go here
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Đã thêm vào thư viện')),
                  );
                },
              ),
            ],
          ),
          body:
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : book == null
                  ? const Center(child: Text('Không tìm thấy sách'))
                  : _buildBookDetails(context, book),
          bottomNavigationBar:
              book == null ? null : _buildBottomBar(context, book),
        );
      },
    );
  }

  Widget _buildBookDetails(BuildContext context, Book book) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Book cover and basic info
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Book cover
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child:
                    book.cover.startsWith('http')
                        ? Image.network(
                          book.cover,
                          width: 120,
                          height: 180,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 120,
                              height: 180,
                              color: Colors.grey[300],
                              child: const Icon(
                                Icons.image_not_supported,
                                size: 40,
                                color: Colors.grey,
                              ),
                            );
                          },
                        )
                        : Image.asset(
                          book.cover,
                          width: 120,
                          height: 180,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 120,
                              height: 180,
                              color: Colors.grey[300],
                              child: const Icon(
                                Icons.image_not_supported,
                                size: 40,
                                color: Colors.grey,
                              ),
                            );
                          },
                        ),
              ),
              const SizedBox(width: 16),
              // Book info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      book.title,
                      style: Theme.of(context).textTheme.bodyLarge,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tác giả: ${book.author}',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 8),
                    if (book.rating != null) _buildRatingStars(book.rating!),
                    const SizedBox(height: 8),
                    if (book.publisher != null)
                      Text(
                        'NXB: ${book.publisher}',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    if (book.year != null)
                      Text(
                        'Năm XB: ${book.year}',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    if (book.pages != null)
                      Text(
                        'Số trang: ${book.pages}',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Book description
          Text('Giới thiệu sách', style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 8),
          Text(
            book.description ?? 'Không có mô tả',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 24),

          // Progress if the user has started reading
          if (book.progress != null && book.progress! > 0) _buildProgress(book),
        ],
      ),
    );
  }

  Widget _buildRatingStars(double rating) {
    final fullStars = rating.floor();
    final halfStar = (rating - fullStars) >= 0.5;
    final emptyStars = 5 - fullStars - (halfStar ? 1 : 0);

    return Row(
      children: [
        ...List.generate(
          fullStars,
          (index) => const Icon(Icons.star, color: Colors.amber, size: 18),
        ),
        if (halfStar)
          const Icon(Icons.star_half, color: Colors.amber, size: 18),
        ...List.generate(
          emptyStars,
          (index) =>
              const Icon(Icons.star_border, color: Colors.amber, size: 18),
        ),
        const SizedBox(width: 4),
        Text(
          rating.toString(),
          style: const TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildProgress(Book book) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Tiến độ đọc', style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: book.progress! / 100,
          backgroundColor: Colors.grey[300],
          valueColor: AlwaysStoppedAnimation<Color>(
            Theme.of(context).primaryColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${book.progress!.toInt()}%',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }

  Widget _buildBottomBar(BuildContext context, Book book) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        children: [
          if (book.price != null)
            Expanded(
              child: Text(
                '${book.price} đ',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ElevatedButton.icon(
            icon: const Icon(Icons.menu_book),
            label: const Text('Đọc ngay'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            onPressed: () {
              _handleReadBook(context, book);
            },
          ),
        ],
      ),
    );
  }

  void _handleReadBook(BuildContext context, Book book) {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    if (!authViewModel.isLoggedIn) {
      // Show login prompt if not logged in
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: const Text('Đăng nhập'),
              content: const Text('Bạn cần đăng nhập để đọc sách này'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Hủy'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    // Navigate to login page
                    // In a real app, you'd navigate to the login screen
                  },
                  child: const Text('Đăng nhập'),
                ),
              ],
            ),
      );
      return;
    }

    // Navigate to reader page
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => ReaderPage(book: book)));
  }
}
