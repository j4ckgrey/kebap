import 'package:flutter/material.dart';

final navBarNode = FocusNode();

// Holds the focus node for the first navigation button so other policies can
// request focus into the navigation bar.
FocusNode? firstNavButtonNode;

void registerFirstNavButtonNode(FocusNode node) {
  firstNavButtonNode = node;
}

// Holds a focus node pointing to the first focusable content item (e.g.
// the first poster in the "up next" row). This allows the top nav to
// jump directly back into content with a single Down press.
FocusNode? firstContentNode;

void registerFirstContentNode(FocusNode node) {
  firstContentNode = node;
}
