import 'package:flutter/material.dart';
import 'package:suggest_a_feature/src/presentation/localization/localization_extensions.dart';
import 'package:suggest_a_feature/src/presentation/pages/theme/theme_extension.dart';
import 'package:suggest_a_feature/src/presentation/pages/widgets/bottom_sheets/base_bottom_sheet.dart';
import 'package:suggest_a_feature/src/presentation/pages/widgets/clickable_list_item.dart';
import 'package:suggest_a_feature/src/presentation/pages/widgets/suggestions_radio_button.dart';
import 'package:suggest_a_feature/src/presentation/utils/dimensions.dart';
import 'package:suggest_a_feature/src/presentation/utils/typedefs.dart';
import 'package:wtf_sliding_sheet/wtf_sliding_sheet.dart';

class SortingBottomSheet extends StatefulWidget {
  final VoidCallback closeBottomSheet;
  final ValueChanged<SortType> onChanged;
  final SortType value;

  const SortingBottomSheet({
    required this.closeBottomSheet,
    required this.value,
    required this.onChanged,
    super.key,
  });

  @override
  State<SortingBottomSheet> createState() => _SortingBottomSheetState();
}

class _SortingBottomSheetState extends State<SortingBottomSheet> {
  final SheetController _controller = SheetController();

  @override
  Widget build(BuildContext context) {
    return BaseBottomSheet(
      controller: _controller,
      onClose: ([_]) => _onClose(),
      backgroundColor: context.theme.bottomSheetTheme.backgroundColor ??
          context.theme.colorScheme.surface,
      previousNavBarColor: context.theme.colorScheme.surface,
      previousStatusBarColor: context.theme.colorScheme.surface,
      title: localization.sortBy,
      contentBuilder: (context, _) {
        final textStyle = context.theme.textTheme.titleMedium;
        return Column(
          children: [
            ClickableListItem(
              title: Text(localization.upvote, style: textStyle),
              onClick: () => widget.onChanged(SortType.upvotes),
              trailing: SuggestionsRadioButton(
                selected: widget.value == SortType.upvotes,
              ),
              verticalPadding: Dimensions.marginMiddle,
            ),
            ClickableListItem(
              title: Text(localization.creationDate, style: textStyle),
              onClick: () => widget.onChanged(SortType.creationDate),
              trailing: SuggestionsRadioButton(
                selected: widget.value == SortType.creationDate,
              ),
              verticalPadding: Dimensions.marginMiddle,
            ),
          ],
        );
      },
    );
  }

  Future<void> _onClose() async {
    await _controller.collapse();
    widget.closeBottomSheet();
  }
}
