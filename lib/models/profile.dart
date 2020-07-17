class PubEntity {
  final String entity;
  final bool public;

  PubEntity({this.entity, this.public});

  factory PubEntity.fromJson(Map<String, dynamic> json) {
    return PubEntity(
      entity: json['entity'],
      public: json['public'],
    );
  }
}

class Social {
  final PubEntity tgrm;
  final PubEntity insta;

  Social({this.tgrm, this.insta});

  factory Social.fromJson(Map<String, dynamic> json) {
    return Social(
      tgrm: PubEntity.fromJson(json['tgrm']),
      insta: PubEntity.fromJson(json['insta']),
    );
  }
}

class Profile {
  final String userId;
  final String photo;
  final PubEntity phone;
  final Social social;
  final String username;

  Profile({this.userId, this.photo, this.phone, this.social, this.username});

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      userId: json['userId'],
      photo: json['photo'],
      phone: PubEntity.fromJson(json['phone']),
      username: json['username'],
      social: Social.fromJson(json['social']),
    );
  }
}