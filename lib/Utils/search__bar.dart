import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.35,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: place.image.length,
            itemBuilder: (context, index) => ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: CachedNetworkImage(
                imageUrl: place.image[index].toString(),
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width,
                fadeOutDuration: const Duration(microseconds: 3),
                progressIndicatorBuilder: (context, s, d){
                  return Center(
                    child: CircularProgressIndicator(
                      value: d.totalSize != null ? d.downloaded / d.totalSize! : null,
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        Text(
          place.name,
          style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
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
          snapshot.data?.forEach((key, value) {
            searchList.add(value);
            suggestions.add(value.name);
          });
          print(snapshot.data);

          return ListView.builder(
            itemCount: suggestions.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(suggestions[index]),
                leading: const Icon(Icons.location_on),
                onTap: () {
                  query = suggestions[index];
                  showResults(context);
                },
              );
            },
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
