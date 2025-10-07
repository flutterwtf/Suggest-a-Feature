import 'package:flutter/material.dart';
import 'package:suggest_a_feature/src/presentation/localization/localization_extensions.dart';
import 'package:suggest_a_feature/src/presentation/pages/theme/theme_extension.dart';
import 'package:suggest_a_feature/src/presentation/pages/widgets/bottom_sheets/base_bottom_sheet.dart';
import 'package:suggest_a_feature/src/presentation/pages/widgets/clickable_list_item.dart';
import 'package:suggest_a_feature/src/presentation/pages/widgets/suggestions_icon.dart';
import 'package:suggest_a_feature/src/presentation/utils/assets_strings.dart';
import 'package:suggest_a_feature/src/presentation/utils/date_utils.dart';
import 'package:suggest_a_feature/src/presentation/utils/dimensions.dart';
import 'package:wtf_sliding_sheet/wtf_sliding_sheet.dart';

class EditDeleteSuggestionBottomSheet extends StatefulWidget {
  final VoidCallback onCancel;
  final VoidCallback onEditClick;
  final VoidCallback onDeleteClick;
  final SheetController controller;
  final DateTime creationDate;

  const EditDeleteSuggestionBottomSheet({
    required this.onCancel,
    required this.onEditClick,
    required this.onDeleteClick,
    required this.controller,
    required this.creationDate,
    super.key,
  });

  @override
  State<EditDeleteSuggestionBottomSheet> createState() =>
      _EditDeleteSuggestionBottomSheetState();
}

class _EditDeleteSuggestionBottomSheetState
    extends State<EditDeleteSuggestionBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return BaseBottomSheet(
      controller: widget.controller,
      onClose: ([_]) => widget.onCancel(),
      backgroundColor: context.theme.bottomSheetTheme.backgroundColor ??
          context.theme.colorScheme.surface,
      previousNavBarColor: context.theme.colorScheme.surface,
      previousStatusBarColor: context.theme.colorScheme.surface,
      contentBuilder: (context, _) {
        return ListView(
          padding: const EdgeInsets.only(
            top: Dimensions.marginDefault,
            bottom: Dimensions.marginBig,
          ),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          children: <Widget>[
            Column(
              children: <Widget>[
                _LeadingText(
                  text: widget.creationDate
                      .formatEditSuggestion(localization.locale),
                ),
                const SizedBox(height: Dimensions.marginDefault),
                _EditItem(onEditClick: widget.onEditClick),
                const SizedBox(height: Dimensions.marginSmall),
                _DeleteItem(onDeleteClick: widget.onDeleteClick),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _LeadingText extends StatelessWidget {
  final String text;

  const _LeadingText({
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: context.theme.textTheme.titleMedium,
    );
  }
}

class _EditItem extends StatelessWidget {
  final VoidCallback onEditClick;

  const _EditItem({
    required this.onEditClick,
  });

  @override
  Widget build(BuildContext context) {
    return ClickableListItem(
      title: Text(
        localization.edit,
        style: context.theme.textTheme.titleMedium,
      ),
      leading: SuggestionsIcon(
        AssetStrings.penIconImage,
        size: Dimensions.defaultSize,
        color: context.theme.colorScheme.onSurface,
      ),
      onClick: onEditClick,
    );
  }
}

class _DeleteItem extends StatelessWidget {
  final VoidCallback onDeleteClick;

  const _DeleteItem({
    required this.onDeleteClick,
  });

  @override
  Widget build(BuildContext context) {
    return ClickableListItem(
      title: Text(
        localization.delete,
        style: context.theme.textTheme.titleMedium?.copyWith(
          color: context.theme.colorScheme.error,
        ),
      ),
      leading: SuggestionsIcon(
        AssetStrings.deleteIconImage,
        size: Dimensions.defaultSize,
        color: context.theme.colorScheme.error,
      ),
      onClick: onDeleteClick,
    );
  }
}
