// To parse this JSON data, do
//
//     final saveattendance = saveattendanceFromJson(jsonString);

import 'dart:convert';

Saveattendance saveattendanceFromJson(String str) => Saveattendance.fromJson(json.decode(str));

String saveattendanceToJson(Saveattendance data) => json.encode(data.toJson());

class Saveattendance {
    bool success;
    Data data;
    String message;

    Saveattendance({
        required this.success,
        required this.data,
        required this.message,
    });

    factory Saveattendance.fromJson(Map<String, dynamic> json) => Saveattendance(
        success: json["success"],
        data: Data.fromJson(json["data"]),
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "data": data.toJson(),
        "message": message,
    };
}

class Data {
    int id;
    int studentId;
    int teacherId;
    int instanceId;
    String latitude;
    String longitude;
    DateTime tanggal;
    String masuk;
    dynamic pulang;
    DateTime createdAt;
    DateTime updatedAt;

    Data({
        required this.id,
        required this.studentId,
        required this.teacherId,
        required this.instanceId,
        required this.latitude,
        required this.longitude,
        required this.tanggal,
        required this.masuk,
        this.pulang,
        required this.createdAt,
        required this.updatedAt,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        studentId: json["student_id"],
        teacherId: json["teacher_id"],
        instanceId: json["instance_id"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        tanggal: DateTime.parse(json["tanggal"]),
        masuk: json["masuk"],
        pulang: json["pulang"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "student_id": studentId,
        "teacher_id": teacherId,
        "instance_id": instanceId,
        "latitude": latitude,
        "longitude": longitude,
        "tanggal": "${tanggal.year.toString().padLeft(4, '0')}-${tanggal.month.toString().padLeft(2, '0')}-${tanggal.day.toString().padLeft(2, '0')}",
        "masuk": masuk,
        "pulang": pulang,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
    };
}
