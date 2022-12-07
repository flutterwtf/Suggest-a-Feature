import 'package:equatable/equatable.dart';

class CreateVotedUserRelationModel extends Equatable {
  final String userId;
  final String suggestionId;

  const CreateVotedUserRelationModel({
    required this.userId,
    required this.suggestionId,
  });

  Map<String, dynamic>? toJson() {
    return {
      'user_id': userId,
      'suggestion_id': suggestionId,
    };
  }

  factory CreateVotedUserRelationModel.fromJson({required Map<String, dynamic> json}) {
    return CreateVotedUserRelationModel(
      userId: json['user_id'],
      suggestionId: json['suggestion_id'],
    );
  }

  @override
  List<Object?> get props => [
        userId,
        suggestionId,
      ];
}
