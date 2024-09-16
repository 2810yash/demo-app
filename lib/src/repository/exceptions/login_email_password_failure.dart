class LoginWithEmailAndPasswordFailure{
  final String message;

  const LoginWithEmailAndPasswordFailure([this.message = "An Unknown error occurred at Login side"]);

  factory LoginWithEmailAndPasswordFailure.code(String code){
    return const LoginWithEmailAndPasswordFailure();
  }
}