class AddNewTestModel {
  int? rawId;
  String entityId;
  String sectionInchargeId;
  String sectionId;
  String? blockSectionId;
  String? stationId;
  String entityProfileId;
  String testLatt;
  String testLong;
  String testMode;
  String connectivityMode;
  String picture;
  List<TestParametersModel> parameters;
  String createdAt;

  AddNewTestModel(
      {this.rawId,
      required this.entityId,
      required this.sectionInchargeId,
      required this.sectionId,
      this.blockSectionId,
      this.stationId,
      required this.entityProfileId,
      required this.testLatt,
      required this.testLong,
      required this.testMode,
      required this.connectivityMode,
      required this.picture,
      required this.parameters,
      required this.createdAt});

  factory AddNewTestModel.fromJson(Map<String, dynamic> json) =>
      AddNewTestModel(
          rawId: json['id'],
          entityId: json["entityId"],
          sectionInchargeId: json["sectionInchargeId"],
          sectionId: json["sectionId"],
          blockSectionId: json["blockSectionId"],
          stationId: json['stationId'],
          entityProfileId: json["entityProfileId"],
          testLatt: json["testLatt"],
          testLong: json["testLong"],
          testMode: json["testMode"],
          connectivityMode: json["connectivityMode"],
          picture: json["picture"],
          parameters: List<TestParametersModel>.from(
              json["parameters"].map((x) => TestParametersModel.fromJson(x))),
          createdAt: json["createdDate"]);

  Map<String, dynamic> toJson() => {
        "entityId": entityId,
        "sectionInchargeId": sectionInchargeId,
        "sectionId": sectionId,
        "blockSectionId": blockSectionId,
        "entityProfileId": entityProfileId,
        "testLatt": testLatt,
        "testLong": testLong,
        "testMode": testMode,
        "connectivityMode": connectivityMode,
        "picture": picture,
        "stationId": stationId,
        "parameters": List<dynamic>.from(parameters.map((x) => x.toJson())),
        "createdDate":createdAt
      };
}

class TestParametersModel {
  String parameterId;
  String parameterValue;
  String? parameterReasonId;

  TestParametersModel({
    required this.parameterId,
    required this.parameterValue,
    this.parameterReasonId,
  });

  factory TestParametersModel.fromJson(Map<String, dynamic> json) =>
      TestParametersModel(
        parameterId: json["parameterId"],
        parameterValue: json["parameterValue"],
        parameterReasonId: json["parameterReasonId"],
      );

  Map<String, dynamic> toJson() => parameterReasonId!.isEmpty
      ? {
          "parameterId": parameterId,
          "parameterValue": parameterValue,
        }
      : {
          "parameterId": parameterId,
          "parameterValue": parameterValue,
          "parameterReasonId": parameterReasonId,
        };
}
