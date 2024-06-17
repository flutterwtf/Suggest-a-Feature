import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
                border: isShowError
                    ? Border.all(color: context.theme.colorScheme.error)
                    : null,
                color: context.theme.colorScheme.surface,
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
      cursorColor: context.theme.colorScheme.onSurface,
      style: context.theme.textTheme.bodyMedium,
      autofocus: autofocus,
      maxLines: null,
      textAlign: textAlign,
      cursorHeight: 20,
      textInputAction: textInputAction,
      decoration: InputDecoration(
        isDense: true,
        hintText: hintText,
        hintStyle: context.theme.textTheme.bodyMedium?.copyWith(
          color: context.theme.colorScheme.onSurface.withOpacity(0.7),
        ),
        fillColor: context.theme.colorScheme.surface,
        filled: true,
        contentPadding: padding,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(Dimensions.smallCircularRadius),
          ),
          borderSide: BorderSide.none,
        ),
        focusedBorder: focusNode != null
            ? OutlineInputBorder(
                borderRadius: const BorderRadius.all(
                  Radius.circular(Dimensions.smallCircularRadius),
                ),
                borderSide:
                    BorderSide(color: context.theme.colorScheme.primary),
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
      cursorColor: context.theme.colorScheme.onSurface,
      style: context.theme.textTheme.bodyMedium,
      autofocus: autofocus,
      maxLines: null,
      textAlign: textAlign,
      textInputAction: textInputAction,
      placeholder: hintText,
      placeholderStyle: context.theme.textTheme.bodyMedium?.copyWith(
        color: context.theme.colorScheme.onSurface.withOpacity(0.7),
      ),
      cursorHeight: 20,
      decoration: BoxDecoration(
        color: context.theme.colorScheme.surface,
        borderRadius: const BorderRadius.all(
          Radius.circular(Dimensions.smallCircularRadius),
        ),
        border: Border.all(
          color: (focusNode?.hasFocus ?? false)
              ? context.theme.colorScheme.primary
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
