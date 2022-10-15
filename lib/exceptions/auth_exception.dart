class AuthException implements Exception {
  final String key;
 static const Map <String, String> errors = {
  'EMAIL_EXISTS': 'esse e-mail já está sendo usado',
  'OPERATION_NOT_ALLOWED': 'Não exite uma conta com essas informações',
  'TOO_MANY_ATTEMPTS_TRY_LATER': 'Você está errando muito sua senha',
  'EMAIL_NOT_FOUND': 'E-mail não encontrado',
  'INVALID_PASSWORD': 'Senha inválida',
  'USER_DISABLED': 'Usuário desabilitado',
  };

  const AuthException(this.key);

  @override 
  String toString(){
    if(errors.containsKey(key)){
      return errors[key];
    }else{
    return 'Ocorreu um erro na autenticação';
    }
  }
}