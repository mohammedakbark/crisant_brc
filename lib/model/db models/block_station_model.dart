class BlockSectionModel {
  String blockSectionId;
  String blockSectionName;
  String sectionId;

  BlockSectionModel({
    required this.blockSectionId,
    required this.blockSectionName,
    required this.sectionId,
  });

  factory BlockSectionModel.fromJson(Map<String, dynamic> json) =>
      BlockSectionModel(
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
