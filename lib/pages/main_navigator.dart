import 'package:ebook_app/views/home_page.dart';
import 'package:ebook_app/views/widgets/bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'search_page.dart';
import 'library_page.dart';
import 'profile_page.dart';

class MainNavigator extends StatefulWidget {
  final int initialIndex;

  const MainNavigator({
    Key? key,
    this.initialIndex = 0,
  }) : super(key: key);

  @override
  State<MainNavigator> createState() => _MainNavigatorState();
}

class _MainNavigatorState extends State<MainNavigator> {
  late int _currentIndex;
  
  // Page controllers to maintain state when switching tabs
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _changePage(int index) {
    setState(() {
      _currentIndex = index;
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(), // Disable swiping
        children: const [
          HomePage(),
          SearchPage(),
          LibraryPage(),
          ProfilePage(),
        ],
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      bottomNavigationBar: BottomNavigation(
        currentIndex: _currentIndex,
        onTap: _changePage,
      ),
    );
  }
}
