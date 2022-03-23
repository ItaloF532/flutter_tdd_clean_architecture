import 'package:test/test.dart';
import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';

import 'package:flutter_tdd_clean_architecture/data/http/http_error.dart';
import 'package:flutter_tdd_clean_architecture/data/http/http_client.dart';
import 'package:flutter_tdd_clean_architecture/domain/helpers/domain_error.dart';
import 'package:flutter_tdd_clean_architecture/data/use_cases/remote_authentication.dart';
import 'package:flutter_tdd_clean_architecture/domain/use_cases/authentication_use_case.dart';

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  late String url;
  late HttpClient httpClient;
  late RemoteAuthenticationUseCase sut;
  late AuthenticationUseCaseRequestDTO authParams;

  Map<String, dynamic> mockValidData() => {
        'accessToken': faker.guid.guid(),
        'name': faker.person.name(),
      };

  PostExpectation _mockRequest() {
    return when(httpClient.request(
      url: url,
      method: 'post',
      body: anyNamed('body'),
    ));
  }

  void mockHttpData(Map<String, dynamic> map) {
    _mockRequest().thenAnswer((_) async => map);
  }

  void mockHttpError(HttpError error) {
    _mockRequest().thenThrow(error);
  }

  // System under test
  // serve para identificar quem você está testando, que no caso é o Remote Authentication

  // Arrange, ou seja dado a instância da classe
  setUp(() {
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();
    sut = RemoteAuthenticationUseCase(url: url, httpClient: httpClient);
    authParams = AuthenticationUseCaseRequestDTO(
      email: faker.internet.email(),
      password: faker.internet.password(),
    );

    mockHttpData(mockValidData());
  });

  test('Should call HttpClient with correct values', () async {
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

  test('Should throw UnexpectedError if HttpClient returns 400', () {
    mockHttpError(HttpError.badRequest);

    // Act, ação de chamar o método de autenticação
    final future = sut.auth(authParams);

    // Assert, resultado esperado, no caso a verifição da URL
    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if HttpClient returns 404', () {
    mockHttpError(HttpError.notFound);

    // Act, ação de chamar o método de autenticação
    final future = sut.auth(authParams);

    // Assert, resultado esperado, no caso a verifição da URL
    expect(future, throwsA(DomainError.unexpected));
  });

  test(
    'Should throw InvalidCredentialsError if HttpClient returns 401',
    () {
      mockHttpError(HttpError.unauthorized);

      // Act, ação de chamar o método de autenticação
      final future = sut.auth(authParams);

      // Assert, resultado esperado, no caso a verifição da URL
      expect(future, throwsA(DomainError.invalidCredentials));
    },
  );

  test('Should throw UnexpectedError if HttpClient returns 500', () {
    mockHttpError(HttpError.internalServerError);

    // Act, ação de chamar o método de autenticação
    final future = sut.auth(authParams);

    // Assert, resultado esperado, no caso a verifição da URL
    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should return an Account if HttpClient returns 200', () async {
    final validData = mockValidData();

    mockHttpData(validData);

    // Act, ação de chamar o método de autenticação
    final response = await sut.auth(authParams);

    // Assert, resultado esperado, no caso a verifição da URL
    expect(response?.token, validData['accessToken']);
  });

  test(
    'Should  throw UnexpectedError if HttpClient returns 200 with invalid Data',
    () async {
      mockHttpData({'invalid_key': 'invalid_value'});

      // Act, ação de chamar o método de autenticação
      final future = sut.auth(authParams);

      // Assert, resultado esperado, no caso a verifição da URL
      expect(future, throwsA(DomainError.unexpected));
    },
  );
}
