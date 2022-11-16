part of 'login_cubit.dart';

class LoginState extends Equatable with FormzMixin {
  LoginState({
    this.email = const Email.dirty(),
    this.password = const Password.pure(),
    this.status = FormzStatus.pure,
    this.errorMessage,
    this.isChecked = false,
  });

  final Email email;
  final Password password;
  @override
  final FormzStatus status;
  final String? errorMessage;
  late bool isChecked;

  @override
  List<Object> get props => [email, password, status];

  LoginState copyWith({
    Email? email,
    Password? password,
    FormzStatus? status,
    String? errorMessage,
    bool? isChecked,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      isChecked: isChecked ?? this.isChecked,
    );
  }

  @override
  List<FormzInput> get inputs => [
        email,
        password,
      ];
}
