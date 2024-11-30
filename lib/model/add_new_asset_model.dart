class AddNewAssetModel {
  int? rawId;
  String entityId;
  String sectionInchargeId;
  String sectionId;
  String? blockSectionId;
  String? stationId;
  String entityIdentifier;
  String entityLatt;
  String entityLong;
  String createdAt;

  AddNewAssetModel(
      {this.rawId,
      required this.entityId,
      required this.sectionInchargeId,
      required this.sectionId,
      this.blockSectionId,
      this.stationId,
      required this.entityIdentifier,
      required this.entityLatt,
      required this.entityLong,
      required this.createdAt});

  factory AddNewAssetModel.fromJson(Map<String, dynamic> json) {
    if (json['stationId'] == null) {
      return AddNewAssetModel(
          rawId: json['id'],
          entityId: json["entityId"],
          sectionInchargeId: json["sectionInchargeId"],
          sectionId: json["sectionId"],
          blockSectionId: json["blockSectionId"],
          entityIdentifier: json["entityIdentifier"],
          entityLatt: json["entityLatt"],
          entityLong: json["entityLong"],
          createdAt: json["createdDate"]);
    } else if (json['blockSectionId'] == null) {
      return AddNewAssetModel(
          rawId: json['id'],
          entityId: json["entityId"],
          sectionInchargeId: json["sectionInchargeId"],
          sectionId: json["sectionId"],
          stationId: json["stationId"],
          entityIdentifier: json["entityIdentifier"],
          entityLatt: json["entityLatt"],
          entityLong: json["entityLong"],
          createdAt: json["createdDate"]);
    } else {
      return AddNewAssetModel(
          rawId: json['id'],
          entityId: json["entityId"],
          sectionInchargeId: json["sectionInchargeId"],
          sectionId: json["sectionId"],
          blockSectionId: json["blockSectionId"],
          stationId: json["stationId"],
          entityIdentifier: json["entityIdentifier"],
          entityLatt: json["entityLatt"],
          entityLong: json["entityLong"],
          createdAt: json["createdDate"]);
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
        "createdDate":createdAt
      };
}
