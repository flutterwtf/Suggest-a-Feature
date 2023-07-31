import 'package:flutter/material.dart';
import 'package:suggest_a_feature/src/presentation/pages/suggestions/suggestions_state.dart';
import 'package:suggest_a_feature/src/presentation/pages/widgets/bottom_sheets/base_bottom_sheet.dart';
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
        return Column(
          children: [
            _SortRow(
              title: context.localization.numberOfLikes,
              value: SortType.likes,
              selected: widget.value == SortType.likes,
              onChanged: widget.onChanged,
            ),
            const SizedBox(height: Dimensions.marginSmall),
            _SortRow(
              title: context.localization.creationDate,
              value: SortType.date,
              onChanged: widget.onChanged,
              selected: widget.value == SortType.date,
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

class _SortRow extends StatelessWidget {
  final String title;
  final SortType value;
  final ValueChanged<SortType> onChanged;
  final bool selected;

  const _SortRow({
    required this.title,
    required this.value,
    required this.onChanged,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: Dimensions.marginSmall,
        horizontal: Dimensions.marginDefault,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: theme.textMedium.copyWith(fontWeight: FontSizes.weightBold),
          ),
          SuggestionsRadioButton(
            selected: selected,
            onTap: () => onChanged(value),
          ),
        ],
      ),
    );
  }
}
