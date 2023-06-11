// To parse this JSON data, do
//
//     final attendancess = attendancessFromJson(jsonString);

import 'dart:convert';

Attendancess attendancessFromJson(String str) => Attendancess.fromJson(json.decode(str));

String attendancessToJson(Attendancess data) => json.encode(data.toJson());

class Attendancess {
    bool success;
    List<Datum> data;
    String message;

    Attendancess({
        required this.success,
        required this.data,
        required this.message,
    });

    factory Attendancess.fromJson(Map<String, dynamic> json) => Attendancess(
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
    int studentId;
    int teacherId;
    int instanceId;
    String latitude;
    String longitude;
    String tanggal;
    String masuk;
    String pulang;
    DateTime createdAt;
    DateTime updatedAt;
    bool isHariIni;

    Datum({
        required this.id,
        required this.studentId,
        required this.teacherId,
        required this.instanceId,
        required this.latitude,
        required this.longitude,
        required this.tanggal,
        required this.masuk,
        required this.pulang,
        required this.createdAt,
        required this.updatedAt,
        required this.isHariIni,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        studentId: json["student_id"],
        teacherId: json["teacher_id"],
        instanceId: json["instance_id"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        tanggal: json["tanggal"],
        masuk: json["masuk"],
        pulang: json["pulang"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        isHariIni: json["is_hari_ini"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "student_id": studentId,
        "teacher_id": teacherId,
        "instance_id": instanceId,
        "latitude": latitude,
        "longitude": longitude,
        "tanggal": tanggal,
        "masuk": masuk,
        "pulang": pulang,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "is_hari_ini": isHariIni,
    };
}
