class SectionInchargeModel {
  String sectionInchargeId;
  String sectionInchargeName;
  String divisionId;

  SectionInchargeModel({
    required this.sectionInchargeId,
    required this.sectionInchargeName,
    required this.divisionId,
  });

  factory SectionInchargeModel.fromJson(Map<String, dynamic> json) =>
      SectionInchargeModel(
        sectionInchargeId: json["sectionInchargeId"],
        sectionInchargeName: json["sectionInchargeName"],
        divisionId: json["divisionId"],
      );

  Map<String, dynamic> toJson() => {
        "sectionInchargeId": sectionInchargeId,
        "sectionInchargeName": sectionInchargeName,
        "divisionId": divisionId,
      };
}
