class MyValidators {
  static String? displayNamevalidator(String? displayName) {
    if (displayName == null || displayName.isEmpty) {
      return 'Display name cannot be empty';
    }
    if (displayName.length < 3 || displayName.length > 20) {
      return 'Display Name must be between 3 and 20 characters';
    }
    return null; // valid display name
  }

  static String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an e-mail';
    }
    if (!RegExp(r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$')
        .hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  static String? passwordValidator(String? value) {
    if (value!.isEmpty) {
      return 'please enter a password';
    }
    if (value!.length < 6) {
      return 'password must be at least 6 characters long';
    }
    return null;
  }

  static String? repaetPasswordValidator({String? value, String? password}) {
    if (value != password) {
      return 'password do not match ';
    }
    return null;
  }
}
