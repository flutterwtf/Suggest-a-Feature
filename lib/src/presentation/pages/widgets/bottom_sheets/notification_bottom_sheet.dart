import 'package:flutter/material.dart';
import 'package:sliding_sheet/sliding_sheet.dart';

import '../../../utils/context_utils.dart';
import '../../../utils/dimensions.dart';
import '../../theme/suggestions_theme.dart';
import '../switch.dart';
import 'base_bottom_sheet.dart';

class NotificationSuggestionBottomSheet extends StatefulWidget {
  final VoidCallback onCancel;
  final Function(bool) onChangeNotification;
  final SheetController controller;
  final bool isNotificationOn;

  const NotificationSuggestionBottomSheet({
    Key? key,
    required this.onCancel,
    required this.onChangeNotification,
    required this.controller,
    required this.isNotificationOn,
  }) : super(key: key);

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
      contentBuilder: (BuildContext context, SheetState sheetState) {
        return ListView(
          padding: const EdgeInsets.symmetric(
            vertical: Dimensions.marginSmall,
            horizontal: Dimensions.marginDefault,
          ),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        context.localization.notifyMe,
                        textAlign: TextAlign.start,
                        style: theme.textMedium,
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
                  onChanged: (bool value) {
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
