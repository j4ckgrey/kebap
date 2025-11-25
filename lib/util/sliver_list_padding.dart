import 'package:flutter/material.dart';

import 'package:kebap/util/adaptive_layout/adaptive_layout.dart';

class DefautlSliverBottomPadding extends StatelessWidget {
  const DefautlSliverBottomPadding({super.key});

  @override
  Widget build(BuildContext context) {
    return (AdaptiveLayout.viewSizeOf(context) != ViewSize.phone)
        ? SliverPadding(padding: EdgeInsets.only(bottom: 60 + MediaQuery.of(context).padding.bottom))
        : SliverPadding(padding: EdgeInsets.only(bottom: 100 + MediaQuery.of(context).padding.bottom));
  }
}

class DefaultSliverTopBadding extends StatelessWidget {
  const DefaultSliverTopBadding({super.key});

  @override
  Widget build(BuildContext context) {
    // Add padding to account for the floating navigation buttons (hamburger + back)
    // The buttons are at top + 8, and are about 48px high.
    // We add a bit more to be safe and visually pleasing.
    final topPadding = MediaQuery.paddingOf(context).top + kToolbarHeight + 16;
    return SliverPadding(padding: EdgeInsets.only(top: topPadding));
  }
}
