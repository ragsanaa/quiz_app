class Token {
  final int responseCode;
  final String token;

  Token({
    required this.responseCode,
    required this.token,
  });

  factory Token.fromJson(Map<String, dynamic> json) => Token(
        responseCode: json["response_code"],
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "response_code": responseCode,
        "token": token,
      };
}
