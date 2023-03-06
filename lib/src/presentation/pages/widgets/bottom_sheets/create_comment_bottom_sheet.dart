import 'package:flutter/material.dart';
import 'package:sliding_sheet/sliding_sheet.dart';

import '../../../di/injector.dart';
import '../../../utils/context_utils.dart';
import '../../../utils/dimensions.dart';
import '../../theme/suggestions_theme.dart';
import '../clickable_list_item.dart';
import '../suggestions_elevated_button.dart';
import '../suggestions_switch.dart';
import '../suggestions_text_field.dart';
import 'base_bottom_sheet.dart';

typedef OnCreateComment = void Function(String, bool, bool);

class CreateCommentBottomSheet extends StatefulWidget {
  final Future<void> Function() onClose;
  final SheetController controller;
  final OnCreateComment onCreateComment;

  const CreateCommentBottomSheet({
    required this.controller,
    required this.onClose,
    required this.onCreateComment,
    super.key,
  });

  @override
  _CreateCommentBottomSheetState createState() =>
      _CreateCommentBottomSheetState();
}

class _CreateCommentBottomSheetState extends State<CreateCommentBottomSheet> {
  final TextEditingController _commentController = TextEditingController();
  bool _isAnonymously = false;
  bool _isFromAdmin = true;
  bool _isShowCommentError = false;
  late FocusNode _inputFocusNode;

  @override
  void initState() {
    super.initState();
    _inputFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _inputFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseBottomSheet(
      controller: widget.controller,
      onOpen: _inputFocusNode.requestFocus,
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
            _CommentTextField(
              commentController: _commentController,
              inputFocusNode: _inputFocusNode,
              isShowCommentError: _isShowCommentError,
              onFocusChanged: (bool hasFocus) {
                if (!hasFocus && _commentController.text.isEmpty) {
                  setState(() => _isShowCommentError = true);
                } else {
                  setState(() => _isShowCommentError = false);
                }
              },
            ),
            const SizedBox(height: Dimensions.marginBig),
            if (i.adminSettings == null) ...<Widget>[
              Divider(color: theme.dividerColor, thickness: 0.5, height: 1.5),
              const SizedBox(height: Dimensions.marginSmall),
              _PostAnonymously(
                isAnonymously: _isAnonymously,
                onChanged: (bool value) =>
                    setState(() => _isAnonymously = value),
              ),
              const SizedBox(height: Dimensions.marginSmall),
            ],
            if (i.adminSettings != null) ...<Widget>[
              Divider(color: theme.dividerColor, thickness: 0.5, height: 1.5),
              const SizedBox(height: Dimensions.marginSmall),
              _PostPostedBy(
                isFromAdmin: _isFromAdmin,
                onChanged: (bool value) => setState(() => _isFromAdmin = value),
              ),
              const SizedBox(height: Dimensions.marginSmall),
            ],
            _CreateCommentButton(
              onClick: () async {
                if (_commentController.text.isNotEmpty) {
                  await widget.onClose();
                  widget.onCreateComment(
                    _commentController.text,
                    _isAnonymously,
                    _isFromAdmin,
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }
}

class _CommentTextField extends StatelessWidget {
  final FocusNode inputFocusNode;
  final TextEditingController commentController;
  final bool isShowCommentError;
  final ValueChanged<bool> onFocusChanged;

  const _CommentTextField({
    required this.inputFocusNode,
    required this.commentController,
    required this.isShowCommentError,
    required this.onFocusChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: onFocusChanged,
      child: SuggestionsTextField(
        focusNode: inputFocusNode,
        controller: commentController,
        hintText: context.localization.commentHint,
        isShowError: isShowCommentError,
        padding: const EdgeInsets.fromLTRB(
          Dimensions.marginDefault,
          Dimensions.marginDefault,
          Dimensions.marginSmall,
          Dimensions.marginDefault,
        ),
      ),
    );
  }
}

class _PostAnonymously extends StatelessWidget {
  final bool isAnonymously;
  final ValueChanged<bool> onChanged;

  const _PostAnonymously({
    required this.onChanged,
    required this.isAnonymously,
  });

  @override
  Widget build(BuildContext context) {
    return ClickableListItem(
      title: Text(
        context.localization.postAnonymously,
        style: theme.textSmallPlusSecondaryBold,
      ),
      trailing: SuggestionsSwitch(
        value: isAnonymously,
        onChanged: onChanged,
      ),
    );
  }
}

class _PostPostedBy extends StatelessWidget {
  final bool isFromAdmin;
  final ValueChanged<bool> onChanged;

  const _PostPostedBy({
    required this.isFromAdmin,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ClickableListItem(
      title: Text(
        context.localization.postFromAdmin,
        style: theme.textSmallPlusSecondaryBold,
      ),
      trailing: SuggestionsSwitch(
        value: isFromAdmin,
        onChanged: onChanged,
      ),
    );
  }
}

class _CreateCommentButton extends StatelessWidget {
  final VoidCallback onClick;

  const _CreateCommentButton({
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Dimensions.marginDefault,
        ),
        child: SuggestionsElevatedButton(
          onClick: onClick,
          buttonText: context.localization.publish,
        ),
      ),
    );
  }
}
