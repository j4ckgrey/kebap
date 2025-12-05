import 'package:flutter/material.dart';

class VerticalPageIndicator extends StatelessWidget {
  final int itemCount;
  final int currentPage;
  final PageController controller;
  final Color color;
  final ValueChanged<int>? onDotTap;

  const VerticalPageIndicator({
    required this.itemCount,
    required this.currentPage,
    required this.controller,
    this.color = Colors.white,
    this.onDotTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withOpacity(0.5),
        borderRadius: BorderRadius.circular(32),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Up Arrow
          Opacity(
            opacity: currentPage > 0 ? 1.0 : 0.0,
            child: IconButton(
              icon: Icon(Icons.keyboard_arrow_up, color: color),
              onPressed: currentPage > 0
                  ? () {
                      controller.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                  : null,
            ),
          ),
          // Dots
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(itemCount, (index) {
                final isSelected = index == currentPage;
                return GestureDetector(
                  onTap: () => onDotTap?.call(index),
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    width: isSelected ? 12 : 8,
                    height: isSelected ? 12 : 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected ? color : color.withOpacity(0.5),
                    ),
                  ),
                );
              }),
            ),
          ),
          // Down Arrow
          Opacity(
            opacity: currentPage < itemCount - 1 ? 1.0 : 0.0,
            child: IconButton(
              icon: Icon(Icons.keyboard_arrow_down, color: color),
              onPressed: currentPage < itemCount - 1
                  ? () {
                      controller.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}
