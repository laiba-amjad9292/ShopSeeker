// ignore_for_file: prefer_function_declarations_over_variables

import 'package:get/get.dart';

class ValidatorUtils {
  static var req = (value) {
    if (value.toString().trim() != "" && value != null) {
      return null;
    } else {
      return 'this_field_is_required'.tr;
    }
  };
  static var email = (value) {
    if (value == null || value.toString().trim() == "") {
      return 'this_field_is_required'.tr;
    } else if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$")
        .hasMatch(value)) {
      return 'enter_valid_email'.tr;
    }
    return null;
  };

  static var phone = (String? value, String? country) {
    if (country == '964') {
      if ((value?.length ?? 0) < 10) {
        return 'enter_a_valid_phone_number'.tr;
      }
      if ((value?.length ?? 0) > 0) {
        if (value?[0] != '7') {
          return 'enter_a_valid_phone_number'.tr;
        }
      }
    } else {
      if ((value?.length ?? 0) < 6) {
        return 'enter_a_valid_phone_number'.tr;
      }
    }
    return null;
  };
  static var password = (value) {
    if (value.toString().trim().length < 6) {
      return 'password_must_be_of_6_characters'.tr;
    } else {
      return null;
    }
  };
  static var idNumber = (value) {
    if (value.toString().trim().length < 5) {
      return 'please_enter_valid_id'.tr;
    } else {
      return null;
    }
  };

  static var description = (value) {
    if (value.toString().trim().length < 10 ||
        value.toString().trim().length > 1000) {
      return 'description_warning'.tr;
    } else {
      return null;
    }
  };

  static var descriptionWithoutPhone = (value) {
    RegExp alphabeticNumber1 = RegExp(
      r'\b(one|two|three|four|five|six|seven|eight|nine|zero)\b',
      caseSensitive: false,
    );
    RegExp numericPatten = RegExp(
      r'(?<![a-zA-Z])\b(one|two|three|four|five|six|seven|eight|nine|zero)\b(?![a-zA-Z])',
      caseSensitive: false,
    );
    RegExp numericPatten2 = RegExp(
      r'(?<!\S)\b(one|two|three|four|five|six|seven|eight|nine|zero)\b(?!\S)',
      caseSensitive: false,
    );

    String input = value.toString().trim();

    // Check if the length is within the allowed range
    // if (input.length < 10 || input.length > 1000) {
    //   return 'description_warning'.tr;
    // }
    if (
        // alphabeticNumber1.hasMatch(input) ||
        numericPatten2.hasMatch(input)) {
      return 'number_words_not_allowed'.tr;
    }

    return null; // Valid input
  };
}
