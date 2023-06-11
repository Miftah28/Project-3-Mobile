// To parse this JSON data, do
//
//     final getProfile = getProfileFromJson(jsonString);

import 'dart:convert';

GetProfile getProfileFromJson(String str) => GetProfile.fromJson(json.decode(str));

String getProfileToJson(GetProfile data) => json.encode(data.toJson());

class GetProfile {
    bool success;
    List<Datum> data;
    String message;

    GetProfile({
        required this.success,
        required this.data,
        required this.message,
    });

    factory GetProfile.fromJson(Map<String, dynamic> json) => GetProfile(
        success: json["success"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
    };
}

class Datum {
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

    Datum({
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

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
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
