import 'package:flutter/material.dart';

class CategoryItem extends StatelessWidget {
  final String name;
  final int count;
  final VoidCallback onTap;
  final Color? backgroundColor;
  final Color? textColor;

  const CategoryItem({
    Key? key,
    required this.name,
    required this.count,
    required this.onTap,
    this.backgroundColor,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bgColor = backgroundColor ?? Theme.of(context).primaryColor.withOpacity(0.1);
    final txtColor = textColor ?? Theme.of(context).primaryColor;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: txtColor,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: txtColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                count.toString(),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: txtColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}