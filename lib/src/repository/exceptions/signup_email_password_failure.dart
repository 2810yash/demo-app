class SignUpWithEmailAndPasswordFailure{
  final String message;

  const SignUpWithEmailAndPasswordFailure([this.message = "An Unknown error occurred"]);

  factory SignUpWithEmailAndPasswordFailure.code(String code){
    return const SignUpWithEmailAndPasswordFailure();
  }
}