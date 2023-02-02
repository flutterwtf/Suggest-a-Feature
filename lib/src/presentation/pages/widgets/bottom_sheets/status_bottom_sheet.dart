import 'package:flutter/material.dart';
import 'package:sliding_sheet/sliding_sheet.dart';
import 'package:suggest_a_feature/src/presentation/utils/status_utils.dart';

import '../../../../domain/entities/suggestion.dart';
import '../../../utils/context_utils.dart';
import '../../../utils/dimensions.dart';
import '../../theme/suggestions_theme.dart';
import 'base_bottom_sheet.dart';
import 'bottom_sheet_actions.dart';

class StatusBottomSheet extends StatefulWidget {
  final VoidCallback onCancel;
  final SheetController controller;
  final ValueChanged<SuggestionStatus> onDone;
  final SuggestionStatus selectedStatus;

  const StatusBottomSheet({
    Key? key,
    required this.onCancel,
    required this.onDone,
    required this.controller,
    required this.selectedStatus,
  }) : super(key: key);

  @override
  _StatusBottomSheetState createState() => _StatusBottomSheetState();
}

class _StatusBottomSheetState extends State<StatusBottomSheet> {
  late SuggestionStatus selectedStatus;

  @override
  void initState() {
    selectedStatus = widget.selectedStatus;
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
                  _statusesList(),
                ],
              ),
            ),
            BottomSheetActions(
              onCancel: widget.onCancel,
              onDone: () => widget.onDone(selectedStatus),
            ),
          ],
        );
      },
    );
  }

  Widget _statusesList() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimensions.marginDefault,
        vertical: Dimensions.marginBig,
      ),
      child: Column(
        children: <Widget>[
          _statusItem(SuggestionStatus.requests),
          const SizedBox(height: Dimensions.marginMiddle),
          _statusItem(SuggestionStatus.inProgress),
          const SizedBox(height: Dimensions.marginMiddle),
          _statusItem(SuggestionStatus.duplicate),
          const SizedBox(height: Dimensions.marginMiddle),
          _statusItem(SuggestionStatus.completed),
          const SizedBox(height: Dimensions.marginMiddle),
          _statusItem(SuggestionStatus.cancelled),
        ],
      ),
    );
  }

  Widget _statusItem(SuggestionStatus status) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          status.statusName(context),
          style: theme.textSmallPlusSecondaryBold,
        ),
        GestureDetector(
          onTap: () => setState(() {
            if (selectedStatus != status) {
              selectedStatus = status;
            }
          }),
          child: SizedBox(
            height: Dimensions.defaultSize,
            width: Dimensions.defaultSize,
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(
                  color: theme.primaryIconColor,
                  width: 0.5,
                ),
                color: selectedStatus == status
                    ? theme.primaryIconColor
                    : theme.thirdBackgroundColor,
                shape: BoxShape.circle,
              ),
              child: selectedStatus == status
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
