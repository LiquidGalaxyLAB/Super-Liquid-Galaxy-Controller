
class ApiErrorResponse {
  int? statusCode;
  String? error;
  String? message;

  ApiErrorResponse({this.statusCode, this.error, this.message});

  ApiErrorResponse.fromJson(Map<String, dynamic> json) {
    this.statusCode = json["statusCode"];
    this.error = json["error"];
    this.message = json["message"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["statusCode"] = this.statusCode;
    data["error"] = this.error;
    data["message"] = this.message;
    return data;
  }
}