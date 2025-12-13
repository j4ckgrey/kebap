import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kebap/models/account_model.dart';
import 'package:kebap/screens/shared/flat_button.dart';
import 'package:kebap/util/string_extensions.dart';

class UserIcon extends ConsumerWidget {
  final AccountModel? user;
  final Size size;
  final TextStyle? labelStyle;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final double cornerRadius;
  const UserIcon({
    this.size = const Size(50, 50),
    this.labelStyle,
    this.cornerRadius = 16,
    this.onTap,
    this.onLongPress,
    required this.user,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print('[LAG_DEBUG] ${DateTime.now()} UserIcon build: ${user?.name}');
    Widget placeHolder() {
      return Container(
        color: Theme.of(context).colorScheme.primaryContainer,
        child: Center(
          child: Text(
            user?.name.getInitials() ?? "",
            style: (labelStyle ?? Theme.of(context).textTheme.titleMedium)?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
        ),
      );
    }

    return Hero(
      tag: Key(user?.id ?? "empty-user-avatar"),
      child: SizedBox(
        width: size.width,
        height: size.height,
        child: AspectRatio(
          aspectRatio: 1,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(cornerRadius),
            ),
            clipBehavior: Clip.none,
            child: Stack(
              alignment: Alignment.center,
              fit: StackFit.expand,
              children: [
                CachedNetworkImage(
                  imageUrl: user?.avatar ?? "",
                  cacheKey: user?.avatar, // Explicitly use the full URL (including tag) as the key
                  progressIndicatorBuilder: (context, url, progress) => placeHolder(),
                  errorWidget: (context, url, error) {
                    print('[UserIcon] Failed to load avatar: $url, Error: $error');
                    // Consider evicting from cache if it was a 404 or similar, to allow retry later
                    PaintingBinding.instance.imageCache.evict(NetworkImage(url));
                    return placeHolder();
                  },
                  memCacheHeight: 128,
                  fit: BoxFit.cover,
                ),
                FlatButton(
                  onTap: onTap,
                  onLongPress: onLongPress,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
