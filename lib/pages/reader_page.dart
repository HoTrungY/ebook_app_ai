import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/book.dart';

class ReaderPage extends StatefulWidget {
  final Book book;

  const ReaderPage({
    Key? key,
    required this.book,
  }) : super(key: key);

  @override
  State<ReaderPage> createState() => _ReaderPageState();
}

class _ReaderPageState extends State<ReaderPage> {
  double _fontSize = 16.0;
  bool _showControls = true;
  String _theme = 'light'; // light, sepia, dark
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Set preferred orientation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    // Hide status bar for immersive reading
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  void dispose() {
    // Restore default orientations and UI visibility when leaving
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    _scrollController.dispose();
    super.dispose();
  }

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
    });
  }

  Color get _backgroundColor {
    switch (_theme) {
      case 'sepia':
        return const Color(0xFFF8F1E3);
      case 'dark':
        return const Color(0xFF121212);
      case 'light':
      default:
        return Colors.white;
    }
  }

  Color get _textColor {
    switch (_theme) {
      case 'dark':
        return Colors.white;
      case 'sepia':
      case 'light':
      default:
        return Colors.black;
    }
  }

  void _increaseFontSize() {
    setState(() {
      _fontSize = _fontSize + 1.0 > 24.0 ? 24.0 : _fontSize + 1.0;
    });
  }

  void _decreaseFontSize() {
    setState(() {
      _fontSize = _fontSize - 1.0 < 12.0 ? 12.0 : _fontSize - 1.0;
    });
  }

  void _changeTheme(String theme) {
    setState(() {
      _theme = theme;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      body: GestureDetector(
        onTap: _toggleControls,
        child: Stack(
          children: [
            // Content
            SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.only(
                top: 60,
                left: 24,
                right: 24,
                bottom: 48,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.book.title,
                    style: TextStyle(
                      fontSize: _fontSize + 8,
                      fontWeight: FontWeight.bold,
                      color: _textColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.book.author,
                    style: TextStyle(
                      fontSize: _fontSize,
                      fontStyle: FontStyle.italic,
                      color: _textColor.withOpacity(0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'Chương 1: Mở đầu',
                    style: TextStyle(
                      fontSize: _fontSize + 4,
                      fontWeight: FontWeight.bold,
                      color: _textColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Sample content - would be real book content in a real app
                  ...List.generate(
                    20,
                    (index) => Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        'Đây là nội dung mẫu của cuốn sách. Trong một ứng dụng thực tế, phần này sẽ hiển thị nội dung thực của cuốn sách được tải từ một API hoặc cơ sở dữ liệu. Người dùng sẽ có thể đọc toàn bộ nội dung của cuốn sách và điều chỉnh trải nghiệm đọc theo ý thích của họ.',
                        style: TextStyle(
                          fontSize: _fontSize,
                          height: 1.5,
                          color: _textColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Top controls
            if (_showControls)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.only(
                    top: 48,
                    left: 16,
                    right: 16,
                    bottom: 16,
                  ),
                  decoration: BoxDecoration(
                    color: _backgroundColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        color: _textColor,
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.bookmark_border),
                            color: _textColor,
                            onPressed: () {
                              // Bookmark functionality
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.settings),
                            color: _textColor,
                            onPressed: () {
                              _showSettingsBottomSheet(context);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

            // Progress indicator
            if (_showControls)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: _backgroundColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 5,
                        offset: const Offset(0, -3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          thumbColor: Theme.of(context).primaryColor,
                          activeTrackColor: Theme.of(context).primaryColor,
                          inactiveTrackColor: Theme.of(context).primaryColor.withOpacity(0.3),
                        ),
                        child: Slider(
                          value: 0.3, // Progress would be dynamic in a real app
                          onChanged: (value) {
                            // Handle progress change
                          },
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Trang 30 / 100', // Would be dynamic in a real app
                            style: TextStyle(
                              color: _textColor.withOpacity(0.7),
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            '30%', // Would be dynamic in a real app
                            style: TextStyle(
                              color: _textColor.withOpacity(0.7),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showSettingsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: _backgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tùy chỉnh',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: _textColor,
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Font size controls
                  Text(
                    'Cỡ chữ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: _textColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () {
                          _decreaseFontSize();
                          setState(() {});
                        },
                      ),
                      Text(
                        '${_fontSize.toInt()}',
                        style: TextStyle(
                          color: _textColor,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          _increaseFontSize();
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  // Theme selection
                  Text(
                    'Giao diện',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: _textColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildThemeOption(
                        context,
                        'light',
                        'Sáng',
                        Colors.white,
                        Colors.black,
                        setState,
                      ),
                      _buildThemeOption(
                        context,
                        'sepia',
                        'Sepia',
                        const Color(0xFFF8F1E3),
                        Colors.brown.shade800,
                        setState,
                      ),
                      _buildThemeOption(
                        context,
                        'dark',
                        'Tối',
                        const Color(0xFF121212),
                        Colors.white,
                        setState,
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildThemeOption(
    BuildContext context,
    String theme,
    String label,
    Color bgColor,
    Color textColor,
    StateSetter setState,
  ) {
    final isSelected = _theme == theme;
    return GestureDetector(
      onTap: () {
        _changeTheme(theme);
        setState(() {});
      },
      child: Container(
        width: 80,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? Theme.of(context).primaryColor : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Text(
              'Aa',
              style: TextStyle(
                fontSize: 24,
                color: textColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
