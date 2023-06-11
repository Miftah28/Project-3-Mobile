// import 'dart:convert';

// class User {
//   int? id;
//   String? username;
//   String? password;
//   String? role;

//   User({
//     this.id,
//     required this.username,
//     this.password,
//     this.role,
//   });

//   factory User.fromJson(Map<String, dynamic> map) {
//     return User(
//       id: map["id"],
//       username: map["username"],
//       password: map["password"],
//       role: map["role"],
//     );
//   }
//   Map<String, dynamic> toJson() {
//     return {
//       "id": id,
//       "usernmae": username,
//       "password": password,
//       "role": role,
//     };
//   }

//   @override
//   String toString() {
//     return 'User{id: $id, username: $username, password: $password, role: $role}';
//   }
// }

// List<User> UserFromJson(String jsonData) {
//   final data = json.decode(jsonData);
//   return List<User>.from(data['data'].map((item) => User.fromJson(item)));
// }

// String UserToJson(User data) {
//   final jsonData = data.toJson();
//   return json.encode(jsonData);
// }

// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
    bool success;
    String message;
    Data data;

    User({
        required this.success,
        required this.message,
        required this.data,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        success: json["success"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data.toJson(),
    };
}

class Data {
    int id;
    String username;
    String role;
    dynamic rememberToken;
    DateTime createdAt;
    DateTime updatedAt;
    String token;
    String tokenType;
    Student student;

    Data({
        required this.id,
        required this.username,
        required this.role,
        this.rememberToken,
        required this.createdAt,
        required this.updatedAt,
        required this.token,
        required this.tokenType,
        required this.student,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        username: json["username"],
        role: json["role"],
        rememberToken: json["remember_token"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        token: json["token"],
        tokenType: json["token_type"],
        student: Student.fromJson(json["student"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "role": role,
        "remember_token": rememberToken,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "token": token,
        "token_type": tokenType,
        "student": student.toJson(),
    };
}

class Student {
    int id;
    int userId;
    int classroomId;
    int instanceId;
    int teacherId;
    String noIdentity;
    String name;
    String gender;
    String address;
    String photo;
    String email;
    String phone;
    DateTime createdAt;
    DateTime updatedAt;

    Student({
        required this.id,
        required this.userId,
        required this.classroomId,
        required this.instanceId,
        required this.teacherId,
        required this.noIdentity,
        required this.name,
        required this.gender,
        required this.address,
        required this.photo,
        required this.email,
        required this.phone,
        required this.createdAt,
        required this.updatedAt,
    });

    factory Student.fromJson(Map<String, dynamic> json) => Student(
        id: json["id"],
        userId: json["user_id"],
        classroomId: json["classroom_id"],
        instanceId: json["instance_id"],
        teacherId: json["teacher_id"],
        noIdentity: json["no_identity"],
        name: json["name"],
        gender: json["gender"],
        address: json["address"],
        photo: json["photo"],
        email: json["email"],
        phone: json["phone"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "classroom_id": classroomId,
        "instance_id": instanceId,
        "teacher_id": teacherId,
        "no_identity": noIdentity,
        "name": name,
        "gender": gender,
        "address": address,
        "photo": photo,
        "email": email,
        "phone": phone,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
    };
}

