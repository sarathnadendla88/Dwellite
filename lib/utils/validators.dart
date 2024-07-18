class Validators {
  static RegExp phoneNumberRegex = RegExp(r'^[0-9]{0,10}$');

  static bool isValidPhoneNumber(String phoneNumber) {
    return phoneNumberRegex.hasMatch(phoneNumber);
  }
}