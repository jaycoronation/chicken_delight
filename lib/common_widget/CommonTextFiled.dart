import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constant/colors.dart';

class CommonTextFiled extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType inputType;
  final int maxLength;
  final String prefixIcon;
  final String suffixIcon;

  const CommonTextFiled({
    required this.controller,
    required this.hintText,
    this.inputType = TextInputType.text,
    this.maxLength = TextField.noMaxLength,
    this.prefixIcon = "",
    this.suffixIcon = "",

    super.key
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      cursorColor: white,
      controller: controller,
      autofocus: true,
      maxLength: maxLength,
      keyboardType: inputType,
      style: getTextFiledStyle(),
      decoration: InputDecoration(
        labelText: hintText,
        counterText: "",
        prefixIcon: prefixIcon.isNotEmpty
            ? Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(prefixIcon, width: 22, height: 22, color: primaryColor),
        )
            : null,
        suffixIcon: suffixIcon.isNotEmpty
            ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(suffixIcon, width: 22, height: 22))
            : null,
        // suffixIcon: suffixIcon,
      ),
    );
  }
}

class CommonTextFieldForPassword extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType inputType;
  final int maxLength;
  final String prefixIcon;
  final String suffixIcon;
  final bool obscureText;


  const CommonTextFieldForPassword({
    required this.controller,
    required this.hintText,
    this.inputType = TextInputType.text,
    this.maxLength = TextField.noMaxLength,
    this.prefixIcon = "",
    this.suffixIcon = "",
    this.obscureText = false,

    super.key
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      cursorColor: white,
      controller: controller,
      autofocus: true,
      maxLength: maxLength,
      keyboardType: inputType,
      style: getTextFiledStyle(),
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: hintText,
        counterText: "",
        prefixIcon: prefixIcon.isNotEmpty
            ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(prefixIcon, width: 22, height: 22, color: primaryColor),
            )
            : null,
        // suffixIcon: suffixIcon,
      ),
    );
  }
}

class CommonTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType inputType;
  final int maxLength;
  final String prefixIcon;
  final String suffixIcon;

  const CommonTextField({
    required this.controller,
    required this.hintText,
    this.inputType = TextInputType.text,
    this.maxLength = TextField.noMaxLength,
    this.prefixIcon = "",
    this.suffixIcon = "",

    super.key
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      cursorColor: black,
      controller: controller,
      autofocus: true,
      maxLength: maxLength,
      keyboardType: inputType,
      style: getTextFieldStyle(),
      decoration: InputDecoration(
        labelText: hintText,
        counterText: "",
        prefixIcon: prefixIcon.isNotEmpty
            ? Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(prefixIcon, width: 22, height: 22, color: primaryColor),
        )
            : null,
        suffixIcon: suffixIcon.isNotEmpty
            ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(suffixIcon, width: 22, height: 22))
            : null,
        // suffixIcon: suffixIcon,
      ),
    );
  }
}

class CommonTextFieldForBottomSheet extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType inputType;
  final int maxLength;
  final String prefixIcon;
  final String suffixIcon;
  final void Function() onTap;

  const CommonTextFieldForBottomSheet({
    required this.controller,
    required this.hintText,
    this.inputType = TextInputType.text,
    this.maxLength = TextField.noMaxLength,
    this.prefixIcon = "",
    this.suffixIcon = "",
    required this.onTap,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      readOnly: true,
      cursorColor: black,
      controller: controller,
      maxLength: maxLength,
      keyboardType: inputType,
      style: getTextFieldStyle(),
      onTap: onTap,
      decoration: InputDecoration(
        labelText: hintText,
        labelStyle: getTextFieldHintStyle(),
        counterText: "",
        prefixIcon: prefixIcon.isNotEmpty
            ? Padding(
          padding: const EdgeInsets.all(12.0),
          child: Image.asset(prefixIcon, width: 22, height: 22),
        ) : null,
        suffixIcon: suffixIcon.isNotEmpty
            ? Padding(
            padding: const EdgeInsets.all(16.0),
            child: Image.asset(suffixIcon, width: 16, height: 16, color: black,))
            : null,
        // suffixIcon: suffixIcon,
      ),
    );
  }
}

