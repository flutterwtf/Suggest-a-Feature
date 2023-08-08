import 'package:flutter/material.dart';
import 'package:suggest_a_feature/src/presentation/localization/localization_extensions.dart';
import 'package:suggest_a_feature/src/presentation/utils/dimensions.dart';
import 'package:suggest_a_feature/src/presentation/utils/platform_check.dart';

class BottomSheetActions extends StatelessWidget {
  final VoidCallback? onCancel;
  final VoidCallback onDone;
  final bool isDoneActive;
  final bool hasLeftButton;

  const BottomSheetActions({
    required this.onDone,
    this.onCancel,
    this.isDoneActive = true,
    this.hasLeftButton = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: Dimensions.marginBig,
        right: Dimensions.marginBig,
        top: Dimensions.marginSmall,
        bottom: SuggestionsPlatform.isIOS
            ? Dimensions.marginBig
            : Dimensions.marginSmall,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          if (hasLeftButton)
            TextButton(
              onPressed: onCancel ?? () {},
              child: Text(localization.cancel),
            ),
          const SizedBox(width: Dimensions.marginMicro),
          FilledButton(
            onPressed: isDoneActive ? onDone : null,
            child: Text(localization.done),
          ),
        ],
      ),
    );
  }
}
