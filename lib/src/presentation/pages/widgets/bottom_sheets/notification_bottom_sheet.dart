import 'package:flutter/material.dart';
import 'package:sliding_sheet/sliding_sheet.dart';

import '../../../utils/dimensions.dart';
import '../../../utils/context_utils.dart';
import '../../theme/suggestions_theme.dart';
import '../switch.dart';
import 'base_bottom_sheet.dart';

class NotificationSuggestionBottomSheet extends StatefulWidget {
  final VoidCallback onCancel;
  final Function(bool) onChangeNotification;
  final SheetController controller;
  final bool isNotificationOn;

  const NotificationSuggestionBottomSheet({
    required this.onCancel,
    required this.onChangeNotification,
    required this.controller,
    required this.isNotificationOn,
  });

  @override
  _NotificationSuggestionBottomSheetState createState() =>
      _NotificationSuggestionBottomSheetState();
}

class _NotificationSuggestionBottomSheetState extends State<NotificationSuggestionBottomSheet> {
  late bool _isNotificationOn;

  @override
  void initState() {
    _isNotificationOn = widget.isNotificationOn;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseBottomSheet(
      controller: widget.controller,
      onClose: ([_]) => widget.onCancel(),
      backgroundColor: theme.bottomSheetBackgroundColor,
      previousNavBarColor: theme.primaryBackgroundColor,
      previousStatusBarColor: theme.primaryBackgroundColor,
      contentBuilder: (context, sheetState) {
        return ListView(
          padding: const EdgeInsets.symmetric(
            vertical: Dimensions.marginSmall,
            horizontal: Dimensions.marginDefault,
          ),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.localization.notifyMe,
                        textAlign: TextAlign.start,
                        style: theme.textMPlus,
                      ),
                      const SizedBox(height: Dimensions.marginMicro),
                      Text(
                        context.localization.notificationDescription,
                        textAlign: TextAlign.start,
                        style: TextStyle(color: theme.secondaryTextColor),
                      ),
                    ],
                  ),
                ),
                SuggestionsSwitch(
                  value: _isNotificationOn,
                  onChanged: (value) {
                    setState(() => _isNotificationOn = value);
                    widget.onChangeNotification(value);
                  },
                ),
              ],
            ),
            const SizedBox(height: Dimensions.margin2x),
          ],
        );
      },
    );
  }
}
