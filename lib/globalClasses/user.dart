class User {
  String name;
  String imageUrl;
  String uid;
  String email;
  User({this.name, this.imageUrl, this.uid, this.email});
  Map<String, dynamic> toJson() {
    Map<String, dynamic> ret = {
      'full_name': name,
      "image_link": imageUrl,
      "user_id": uid,
      "email": email
    };
    return ret;
  }
}
