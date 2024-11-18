class BlockStationModel {
    String blockSectionId;
    String blockSectionName;
    String sectionId;

    BlockStationModel({
        required this.blockSectionId,
        required this.blockSectionName,
        required this.sectionId,
    });

    factory BlockStationModel.fromJson(Map<String, dynamic> json) => BlockStationModel(
        blockSectionId: json["blockSectionId"],
        blockSectionName: json["blockSectionName"],
        sectionId: json["sectionId"],
    );

    Map<String, dynamic> toJson() => {
        "blockSectionId": blockSectionId,
        "blockSectionName": blockSectionName,
        "sectionId": sectionId,
    };
}