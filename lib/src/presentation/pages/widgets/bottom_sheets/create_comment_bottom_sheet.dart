import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:suggest_a_feature/src/presentation/di/injector.dart';
import 'package:suggest_a_feature/src/presentation/pages/theme/theme_extension.dart';
import 'package:suggest_a_feature/src/presentation/pages/widgets/bottom_sheets/base_bottom_sheet.dart';
import 'package:suggest_a_feature/src/presentation/pages/widgets/clickable_list_item.dart';
import 'package:suggest_a_feature/src/presentation/pages/widgets/suggestions_switch.dart';
import 'package:suggest_a_feature/src/presentation/pages/widgets/suggestions_text_field.dart';
import 'package:suggest_a_feature/src/presentation/utils/context_utils.dart';
import 'package:suggest_a_feature/src/presentation/utils/dimensions.dart';
import 'package:wtf_sliding_sheet/wtf_sliding_sheet.dart';

typedef OnCreateComment = void Function(
  String text, {
  required bool isAnonymous,
  required bool postedByAdmin,
});

class CreateCommentBottomSheet extends StatefulWidget {
  final AsyncCallback onClose;
  final SheetController controller;
  final OnCreateComment onCreateComment;

  const CreateCommentBottomSheet({
    required this.controller,
    required this.onClose,
    required this.onCreateComment,
    super.key,
  });

  @override
  State<CreateCommentBottomSheet> createState() =>
      _CreateCommentBottomSheetState();
}

class _CreateCommentBottomSheetState extends State<CreateCommentBottomSheet> {
  late final TextEditingController _commentController;
  late final FocusNode _inputFocusNode;

  var _isAnonymously = false;
  var _isFromAdmin = true;
  var _isShowCommentError = false;

  @override
  void initState() {
    super.initState();
    _commentController = TextEditingController();
    _inputFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _commentController.dispose();
    _inputFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseBottomSheet(
      controller: widget.controller,
      onOpen: _inputFocusNode.requestFocus,
      onClose: ([_]) => widget.onClose(),
      backgroundColor: context.theme.bottomSheetTheme.backgroundColor ??
          context.theme.colorScheme.background,
      previousNavBarColor: context.theme.colorScheme.background,
      previousStatusBarColor: context.theme.colorScheme.background,
      contentBuilder: (_, __) {
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
              onFocusChanged: (hasFocus) => setState(
                () => !hasFocus && _commentController.text.isEmpty
                    ? _isShowCommentError = true
                    : _isShowCommentError = false,
              ),
            ),
            const SizedBox(height: Dimensions.marginBig),
            ..._postAdmin(
              isAnonymously: _isAnonymously,
              isFromAdmin: _isFromAdmin,
              onChangedAdmin: (value) => setState(
                () => _isFromAdmin = value,
              ),
              onChangedAnonymously: (value) =>
                  setState(() => _isAnonymously = value),
            ),
            _CreateCommentButton(
              onClick: () async {
                if (_commentController.text.isNotEmpty) {
                  await widget.onClose();
                  widget.onCreateComment(
                    _commentController.text,
                    isAnonymous: !i.isAdmin && _isAnonymously,
                    postedByAdmin: i.isAdmin && _isFromAdmin,
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

List<Widget> _postAdmin({
  required bool isAnonymously,
  required ValueChanged<bool> onChangedAdmin,
  required ValueChanged<bool> onChangedAnonymously,
  required bool isFromAdmin,
}) {
  if (!i.isAdmin) {
    return <Widget>[
      const Divider(thickness: 0.5, height: 1.5),
      const SizedBox(height: Dimensions.marginSmall),
      _PostAnonymously(
        isAnonymously: isAnonymously,
        onChanged: onChangedAnonymously,
      ),
      const SizedBox(height: Dimensions.marginSmall),
    ];
  }
  return <Widget>[
    const Divider(thickness: 0.5, height: 1.5),
    const SizedBox(height: Dimensions.marginSmall),
    _PostPostedBy(isFromAdmin: isFromAdmin, onChanged: onChangedAdmin),
    const SizedBox(height: Dimensions.marginSmall),
  ];
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
        style: context.theme.textTheme.labelLarge
            ?.copyWith(color: context.theme.colorScheme.onSurfaceVariant),
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
        style: context.theme.textTheme.labelLarge
            ?.copyWith(color: context.theme.colorScheme.onSurfaceVariant),
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
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimensions.marginDefault,
      ),
      child: FilledButton(
        onPressed: onClick,
        child: Text(context.localization.publish),
      ),
    );
  }
}
