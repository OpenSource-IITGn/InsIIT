class HashtagModel {
  String id, name;
  bool following;
  HashtagModel({this.id, this.name, this.following});
  factory HashtagModel.fromJson(Map<String, dynamic> json) {
    return HashtagModel(
        id: json['hash_tag_id'],
        name: json['hash_tag_name'],
        following: json['followed_by_user']);
  }
}
