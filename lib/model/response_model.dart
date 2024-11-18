class ResponseModel {
  int status;
  String message;
  bool error;
  Object data;

  ResponseModel(
      {required this.data,
      required this.error,
      required this.message,
      required this.status});

  Map<String, dynamic> toJson() =>
      {'status': status, 'message': message, 'error': error, 'data': data};

  factory ResponseModel.fromJson(Map<String, dynamic> json) {
    return ResponseModel(
        data: json['data'],
        error: json['error'],
        message: json['message'],
        status: json['status']);
  }
}
