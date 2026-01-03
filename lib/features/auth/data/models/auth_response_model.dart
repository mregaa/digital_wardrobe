import 'package:json_annotation/json_annotation.dart';

part 'auth_response_model.g.dart';

/// Response model for login/register endpoints
@JsonSerializable()
class AuthResponseModel {
  @JsonKey(name: 'access_token')
  final String accessToken;
  
  @JsonKey(name: 'token_type')
  final String tokenType;

  const AuthResponseModel({
    required this.accessToken,
    required this.tokenType,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$AuthResponseModelToJson(this);
}
