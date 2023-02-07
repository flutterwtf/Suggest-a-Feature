import 'package:suggest_a_feature/src/domain/entities/suggestion_author.dart';

class AdminSettings extends SuggestionAuthor {
  const AdminSettings({
    required String id,
    required String username,
    String? avatar,
  }) : super(
          id: id,
          username: username,
          avatar: avatar,
        );
}
