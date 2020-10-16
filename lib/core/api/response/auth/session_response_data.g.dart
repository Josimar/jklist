part of 'session_response_data.dart';

SessionResponseData _$SessionResponseDataFromJson(Map<String, dynamic> json) {
  return SessionResponseData(
    user: json['user'],
    token: json['token'] as String,
  );
}