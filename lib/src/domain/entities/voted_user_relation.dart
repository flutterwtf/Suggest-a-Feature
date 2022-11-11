class CreateVotedUserRelationModel {
  final String userId;
  final int suggestionId;

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
}
