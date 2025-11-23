import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kebap/models/item_base_model.dart';

/// Provider to track the currently focused item across all poster rows
/// Used to update the shared banner at the top of the dashboard
final focusedItemProvider = StateProvider<ItemBaseModel?>((ref) => null);
