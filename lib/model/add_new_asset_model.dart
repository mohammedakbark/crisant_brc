class AddNewAssetModel {
  String entityId;
  String sectionInchargeId;
  String sectionId;
  String? blockSectionId;
  String? stationId;
  String entityIdentifier;
  String entityLatt;
  String entityLong;

  AddNewAssetModel({
    required this.entityId,
    required this.sectionInchargeId,
    required this.sectionId,
    this.blockSectionId,
    this.stationId,
    required this.entityIdentifier,
    required this.entityLatt,
    required this.entityLong,
  });

  factory AddNewAssetModel.fromJson(Map<String, dynamic> json) {
    if (json['stationId'] == null) {
      return AddNewAssetModel(
        entityId: json["entityId"],
        sectionInchargeId: json["sectionInchargeId"],
        sectionId: json["sectionId"],
        blockSectionId: json["blockSectionId"],
        entityIdentifier: json["entityIdentifier"],
        entityLatt: json["entityLatt"],
        entityLong: json["entityLong"],
      );
    } else if (json['blockSectionId'] == null) {
      return AddNewAssetModel(
        entityId: json["entityId"],
        sectionInchargeId: json["sectionInchargeId"],
        sectionId: json["sectionId"],
        stationId: json["stationId"],
        entityIdentifier: json["entityIdentifier"],
        entityLatt: json["entityLatt"],
        entityLong: json["entityLong"],
      );
    } else {
      return AddNewAssetModel(
        entityId: json["entityId"],
        sectionInchargeId: json["sectionInchargeId"],
        sectionId: json["sectionId"],
        blockSectionId: json["blockSectionId"],
        stationId: json["stationId"],
        entityIdentifier: json["entityIdentifier"],
        entityLatt: json["entityLatt"],
        entityLong: json["entityLong"],
      );
    }
  }

  Map<String, dynamic> toJson() => {
        "entityId": entityId,
        "sectionInchargeId": sectionInchargeId,
        "sectionId": sectionId,
        "blockSectionId": blockSectionId,
        "stationId": stationId,
        "entityIdentifier": entityIdentifier,
        "entityLatt": entityLatt,
        "entityLong": entityLong,
      };
}
