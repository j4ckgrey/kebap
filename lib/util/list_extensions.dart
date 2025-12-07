import 'package:collection/collection.dart';

import 'package:kebap/models/item_base_model.dart';

extension ListExtensions<T> on List<T> {
  List<T> replace(T entry) {
    var tempList = toList();
    final index = indexOf(entry);
    tempList.removeAt(index);
    tempList.insert(index, entry);
    return tempList;
  }

  List<T> toggle(T entry) {
    var tempList = toList();
    if (contains(entry)) {
      return tempList..remove(entry);
    } else {
      return tempList..add(entry);
    }
  }

  bool containsAny(Iterable<T> entries) {
    for (var value in entries) {
      if (contains(value)) {
        return true;
      }
    }
    return false;
  }

  List<T> toggleUnique(T entry) => toggle(entry).toSet().toList();

  List<T> random() {
    List<T> tempList = this;
    tempList.shuffle();
    return tempList;
  }

  List<T> uniqueBy(dynamic Function(T value) keySelector) {
    final Map<dynamic, T> uniqueMap = {};

    for (var item in this) {
      final key = keySelector(item);
      if (!uniqueMap.containsKey(key)) {
        uniqueMap[key] = item;
      }
    }

    return uniqueMap.values.toList();
  }

  Iterable<List<T>> chunk(int size) sync* {
    if (size <= 0) {
      throw ArgumentError('Chunk size must be greater than zero.');
    }

    final iterator = this.iterator;
    while (iterator.moveNext()) {
      final chunk = <T>[];
      for (var i = 0; i < size; i++) {
        if (!iterator.moveNext()) {
          break;
        }
        chunk.add(iterator.current);
      }
      yield chunk;
    }
  }

  T? nextOrNull(T item) {
    int index = indexOf(item);
    
    // ID-based fallback for ItemBaseModel when standard indexOf fails
    if (index == -1 && item is ItemBaseModel) {
      index = indexWhere((e) => e is ItemBaseModel && (e as ItemBaseModel).id == item.id);
    }
    
    if (index == -1 || index + 1 >= length) return null;
    return elementAtOrNull(index + 1);
  }

  T? previousOrNull(T item) {
    int index = indexOf(item);
    
    // ID-based fallback for ItemBaseModel when standard indexOf fails
    if (index == -1 && item is ItemBaseModel) {
      index = indexWhere((e) => e is ItemBaseModel && (e as ItemBaseModel).id == item.id);
    }
    
    if (index == -1 || index - 1 < 0) return null;
    return elementAtOrNull(index - 1);
  }

  T? nextWhereOrNull(bool Function(T element) test) {
    final indexOf = indexWhere((element) => test(element));
    if (indexOf + 1 < length) return null;
    return elementAtOrNull(indexOf + 1);
  }

  T? previousWhereOrNull(bool Function(T element) test) {
    final indexOf = indexWhere((element) => test(element));
    if (indexOf - 1 < length) return null;
    return elementAtOrNull(indexOf - 1);
  }
}
