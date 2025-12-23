import 'package:flutter/material.dart';

class VerticalPageIndicator extends StatelessWidget {
  final int itemCount;
  final int currentPage;
  final PageController controller;
  final Color color;
  final ValueChanged<int>? onDotTap;

  /// Maximum number of dots to show at once
  static const int _maxVisibleDots = 7;

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
    
    // Calculate which dots to show (sliding window centered on current page)
    int startIndex = 0;
    int endIndex = itemCount;
    
    if (itemCount > _maxVisibleDots) {
      // Center the window on currentPage
      final halfWindow = _maxVisibleDots ~/ 2;
      startIndex = (currentPage - halfWindow).clamp(0, itemCount - _maxVisibleDots);
      endIndex = startIndex + _maxVisibleDots;
    }
    
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
          // Dots (limited and centered between arrows)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  // Show "..." indicator if there are hidden dots above
                  if (startIndex > 0)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Icon(Icons.more_horiz, color: color.withOpacity(0.5), size: 12),
                    ),
                  // Visible dots
                  ...List.generate(endIndex - startIndex, (i) {
                    final index = startIndex + i;
                    final isSelected = index == currentPage;
                    return GestureDetector(
                      onTap: () => onDotTap?.call(index),
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 3),
                        width: isSelected ? 12 : 8,
                        height: isSelected ? 12 : 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected ? color : color.withOpacity(0.5),
                        ),
                      ),
                    );
                  }),
                  // Show "..." indicator if there are hidden dots below
                  if (endIndex < itemCount)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Icon(Icons.more_horiz, color: color.withOpacity(0.5), size: 12),
                    ),
                ],
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
