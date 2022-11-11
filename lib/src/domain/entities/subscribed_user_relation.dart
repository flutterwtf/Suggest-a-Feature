class CreateSubscribedUserRelationModel {
  final String userId;
  final int suggestionId;

  const CreateSubscribedUserRelationModel({
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
