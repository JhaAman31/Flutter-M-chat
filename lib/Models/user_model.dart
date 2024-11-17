class UserModel {
  String? name;
  String? email;
  String? password;
  String? userId;
  String? profilePic;

  UserModel(this.name, this.email, this.password, this.userId, this.profilePic);

  UserModel.fromMap(Map<String, dynamic> map){
    name = map["Name"];
    email = map["Email"];
    password = map["Password"];
    userId = map["UserId"];
    profilePic = map["ProfilePic"];
  }

  Map<String, dynamic> toMap() {
    return {
      "Name": name,
      "Email": email,
      "Password": password,
      "UserId": userId,
      "ProfilePic": profilePic,
    };
  }
}