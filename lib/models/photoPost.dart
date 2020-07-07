import "package:eva/models/geoJson.dart";

class PhotoPost {
  final String id;
  final String imagesPaths;
  final Geometry location;
  final String description;
  final String userId;

  PhotoPost({this.id, this.imagesPaths, this.location, this.description, this.userId});

  factory PhotoPost.fromJson(Map<String, dynamic> json) {
    return PhotoPost(
      userId: json['userId'],
      id: json['_id'],
      description: json['description'],
      imagesPaths: json['imagesPaths'],
      location: Geometry.fromJson(json['location'])
    );
  }
}