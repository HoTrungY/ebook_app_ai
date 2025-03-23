import 'package:ebook_app/views/home_page.dart';
import 'package:ebook_app/views/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/auth_view_model.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    // Simulate splash screen delay
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    await authViewModel.checkLoginStatus();

    if (!mounted) return;

    // Navigate to appropriate screen based on login status
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder:
            (context) =>
                authViewModel.isLoggedIn
                    ? const HomePage()
                    : const WelcomePage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.menu_book_rounded,
                size: 80,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 24),

            // App Name
            Text(
              'Waka',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),

            const SizedBox(height: 16),

            // Tagline
            Text(
              'Khám phá thế giới qua từng trang sách',
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
            ),

            const SizedBox(height: 48),

            // Loading indicator
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
