bool containsIgnoreCase(Iterable<String> set, String element) {
  for (String e in set) {
    if (e.toLowerCase() == element.toLowerCase()) return true;
  }
  return false;
}

List<String> mergeSortIgnoreCase(List<String> strings) {
  if (strings.length <= 1) {
    return strings;
  }

  int mid = strings.length ~/ 2;
  List<String> left = mergeSortIgnoreCase(strings.sublist(0, mid));
  List<String> right = mergeSortIgnoreCase(strings.sublist(mid));

  return merge(left, right);
}

List<String> merge(List<String> left, List<String> right) {
  List<String> merged = [];
  int leftIndex = 0;
  int rightIndex = 0;

  while (leftIndex < left.length && rightIndex < right.length) {
    if (left[leftIndex]
            .toLowerCase()
            .compareTo(right[rightIndex].toLowerCase()) <=
        0) {
      merged.add(left[leftIndex]);
      leftIndex++;
    } else {
      merged.add(right[rightIndex]);
      rightIndex++;
    }
  }

  while (leftIndex < left.length) {
    merged.add(left[leftIndex]);
    leftIndex++;
  }

  while (rightIndex < right.length) {
    merged.add(right[rightIndex]);
    rightIndex++;
  }

  return merged;
}
