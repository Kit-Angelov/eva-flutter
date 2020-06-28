class Geometry {
  final String type;
  final List coordinates;

  Geometry({this.type, this.coordinates});

  factory Geometry.fromJson(Map<String, dynamic> json) {
    return Geometry(
      type: json['type'],
      coordinates: json['coordinates']
    );
  }
}