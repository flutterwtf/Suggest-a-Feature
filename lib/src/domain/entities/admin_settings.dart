import 'package:suggest_a_feature/src/domain/entities/suggestion_author.dart';

/// This class is required to provide Admin information for other users
/// In can be visible in comments
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
