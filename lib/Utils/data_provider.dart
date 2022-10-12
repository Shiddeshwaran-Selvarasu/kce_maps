import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models.dart';

class DataProvider extends ChangeNotifier {
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<Map<String, Spots>> getData() async {
    Map<String, Spots> places = {};
    await FirebaseFirestore.instance.collection('/KCE/').get().then((value) {
      value.docs.forEach((element) {
        String name = element.id;
        var data = element.data()[name];
        print("name = $name data = $data");
        places.addAll({
          element.id: Spots(
            name: data['name'],
            image: data['image'],
            description: data['description'],
            id: data['id'],
            blockName: data['blockName'],
            loc: data['location'],
          )
        });
      });
    });
    print(places);
    return places;
  }
}
