class ParameterValuesModel {
    String parameterValueId;
    String parameterId;
    String parameterValue;
    String parameterStatus;

    ParameterValuesModel({
        required this.parameterValueId,
        required this.parameterId,
        required this.parameterValue,
        required this.parameterStatus,
    });

    factory ParameterValuesModel.fromJson(Map<String, dynamic> json) => ParameterValuesModel(
        parameterValueId: json["parameterValueId"],
        parameterId: json["parameterId"],
        parameterValue: json["parameterValue"],
        parameterStatus: json["parameterStatus"],
    );

    Map<String, dynamic> toJson() => {
        "parameterValueId": parameterValueId,
        "parameterId": parameterId,
        "parameterValue": parameterValue,
        "parameterStatus": parameterStatus,
    };
}
