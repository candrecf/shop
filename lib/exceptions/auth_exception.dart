class AuthException implements Exception {
  static const Map<String, String> errors = {
    'EMAIL_EXISTS': 'E-mail já cadastrado.',
    'OPERATION_NOT_ALLOWED': 'Operação não permitida!',
    'TOO_MANY_ATTEMPTS_TRY_LATER':
        'Acesso bloqueado temporariamente. Tente mais tarde.',
    'EMAIL_NOT_FOUND': 'E-mail não encontrado.',
    'INVALID_PASSWORD': 'Senha informada não confere.',
    'USER_DISABLED': 'A conta do usuário não confere.',
    'INVALID_LOGIN_CREDENTIALS': 'Login ou senha inválidos.',
  };
  final String key;

  AuthException({required this.key});

  @override
  String toString() {
    return errors[key] ?? 'Ocorreu um erro no processo de autenticação.';
  }
}
