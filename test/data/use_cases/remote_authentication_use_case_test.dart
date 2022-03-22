import 'package:test/test.dart';
import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';

import 'package:flutter_tdd_clean_architecture/data/http/http_cliente.dart';
import 'package:flutter_tdd_clean_architecture/data/use_cases/remote_authentication.dart';
import 'package:flutter_tdd_clean_architecture/domain/use_cases/authentication_use_case.dart';

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  late String url;
  late HttpClient httpClient;
  late RemoteAuthenticationUseCase sut;

  // System under test
  // serve para identificar quem você está testando, que no caso é o Remote Authentication

  // Arrange, ou seja dado a instância da classe
  setUp(() {
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();
    sut = RemoteAuthenticationUseCase(url: url, httpClient: httpClient);
  });

  test('Should call HttpClient with correct values', () async {
    //  Arrange
    final authParams = AuthenticationUseCaseRequestDTO(
      email: faker.internet.email(),
      password: faker.internet.password(),
    );

    // Act, ação de chamar o método de autenticação
    await sut.auth(authParams);

    // Assert, resultado esperado, no caso a verifição da URL
    verify(httpClient.request(
      url: url,
      method: 'post',
      body: {
        'email': authParams.email,
        'password': authParams.password,
      },
    ));
  });
}
