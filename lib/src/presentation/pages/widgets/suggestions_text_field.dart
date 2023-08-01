import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:suggest_a_feature/src/presentation/pages/theme/suggestions_theme.dart';
import 'package:suggest_a_feature/src/presentation/pages/theme/theme_extension.dart';
import 'package:suggest_a_feature/src/presentation/utils/dimensions.dart';
import 'package:suggest_a_feature/src/presentation/utils/platform_check.dart';

class SuggestionsTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final EdgeInsetsGeometry padding;
  final bool autofocus;
  final bool isShowError;
  final Brightness? keyboardAppearance;
  final FocusNode? focusNode;
  final TextAlign textAlign;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;

  const SuggestionsTextField({
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
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimensions.marginDefault,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: DecoratedBox(
              decoration: BoxDecoration(
                border:
                    isShowError ? Border.all(color: theme.errorColor) : null,
                color: theme.primaryBackgroundColor,
                borderRadius: BorderRadius.circular(
                  Dimensions.smallCircularRadius,
                ),
              ),
              child: SuggestionsPlatform.isIOS
                  ? _IosTextField(
                      controller: controller,
                      hintText: hintText,
                      onChanged: onChanged,
                      padding: padding,
                      autofocus: autofocus,
                      keyboardAppearance: keyboardAppearance,
                      focusNode: focusNode,
                      textAlign: textAlign,
                      textInputAction: textInputAction,
                      inputFormatters: inputFormatters,
                    )
                  : _CommonTextField(
                      controller: controller,
                      hintText: hintText,
                      onChanged: onChanged,
                      padding: padding,
                      autofocus: autofocus,
                      keyboardAppearance: keyboardAppearance,
                      focusNode: focusNode,
                      textAlign: textAlign,
                      textInputAction: textInputAction,
                      inputFormatters: inputFormatters,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CommonTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final EdgeInsetsGeometry padding;
  final bool autofocus;
  final Brightness? keyboardAppearance;
  final FocusNode? focusNode;
  final TextAlign textAlign;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;

  const _CommonTextField({
    required this.controller,
    required this.hintText,
    required this.padding,
    required this.autofocus,
    required this.textAlign,
    this.onChanged,
    this.keyboardAppearance,
    this.focusNode,
    this.textInputAction,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: focusNode,
      keyboardAppearance: keyboardAppearance,
      controller: controller,
      cursorColor: theme.onPrimaryColor,
      style: context.themeData.textTheme.titleMedium,
      autofocus: autofocus,
      maxLines: null,
      textAlign: textAlign,
      cursorHeight: 20,
      textInputAction: textInputAction,
      decoration: InputDecoration(
        isDense: true,
        hintText: hintText,
        hintStyle: context.themeData.textTheme.titleMedium?.copyWith(
          color: theme.onPrimaryColor.withOpacity(0.7),
        ),
        fillColor: Colors.transparent,
        contentPadding: padding,
        border: InputBorder.none,
        focusedBorder: focusNode != null
            ? OutlineInputBorder(
                borderRadius: const BorderRadius.all(
                  Radius.circular(Dimensions.smallCircularRadius),
                ),
                borderSide: BorderSide(color: theme.accentColor),
              )
            : null,
      ),
      textCapitalization: TextCapitalization.sentences,
      onChanged: (text) {
        // Note: `onChanged: onChanged?.call` was not working on web release.
        onChanged?.call(text);
      },
      inputFormatters: inputFormatters,
    );
  }
}

class _IosTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final EdgeInsetsGeometry padding;
  final bool autofocus;
  final Brightness? keyboardAppearance;
  final FocusNode? focusNode;
  final TextAlign textAlign;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;

  const _IosTextField({
    required this.controller,
    required this.hintText,
    required this.padding,
    required this.autofocus,
    required this.textAlign,
    this.onChanged,
    this.keyboardAppearance,
    this.focusNode,
    this.textInputAction,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoTextField(
      controller: controller,
      focusNode: focusNode,
      keyboardAppearance: keyboardAppearance,
      cursorColor: theme.onPrimaryColor,
      style: context.themeData.textTheme.titleMedium,
      autofocus: autofocus,
      maxLines: null,
      textAlign: textAlign,
      textInputAction: textInputAction,
      placeholder: hintText,
      placeholderStyle: context.themeData.textTheme.titleMedium?.copyWith(
        color: theme.onPrimaryColor.withOpacity(0.7),
      ),
      cursorHeight: 20,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: const BorderRadius.all(
          Radius.circular(Dimensions.smallCircularRadius),
        ),
        border: Border.all(
          color: (focusNode?.hasFocus ?? false)
              ? theme.accentColor
              : Colors.transparent,
        ),
      ),
      padding: padding,
      textCapitalization: TextCapitalization.sentences,
      onChanged: onChanged?.call,
      inputFormatters: inputFormatters,
    );
  }
}
