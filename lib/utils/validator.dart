import 'package:email_validator/email_validator.dart';

class Validator implements EmailValidator {
  String validateEmail(value) {
    if (value.length == 0) {
      return "Email is required";
    } else if (value.length < 3) {
      return "Min 4 characters";
    } else if (EmailValidator.validate(value) == false) {
      return "Invalid format";
    } else
      return null;
  }

  String validateFullname(value) {
    if (value.length == 0) {
      return "Fullname is required";
    } else
      return null;
  }

  String validatePassword(value) {
    if (value.length == 0) {
      return "Password is required";
    } else if (value.length < 8) {
      return "Password Min 8 characters";
    } else
      return null;
  }

  String validatePasswordConfirmation(password, value) {
    if (value.length == 0) {
      return "Password confirmation is required";
    } else if (password != value) {
      return "The password confirmation does not match";
    } else
      return null;
  }
}