class BottomLineTextFieldForBottomSheet extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType inputType;
  final int maxLength;
  final String suffixIcon;
  final bool readOnly;
  final void Function() onTap;
  final void Function(String)? onChange;

  const BottomLineTextFieldForBottomSheet({
    required this.controller,
    required this.hintText,
    this.inputType = TextInputType.text,
    this.maxLength = TextField.noMaxLength,
    this.suffixIcon = "",
    this.readOnly = true,
    this.onChange,
    required this.onTap,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      readOnly: readOnly,
      cursorColor: black,
      controller: controller,
      maxLength: maxLength,
      keyboardType: inputType,
      style: getTextFieldStyle(),
      onTap: onTap,
      onChanged: onChange,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.only(left: 4, right: 4, top: 0, bottom: 0),
        border: const OutlineInputBorder(borderSide: BorderSide(width: 0, style: BorderStyle.none, color: Colors.transparent)),
        focusedBorder: const OutlineInputBorder(borderSide: BorderSide(width: 0, style: BorderStyle.none, color: Colors.transparent)),
        errorBorder: const OutlineInputBorder(borderSide: BorderSide(width: 0, color: Colors.transparent)),
        focusedErrorBorder: const OutlineInputBorder(borderSide: BorderSide(width: 0, color: Colors.transparent)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(kEditTextCornerRadius),
            borderSide: const BorderSide(width: 0, style: BorderStyle.none, color: Colors.transparent)),
        hintText: hintText,
        hintStyle: getTextFieldHintStyle(),
        counterText: "",
        suffixIcon: suffixIcon.isNotEmpty ? Image.asset(suffixIcon, width: 10, height: 10) : null,
        // suffixIcon: suffixIcon,
      ),
    );
  }
}

class CommonTextFieldForBottomSheetBottomLine extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType inputType;
  final int maxLength;
  final String prefixIcon;
  final String suffixIcon;
  final void Function() onTap;

  const CommonTextFieldForBottomSheetBottomLine({
    required this.controller,
    required this.hintText,
    this.inputType = TextInputType.text,
    this.maxLength = TextField.noMaxLength,
    this.prefixIcon = "",
    this.suffixIcon = "",
    required this.onTap,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      readOnly: true,
      cursorColor: black,
      controller: controller,
      maxLength: maxLength,
      keyboardType: inputType,
      textCapitalization: TextCapitalization.words,
      style: getTextFieldStyle(),
      onTap: onTap,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: getTextFieldHintStyle(),
        counterText: "",
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: grayNew),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: grayNew),
        ),
        prefixIcon: prefixIcon.isNotEmpty
            ? Padding(
          padding: const EdgeInsets.all(12.0),
          child: Image.asset(prefixIcon, width: 22, height: 22, ),
        ) : null,
        suffixIcon: suffixIcon.isNotEmpty
            ? Padding(
            padding: const EdgeInsets.all(12.0),
            child: Image.asset(suffixIcon, width: 22, height: 22))
            : null,
        // suffixIcon: suffixIcon,
      ),
    );
  }
}

class CommonTextFieldInputType extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType inputType;
  final int maxLength;
  final String prefixIcon;
  final String suffixIcon;

  const CommonTextFieldInputType({
    required this.controller,
    required this.hintText,
    this.inputType = TextInputType.text,
    this.maxLength = TextField.noMaxLength,
    this.prefixIcon = "",
    this.suffixIcon = "",
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      cursorColor: black,
      controller: controller,
      maxLength: maxLength,
      keyboardType: inputType,
      style: getTextFieldStyle(),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: getTextFieldHintStyle(),
        counterText: "",
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: grayNew),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: grayNew),
        ),
        prefixIcon: prefixIcon.isNotEmpty
            ? Padding(
          padding: const EdgeInsets.all(12.0),
          child: Image.asset(prefixIcon, width: 22, height: 22, ),
        ) : null,
        suffixIcon: suffixIcon.isNotEmpty
            ? Padding(
            padding: const EdgeInsets.all(12.0),
            child: Image.asset(suffixIcon, width: 22, height: 22))
            : null,
        // suffixIcon: suffixIcon,
      ),
    );
  }
}

class SearchTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType inputType;
  final int maxLength;
  final String suffixIcon;
  final void Function() onTapClear;
  final void Function(String text) onChanged;

  const SearchTextField({
    required this.controller,
    required this.hintText,
    this.inputType = TextInputType.text,
    this.maxLength = TextField.noMaxLength,
    this.suffixIcon = "",
    required this.onTapClear,
    required this.onChanged,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      cursorColor: black,
      controller: controller,
      maxLength: maxLength,
      keyboardType: inputType,
      style: getTextFieldStyle(),
      onChanged: onChanged,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
        contentPadding: const EdgeInsets.only(left: 12, right: 12),
        hintText: hintText,
        hintStyle: getTextFieldHintStyle(),
        counterText: "",
        suffixIcon: suffixIcon.isNotEmpty
            ? GestureDetector(
          onTap:onTapClear,
          child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Image.asset(suffixIcon, width: 14, height: 14)
          ),
        )
            : null,
        // suffixIcon: suffixIcon,
      ),
    );
  }
}

