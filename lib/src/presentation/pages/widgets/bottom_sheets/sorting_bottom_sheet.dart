import 'package:flutter/material.dart';
import 'package:suggest_a_feature/src/presentation/pages/suggestions/suggestions_state.dart';
import 'package:suggest_a_feature/src/presentation/pages/widgets/bottom_sheets/base_bottom_sheet.dart';
import 'package:suggest_a_feature/src/presentation/pages/widgets/clickable_list_item.dart';
import 'package:suggest_a_feature/src/presentation/pages/widgets/suggestions_radio_button.dart';
import 'package:suggest_a_feature/src/presentation/utils/context_utils.dart';
import 'package:suggest_a_feature/src/presentation/utils/dimensions.dart';
import 'package:suggest_a_feature/src/presentation/utils/font_sizes.dart';
import 'package:suggest_a_feature/suggest_a_feature.dart';
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
      backgroundColor: theme.bottomSheetBackgroundColor,
      previousNavBarColor: theme.primaryBackgroundColor,
      previousStatusBarColor: theme.primaryBackgroundColor,
      title: context.localization.sortBy,
      contentBuilder: (context, _) {
        final textStyle = theme.textMedium.copyWith(
          fontWeight: FontSizes.weightBold,
        );
        return Column(
          children: [
            ClickableListItem(
              title: Text(context.localization.numberOfLikes, style: textStyle),
              onClick: () => widget.onChanged(SortType.likes),
              trailing: SuggestionsRadioButton(
                selected: widget.value == SortType.likes,
              ),
              verticalPadding: Dimensions.marginMiddle,
            ),
            ClickableListItem(
              title: Text(context.localization.creationDate, style: textStyle),
              onClick: () => widget.onChanged(SortType.date),
              trailing: SuggestionsRadioButton(
                selected: widget.value == SortType.date,
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
