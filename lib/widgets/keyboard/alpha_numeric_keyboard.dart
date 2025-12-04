import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

import 'package:kebap/theme.dart';

class AlphaNumericKeyboard extends ConsumerStatefulWidget {
  final void Function(String character) onCharacter;
  final TextInputType keyboardType;
  final TextInputAction keyboardActionType;
  final VoidCallback onBackspace;
  final VoidCallback onClear;
  final VoidCallback onDone;

  const AlphaNumericKeyboard({
    required this.onCharacter,
    this.keyboardType = TextInputType.name,
    this.keyboardActionType = TextInputAction.done,
    required this.onBackspace,
    required this.onClear,
    required this.onDone,
    super.key,
  });

  @override
  ConsumerState<AlphaNumericKeyboard> createState() => _AlphaNumericKeyboardState();
}

class _AlphaNumericKeyboardState extends ConsumerState<AlphaNumericKeyboard> {
  bool usingAlpha = true;
  bool shift = false;
  late TextInputType type = widget.keyboardType;
  late TextInputAction actionType = widget.keyboardActionType;

  List<List<String>> get activeLayout {
    if (!usingAlpha) {
      // Numbers and Symbols layer
      return [
        ['1', '2', '3', '4', '5', '6', '7', '8', '9', '0'],
        ['@', '#', '\$', '_', '&', '-', '+', '(', ')', '/'],
        ['*', '"', '\'', ':', ';', '!', '?', ',', '.', '\\'],
        ['ABC', 'SPACE', '⌫', 'ACTION'],
      ];
    }

    // QWERTY layer
    return [
      ['1', '2', '3', '4', '5', '6', '7', '8', '9', '0'],
      ['q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p'],
      ['a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l'],
      ['SHIFT', 'z', 'x', 'c', 'v', 'b', 'n', 'm', '⌫'],
      ['?123', ',', 'SPACE', '.', 'ACTION'],
    ];
  }

  Widget buildKey(String label, {bool autofocus = false, int flex = 1}) {
    // Handle special keys
    final isAction = label == 'ACTION';
    final isShift = label == 'SHIFT';
    final isBackspace = label == '⌫';
    final isSpace = label == 'SPACE';
    final isModeSwitch = label == '?123' || label == 'ABC';

    final displayText = switch (label) {
      'ACTION' => switch (actionType) {
          TextInputAction.next => 'Next',
          TextInputAction.search => 'Search',
          TextInputAction.send => 'Send',
          TextInputAction.go => 'Go',
          _ => 'Done',
        },
      'SHIFT' => 'Shift',
      'SPACE' => 'Space',
      '⌫' => '',
      _ => shift && label.length == 1 ? label.toUpperCase() : label,
    };

    final icon = switch (label) {
      '⌫' => Icons.backspace_rounded,
      'SHIFT' => shift ? Icons.keyboard_capslock : Icons.arrow_upward_rounded,
      'ACTION' => switch (actionType) {
          TextInputAction.next => IconsaxPlusBold.next,
          TextInputAction.search => IconsaxPlusBold.search_normal,
          TextInputAction.send => IconsaxPlusBold.send_1,
          _ => Icons.check_rounded,
        },
      _ => null,
    };

    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: FilledButton.tonal(
          autofocus: autofocus,
          style: FilledButton.styleFrom(
            padding: EdgeInsets.zero,
            shape: KebapTheme.smallShape,
            backgroundColor: (isAction || (isShift && shift)) 
                ? Theme.of(context).colorScheme.primary 
                : null,
            foregroundColor: (isAction || (isShift && shift))
                ? Theme.of(context).colorScheme.onPrimary
                : null,
          ),
          onPressed: () {
            if (isBackspace) {
              widget.onBackspace();
            } else if (isShift) {
              setState(() => shift = !shift);
            } else if (isModeSwitch) {
              setState(() => usingAlpha = !usingAlpha);
            } else if (isAction) {
              widget.onDone();
            } else if (isSpace) {
              widget.onCharacter(' ');
            } else {
              widget.onCharacter(shift ? label.toUpperCase() : label);
              if (shift) setState(() => shift = false); // Auto-unshift
            }
          },
          child: icon != null
              ? Icon(icon, size: 20)
              : Text(
                  displayText,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: (isAction || (isShift && shift))
                            ? Theme.of(context).colorScheme.onPrimary
                            : null,
                      ),
                ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final rows = activeLayout;

    return FocusTraversalGroup(
      policy: _KeyboardTraversalPolicy(),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (int r = 0; r < rows.length; r++)
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Add spacing for 2nd and 3rd row to center them slightly like real keyboard
                  if (usingAlpha && r == 2) const Spacer(flex: 1), // Indent 'a' row
                  
                  for (int c = 0; c < rows[r].length; c++)
                    buildKey(
                      rows[r][c],
                      autofocus: r == 1 && c == 0, // Focus 'q' initially
                      flex: (rows[r][c] == 'SPACE') ? 4 : (rows[r][c].length > 1 ? 2 : 2),
                    ),
                    
                  if (usingAlpha && r == 2) const Spacer(flex: 1), // Indent 'l' row
                ],
              ),
            ),
        ],
      ),
    );
  }
}

enum KeyboardActions {
  shift,
  space,
  clear,
  action;

  const KeyboardActions();

  String label(BuildContext context) {
    return switch (this) {
      KeyboardActions.space => "Space",
      KeyboardActions.clear => "Clear",
      KeyboardActions.action => "Action",
      KeyboardActions.shift => "Shift",
    };
  }
}

/// Custom traversal policy for keyboard that implements wrap-around navigation
/// When pressing left from the first item in a row, focus moves to the last item
/// When pressing right from the last item in a row, focus moves to the first item
class _KeyboardTraversalPolicy extends ReadingOrderTraversalPolicy {
  @override
  bool inDirection(FocusNode currentNode, TraversalDirection direction) {
    // Only handle left/right navigation for wrap-around
    if (direction == TraversalDirection.left || direction == TraversalDirection.right) {
      final parent = currentNode.parent;
      if (parent == null) return super.inDirection(currentNode, direction);
      
      // Get all focusable nodes
      final allNodes = parent.descendants
          .where((n) => n.canRequestFocus && n.context != null)
          .toList();

      // Filter for nodes in the same row
      // We use a small epsilon for float comparison, or check overlap
      final currentRect = currentNode.rect;
      final rowNodes = allNodes.where((n) {
        final rect = n.rect;
        return (rect.center.dy - currentRect.center.dy).abs() < 20; // 20px tolerance
      }).toList();
      
      // Sort by left position
      rowNodes.sort((a, b) => a.rect.left.compareTo(b.rect.left));
      
      if (rowNodes.isEmpty) return super.inDirection(currentNode, direction);
      
      final currentIndex = rowNodes.indexOf(currentNode);
      if (currentIndex == -1) return super.inDirection(currentNode, direction);
      
      if (direction == TraversalDirection.left) {
        // Wrap around to last item if at first item
        if (currentIndex == 0) {
          rowNodes.last.requestFocus();
          return true;
        } else {
          rowNodes[currentIndex - 1].requestFocus();
          return true;
        }
      } else if (direction == TraversalDirection.right) {
        // Wrap around to first item if at last item
        if (currentIndex == rowNodes.length - 1) {
          rowNodes.first.requestFocus();
          return true;
        } else {
          rowNodes[currentIndex + 1].requestFocus();
          return true;
        }
      }
    }
    
    // For up/down navigation, use default behavior
    return super.inDirection(currentNode, direction);
  }
}
