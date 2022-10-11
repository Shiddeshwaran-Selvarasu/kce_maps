import 'package:flutter/material.dart';

class SearchBar extends SearchDelegate<String> {
  List<String> searchList = ["ONe", "two", "three", "four"];

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          if(query == ""){
            close(context, "");
          } else {
            query = "";
          }
        },
        icon: const Icon(Icons.close),
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
    return const SizedBox();
    // throw UnimplementedError();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> suggestions =
        searchList.where((text) => text.toLowerCase().contains(query.toLowerCase())).toList();
    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(suggestions[index]),
          leading: const Icon(Icons.location_on),
        );
      },
    );
  }
}
