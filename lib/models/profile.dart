class Profile {
  final String userId;
  final String photo;
  final String phone;
  final String insta;
  final String username;

  Profile({this.userId, this.photo, this.phone, this.insta, this.username});

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      userId: json['userId'],
      photo: json['photo'],
      phone: json['phone'],
      username: json['username'],
      insta: json['insta'],
    );
  }
}
