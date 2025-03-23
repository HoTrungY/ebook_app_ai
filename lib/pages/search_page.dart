import 'package:ebook_app/views/widgets/book_grid.dart';
import 'package:ebook_app/views/widgets/book_list_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/book_view_model.dart';
import 'book_detail_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  bool _isGridView = false;

  @override
  void initState() {
    super.initState();
    // Load featured books on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final bookViewModel = Provider.of<BookViewModel>(context, listen: false);
      bookViewModel.loadFeaturedBooks();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch(String query) {
    if (query.trim().isNotEmpty) {
      final bookViewModel = Provider.of<BookViewModel>(context, listen: false);
      bookViewModel.searchBooks(query);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BookViewModel>(
      builder: (context, bookViewModel, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Tìm kiếm'),
            actions: [
              // Toggle view button
              IconButton(
                icon: Icon(_isGridView ? Icons.view_list : Icons.grid_view),
                onPressed: () {
                  setState(() {
                    _isGridView = !_isGridView;
                  });
                },
              ),
            ],
          ),
          body: Column(
            children: [
              // Search bar
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Tìm kiếm sách, tác giả...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon:
                        _searchController.text.isNotEmpty
                            ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                                bookViewModel.clearSearchResults();
                              },
                            )
                            : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onSubmitted: _performSearch,
                  onChanged: (value) {
                    if (value.isEmpty) {
                      bookViewModel.clearSearchResults();
                    }
                  },
                ),
              ),

              // Results or featured books
              Expanded(
                child:
                    bookViewModel.isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : _buildBookList(bookViewModel),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBookList(BookViewModel viewModel) {
    final books =
        _searchController.text.isNotEmpty
            ? viewModel.searchResults
            : viewModel.featuredBooks;

    if (books.isEmpty) {
      return Center(
        child: Text(
          _searchController.text.isNotEmpty
              ? 'Không tìm thấy kết quả'
              : 'Không có sách nào',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      );
    }

    if (_isGridView) {
      return BookGrid(
        books: books,
        onTap: (book) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => BookDetailPage(bookId: book.id),
            ),
          );
        },
      );
    } else {
      return ListView.builder(
        itemCount: books.length,
        itemBuilder: (context, index) {
          final book = books[index];
          return BookListItem(
            book: book,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => BookDetailPage(bookId: book.id),
                ),
              );
            },
          );
        },
      );
    }
  }
}
