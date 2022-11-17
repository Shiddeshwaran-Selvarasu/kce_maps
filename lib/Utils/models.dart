import 'package:cloud_firestore/cloud_firestore.dart';

class Spots {
  final String name;
  final List<dynamic> image;
  final String description;
  final int id;
  final String? blockName;
  final GeoPoint loc;

  Spots({
    required this.name,
    required this.image,
    required this.description,
    required this.id,
    required this.blockName,
    required this.loc,
  });

  int compareTo(Spots other) {
    return name.compareTo(other.name);
  }
}