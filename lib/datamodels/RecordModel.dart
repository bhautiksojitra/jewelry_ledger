import "dart:convert";
import 'dart:developer';
import 'package:intl/intl.dart';

Recordmodel recordmodelFromJson(String str) =>
    Recordmodel.fromJson(json.decode(str));

String recordmodelToJson(Recordmodel Recordmodel) =>
    json.encode(Recordmodel.toJson());

class Recordmodel {
  int granular;
  DateTime sentdate;
  String status;
  int weight;

  Recordmodel(
      {required this.granular,
      required this.sentdate,
      required this.status,
      required this.weight});

  factory Recordmodel.fromJson(Map<String, dynamic> json) {
    log(json["granular"].toString());
    return Recordmodel(
        granular: json["granular"],
        sentdate: DateTime.parse(json["sentdate"]),
        status: json["status"],
        weight: json["weight"]);
  }

  Map<String, dynamic> toJson() => {
        "granular": granular,
        "sentdate": DateFormat("yyyy-MM-dd").format(sentdate),
        "status": status,
        "weight": weight
      };
}
