extension StringExtension on String {
  bool get isEmptyOrNull {
    return this == null || this.isEmpty;
  }
}

extension ExtendedList<E> on Iterable<E> {
  void forEachIndexed(void f(E element, int index)) {
    int i = 0;
    for (E element in this) {
      f(element, i);
      i++;
    }
  }
}
