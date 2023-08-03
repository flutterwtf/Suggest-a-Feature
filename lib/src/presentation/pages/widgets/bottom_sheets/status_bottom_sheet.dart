import 'package:flutter/material.dart';
import 'package:suggest_a_feature/src/domain/entities/suggestion.dart';
import 'package:suggest_a_feature/src/presentation/pages/theme/theme_extension.dart';
import 'package:suggest_a_feature/src/presentation/pages/widgets/bottom_sheets/base_bottom_sheet.dart';
import 'package:suggest_a_feature/src/presentation/pages/widgets/bottom_sheets/bottom_sheet_actions.dart';
import 'package:suggest_a_feature/src/presentation/pages/widgets/clickable_list_item.dart';
import 'package:suggest_a_feature/src/presentation/pages/widgets/suggestions_radio_button.dart';
import 'package:suggest_a_feature/src/presentation/utils/context_utils.dart';
import 'package:suggest_a_feature/src/presentation/utils/dimensions.dart';
import 'package:suggest_a_feature/src/presentation/utils/status_utils.dart';
import 'package:wtf_sliding_sheet/wtf_sliding_sheet.dart';

class StatusBottomSheet extends StatefulWidget {
  final VoidCallback onCancel;
  final SheetController controller;
  final ValueChanged<SuggestionStatus> onDone;
  final SuggestionStatus selectedStatus;

  const StatusBottomSheet({
    required this.onCancel,
    required this.onDone,
    required this.controller,
    required this.selectedStatus,
    super.key,
  });

  @override
  State<StatusBottomSheet> createState() => _StatusBottomSheetState();
}

class _StatusBottomSheetState extends State<StatusBottomSheet> {
  late SuggestionStatus selectedStatus;

  @override
  void initState() {
    super.initState();
    selectedStatus = widget.selectedStatus;
  }

  @override
  Widget build(BuildContext context) {
    return BaseBottomSheet(
      title: context.localization.status,
      titleBottomPadding: 0,
      controller: widget.controller,
      previousNavBarColor: context.theme.bottomSheetTheme.backgroundColor ??
          context.theme.colorScheme.background,
      previousStatusBarColor: context.theme.colorScheme.surface,
      onClose: ([ClosureType? closureType]) async {
        if (closureType == ClosureType.backButton) {
          widget.onCancel();
        } else {
          await widget.controller.collapse();
          widget.onCancel();
        }
      },
      backgroundColor: context.theme.bottomSheetTheme.backgroundColor ??
          context.theme.colorScheme.background,
      contentBuilder: (BuildContext context, SheetState sheetState) {
        return ListView(
          padding: const EdgeInsets.only(bottom: Dimensions.marginMiddle),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          children: <Widget>[
            _Statuses(
              onStatusTap: (status) {
                if (selectedStatus != status) {
                  setState(() => selectedStatus = status);
                }
              },
              selectedStatus: selectedStatus,
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

class _Statuses extends StatelessWidget {
  final ValueChanged<SuggestionStatus> onStatusTap;
  final SuggestionStatus selectedStatus;

  const _Statuses({
    required this.onStatusTap,
    required this.selectedStatus,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: context.theme.dividerColor,
            width: 0.5,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _StatusesList(
            onStatusTap: onStatusTap,
            selectedStatus: selectedStatus,
          ),
        ],
      ),
    );
  }
}

class _StatusesList extends StatelessWidget {
  final ValueChanged<SuggestionStatus> onStatusTap;
  final SuggestionStatus selectedStatus;

  const _StatusesList({
    required this.onStatusTap,
    required this.selectedStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 18,
      ),
      child: Column(
        children: <Widget>[
          _StatusItem(
            status: SuggestionStatus.requests,
            onTap: onStatusTap,
            selectedStatus: selectedStatus,
          ),
          _StatusItem(
            status: SuggestionStatus.inProgress,
            onTap: onStatusTap,
            selectedStatus: selectedStatus,
          ),
          _StatusItem(
            status: SuggestionStatus.completed,
            onTap: onStatusTap,
            selectedStatus: selectedStatus,
          ),
          _StatusItem(
            status: SuggestionStatus.declined,
            onTap: onStatusTap,
            selectedStatus: selectedStatus,
          ),
          _StatusItem(
            status: SuggestionStatus.duplicated,
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
  });

  @override
  Widget build(BuildContext context) {
    return ClickableListItem(
      title: Text(
        status.statusName(context),
        style: context.theme.textTheme.labelLarge
            ?.copyWith(color: context.theme.colorScheme.onSurfaceVariant),
      ),
      trailing: SuggestionsRadioButton(selected: selectedStatus == status),
      onClick: () => onTap(status),
      verticalPadding: 6,
    );
  }
}
