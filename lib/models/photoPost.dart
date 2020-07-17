import "package:eva/models/geoJson.dart";

class PhotoPost {
  final String id;
  final String imagesPaths;
  final Geometry location;
  final String description;
  final String userId;
  final Map favorites;

  PhotoPost({this.id, this.imagesPaths, this.location, this.description, this.userId, this.favorites});

  factory PhotoPost.fromJson(Map<String, dynamic> json) {
    return PhotoPost(
      userId: json['userId'],
      id: json['_id'],
      description: json['description'],
      imagesPaths: json['imagesPaths'],
      location: Geometry.fromJson(json['location']),
      favorites: json['favorites']
    );
  }
}