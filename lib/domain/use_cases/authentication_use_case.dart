import 'package:flutter_tdd_clean_architecture/domain/entities/account_entity.dart';

class AuthenticationUseCaseRequestDTO {
  final String email;
  final String password;

  AuthenticationUseCaseRequestDTO({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = this.email;
    data['password'] = this.password;
    return data;
  }
}

abstract class AuthenticationUseCase {
  Future<void>? auth(AuthenticationUseCaseRequestDTO auth);
}
