import 'package:ebook_app/views/widgets/stats_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/auth_view_model.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthViewModel>(
      builder: (context, authViewModel, child) {
        final user = authViewModel.currentUser;
        final isLoggedIn = authViewModel.isLoggedIn;

        if (!isLoggedIn) {
          return _buildLoginPrompt(context);
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Tài khoản'),
            actions: [
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {
                  // Navigate to settings
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Profile header
                Center(
                  child: Column(
                    children: [
                      // Avatar
                      CircleAvatar(
                        radius: 50,
                        backgroundImage:
                            user?.avatar != null
                                ? AssetImage(user!.avatar)
                                : null,
                        backgroundColor: Colors.grey[300],
                        child:
                            user?.avatar == null
                                ? const Icon(
                                  Icons.person,
                                  size: 50,
                                  color: Colors.white,
                                )
                                : null,
                      ),
                      const SizedBox(height: 16),

                      // User name and info
                      Text(
                        user?.name ?? 'Người dùng',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user?.email ?? 'email@example.com',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Reading stats
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: const [
                    StatsCard(
                      title: '12',
                      subtitle: 'Sách đã đọc',
                      icon: Icons.menu_book,
                    ),
                    StatsCard(
                      title: '87',
                      subtitle: 'Giờ đọc',
                      icon: Icons.timer,
                    ),
                    StatsCard(
                      title: '4.8',
                      subtitle: 'Đánh giá',
                      icon: Icons.star,
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // Menu options
                _buildMenuItem(
                  context,
                  'Thông tin cá nhân',
                  Icons.person_outline,
                  () {
                    // Navigate to profile edit
                  },
                ),
                _buildMenuItem(
                  context,
                  'Thanh toán & mua hàng',
                  Icons.payment,
                  () {
                    // Navigate to payments
                  },
                ),
                _buildMenuItem(
                  context,
                  'Thông báo',
                  Icons.notifications_none,
                  () {
                    // Navigate to notifications
                  },
                ),
                _buildMenuItem(
                  context,
                  'Trợ giúp & hỗ trợ',
                  Icons.help_outline,
                  () {
                    // Navigate to help
                  },
                ),

                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 16),

                // Logout button
                ElevatedButton.icon(
                  onPressed: () async {
                    final success = await authViewModel.logout();
                    if (success) {
                      // Redirect to home page
                      // In a real app, you might want to navigate to a different screen
                    }
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text('Đăng xuất'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    minimumSize: const Size(double.infinity, 48),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoginPrompt(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tài khoản')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.account_circle, size: 100, color: Colors.grey),
            const SizedBox(height: 24),
            Text(
              'Vui lòng đăng nhập',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Đăng nhập để quản lý tài khoản và truy cập thư viện của bạn',
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                // Navigate to login page
              },
              child: const Text('Đăng nhập'),
              style: ElevatedButton.styleFrom(minimumSize: const Size(200, 48)),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                // Navigate to registration page
              },
              child: const Text('Tạo tài khoản mới'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).primaryColor),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}
