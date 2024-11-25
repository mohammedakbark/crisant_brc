class DivisionsModel {
    String divisionId;
    String divisionName;
    DateTime createdDate;
    DateTime modifiedDate;

    DivisionsModel({
        required this.divisionId,
        required this.divisionName,
        required this.createdDate,
        required this.modifiedDate,
    });

    factory DivisionsModel.fromJson(Map<String, dynamic> json) => DivisionsModel(
        divisionId: json["divisionId"],
        divisionName: json["divisionName"],
        createdDate: DateTime.parse(json["createdDate"]),
        modifiedDate: DateTime.parse(json["modifiedDate"]),
    );

    Map<String, dynamic> toJson() => {
        "divisionId": divisionId,
        "divisionName": divisionName,
        "createdDate": createdDate.toIso8601String(),
        "modifiedDate": modifiedDate.toIso8601String(),
    };
}
