import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../utils/dimensions.dart';
import '../../utils/platform_check.dart';
import '../theme/suggestions_theme.dart';

class SuggestionsTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Function(String)? onChanged;
  final EdgeInsetsGeometry padding;
  final bool autofocus;
  final bool isShowError;
  final Brightness? keyboardAppearance;
  final FocusNode? focusNode;
  final TextAlign textAlign;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;

  const SuggestionsTextField({
    Key? key,
    required this.controller,
    this.hintText = '',
    this.onChanged,
    this.focusNode,
    this.keyboardAppearance,
    this.padding = EdgeInsets.zero,
    this.autofocus = false,
    this.isShowError = false,
    this.textAlign = TextAlign.start,
    this.textInputAction,
    this.inputFormatters,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.marginDefault),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: isShowError ? Border.all(color: theme.errorColor) : null,
                color: theme.primaryBackgroundColor,
                borderRadius: BorderRadius.circular(Dimensions.smallCircularRadius),
              ),
              child: SuggestionsPlatform.isIOS ? _iosTextField() : _androidTextField(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _androidTextField() {
    return TextField(
      focusNode: focusNode,
      keyboardAppearance: keyboardAppearance,
      controller: controller,
      cursorColor: theme.primaryTextColor,
      style: theme.textSmallPlus,
      autofocus: autofocus,
      maxLines: null,
      textAlign: textAlign,
      cursorHeight: 20,
      textInputAction: textInputAction,
      decoration: InputDecoration(
        isDense: true,
        hintText: hintText,
        hintStyle: theme.textSmallPlus.copyWith(color: theme.primaryTextColor.withOpacity(0.7)),
        fillColor: Colors.transparent,
        contentPadding: padding,
        border: InputBorder.none,
        focusedBorder: focusNode != null
            ? OutlineInputBorder(
                borderRadius: const BorderRadius.all(
                  Radius.circular(Dimensions.smallCircularRadius),
                ),
                borderSide: BorderSide(color: theme.focusedTextFieldBorderlineColor),
              )
            : null,
      ),
      textCapitalization: TextCapitalization.sentences,
      onChanged: (String text) => onChanged?.call(text),
      inputFormatters: inputFormatters,
    );
  }

  Widget _iosTextField() {
    return CupertinoTextField(
      controller: controller,
      focusNode: focusNode,
      keyboardAppearance: keyboardAppearance,
      cursorColor: theme.primaryTextColor,
      style: theme.textSmallPlus,
      autofocus: autofocus,
      maxLines: null,
      textAlign: textAlign,
      textInputAction: textInputAction,
      placeholder: hintText,
      placeholderStyle: theme.textSmallPlus.copyWith(
        color: theme.primaryTextColor.withOpacity(0.7),
      ),
      cursorHeight: 20,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: const BorderRadius.all(
          Radius.circular(Dimensions.smallCircularRadius),
        ),
        border: Border.all(
          color: (focusNode?.hasFocus ?? false)
              ? theme.focusedTextFieldBorderlineColor
              : Colors.transparent,
        ),
      ),
      padding: padding,
      textCapitalization: TextCapitalization.sentences,
      onChanged: (String text) => onChanged?.call(text),
    );
  }
}
