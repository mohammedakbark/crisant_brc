class TestReportsModel {
    String testReportId;
    String entityId;
    String entityProfileId;
    String divisionId;
    String sectionInchargeId;
    String sectionId;
    String? blockSectionId;
    String? stationId;
    String testLatt;
    String testLong;
    String distance;
    dynamic testroomNotes;
    String testConfirmed;
    String testMode;
    String connectivityMode;
    dynamic picture;
    DateTime createdDate;
    DateTime modifiedDate;

    TestReportsModel({
        required this.testReportId,
        required this.entityId,
        required this.entityProfileId,
        required this.divisionId,
        required this.sectionInchargeId,
        required this.sectionId,
        required this.blockSectionId,
        required this.stationId,
        required this.testLatt,
        required this.testLong,
        required this.distance,
        required this.testroomNotes,
        required this.testConfirmed,
        required this.testMode,
        required this.connectivityMode,
        required this.picture,
        required this.createdDate,
        required this.modifiedDate,
    });

    factory TestReportsModel.fromJson(Map<String, dynamic> json) => TestReportsModel(
        testReportId: json["testReportId"],
        entityId: json["entityId"],
        entityProfileId: json["entityProfileId"],
        divisionId: json["divisionId"],
        sectionInchargeId: json["sectionInchargeId"],
        sectionId: json["sectionId"],
        blockSectionId: json["blockSectionId"],
        stationId: json["stationId"],
        testLatt: json["testLatt"],
        testLong: json["testLong"],
        distance: json["distance"],
        testroomNotes: json["testroomNotes"],
        testConfirmed: json["testConfirmed"],
        testMode: json["testMode"],
        connectivityMode: json["connectivityMode"],
        picture: json["picture"],
        createdDate: DateTime.parse(json["createdDate"]),
        modifiedDate: DateTime.parse(json["modifiedDate"]),
    );

    Map<String, dynamic> toJson() => {
        "testReportId": testReportId,
        "entityId": entityId,
        "entityProfileId": entityProfileId,
        "divisionId": divisionId,
        "sectionInchargeId": sectionInchargeId,
        "sectionId": sectionId,
        "blockSectionId": blockSectionId,
        "stationId": stationId,
        "testLatt": testLatt,
        "testLong": testLong,
        "distance": distance,
        "testroomNotes": testroomNotes,
        "testConfirmed": testConfirmed,
        "testMode": testMode,
        "connectivityMode": connectivityMode,
        "picture": picture,
        "createdDate": createdDate.toIso8601String(),
        "modifiedDate": modifiedDate.toIso8601String(),
    };
}
