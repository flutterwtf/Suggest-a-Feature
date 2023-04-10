import 'package:suggest_a_feature/src/domain/entities/suggestion_author.dart';

/// This class is required to provide Admin information for other users
/// It can be visible in comments
class AdminSettings extends SuggestionAuthor {
  const AdminSettings({
    required super.id,
    required super.username,
    super.avatar,
  });
}
