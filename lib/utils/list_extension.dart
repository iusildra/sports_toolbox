extension Intercalate on List {
  /// Intercalates the list with the given [element].
  ///
  /// For example, if the list is `[1, 2, 3]` and the element is `0`, the result
  /// will be `[1, 0, 2, 0, 3]`.
  List<T> intercalate<T>(T element) {
    if (isEmpty) return [];
    final result = List<T>.empty(growable: true);
    for (var i = 0; i < length; i++) {
      result.add(this[i]);
      if (i < length - 1) result.add(element);
    }
    return result;
  }
}
