import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/auth_view_model.dart';
import '../view_models/book_view_model.dart';
import '../models/book_model.dart';
import 'welcome_page.dart';
import 'widgets/book_card.dart';
import 'widgets/category_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final bookViewModel = Provider.of<BookViewModel>(context, listen: false);
    await bookViewModel.loadFeaturedBooks();
    await bookViewModel.loadCategories();
  }

  // Kiểm tra trạng thái đăng nhập và xử lý chuyển trang
  void _handleFeatureAccess(VoidCallback action) {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    
    if (authViewModel.isLoggedIn) {
      // Đã đăng nhập, cho phép sử dụng tính năng
      action();
    } else {
      // Chưa đăng nhập, hiển thị màn hình đăng nhập
      _showLoginScreen();
    }
  }

  // Hiển thị màn hình đăng nhập
  void _showLoginScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const WelcomePage()),
    ).then((_) {
      // Cập nhật UI sau khi đăng nhập
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    final bookViewModel = Provider.of<BookViewModel>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trang chủ'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () => _handleFeatureAccess(() {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Đã đăng nhập, xem thông báo')),
              );
            }),
          ),
        ],
      ),
      body: bookViewModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Banner
                      _buildBanner(context),
                      
                      const SizedBox(height: 24),
                      
                      // Featured books
                      const Text(
                        'Sách nổi bật',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 220,
                        child: bookViewModel.featuredBooks.isEmpty
                            ? const Center(child: Text('Không có sách nổi bật'))
                            : ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: bookViewModel.featuredBooks.length,
                                itemBuilder: (context, index) {
                                  final book = bookViewModel.featuredBooks[index];
                                  return BookCard(
                                    book: book,
                                    onTap: () => _handleFeatureAccess(() {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Đã đăng nhập, xem sách ${book.title}')),
                                      );
                                    }),
                                  );
                                },
                              ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Categories
                      const Text(
                        'Danh mục sách',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      bookViewModel.categories.isEmpty
                          ? const Center(child: Text('Không có danh mục sách'))
                          : ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: bookViewModel.categories.length,
                              itemBuilder: (context, index) {
                                final category = bookViewModel.categories[index];
                                return CategoryItem(
                                  category: category,
                                  bookCount: 12 * (index + 1), // Mock data
                                  onTap: () => _handleFeatureAccess(() {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Đã đăng nhập, xem danh mục $category')),
                                    );
                                  }),
                                );
                              },
                            ),
                    ],
                  ),
                ),
              ),
            ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          if (index != 0) {
            // Không phải tab Home, yêu cầu đăng nhập
            _handleFeatureAccess(() {
              setState(() {
                _currentIndex = index;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Đã đăng nhập, chuyển sang tab $index')),
              );
            });
          } else {
            // Tab Home, cho phép chuyển trực tiếp
            setState(() {
              _currentIndex = index;
            });
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Trang chủ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Thư viện',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Tìm kiếm',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Tài khoản',
          ),
        ],
      ),
    );
  }

  Widget _buildBanner(BuildContext context) {
    return InkWell(
      onTap: () => _handleFeatureAccess(() {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đã đăng nhập, xem chi tiết banner')),
        );
      }),
      child: Container(
        height: 180,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue.shade800, Colors.blue.shade600],
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Khám phá sách mới',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Những cuốn sách hay nhất đang chờ đợi bạn',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withOpacity(0.9),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _handleFeatureAccess(() {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Đã đăng nhập, xem sách mới')),
                );
              }),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.blue.shade800,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Xem ngay',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}