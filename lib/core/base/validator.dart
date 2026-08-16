abstract class Validator {
  bool hasErrors = false;

  void addError() {
    hasErrors = true;
  }

  void resetErrors() {
    hasErrors = false;
  }
}
