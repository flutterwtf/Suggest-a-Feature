import 'package:flutter/material.dart';
import 'package:wtf_sliding_sheet/wtf_sliding_sheet.dart';

import '../../../../domain/entities/suggestion.dart';
import '../../../utils/context_utils.dart';
import '../../../utils/dimensions.dart';
import '../../../utils/status_utils.dart';
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
      title: context.localization.status,
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
                  _StatusesList(
                    onStatusTap: (status) {
                      setState(() {
                        if (selectedStatus != status) {
                          selectedStatus = status;
                        }
                      });
                    },
                    selectedStatus: selectedStatus,
                  ),
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
}

class _StatusesList extends StatelessWidget {
  final ValueChanged<SuggestionStatus> onStatusTap;
  final SuggestionStatus selectedStatus;

  const _StatusesList({
    required this.onStatusTap,
    required this.selectedStatus,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimensions.marginDefault,
        vertical: Dimensions.marginBig,
      ),
      child: Column(
        children: <Widget>[
          _StatusItem(
            status: SuggestionStatus.requests,
            onTap: onStatusTap,
            selectedStatus: selectedStatus,
          ),
          const SizedBox(height: Dimensions.marginMiddle),
          _StatusItem(
            status: SuggestionStatus.inProgress,
            onTap: onStatusTap,
            selectedStatus: selectedStatus,
          ),
          const SizedBox(height: Dimensions.marginMiddle),
          _StatusItem(
            status: SuggestionStatus.duplicate,
            onTap: onStatusTap,
            selectedStatus: selectedStatus,
          ),
          const SizedBox(height: Dimensions.marginMiddle),
          _StatusItem(
            status: SuggestionStatus.completed,
            onTap: onStatusTap,
            selectedStatus: selectedStatus,
          ),
          const SizedBox(height: Dimensions.marginMiddle),
          _StatusItem(
            status: SuggestionStatus.cancelled,
            onTap: onStatusTap,
            selectedStatus: selectedStatus,
          ),
        ],
      ),
    );
  }
}

class _StatusItem extends StatelessWidget {
  final SuggestionStatus status;
  final SuggestionStatus selectedStatus;
  final ValueChanged<SuggestionStatus> onTap;

  const _StatusItem({
    required this.status,
    required this.selectedStatus,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          status.statusName(context),
          style: theme.textSmallPlusSecondaryBold,
        ),
        GestureDetector(
          onTap: () => onTap(status),
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
