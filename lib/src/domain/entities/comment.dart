import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:suggest_a_feature/src/domain/entities/suggestion_author.dart';
import 'package:suggest_a_feature/src/presentation/utils/date_utils.dart';

class Comment extends Equatable {
  /// The id of the comment
  final String id;

  /// The id of the Suggestion of the comment
  final String suggestionId;

  /// The author of the comment
  final SuggestionAuthor author;

  /// Whether the comment was posted anonymously or not
  final bool isAnonymous;

  /// Text of the comment
  final String text;

  /// The time of comment creation
  final DateTime creationTime;

  /// Whether the comment was left from the Admin or not
  final bool isFromAdmin;

  const Comment({
    required this.id,
    required this.suggestionId,
    required this.author,
    required this.isAnonymous,
    required this.text,
    required this.creationTime,
    required this.isFromAdmin,
  });

  factory Comment.fromJson({required Map<String, dynamic> json}) {
    return Comment(
      id: json['comment_id'].toString(),
      suggestionId: json['suggestion_id'].toString(),
      author: SuggestionAuthor.empty(id: json['author_id']),
      isAnonymous: json['is_anonymous'],
      text: json['text'],
      creationTime: fromDateTime(json['creation_time']),
      isFromAdmin: json['is_from_admin'] ?? false,
    );
  }

  Map<String, dynamic> toUpdatingJson() {
    return <String, dynamic>{
      'text': text,
      'is_anonymous': isAnonymous,
    };
  }

  Comment copyWith({
    String? id,
    String? suggestionId,
    SuggestionAuthor? author,
    bool? isAnonymous,
    String? text,
    DateTime? creationTime,
    bool? isFromAdmin,
  }) {
    return Comment(
      id: id ?? this.id,
      suggestionId: suggestionId ?? this.suggestionId,
      author: author ?? this.author,
      isAnonymous: isAnonymous ?? this.isAnonymous,
      text: text ?? this.text,
      creationTime: creationTime ?? this.creationTime,
      isFromAdmin: isFromAdmin ?? this.isFromAdmin,
    );
  }

  @override
  List<Object?> get props => <Object?>[
        id,
        suggestionId,
        author,
        isAnonymous,
        text,
        isFromAdmin,
      ];
}

class CreateCommentModel extends Equatable {
  final String authorId;
  final bool isAnonymous;
  final String text;
  final String suggestionId;
  final bool isFromAdmin;

  const CreateCommentModel({
    required this.authorId,
    required this.isAnonymous,
    required this.text,
    required this.suggestionId,
    required this.isFromAdmin,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'author_id': authorId,
      'is_anonymous': isAnonymous,
      'text': text,
      'suggestion_id': suggestionId,
      'creation_time': DateFormat('yyyy-MM-ddTHH:mm:ss').format(DateTime.now()),
      //'is_from_admin': isFromAdmin,
    };
  }

  @override
  List<Object?> get props => <Object?>[
        authorId,
        isAnonymous,
        text,
        suggestionId,
        isFromAdmin,
      ];
}
