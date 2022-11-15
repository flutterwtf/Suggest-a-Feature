class CreateVotedUserRelationModel {
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
}
