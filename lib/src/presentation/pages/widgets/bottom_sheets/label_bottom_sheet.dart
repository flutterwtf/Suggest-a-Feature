import 'package:flutter/material.dart';
import 'package:sliding_sheet/sliding_sheet.dart';

import '../../../../domain/entities/suggestion.dart';
import '../../../utils/context_utils.dart';
import '../../../utils/dimensions.dart';
import '../../theme/suggestions_theme.dart';
import '../suggestions_labels.dart';
import 'base_bottom_sheet.dart';
import 'bottom_sheet_actions.dart';

class LabelBottomSheet extends StatefulWidget {
  final VoidCallback onCancel;
  final SheetController controller;
  final Function(List<SuggestionLabel>) onDone;
  final List<SuggestionLabel> selectedLabels;

  const LabelBottomSheet({
    Key? key,
    required this.onCancel,
    required this.onDone,
    required this.controller,
    required this.selectedLabels,
  }) : super(key: key);

  @override
  _LabelBottomSheetState createState() => _LabelBottomSheetState();
}

class _LabelBottomSheetState extends State<LabelBottomSheet> {
  final List<SuggestionLabel> selectedLabels = <SuggestionLabel>[];

  @override
  void initState() {
    selectedLabels.addAll(widget.selectedLabels);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseBottomSheet(
      title: context.localization.labels,
      titleBottomPadding: 0,
      controller: widget.controller,
      previousNavBarColor: theme.bottomSheetBackgroundColor,
      previousStatusBarColor: theme.thirdBackgroundColor,
      onClose: ([ClosureType? closureType]) async {
        if (closureType == ClosureType.backButton) {
          widget.onCancel();
        } else {
          await widget.controller.collapse();
          widget.onCancel();
        }
      },
      backgroundColor: theme.bottomSheetBackgroundColor,
      contentBuilder: (BuildContext context, SheetState sheetState) {
        return ListView(
          padding: const EdgeInsets.only(bottom: Dimensions.marginMiddle),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          children: <Widget>[
            DecoratedBox(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: theme.dividerColor,
                    width: 0.5,
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _labelsRow(context),
                ],
              ),
            ),
            BottomSheetActions(
              onCancel: widget.onCancel,
              onDone: () => widget.onDone(selectedLabels),
            ),
          ],
        );
      },
    );
  }

  Widget _labelsRow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimensions.marginDefault,
        vertical: Dimensions.marginBig,
      ),
      child: Column(
        children: <Widget>[
          _labelItem(SuggestionLabel.feature),
          const SizedBox(height: Dimensions.marginBig),
          _labelItem(SuggestionLabel.bug),
        ],
      ),
    );
  }

  Widget _labelItem(SuggestionLabel label) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        SuggestionLabels(labels: <SuggestionLabel>[label]),
        GestureDetector(
          onTap: () => setState(() {
            if (!selectedLabels.contains(label)) {
              selectedLabels.add(label);
            } else {
              selectedLabels.remove(label);
            }
          }),
          child: SizedBox(
            height: Dimensions.defaultSize,
            width: Dimensions.defaultSize,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: theme.primaryIconColor,
                  width: 0.5,
                ),
                color: selectedLabels.contains(label)
                    ? theme.primaryIconColor
                    : theme.thirdBackgroundColor,
                shape: BoxShape.circle,
              ),
              child: selectedLabels.contains(label)
                  ? Icon(
                      Icons.check,
                      size: Dimensions.smallSize,
                      color: theme.primaryBackgroundColor,
                    )
                  : null,
            ),
          ),
        ),
      ],
    );
  }
}
