class StationModel {
    String stationId;
    String stationName;
    String sectionId;

    StationModel({
        required this.stationId,
        required this.stationName,
        required this.sectionId,
    });

    factory StationModel.fromJson(Map<String, dynamic> json) => StationModel(
        stationId: json["stationId"],
        stationName: json["stationName"],
        sectionId: json["sectionId"],
    );

    Map<String, dynamic> toJson() => {
        "stationId": stationId,
        "stationName": stationName,
        "sectionId": sectionId,
    };
}
