class EntityModel {
  String entityId;
  String entityName;
  String pictureRequired;
  String periodicity;
  String entityType;

  EntityModel({
    required this.entityId,
    required this.entityName,
    required this.pictureRequired,
    required this.periodicity,
    required this.entityType,
  });

  factory EntityModel.fromJson(Map<String, dynamic> json) =>
      EntityModel(
        entityId: json["entityId"],
        entityName: json["entityName"],
        pictureRequired: json["pictureRequired"],
        periodicity: json["periodicity"],
        entityType: json["entityType"],
      );

  Map<String, dynamic> toJson() => {
        "entityId": entityId,
        "entityName": entityName,
        "pictureRequired": pictureRequired,
        "periodicity": periodicity,
        "entityType": entityType,
      };
}
