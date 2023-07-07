// ignore_for_file: avoid_print

import 'package:appspesa/pages/mytheme.dart';
import 'package:flutter/material.dart';
import '../connection/connection_railway.dart';
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

    Future<Widget> buildTabBar() async {
      final conn = await connectToDatabase();

      // Esegue la query per ottenere i dati dal database
      var results = await conn.execute('SELECT * FROM tipo');
      List<Widget> tabWidgets = [];
      Map<String, List<Prodotto>> prodotti = {};
      for (var row in results.rows) {
        String? value = row.colAt(0);
        if (value != null) {
          List<Prodotto> prodottiList = [];
          var otherResult = await conn.execute(
              'SELECT * FROM prodotto WHERE nome_tipo = :tipo',
              {'tipo': value});

          for (var prodotto in otherResult.rows) {
            int idProdotto = int.parse(prodotto.colAt(0) as String);
            String nomeProdotto = prodotto.colAt(1) as String;
            String nomeMarca = prodotto.colAt(2) as String;
            String nomeTipo = value;
            bool isDaRicomprare = (prodotto.colAt(4) == 'true');
            bool? isPiaciuto = prodotto.colAt(5) as bool?;
            String? nota = prodotto.colAt(6);

            prodottiList.add(Prodotto(
                id: idProdotto,
                nome: nomeProdotto,
                nomeMarca: nomeMarca,
                nomeTipo: nomeTipo,
                isDaRicomprare: isDaRicomprare,
                isPiaciuto: isPiaciuto,
                nota: nota));
          }

          prodotti[value] = prodottiList;

          // Aggiunge una Tab per ogni valore ottenuto dalla query
          tabWidgets.add(
            Tab(
              text: value,
            ),
          );
        }
      }

      // Ottiene il numero di voci del menu orizzontale
      final int tabsCount = tabWidgets.length;

      print("Disconnected from database");
      await conn.close();

      // Costruisce la TabBar utilizzando i dati ottenuti dalla query
      return DefaultTabController(
        initialIndex: 1,
        length: tabsCount,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Spesa'),

            // Imposta il predicate per mostrare la notifica solo quando lo scroll è a profondità 1
            notificationPredicate: (ScrollNotification notification) {
              return notification.depth == 1;
            },
            // L'elevazione dell'app bar quando lo scroll view è sotto di essa
            scrolledUnderElevation: 2.0,
            // Colore dell'ombra dell'app bar
            // ignore: use_build_context_synchronously
            shadowColor: MyTheme.getThemeData().colorScheme.shadow,
            // TabBar con le Tab generate dalla query
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

    // Utilizza il FutureBuilder per gestire l'asincronicità della costruzione della TabBar
    return FutureBuilder<Widget>(
      future: buildTabBar(),
      builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Visualizza un indicatore di caricamento durante l'attesa dei dati
          return Scaffold(
            appBar: AppBar(
              title: const Text('Spesa'),
            ),
            body: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasData) {
          // Restituisce il widget della TabBar se sono disponibili i dati
          return snapshot.data!;
        } else if (snapshot.hasError) {
          // Visualizza il messaggio di errore ricevuto dal database
          return Scaffold(
            appBar: AppBar(
              title: const Text('Spesa'),
            ),
            body: Center(
              child: Text('Error retrieving data: ${snapshot.error}'),
            ),
          );
        } else {
          // Visualizza un messaggio generico di errore se si verifica un problema sconosciuto
          return Scaffold(
            appBar: AppBar(
              title: const Text('Spesa'),
            ),
            body: const Center(
              child: Text('Unknown error occurred'),
            ),
          );
        }
      },
    );
  }
}
