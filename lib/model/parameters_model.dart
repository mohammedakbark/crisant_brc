class ParametersModel {
    String parameterId;
    String entityId;
    String parameterName;
    String parameterType;
    String mandatory;
    List<OptionModel> values;

    ParametersModel({
        required this.parameterId,
        required this.entityId,
        required this.parameterName,
        required this.parameterType,
        required this.mandatory,
        required this.values,
    });

    factory ParametersModel.fromJson(Map<String, dynamic> json) => ParametersModel(
        parameterId: json["parameterId"],
        entityId: json["entityId"],
        parameterName: json["parameterName"],
        parameterType: json["parameterType"],
        mandatory: json["mandatory"],
        values: List<OptionModel>.from(json["values"].map((x) => OptionModel.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "parameterId": parameterId,
        "entityId": entityId,
        "parameterName": parameterName,
        "parameterType": parameterType,
        "mandatory": mandatory,
        "values": List<dynamic>.from(values.map((x) => x.toJson())),
    };
}

class OptionModel {
    String parameterValueId;
    String parameterValue;
    String parameterStatus;

    OptionModel({
        required this.parameterValueId,
        required this.parameterValue,
        required this.parameterStatus,
    });

    factory OptionModel.fromJson(Map<String, dynamic> json) => OptionModel(
        parameterValueId: json["parameterValueId"],
        parameterValue: json["parameterValue"],
        parameterStatus: json["parameterStatus"],
    );

    Map<String, dynamic> toJson() => {
        "parameterValueId": parameterValueId,
        "parameterValue": parameterValue,
        "parameterStatus": parameterStatus,
    };
}