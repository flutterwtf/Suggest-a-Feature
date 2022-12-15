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
  final String authorId;
  final bool isAnonymous;
  final DateTime creationTime;
  final SuggestionStatus status;
  final Set<String> votedUserIds;
  final Set<String> notifyUserIds;

  int get upvotesCount => votedUserIds.length;

  const Suggestion({
    required this.id,
    required this.title,
    this.description,
    required this.authorId,
    required this.isAnonymous,
    required this.creationTime,
    required this.status,
    this.labels = const [],
    this.images = const [],
    this.comments = const [],
    this.notifyUserIds = const {},
    this.votedUserIds = const {},
  });

  Suggestion.empty({
    this.title = '',
    this.isAnonymous = false,
    this.images = const [],
    this.status = SuggestionStatus.requests,
    this.labels = const [],
    this.comments = const [],
    this.id = '0',
    this.authorId = '',
    this.description = '',
    DateTime? creationTime,
    this.notifyUserIds = const {},
    this.votedUserIds = const {},
  }) : creationTime = creationTime ?? DateTime.now();

  Suggestion copyWith({
    String? id,
    String? title,
    String? description,
    List<Comment>? comments,
    List<String>? images,
    List<SuggestionLabel>? labels,
    String? authorId,
    bool? isAnonymous,
    DateTime? creationTime,
    SuggestionStatus? status,
    Set<String>? votedUserIds,
    Set<String>? notifyUserIds,
  }) {
    return Suggestion(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      images: images ?? this.images,
      labels: labels ?? this.labels,
      comments: comments ?? this.comments,
      authorId: authorId ?? this.authorId,
      isAnonymous: isAnonymous ?? this.isAnonymous,
      creationTime: creationTime ?? this.creationTime,
      status: status ?? this.status,
      votedUserIds: votedUserIds ?? this.votedUserIds,
      notifyUserIds: notifyUserIds ?? this.notifyUserIds,
    );
  }

  factory Suggestion.fromJson({required Map<String, dynamic> json}) {
    return Suggestion(
      id: json['suggestion_id'].toString(),
      title: json['title'],
      description: json['description'],
      labels: (json['labels'] as List).cast<String>().map(LabelExt.labelType).toList(),
      images: (json['images'] as List).cast<String>(),
      authorId: json['author_id'],
      isAnonymous: json['is_anonymous'],
      creationTime: json['creation_time'].runtimeType == String
          ? fromDateTime(json['creation_time'])
          : json['creation_time'],
      status: SuggestionStatus.values.firstWhere((e) => describeEnum(e) == json['status']),
      votedUserIds: (json['voted_user_ids'] ?? []).cast<String>().toSet(),
      notifyUserIds: (json['notify_user_ids'] ?? []).cast<String>().toSet(),
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
        authorId,
        isAnonymous,
        status,
        votedUserIds,
        notifyUserIds,
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
