// To parse this JSON data, do
//
//     final getJournal = getJournalFromJson(jsonString);

import 'dart:convert';

GetJournal getJournalFromJson(String str) => GetJournal.fromJson(json.decode(str));

String getJournalToJson(GetJournal data) => json.encode(data.toJson());

class GetJournal {
    bool success;
    List<Datum> data;
    String message;

    GetJournal({
        required this.success,
        required this.data,
        required this.message,
    });

    factory GetJournal.fromJson(Map<String, dynamic> json) => GetJournal(
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
    int instanceId;
    String listJurnals;
    String tanggal;
    String validationJurnal;
    DateTime createdAt;
    DateTime updatedAt;

    Datum({
        required this.id,
        required this.teacherId,
        required this.studentId,
        required this.instanceId,
        required this.tanggal,
        required this.listJurnals,
        required this.validationJurnal,
        required this.createdAt,
        required this.updatedAt,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        teacherId: json["teacher_id"],
        studentId: json["student_id"],
        instanceId: json["instance_id"],
        listJurnals: json["list_jurnals"],
        tanggal: json["tanggal"],
        validationJurnal: json["validation_jurnal"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "teacher_id": teacherId,
        "student_id": studentId,
        "instance_id": instanceId,
        "list_jurnals": listJurnals,
        "tanggal": tanggal,
        "validation_jurnal": validationJurnal,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
    };
}
