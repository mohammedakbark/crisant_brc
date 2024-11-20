class ParametersModel {
  String parameterId;
  String entityId;
  String parameterName;
  String parameterType;
  String mandatory;
  // List<ValuesModel>? values;

  ParametersModel({
    required this.parameterId,
    required this.entityId,
    required this.parameterName,
    required this.parameterType,
    required this.mandatory,
    // required this.values,
  });

  factory ParametersModel.fromJson(Map<String, dynamic> json) {
    // Check if 'values' is null or not
    // List<ValuesModel>? listOfValues =
    //     (json["values"] as List?)?.map((e) => ValuesModel.fromJson(e)).toList();

    return ParametersModel(
      parameterId: json["parameterId"] ?? '',
      entityId: json["entityId"] ?? '',
      parameterName: json["parameterName"] ?? '',
      parameterType: json["parameterType"] ?? '',
      mandatory: json["mandatory"] ?? '',
      // values: listOfValues,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "parameterId": parameterId,
      "entityId": entityId,
      "parameterName": parameterName,
      "parameterType": parameterType,
      "mandatory": mandatory,
      // Convert values to JSON if not null; otherwise, return an empty list
      // "values": values?.map((e) => e.toJson()).toList() ?? [],
    };
  }
}

// class ValuesModel {
//   String parameterValueId;
//   String parameterValue;
//   String parameterStatus;

//   ValuesModel({
//     required this.parameterValueId,
//     required this.parameterValue,
//     required this.parameterStatus,
//   });

//   factory ValuesModel.fromJson(Map<String, dynamic> json) => ValuesModel(
//         parameterValueId: json["parameterValueId"] ?? '',
//         parameterValue: json["parameterValue"] ?? '',
//         parameterStatus: json["parameterStatus"] ?? '',
//       );

//   Map<String, dynamic> toJson() => {
//         "parameterValueId": parameterValueId,
//         "parameterValue": parameterValue,
//         "parameterStatus": parameterStatus,
//       };
// }
