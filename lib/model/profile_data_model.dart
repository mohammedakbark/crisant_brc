class ProfileModel {
    User user;

    ProfileModel({
        required this.user,
    });

    factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
        user: User.fromJson(json["user"]),
    );

    Map<String, dynamic> toJson() => {
        "user": user.toJson(),
    };
}

class User {
    int iat;
    int nbf;
    Userinfo userinfo;

    User({
        required this.iat,
        required this.nbf,
        required this.userinfo,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        iat: json["iat"],
        nbf: json["nbf"],
        userinfo: Userinfo.fromJson(json["userinfo"]),
    );

    Map<String, dynamic> toJson() => {
        "iat": iat,
        "nbf": nbf,
        "userinfo": userinfo.toJson(),
    };
}

class Userinfo {
    String userId;
    String userName;
    String userFullName;
    String divisionId;
    String userRole;

    Userinfo({
        required this.userId,
        required this.userName,
        required this.userFullName,
        required this.divisionId,
        required this.userRole,
    });

    factory Userinfo.fromJson(Map<String, dynamic> json) => Userinfo(
        userId: json["userId"],
        userName: json["userName"],
        userFullName: json["userFullName"],
        divisionId: json["divisionId"],
        userRole: json["userRole"],
    );

    Map<String, dynamic> toJson() => {
        "userId": userId,
        "userName": userName,
        "userFullName": userFullName,
        "divisionId": divisionId,
        "userRole": userRole,
    };
}