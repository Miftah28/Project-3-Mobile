// To parse this JSON data, do
//
//     final getReport = getReportFromJson(jsonString);

import 'dart:convert';

GetReport getReportFromJson(String str) => GetReport.fromJson(json.decode(str));

String getReportToJson(GetReport data) => json.encode(data.toJson());

class GetReport {
  bool success;
  List<Datum> data;
  String message;

  GetReport({
    required this.success,
    required this.data,
    required this.message,
  });

  factory GetReport.fromJson(Map<String, dynamic> json) => GetReport(
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
  int teacherId;
  int studentId;
  String description;
  String tanggal;
  String file;
  DateTime createdAt;
  DateTime updatedAt;

  Datum({
    required this.id,
    required this.teacherId,
    required this.studentId,
    required this.description,
    required this.tanggal,
    required this.file,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        teacherId: json["teacher_id"],
        studentId: json["student_id"],
        description: json["description"],
        tanggal: json["tanggal"],
        file: json["file"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "teacher_id": teacherId,
        "student_id": studentId,
        "description": description,
        "tanggal": tanggal,
        "file": file,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
