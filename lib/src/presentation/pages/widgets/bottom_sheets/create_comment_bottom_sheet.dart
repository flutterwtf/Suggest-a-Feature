import 'package:flutter/material.dart';
import 'package:sliding_sheet/sliding_sheet.dart';

import '../../../utils/context_utils.dart';
import '../../../utils/dimensions.dart';
import '../../theme/suggestions_theme.dart';
import '../clickable_list_item.dart';
import '../elevated_button.dart';
import '../switch.dart';
import '../text_field.dart';
import 'base_bottom_sheet.dart';

typedef OnCreateComment = void Function(String, bool);

class CreateCommentBottomSheet extends StatefulWidget {
  final Future<void> Function() onClose;
  final SheetController controller;
  final OnCreateComment onCreateComment;

  const CreateCommentBottomSheet({
    Key? key,
    required this.controller,
    required this.onClose,
    required this.onCreateComment,
  }) : super(key: key);

  @override
  _CreateCommentBottomSheetState createState() => _CreateCommentBottomSheetState();
}

class _CreateCommentBottomSheetState extends State<CreateCommentBottomSheet> {
  final TextEditingController _commentController = TextEditingController();
  bool _isAnonymously = false;
  bool _isShowCommentError = false;
  late FocusNode _inputFocusNode;

  @override
  void initState() {
    super.initState();
    _inputFocusNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    _inputFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseBottomSheet(
      controller: widget.controller,
      onOpen: () => _inputFocusNode.requestFocus(),
      onClose: ([_]) => widget.onClose(),
      backgroundColor: theme.bottomSheetBackgroundColor,
      previousNavBarColor: theme.primaryBackgroundColor,
      previousStatusBarColor: theme.primaryBackgroundColor,
      contentBuilder: (BuildContext context, SheetState sheetState) {
        return ListView(
          padding: const EdgeInsets.only(
            top: Dimensions.marginSmall,
            bottom: Dimensions.marginBig,
          ),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          children: <Widget>[
            _commentTextField(context),
            const SizedBox(height: Dimensions.marginBig),
            Divider(color: theme.dividerColor, thickness: 0.5, height: 1.5),
            const SizedBox(height: Dimensions.marginSmall),
            _postAnonymously(),
            const SizedBox(height: Dimensions.marginSmall),
            _createCommentButton(),
          ],
        );
      },
    );
  }

  Widget _commentTextField(BuildContext context) {
    return Focus(
      onFocusChange: (bool hasFocus) {
        if (!hasFocus && _commentController.text.isEmpty) {
          setState(() => _isShowCommentError = true);
        } else {
          setState(() => _isShowCommentError = false);
        }
      },
      child: SuggestionsTextField(
        focusNode: _inputFocusNode,
        controller: _commentController,
        hintText: context.localization.commentHint,
        isShowError: _isShowCommentError,
        padding: const EdgeInsets.fromLTRB(
          Dimensions.marginDefault,
          Dimensions.marginDefault,
          Dimensions.marginSmall,
          Dimensions.marginDefault,
        ),
      ),
    );
  }

  Widget _postAnonymously() {
    return ClickableListItem(
      title: Text(
        context.localization.postAnonymously,
        style: theme.textSmallPlusSecondaryBold,
      ),
      trailing: SuggestionsSwitch(
        value: _isAnonymously,
        onChanged: (bool value) => setState(() => _isAnonymously = value),
      ),
    );
  }

  Widget _createCommentButton() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.marginDefault),
        child: SuggestionsElevatedButton(
          onClick: () async {
            if (_commentController.text.isNotEmpty) {
              await widget.onClose();
              widget.onCreateComment(_commentController.text, _isAnonymously);
            } else {
              return;
            }
          },
          buttonText: context.localization.publish,
        ),
      ),
    );
  }
}
