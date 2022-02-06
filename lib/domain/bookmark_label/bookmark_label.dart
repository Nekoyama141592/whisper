// packages
import 'package:freezed_annotation/freezed_annotation.dart';
part 'bookmark_label.g.dart';

@JsonSerializable()
class BookmarkLabel {
  BookmarkLabel({
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

  factory BookmarkLabel.fromJson(Map<String,dynamic> json) => _$BookmarkLabelFromJson(json);

  Map<String,dynamic> toJson() => _$BookmarkLabelToJson(this);
}