class EntityProfileModel {
    String entityProfileId;
    String divisionId;
    String sectionInchargeId;
    String sectionId;
    String blockSectionId;
    String stationId;
    String entityId;
    String entityIdentifier;
    String entityLatt;
    String entityLong;
    String entityStatus;
    String entityConfirmed;
    String status;
    String userId;
    DateTime modifiedDate;

    EntityProfileModel({
        required this.entityProfileId,
        required this.divisionId,
        required this.sectionInchargeId,
        required this.sectionId,
        required this.blockSectionId,
        required this.stationId,
        required this.entityId,
        required this.entityIdentifier,
        required this.entityLatt,
        required this.entityLong,
        required this.entityStatus,
        required this.entityConfirmed,
        required this.status,
        required this.userId,
        required this.modifiedDate,
    });

    factory EntityProfileModel.fromJson(Map<String, dynamic> json) => EntityProfileModel(
        entityProfileId: json["entityProfileId"],
        divisionId: json["divisionId"],
        sectionInchargeId: json["sectionInchargeId"],
        sectionId: json["sectionId"],
        blockSectionId: json["blockSectionId"],
        stationId: json["stationId"],
        entityId: json["entityId"],
        entityIdentifier: json["entityIdentifier"],
        entityLatt: json["entityLatt"],
        entityLong: json["entityLong"],
        entityStatus: json["entityStatus"],
        entityConfirmed: json["entityConfirmed"],
        status: json["status"],
        userId: json["userId"],
        modifiedDate: DateTime.parse(json["modifiedDate"]),
    );

    Map<String, dynamic> toJson() => {
        "entityProfileId": entityProfileId,
        "divisionId": divisionId,
        "sectionInchargeId": sectionInchargeId,
        "sectionId": sectionId,
        "blockSectionId": blockSectionId,
        "stationId": stationId,
        "entityId": entityId,
        "entityIdentifier": entityIdentifier,
        "entityLatt": entityLatt,
        "entityLong": entityLong,
        "entityStatus": entityStatus,
        "entityConfirmed": entityConfirmed,
        "status": status,
        "userId": userId,
        "modifiedDate": modifiedDate.toIso8601String(),
    };
}