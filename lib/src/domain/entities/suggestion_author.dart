import 'package:equatable/equatable.dart';

class SuggestionAuthor extends Equatable {
  final String id;
  final String username;
  final String? avatar;

  factory SuggestionAuthor.fromJson(Map<String, dynamic> json) {
    return SuggestionAuthor(
      id: json['id'].toString(),
      avatar: json['avatar'],
      username: json['username'],
    );
  }

  const SuggestionAuthor({
    required this.id,
    this.avatar,
    required this.username,
  });

  const SuggestionAuthor.empty({String? id}) : this(id: id ?? '', username: '');

  @override
  List<Object?> get props => [
        id,
        username,
        avatar,
      ];
}
