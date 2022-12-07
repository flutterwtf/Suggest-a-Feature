import 'package:equatable/equatable.dart';

class CreateSubscribedUserRelationModel extends Equatable {
  final String userId;
  final String suggestionId;

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

  @override
  List<Object?> get props => [
        userId,
        suggestionId,
      ];
}
