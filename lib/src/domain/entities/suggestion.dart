import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../../presentation/utils/date_utils.dart';
import 'comment.dart';
import 'utils/suggestion_utils.dart';

class Suggestion extends Equatable {
  final String id;
  final String title;
  final String? description;
  final List<SuggestionLabel> labels;
  final List<String> images;
  final List<Comment> comments;
  final int upvotesCount;
  final String authorId;
  final bool isAnonymous;
  final bool shouldNotifyAfterCompleted;
  final DateTime creationTime;
  final bool isVoted;
  final SuggestionStatus status;

  const Suggestion({
    required this.id,
    required this.title,
    this.description,
    required this.authorId,
    required this.isAnonymous,
    required this.creationTime,
    required this.status,
    this.upvotesCount = 0,
    this.labels = const [],
    this.images = const [],
    this.comments = const [],
    this.shouldNotifyAfterCompleted = false,
    this.isVoted = false,
  });

  Suggestion.empty({
    this.title = '',
    this.isAnonymous = false,
    this.upvotesCount = 0,
    this.shouldNotifyAfterCompleted = false,
    this.images = const [],
    this.status = SuggestionStatus.requests,
    this.isVoted = false,
    this.labels = const [],
    this.comments = const [],
    this.id = '0',
    this.authorId = '',
    this.description = '',
    DateTime? creationTime,
  }) : creationTime = creationTime ?? DateTime.now();

  Suggestion copyWith({
    String? id,
    String? title,
    String? description,
    List<Comment>? comments,
    List<String>? images,
    List<SuggestionLabel>? labels,
    int? upvotesCount,
    String? authorId,
    bool? isAnonymous,
    bool? shouldNotifyAfterCompleted,
    DateTime? creationTime,
    bool? isVoted,
    SuggestionStatus? status,
  }) {
    return Suggestion(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      images: images ?? this.images,
      labels: labels ?? this.labels,
      comments: comments ?? this.comments,
      upvotesCount: upvotesCount ?? this.upvotesCount,
      authorId: authorId ?? this.authorId,
      isAnonymous: isAnonymous ?? this.isAnonymous,
      shouldNotifyAfterCompleted: shouldNotifyAfterCompleted ?? this.shouldNotifyAfterCompleted,
      creationTime: creationTime ?? this.creationTime,
      isVoted: isVoted ?? this.isVoted,
      status: status ?? this.status,
    );
  }

  factory Suggestion.fromJson({required Map<String, dynamic> json}) {
    return Suggestion(
      id: json['suggestion_id'].toString(),
      title: json['title'],
      description: json['description'],
      labels: (json['labels'] as List).cast<String>().map(LabelExt.labelType).toList(),
      images: (json['images'] as List).cast<String>(),
      upvotesCount: json['upvotes_count'] ?? 0,
      authorId: json['author_id'],
      isAnonymous: json['is_anonymous'],
      shouldNotifyAfterCompleted: json['should_notify_after_completed'] ?? false,
      creationTime: json['creation_time'].runtimeType == String
          ? fromDateTime(json['creation_time'])
          : json['creation_time'],
      isVoted: json['is_voted'] ?? false,
      status: SuggestionStatus.values.firstWhere((e) => describeEnum(e) == json['status']),
    );
  }

  Map<String, dynamic> toUpdatingJson() {
    return {
      'title': title,
      'description': description,
      'labels': labels.map(describeEnum).toList(),
      'images': images,
    };
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        labels,
        images,
        comments,
        upvotesCount,
        authorId,
        isAnonymous,
        shouldNotifyAfterCompleted,
        isVoted,
        status,
      ];
}

enum SuggestionStatus { requests, inProgress, completed }

enum SuggestionLabel { feature, bug }

class CreateSuggestionModel {
  final String title;
  final String? description;
  final List<SuggestionLabel> labels;
  final List<String> images;
  final String authorId;
  final bool isAnonymous;
  final SuggestionStatus status;

  CreateSuggestionModel({
    required this.title,
    this.description,
    required this.labels,
    this.images = const [],
    required this.authorId,
    required this.isAnonymous,
    this.status = SuggestionStatus.requests,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'labels': labels.map(describeEnum).toList(),
      'images': images,
      'author_id': authorId,
      'is_anonymous': isAnonymous,
      'status': describeEnum(status),
    };
  }
}
