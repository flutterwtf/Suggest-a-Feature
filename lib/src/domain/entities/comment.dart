import '../../presentation/utils/date_utils.dart';
import 'suggestion_author.dart';

class Comment {
  final int id;
  final int suggestionId;
  final SuggestionAuthor author;
  final bool isAnonymous;
  final String text;
  final DateTime creationTime;

  const Comment({
    required this.id,
    required this.suggestionId,
    required this.author,
    required this.isAnonymous,
    required this.text,
    required this.creationTime,
  });

  factory Comment.fromJson({required Map<String, dynamic> json}) {
    return Comment(
      id: json['comment_id'],
      suggestionId: json['suggestion_id'],
      author: SuggestionAuthor.empty(id: json['author_id']),
      isAnonymous: json['is_anonymous'],
      text: json['text'],
      creationTime: fromDateTime(json['creation_time']),
    );
  }

  Map<String, dynamic> toUpdatingJson() {
    return {
      'text': text,
      'is_anonymous': isAnonymous,
    };
  }

  Comment copyWith({
    int? id,
    int? suggestionId,
    SuggestionAuthor? author,
    bool? isAnonymous,
    String? text,
    DateTime? creationTime,
  }) {
    return Comment(
      id: id ?? this.id,
      suggestionId: suggestionId ?? this.suggestionId,
      author: author ?? this.author,
      isAnonymous: isAnonymous ?? this.isAnonymous,
      text: text ?? this.text,
      creationTime: creationTime ?? this.creationTime,
    );
  }
}

class CreateCommentModel {
  final String authorId;
  final bool isAnonymous;
  final String text;
  final int suggestionId;

  const CreateCommentModel({
    required this.authorId,
    required this.isAnonymous,
    required this.text,
    required this.suggestionId,
  });

  Map<String, dynamic> toJson() {
    return {
      'author_id': authorId,
      'is_anonymous': isAnonymous,
      'text': text,
      'suggestion_id': suggestionId,
    };
  }
}
