import 'package:dart_countries/dart_countries.dart';
import 'package:phone_form_field/phone_form_field.dart';

typedef PhoneNumberInputValidator = String? Function(PhoneNumber? phoneNumber);

class PhoneValidator {
  /// allow to compose several validators
  /// Note that validator list order is important as first
  /// validator failing will return according message.
  static PhoneNumberInputValidator compose(
      List<PhoneNumberInputValidator> validators) {
    return (valueCandidate) {
      for (var validator in validators) {
        final validatorResult = validator.call(valueCandidate);
        if (validatorResult != null) {
          return validatorResult;
        }
      }
      return null;
    };
  }

  static PhoneNumberInputValidator required({
    /// custom error message
    String? errorText,
  }) {
    return (PhoneNumber? valueCandidate) {
      if (valueCandidate == null || (valueCandidate.nsn.trim().isEmpty)) {
        return errorText ?? 'requiredPhoneNumber';
      }
      return null;
    };
  }

  static PhoneNumberInputValidator invalid({
    /// custom error message
    String? errorText,

    /// determine whether a missing value should be reported as invalid
    bool allowEmpty = true,
  }) =>
      valid(errorText: errorText, allowEmpty: allowEmpty);

  static PhoneNumberInputValidator valid({
    /// custom error message
    String? errorText,

    /// determine whether a missing value should be reported as invalid
    bool allowEmpty = true,
  }) {
    return (PhoneNumber? valueCandidate) {
      if (valueCandidate != null &&
          (!allowEmpty || valueCandidate.nsn.isNotEmpty) &&
          !valueCandidate.validate()) {
        return errorText ?? 'invalidPhoneNumber';
      }
      return null;
    };
  }

  @Deprecated('use validType, invalid type naming was backward')
  static PhoneNumberInputValidator invalidType(
    /// expected phonetype
    PhoneNumberType expectedType, {

    /// custom error message
    String? errorText,

    /// determine whether a missing value should be reported as invalid
    bool allowEmpty = true,
  }) =>
      validType(
        expectedType,
        errorText: errorText,
        allowEmpty: allowEmpty,
      );

  static PhoneNumberInputValidator validType(
    /// expected phonetype
    PhoneNumberType expectedType, {

    /// custom error message
    String? errorText,

    /// determine whether a missing value should be reported as invalid
    bool allowEmpty = true,
  }) {
    final defaultMessage = expectedType == PhoneNumberType.mobile
        ? 'invalidMobilePhoneNumber'
        : 'invalidFixedLinePhoneNumber';
    return (PhoneNumber? valueCandidate) {
      if (valueCandidate != null &&
          (!allowEmpty || valueCandidate.nsn.isNotEmpty) &&
          !valueCandidate.validate(type: expectedType)) {
        return errorText ?? defaultMessage;
      }
      return null;
    };
  }

  @Deprecated('use validFixedLine, naming was backward')
  static PhoneNumberInputValidator invalidFixedLine({
    /// custom error message
    String? errorText,

    /// determine whether a missing value should be reported as invalid
    bool allowEmpty = true,
  }) =>
      validFixedLine(errorText: errorText, allowEmpty: allowEmpty);

  /// convenience shortcut method for
  /// invalidType(context, PhoneNumberType.fixedLine, ...)
  static PhoneNumberInputValidator validFixedLine({
    /// custom error message
    String? errorText,

    /// determine whether a missing value should be reported as invalid
    bool allowEmpty = true,
  }) =>
      validType(
        PhoneNumberType.fixedLine,
        errorText: errorText,
        allowEmpty: allowEmpty,
      );

  @Deprecated('Use validMobile, naming was backward')
  static PhoneNumberInputValidator invalidMobile({
    /// custom error message
    String? errorText,

    /// determine whether a missing value should be reported as invalid
    bool allowEmpty = true,
  }) =>
      validMobile(
        errorText: errorText,
        allowEmpty: allowEmpty,
      );

  /// convenience shortcut method for
  /// invalidType(context, PhoneNumberType.mobile, ...)
  static PhoneNumberInputValidator validMobile({
    /// custom error message
    String? errorText,

    /// determine whether a missing value should be reported as invalid
    bool allowEmpty = true,
  }) =>
      validType(
        PhoneNumberType.mobile,
        errorText: errorText,
        allowEmpty: allowEmpty,
      );

  @Deprecated('Use valid country, naming was backward')
  static invalidCountry(
    /// list of valid country isocode
    List<String> expectedCountries, {

    /// custom error message
    String? errorText,

    /// determine whether a missing value should be reported as invalid
    bool allowEmpty = true,
  }) =>
      validCountry(
        expectedCountries,
        errorText: errorText,
        allowEmpty: allowEmpty,
      );

  static PhoneNumberInputValidator validCountry(
    /// list of valid country isocode
    List<String> expectedCountries, {

    /// custom error message
    String? errorText,

    /// determine whether a missing value should be reported as invalid
    bool allowEmpty = true,
  }) {
    assert(
      expectedCountries.every((isoCode) => isoCodes.contains(isoCode)),
      'Each expectedCountries value be valid country isoCode',
    );

    return (PhoneNumber? valueCandidate) {
      if (valueCandidate != null &&
          (!allowEmpty || valueCandidate.nsn.isNotEmpty) &&
          !expectedCountries.contains(valueCandidate.isoCode)) {
        return errorText ?? 'invalidCountry';
      }
      return null;
    };
  }

  static PhoneNumberInputValidator get none => (PhoneNumber? valueCandidate) {};
}
