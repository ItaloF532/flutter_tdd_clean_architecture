import 'package:flutter_tdd_clean_architecture/data/http/http_error.dart';
import 'package:flutter_tdd_clean_architecture/data/http/http_client.dart';
import 'package:flutter_tdd_clean_architecture/data/models/remote_account_model.dart';
import 'package:flutter_tdd_clean_architecture/domain/entities/account_entity.dart';
import 'package:flutter_tdd_clean_architecture/domain/helpers/domain_error.dart';
import 'package:flutter_tdd_clean_architecture/domain/use_cases/authentication_use_case.dart';

class RemoteAuthenticationUseCaseRequestDTO {
  final String email;
  final String password;

  RemoteAuthenticationUseCaseRequestDTO({
    required this.email,
    required this.password,
  });

  factory RemoteAuthenticationUseCaseRequestDTO.fromDomain(
      AuthenticationUseCaseRequestDTO dto) {
    return RemoteAuthenticationUseCaseRequestDTO(
      email: dto.email,
      password: dto.password,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = this.email;
    data['password'] = this.password;
    return data;
  }
}

class RemoteAuthenticationUseCase implements AuthenticationUseCase {
  final String url;
  final HttpClient httpClient;

  RemoteAuthenticationUseCase({
    required this.url,
    required this.httpClient,
  });

  @override
  Future<AccountEntity?> auth(
      AuthenticationUseCaseRequestDTO authParams) async {
    try {
      final response = await httpClient.request(
        url: url,
        method: 'post',
        body: RemoteAuthenticationUseCaseRequestDTO.fromDomain(authParams)
            .toJson(),
      );

      if (response != null) {
        return RemoteAccountModel.fromJson(response).toDomain();
      }

      return null;
    } on HttpError catch (err) {
      if (err == HttpError.unauthorized) {
        throw DomainError.invalidCredentials;
      }

      throw DomainError.unexpected;
    }
  }
}
