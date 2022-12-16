import 'package:equatable/equatable.dart';

class SuggestionAuthor extends Equatable {
  final String id;
  final String username;
  final String? avatar;

  const SuggestionAuthor({
    required this.id,
    this.avatar,
    required this.username,
  });

  factory SuggestionAuthor.fromJson(Map<String, dynamic> json) {
    return SuggestionAuthor(
      id: json['id'].toString(),
      avatar: json['avatar'],
      username: json['username'],
    );
  }

  const SuggestionAuthor.empty({String? id}) : this(id: id ?? '', username: '');

  @override
  List<Object?> get props => <Object?>[
        id,
        username,
        avatar,
      ];
}
