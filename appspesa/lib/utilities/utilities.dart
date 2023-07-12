import 'package:appspesa/data/data_dispatcher.dart';
import 'package:appspesa/domain/prodotto.dart';

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

String capitalizeFirstForEachWord(String string) {
  List<String> words = string.split(' ');
  String result = "";
  for (var word in words) {
    if (result.isEmpty) {
      result +=
          word.substring(0, 1).toUpperCase() + word.substring(1).toLowerCase();
    } else {
      result +=
          ' ${word.substring(0, 1).toUpperCase()}${word.substring(1).toLowerCase()}';
    }
  }
  return result;
}

String capitalizeOnlyFirst(String string) {
  return string.substring(0, 1).toUpperCase() +
      string.substring(1).toLowerCase();
}

void sortByIsDaRicomprare(bool primaDaRicomprare) {
  for (var key in prodotti.keys) {
    List<Prodotto> daRicomprare = [];
    List<Prodotto> nonDaRicomprare = [];

    for (var prodotto in prodotti[key]!) {
      if (prodotto.isDaRicomprare) {
        daRicomprare.add(prodotto);
      } else {
        nonDaRicomprare.add(prodotto);
      }
    }

    if (primaDaRicomprare) {
      prodotti[key] = daRicomprare + nonDaRicomprare;
    } else {
      prodotti[key] = nonDaRicomprare + daRicomprare;
    }
  }
}

void sortByIsPiaciuto(bool primaPiaciuti) {
  for (var key in prodotti.keys) {
    List<Prodotto> piaciuti = [];
    List<Prodotto> nonPiaciuti = [];
    List<Prodotto> inAttesa = [];

    for (var prodotto in prodotti[key]!) {
      if (prodotto.isPiaciuto == true) {
        piaciuti.add(prodotto);
      } else if (prodotto.isPiaciuto == null) {
        inAttesa.add(prodotto);
      } else {
        nonPiaciuti.add(prodotto);
      }
    }

    if (primaPiaciuti) {
      prodotti[key] = piaciuti + inAttesa + nonPiaciuti;
    } else {
      prodotti[key] = nonPiaciuti + inAttesa + piaciuti;
    }
  }
}
