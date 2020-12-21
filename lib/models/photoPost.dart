import "package:eva/models/geoJson.dart";

class PhotoPost {
  final String id;
  final String imagesPaths;
  final Geometry location;
  final String title;
  final String description;
  final String userId;
  final Map favorites;
  final int views;
  final int date;

  PhotoPost(
      {this.id,
      this.imagesPaths,
      this.location,
      this.title,
      this.description,
      this.userId,
      this.favorites,
      this.views,
      this.date});

  factory PhotoPost.fromJson(Map<String, dynamic> json) {
    return PhotoPost(
        userId: json['userId'],
        id: json['_id'],
        title: json['title'],
        description: json['description'],
        imagesPaths: json['imagesPaths'],
        location: Geometry.fromJson(json['location']),
        favorites: json['favorites'],
        views: json['views'],
        date: json['date']);
  }
  factory PhotoPost.fromSymbolData(symboData) {
    return PhotoPost(
        userId: symboData['userId'],
        id: symboData['id'],
        title: symboData['title'],
        description: symboData['description'],
        imagesPaths: symboData['imagesPaths'],
        favorites: symboData['favorites'],
        views: symboData['views'],
        date: symboData['date']);
  }
  Map toJson() {
    return {
      'id': id,
      'imagesPaths': imagesPaths,
      'title': title,
      'description': description,
      'userId': userId,
      'favorites': favorites,
      'views': views,
      'date': date
    };
  }
}
