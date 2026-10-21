class FormValidators {
  FormValidators._();

  static final RegExp _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  static String? requiredField(
    String? value, [
    String errorMessage = 'This field is required',
  ]) {
    if (value == null || value.trim().isEmpty) {
      return errorMessage;
    }
    return null;
  }

  static String? email(
    String? value, {
    String requiredMessage = 'Email is required',
    String invalidMessage = 'Please enter a valid email address',
  }) {
    if (value == null || value.trim().isEmpty) {
      return requiredMessage;
    }
    if (!_emailRegex.hasMatch(value.trim())) {
      return invalidMessage;
    }
    return null;
  }

  static String? minLength(String? value, int min, String errorMessage) {
    if (value == null || value.length < min) {
      return errorMessage;
    }
    return null;
  }

  static String? matches(String? value, String target, String errorMessage) {
    if (value != target) {
      return errorMessage;
    }
    return null;
  }
}
