class SectionModel {
    String sectionId;
    String sectionName;
    String sectionInchargeId;

    SectionModel({
        required this.sectionId,
        required this.sectionName,
        required this.sectionInchargeId,
    });

    factory SectionModel.fromJson(Map<String, dynamic> json) => SectionModel(
        sectionId: json["sectionId"],
        sectionName: json["sectionName"],
        sectionInchargeId: json["sectionInchargeId"],
    );

    Map<String, dynamic> toJson() => {
        "sectionId": sectionId,
        "sectionName": sectionName,
        "sectionInchargeId": sectionInchargeId,
    };
}