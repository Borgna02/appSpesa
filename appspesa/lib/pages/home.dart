import 'package:appspesa/data/data_dispatcher.dart';
import 'package:appspesa/pages/mytheme.dart';
import 'package:flutter/material.dart';
import 'aggiungi_prodotto_page.dart';
import 'dettaglio_prodotto_page.dart';
import '../domain/prodotto.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = MyTheme.getThemeData().colorScheme;
    final Color oddItemColor = colorScheme.primary.withOpacity(0.05);
    final Color evenItemColor = colorScheme.primary.withOpacity(0.15);

    List<Widget> tabWidgets = [];

    // Ottiene il numero di voci del menu orizzontale
    Iterable<String> tabs = prodotti.keys;

    for (String tab in tabs) {
      // Aggiunge una Tab per ogni chiave della mappa
      tabWidgets.add(
        Tab(
          text: tab,
        ),
      );
    }
    int tabsCount = tabWidgets.length;

    // Costruisce la TabBar utilizzando i dati ottenuti dalla query
    return DefaultTabController(
      initialIndex: 1,
      length: tabsCount,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Spesa'),
          notificationPredicate: (ScrollNotification notification) {
            return notification.depth == 1;
          },
          scrolledUnderElevation: 2.0,
          shadowColor: MyTheme.getThemeData().colorScheme.shadow,
          bottom: TabBar(
            isScrollable: true,
            tabs: tabWidgets,
          ),
        ),
        body: TabBarView(
          children: prodotti.keys.map((key) {
            return ListView.builder(
              itemCount: prodotti[key]?.length,
              itemBuilder: (BuildContext context, int index) {
                String? nomeProdotto = prodotti[key]?[index].nome;
                Prodotto prodotto = prodotti[key]![index];
                IconData iconData;
                if (prodotto.isPiaciuto == true) {
                  iconData = Icons.thumb_up;
                } else if (prodotto.isPiaciuto == false) {
                  iconData = Icons.thumb_down;
                } else {
                  iconData = Icons.watch_later;
                }

                return ListTile(
                  tileColor: index.isOdd ? oddItemColor : evenItemColor,
                  title: Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: prodotto.isDaRicomprare
                              ? Colors.red
                              : Colors.green,
                        ),
                      ),
                      Text(nomeProdotto!),
                    ],
                  ),
                  subtitle: Text(prodotto.nomeMarca),
                  trailing: Icon(iconData),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            DettaglioProdottoPage(prodotto: prodotto),
                      ),
                    );
                  },
                );
              },
            );
          }).toList(),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AggiungiProdottoPage(),
              ),
            );
          },
          child: const Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }
}
