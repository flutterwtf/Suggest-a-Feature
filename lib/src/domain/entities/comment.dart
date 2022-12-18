import 'package:equatable/equatable.dart';

import '../../presentation/utils/date_utils.dart';
import 'suggestion_author.dart';

class Comment extends Equatable {
  final String id;
  final String suggestionId;
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
      id: json['comment_id'].toString(),
      suggestionId: json['suggestion_id'].toString(),
      author: SuggestionAuthor.empty(id: json['author_id']),
      isAnonymous: json['is_anonymous'],
      text: json['text'],
      // ignore: avoid_dynamic_calls
      creationTime: json['creation_time'].runtimeType == String
          ? fromDateTime(json['creation_time'])
          : json['creation_time'],
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

  @override
  List<Object?> get props => <Object?>[
        id,
        suggestionId,
        author,
        isAnonymous,
        text,
      ];
}

class CreateCommentModel extends Equatable {
  final String authorId;
  final bool isAnonymous;
  final String text;
  final String suggestionId;

  const CreateCommentModel({
    required this.authorId,
    required this.isAnonymous,
    required this.text,
    required this.suggestionId,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'author_id': authorId,
      'is_anonymous': isAnonymous,
      'text': text,
      'suggestion_id': suggestionId,
    };
  }

  @override
  List<Object?> get props => <Object?>[
        authorId,
        isAnonymous,
        text,
        suggestionId,
      ];
}
