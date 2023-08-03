import 'package:flutter/material.dart';
import 'package:suggest_a_feature/src/presentation/localization/localization_extensions.dart';
import 'package:suggest_a_feature/src/presentation/pages/theme/suggestions_theme.dart';
import 'package:suggest_a_feature/src/presentation/pages/widgets/bottom_sheets/base_bottom_sheet.dart';
import 'package:suggest_a_feature/src/presentation/pages/widgets/suggestions_switch.dart';
import 'package:suggest_a_feature/src/presentation/utils/dimensions.dart';
import 'package:wtf_sliding_sheet/wtf_sliding_sheet.dart';

class NotificationSuggestionBottomSheet extends StatefulWidget {
  final VoidCallback onCancel;
  final ValueChanged<bool> onChangeNotification;
  final SheetController controller;
  final bool isNotificationOn;

  const NotificationSuggestionBottomSheet({
    required this.onCancel,
    required this.onChangeNotification,
    required this.controller,
    required this.isNotificationOn,
    super.key,
  });

  @override
  State<NotificationSuggestionBottomSheet> createState() =>
      _NotificationSuggestionBottomSheetState();
}

class _NotificationSuggestionBottomSheetState
    extends State<NotificationSuggestionBottomSheet> {
  late bool _isNotificationOn;

  @override
  void initState() {
    super.initState();
    _isNotificationOn = widget.isNotificationOn;
  }

  @override
  Widget build(BuildContext context) {
    return BaseBottomSheet(
      controller: widget.controller,
      onClose: ([_]) => widget.onCancel(),
      backgroundColor: theme.bottomSheetBackgroundColor,
      previousNavBarColor: theme.primaryBackgroundColor,
      previousStatusBarColor: theme.primaryBackgroundColor,
      contentBuilder: (BuildContext context, SheetState sheetState) {
        return ListView(
          padding: const EdgeInsets.symmetric(
            vertical: Dimensions.marginSmall,
            horizontal: Dimensions.marginDefault,
          ),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          children: <Widget>[
            _NotificationSwitch(
              isNotificationOn: _isNotificationOn,
              onChanged: (value) {
                setState(() => _isNotificationOn = value);
                widget.onChangeNotification(value);
              },
            ),
            const SizedBox(height: Dimensions.margin2x),
          ],
        );
      },
    );
  }
}

class _NotificationSwitch extends StatelessWidget {
  final bool isNotificationOn;
  final ValueChanged<bool> onChanged;

  const _NotificationSwitch({
    required this.isNotificationOn,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                localization.notifyMe,
                textAlign: TextAlign.start,
                style: theme.textMedium,
              ),
              const SizedBox(height: Dimensions.marginMicro),
              Text(
                localization.notificationDescription,
                textAlign: TextAlign.start,
                style: TextStyle(color: theme.secondaryTextColor),
              ),
            ],
          ),
        ),
        SuggestionsSwitch(
          value: isNotificationOn,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
