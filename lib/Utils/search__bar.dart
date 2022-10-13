import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:kce_maps/Utils/data_provider.dart';
import 'package:provider/provider.dart';

import 'models.dart';

class SearchBar extends SearchDelegate<String> {
  List<Spots> searchList = [];

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          if (query == "") {
            close(context, "");
          } else {
            query = "";
          }
        },
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_close,
          progress: transitionAnimation,
        ),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, query);
      },
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    Spots place = searchList[
        searchList.indexWhere((element) => element.name.contains(query))];
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,

      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: CarouselSlider(
            options: CarouselOptions(
              height: MediaQuery.of(context).size.height * 0.25,
              enlargeCenterPage: true,
              autoPlay: true,
              aspectRatio: 16 / 13,
              autoPlayCurve: Curves.easeOutBack,
              enableInfiniteScroll: true,
              autoPlayAnimationDuration: const Duration(milliseconds: 1000),
              viewportFraction: 0.8,
            ),
            items: place.image
                .map(
                  (e) => Container(
                    padding: EdgeInsets.all(10),

                    decoration: BoxDecoration(
                   borderRadius: BorderRadius.circular(12),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        imageUrl: e.toString(),
                        fit: BoxFit.cover,
                        width: MediaQuery.of(context).size.width,
                        fadeOutDuration: const Duration(microseconds: 3),
                        progressIndicatorBuilder: (context, s, d) {
                          return Center(
                            child: CircularProgressIndicator(
                              value: d.totalSize != null
                                  ? d.downloaded / d.totalSize!
                                  : null,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Text(
            place.name,
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Text(
            place.description,
            textAlign: TextAlign.justify,
            style: const TextStyle(
              fontSize: 20,
            ),
          ),
        ),
        if (!place.blockName.contains(' nil '))
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Text(
              "Block: ${place.blockName}",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.location_on),
              iconSize: 30,
              color: Colors.green,
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.directions),
              iconSize: 30,
              color: Colors.green,
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final data = Provider.of<DataProvider>(context);
    return FutureBuilder(
      future: data.getData(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<String> suggestions = [];
          List<String> results = [];
          snapshot.data?.forEach((key, value) {
            searchList.add(value);
            suggestions.add(value.name);
          });

          results = query.isEmpty
              ? suggestions
              : suggestions
                  .where((element) =>
                      element.toLowerCase().contains(query.toLowerCase()))
                  .toList();

          return results.isNotEmpty
              ? ListView.builder(
                  itemCount: results.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(results[index]),
                      leading: const Icon(Icons.location_on),
                      onTap: () {
                        query = results[index];
                        showResults(context);
                      },
                    );
                  },
                )
              : Center(
                  child: Text("No results found for $query"),
                );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
