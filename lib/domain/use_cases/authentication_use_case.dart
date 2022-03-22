import 'package:flutter_tdd_clean_architecture/domain/entities/account_entity.dart';

abstract class AuthenticationUseCase {
  Future<AccountEntity> auth({
    required String email,
    required String password,
  });
}
