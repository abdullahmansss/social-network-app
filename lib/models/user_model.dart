class UserDataModel {
  UserDataModel({
    required this.uId,
    required this.username,
    required this.email,
    required this.token,
    required this.image,
  });

  late final String uId;
  late final String username;
  late final String email;
  late final String token;
  late final String image;

  UserDataModel.fromJson(Map<String, dynamic> json) {
    uId = json['uId'] ?? '';
    username = json['username'] ?? '';
    email = json['email'] ?? '';
    token = json['token'] ?? '';
    image = json['image'] ?? '';
  }

  Map<String, dynamic> toJson() {
    return {
      'uId': uId,
      'username': username,
      'email': email,
      'token': token,
      'image': image,
    };
  }
}