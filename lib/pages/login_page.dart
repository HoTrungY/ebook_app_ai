import 'dart:ui';

import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Hình ảnh nền
          Positioned.fill(
            child: Image.asset(
              'assets/images/pic_login.png',
              fit:
                  BoxFit.fitWidth, // Hiển thị toàn bộ chiều rộng, không cắt xén
              alignment: Alignment.topCenter, // Căn hình ảnh ở phía trên
            ),
          ),

          // Hiệu ứng mờ áp dụng lên toàn bộ màn hình
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0), // Độ mờ
              child: Container(
                color: Colors.black.withOpacity(0.8), // Màu nền mờ
              ),
            ),
          ),

          // Nền đen phía dưới
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height:
                MediaQuery.of(context).size.height /
                2, // Chiều cao bằng nửa màn hình
            child: Container(
              color: Colors.black, // Màu nền đen
            ),
          ),

          // Phần nội dung chính
          Center(
            child: Padding(
              padding: const EdgeInsets.all(
                20.0,
              ), // Thêm padding để tránh sát lề
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Text "Chào mừng bạn đến với Waka"
                  Text(
                    'Chào mừng bạn đến với Waka',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // Chữ màu trắng
                    ),
                  ),
                  SizedBox(height: 10), // Khoảng cách giữa các widget
                  // Text "WAKA"
                  Text(
                    'WAKA',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // Chữ màu trắng
                    ),
                  ),
                  SizedBox(height: 20), // Khoảng cách giữa các widget
                  // Text "Đăng nhập để đồng bộ dữ liệu của tài khoản trên nhiều thiết bị"
                  Text(
                    'Đăng nhập để đồng bộ dữ liệu của tài khoản trên nhiều thiết bị',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white, // Chữ màu trắng
                    ),
                  ),
                  SizedBox(height: 40), // Khoảng cách giữa các widget
                  // Ô nhập tên đăng nhập/số điện thoại
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Tên đăng nhập/Số điện thoại',
                      labelStyle: TextStyle(
                        color: Colors.white,
                      ), // Màu chữ label
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.white), // Màu viền
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Colors.white,
                        ), // Màu viền khi không focus
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Colors.blue,
                        ), // Màu viền khi focus
                      ),
                      filled: true,
                      fillColor: Colors.black.withOpacity(
                        0.5,
                      ), // Màu nền ô nhập liệu
                    ),
                    style: TextStyle(color: Colors.white), // Màu chữ nhập liệu
                  ),
                  SizedBox(height: 20), // Khoảng cách giữa các widget
                  // Ô nhập mật khẩu
                  TextField(
                    obscureText: true, // Ẩn mật khẩu
                    decoration: InputDecoration(
                      labelText: 'Mật khẩu',
                      labelStyle: TextStyle(
                        color: Colors.white,
                      ), // Màu chữ label
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.white), // Màu viền
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Colors.white,
                        ), // Màu viền khi không focus
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Colors.blue,
                        ), // Màu viền khi focus
                      ),
                      filled: true,
                      fillColor: Colors.black.withOpacity(
                        0.5,
                      ), // Màu nền ô nhập liệu
                    ),
                    style: TextStyle(color: Colors.white), // Màu chữ nhập liệu
                  ),
                  SizedBox(height: 20), // Khoảng cách giữa các widget
                  // Nút ĐĂNG NHẬP
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Xử lý khi nhấn nút ĐĂNG NHẬP
                      },
                      child: Text(
                        'ĐĂNG NHẬP',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        backgroundColor: Colors.blue, // Màu nền của nút
                        foregroundColor: Colors.white, // Màu chữ của nút
                      ),
                    ),
                  ),
                  SizedBox(height: 20), // Khoảng cách giữa các widget
                  // Dòng chữ "Đăng ký ngay" và "Quên mật khẩu?"
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          // Xử lý khi nhấn "Đăng ký ngay"
                        },
                        child: Text(
                          'Đăng ký ngay',
                          style: TextStyle(fontSize: 16, color: Colors.blue),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // Xử lý khi nhấn "Quên mật khẩu?"
                        },
                        child: Text(
                          'Quên mật khẩu?',
                          style: TextStyle(fontSize: 16, color: Colors.blue),
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
    );
  }
}
