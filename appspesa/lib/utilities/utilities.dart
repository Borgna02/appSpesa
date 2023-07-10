bool containsIgnoreCase(Iterable<String> set, String element) {
  for (String e in set) {
    if (e.toLowerCase() == element.toLowerCase()) return true;
  }
  return false;
}
