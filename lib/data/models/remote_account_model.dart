import 'package:flutter_tdd_clean_architecture/data/http/http_error.dart';
import 'package:flutter_tdd_clean_architecture/domain/entities/account_entity.dart';

class RemoteAccountModel {
  final String accessToken;

  RemoteAccountModel({
    required this.accessToken,
  });

  factory RemoteAccountModel.fromJson(Map<String, dynamic> json) {
    if (!json.containsKey('accessToken')) throw HttpError.invalidData;

    return RemoteAccountModel(
      accessToken: json['accessToken'],
    );
  }

  AccountEntity toDomain() => AccountEntity(token: this.accessToken);
}
