// packages
import 'package:freezed_annotation/freezed_annotation.dart';
part 'bookmark_post_label.g.dart';

@JsonSerializable()
class BookmarkPostLabel {
  BookmarkPostLabel({
    required this.createdAt,
    required this.label,
    required this.tokenId,
    required this.tokenType,
    required this.imageURL,
    required this.uid,
    required this.updatedAt
  });
  
  final dynamic createdAt;
  String label;
  final String tokenId;
  final String tokenType;
  String imageURL;
  final String uid;
  final dynamic updatedAt;

  factory BookmarkPostLabel.fromJson(Map<String,dynamic> json) => _$BookmarkPostLabelFromJson(json);

  Map<String,dynamic> toJson() => _$BookmarkPostLabelToJson(this);
}