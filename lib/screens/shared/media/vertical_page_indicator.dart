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
    final backgroundColor = Theme.of(context).colorScheme.surface.withOpacity(0.5);
    
    return ExcludeFocus(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Up Arrow with squared background
          Opacity(
            opacity: currentPage > 0 ? 1.0 : 0.0,
            child: Container(
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.zero,
              ),
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
          ),
          // Dots (no background)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
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
          ),
          // Down Arrow with squared background
          Opacity(
            opacity: currentPage < itemCount - 1 ? 1.0 : 0.0,
            child: Container(
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.zero,
              ),
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
          ),
        ],
      ),
    );
  }
}
