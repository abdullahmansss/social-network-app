class PostDataModel {
  PostDataModel({
    required this.text,
    required this.time,
    required this.image,
    required this.ownerName,
    required this.ownerImage,
    required this.likes,
    required this.shares,
    required this.comments,
  });

  late final String text;
  late final String time;
  late final String image;
  late final String ownerName;
  late final String ownerImage;
  late final List<String> likes;
  late int shares;
  late final List<CommentDataModel> comments;

  PostDataModel.fromJson(Map<String, dynamic> json) {
    text = json['text'] ?? '';
    time = json['time'] ?? '';
    image = json['image'] ?? '';
    ownerName = json['ownerName'] ?? '';
    ownerImage = json['ownerImage'] ?? '';
    likes = List.from(json['likes']).map((e) => e.toString()).toList();
    shares = json['shares'] ?? 0;
    comments = List.from(json['comments']).map((e) => CommentDataModel.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'time': time,
      'image': image,
      'ownerName': ownerName,
      'ownerImage': ownerImage,
      'likes': likes.map((element) => element).toList(),
      'shares': shares,
      'comments': comments.map((element) => element.toJson()).toList(),
    };
  }
}

class CommentDataModel {
  CommentDataModel({
    required this.text,
    required this.time,
    required this.ownerName,
    required this.ownerImage,
  });

  late final String text;
  late final String time;
  late final String ownerName;
  late final String ownerImage;

  CommentDataModel.fromJson(Map<String, dynamic> json) {
    text = json['text'] ?? '';
    time = json['time'] ?? '';
    ownerName = json['ownerName'] ?? '';
    ownerImage = json['ownerImage'] ?? '';
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'time': time,
      'ownerName': ownerName,
      'ownerImage': ownerImage,
    };
  }
}

