class ParameterReasonModel {
    String parameterReasonId;
    String parameterValueId;
    String reason;

    ParameterReasonModel({
        required this.parameterReasonId,
        required this.parameterValueId,
        required this.reason,
    });

    factory ParameterReasonModel.fromJson(Map<String, dynamic> json) => ParameterReasonModel(
        parameterReasonId: json["parameterReasonId"],
        parameterValueId: json["parameterValueId"],
        reason: json["reason"],
    );

    Map<String, dynamic> toJson() => {
        "parameterReasonId": parameterReasonId,
        "parameterValueId": parameterValueId,
        "reason": reason,
    };
}
