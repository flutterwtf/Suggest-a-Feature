import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:suggest_a_feature/src/domain/entities/comment.dart';
import 'package:suggest_a_feature/src/presentation/utils/date_utils.dart';

class Suggestion extends Equatable {
  /// The id of the suggestion
  final String id;

  /// Suggestion's title
  final String title;

  /// Suggestion's description
  final String? description;

  /// Suggestion's labels (feature, bug)
  final List<SuggestionLabel> labels;

  /// Attached images
  final List<String> images;

  /// Comments to this suggestion
  final List<Comment> comments;

  /// Id of the suggestion's author
  final String authorId;

  /// Whether suggestion was posted anonymously or not
  final bool isAnonymous;

  /// The time of suggestion creation
  final DateTime creationTime;

  /// Status of the suggestion (requests, inProgress, completed)
  final SuggestionStatus status;

  /// Id`s of users who have voted for this suggestion
  final Set<String> votedUserIds;

  /// Id`s of users who have subscribed for this suggestion
  final Set<String> notifyUserIds;

  int get upvotesCount => votedUserIds.length;

  const Suggestion({
    required this.id,
    required this.title,
    required this.authorId,
    required this.isAnonymous,
    required this.creationTime,
    required this.status,
    this.description,
    this.labels = const <SuggestionLabel>[],
    this.images = const <String>[],
    this.comments = const <Comment>[],
    this.notifyUserIds = const <String>{},
    this.votedUserIds = const <String>{},
  });

  Suggestion.empty({
    this.title = '',
    this.isAnonymous = false,
    this.images = const <String>[],
    this.status = SuggestionStatus.requests,
    this.labels = const <SuggestionLabel>[],
    this.comments = const <Comment>[],
    this.id = '0',
    this.authorId = '',
    this.description = '',
    DateTime? creationTime,
    this.notifyUserIds = const <String>{},
    this.votedUserIds = const <String>{},
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
    final votedUserIds = json['voted_user_ids'] as List<dynamic>?;
    final notifyUserIds = json['notify_user_ids'] as List<dynamic>?;

    return Suggestion(
      id: json['suggestion_id'].toString(),
      title: json['title'],
      description: json['description'],
      labels: (json['labels'] as List<dynamic>)
          .cast<String>()
          .map(SuggestionLabel.fromName)
          .toList(),
      images: (json['images'] as List<dynamic>).cast<String>(),
      authorId: json['author_id'],
      isAnonymous: json['is_anonymous'],
      creationTime: fromDateTime(json['creation_time']),
      status: SuggestionStatus.fromName(json['status']),
      votedUserIds: votedUserIds?.cast<String>().toSet() ?? {},
      notifyUserIds: notifyUserIds?.cast<String>().toSet() ?? {},
    );
  }

  Map<String, dynamic> toUpdatingJson() {
    return <String, dynamic>{
      'title': title,
      'description': description,
      'labels': labels.map((label) => label.name).toList(),
      'images': images,
      'status': status.name,
    };
  }

  @override
  List<Object?> get props => <Object?>[
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

enum SuggestionStatus {
  requests,
  inProgress,
  completed,
  declined,
  duplicated,
  unknown;

  static SuggestionStatus fromName(String? name) {
    return values.firstWhere(
      (status) => status.name == name,
      orElse: () => unknown,
    );
  }
}

enum SuggestionLabel {
  feature,
  bug,
  unknown;

  static SuggestionLabel fromName(String? name) {
    return values.firstWhere(
      (label) => label.name == name,
      orElse: () => unknown,
    );
  }
}

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
    required this.labels,
    required this.authorId,
    required this.isAnonymous,
    this.description,
    this.images = const <String>[],
    this.status = SuggestionStatus.requests,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'title': title,
      'description': description,
      'labels': labels.map((label) => label.name).toList(),
      'images': images,
      'author_id': authorId,
      'is_anonymous': isAnonymous,
      'status': status.name,
      'creation_time': DateFormat('yyyy-MM-ddTHH:mm:ss').format(DateTime.now()),
    };
  }
}
