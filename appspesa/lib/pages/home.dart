import 'package:appspesa/data/data_dispatcher.dart';
import 'package:appspesa/pages/mytheme.dart';
import 'package:appspesa/utilities/utilities.dart';
import 'package:flutter/material.dart';
import 'aggiungi_prodotto_page.dart';
import 'dettaglio_prodotto_page.dart';
import '../domain/prodotto.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController searchController = TextEditingController();
  bool? primaIsDaRicomprare;
  bool? primaPiaciuti;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchProdottoSuggestions(""); //resetto la ricerca
    searchController.text = "";
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

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
      initialIndex: 0,
      length: tabsCount,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Spesa'),
          notificationPredicate: (ScrollNotification notification) {
            return notification.depth == 1;
          },
          scrolledUnderElevation: 2.0,
          shadowColor: MyTheme.getThemeData().colorScheme.shadow,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(
                kToolbarHeight + 56.0), // Height of TabBar + SearchBar
            child: Column(
              children: [
                TabBar(
                  isScrollable: true,
                  tabs: tabWidgets,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'Cerca',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 8.0), // Adjust the vertical padding
                    ),
                    onChanged: (value) {
                      fetchProdottoSuggestions(value);
                      setState(() {});
                    },
                  ),
                ),
              ],
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.sort),
              onPressed: () {
                if (primaIsDaRicomprare == null) {
                  primaIsDaRicomprare = true;
                } else {
                  primaIsDaRicomprare = !primaIsDaRicomprare!;
                }
                sortByIsDaRicomprare(primaIsDaRicomprare!);
                setState(() {});
              },
            ),
            IconButton(
              icon: const Icon(Icons.thumbs_up_down_outlined),
              onPressed: () {
                if (primaPiaciuti == null) {
                  primaPiaciuti = true;
                } else {
                  primaPiaciuti = !primaPiaciuti!;
                }
                sortByIsPiaciuto(primaPiaciuti!);
                setState(() {});
              },
            )
          ],
        ),
        body: TabBarView(
          children: prodotti.keys.map((key) {
            if (prodotti[key]!.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Non ci sono prodotti per questo tipo",
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 5),
                    ElevatedButton.icon(
                        onPressed: () {
                          //TODO codice per eliminare il tipo
                        },
                        label: const Text("Elimina tipo"),
                        icon: const Icon(Icons.delete))
                  ],
                ),
              );
            } else {
              return ListView.builder(
                itemCount: prodotti[key]?.length,
                itemBuilder: (BuildContext context, int index) {
                  if (prodotti[key]![index].isDaMostrare == true) {
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
                                builder: (context) => DettaglioProdottoPage(
                                    prodotto: prodotto))).then(
                          (result) {
                            if (result != null && result['tipoAdded'] != null) {
                              tabWidgets.add(Tab(
                                text: result['tipoAdded'],
                              ));
                            }
                            if (result != null &&
                                result['prodottoAdded'] != null) {
                              setState(() {});
                            }
                            fetchProdottoSuggestions("");
                            searchController.text = "";
                          },
                        );
                      },
                    );
                  }
                },
              );
            }
          }).toList(),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AggiungiProdottoPage()))
                .then((result) {
              if (result != null && result['tipoAdded'] != null) {
                tabWidgets.add(Tab(
                  text: result['tipoAdded'],
                ));
              }
              fetchProdottoSuggestions("");
              searchController.text = "";
              setState(() {});
            });
          },
          child: const Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

//! Soluzione non funzionante con doppio floatingActionButton
        /* floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
                onPressed: () {
                  print("primo tasto");
                },
                child: const Icon(Icons.sort)),
            const SizedBox(width: 10),
            FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const AggiungiProdottoPage())).then((result) {
                    if (result != null && result['tipoAdded'] != null) {
                      tabWidgets.add(Tab(
                        text: result['tipoAdded'],
                      ));
                    }
                    if (result != null && result['prodottoAdded'] != null) {
                      setState(() {});
                    }
                  });
                },
                child: const Icon(Icons.add)),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat, */
      ),
    );
  }
}