class CommonTextFieldBottomLine extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType inputType;
  final int maxLength;

  const CommonTextFieldBottomLine({
    required this.controller,
    required this.hintText,
    this.inputType = TextInputType.text,
    this.maxLength = TextField.noMaxLength,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      cursorColor: black,
      controller: controller,
      maxLength: maxLength,
      keyboardType: inputType,
      style: getTextFieldStyle(),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: getTextFieldHintStyle(),
        counterText: "",
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: grayNew),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: grayNew),
        ),
      ),
    );
  }
}

class OutlineTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType inputType;
  final TextInputAction inputAction;

  final int maxLength;
  final void Function() onTapClear;
  final void Function(String)? onChanged;

  const OutlineTextField({
    required this.controller,
    required this.hintText,
    required this.onTapClear,
    this.inputType = TextInputType.text,
    this.inputAction = TextInputAction.next,
    this.maxLength = TextField.noMaxLength,
    this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      cursorColor: black,
      controller: controller,
      maxLength: maxLength,
      keyboardType: inputType,
      textInputAction: inputAction,
      style: getTextFieldStyle(),
      onTap: onTapClear,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: getTextFieldHintStyle(),
        counterText: "",
        contentPadding: const EdgeInsets.only(left: 12,right: 12),
        border: const OutlineInputBorder(
            borderSide: BorderSide(width: 0.8, style: BorderStyle.solid, color: grayNew)),
        focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(width: 0.8, style: BorderStyle.solid, color: grayNew)),
        errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(width: 0.8, color: grayNew)),
        focusedErrorBorder: const OutlineInputBorder(
            borderSide: BorderSide(width: 0.8, color: grayNew)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(kEditTextCornerRadius),
            borderSide: const BorderSide(width: 0.8, style: BorderStyle.solid, color: grayNew)),
      ),
    );
  }
}

class CommonTextFieldBottomLineInputAction extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType inputType;
  final TextInputAction inputAction;
  final int maxLength;
  final String prefixIcon;
  final String suffixIcon;

  const CommonTextFieldBottomLineInputAction({
    required this.controller,
    required this.hintText,
    this.inputType = TextInputType.text,
    this.inputAction = TextInputAction.next,
    this.maxLength = TextField.noMaxLength,
    this.prefixIcon = "",
    this.suffixIcon = "",
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      readOnly: true,
      cursorColor: black,
      controller: controller,
      maxLength: maxLength,
      keyboardType: inputType,
      textInputAction: inputAction,
      style: getTextFieldStyle(),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: getTextFieldHintStyle(),
        labelText: hintText,
        labelStyle: getTextFieldHintStyle(),
        counterText: "",
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: grayNew),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: grayNew),
        ),
        prefixIcon: prefixIcon.isNotEmpty
            ? Padding(
          padding: const EdgeInsets.all(12.0),
          child: Image.asset(prefixIcon, width: 22, height: 22, ),
        ) : null,
        suffixIcon: suffixIcon.isNotEmpty
            ? Padding(
            padding: const EdgeInsets.all(12.0),
            child: Image.asset(suffixIcon, width: 22, height: 22))
            : null,
        // suffixIcon: suffixIcon,
      ),
    );
  }

}


class BottomLineDigitOnlyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType inputType;
  final TextInputAction inputAction;

  final int maxLength;
  final void Function(String)? onChanged;

  const BottomLineDigitOnlyTextField({
    required this.controller,
    required this.hintText,
    this.inputType = TextInputType.text,
    this.inputAction = TextInputAction.next,
    this.maxLength = TextField.noMaxLength,
    this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      cursorColor: black,
      controller: controller,
      maxLength: maxLength,
      keyboardType: inputType,
      textInputAction: inputAction,
      style: getTextFieldStyle(),
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: getTextFieldHintStyle(),
        counterText: "",
        contentPadding: const EdgeInsets.only(left: 12,right: 12),
        border: const OutlineInputBorder(
            borderSide: BorderSide(width: 0.8, style: BorderStyle.solid, color: grayNew)),
        focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(width: 0.8, style: BorderStyle.solid, color: grayNew)),
        errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(width: 0.8, color: grayNew)),
        focusedErrorBorder: const OutlineInputBorder(
            borderSide: BorderSide(width: 0.8, color: grayNew)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(kEditTextCornerRadius),
            borderSide: const BorderSide(width: 0.8, style: BorderStyle.solid, color: grayNew)),
      ),
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
    );
  }
}

