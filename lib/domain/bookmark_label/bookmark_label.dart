// packages
import 'package:freezed_annotation/freezed_annotation.dart';

part 'bookmark_label.g.dart';

@JsonSerializable()
class BookmarkLabel {
  BookmarkLabel({
    required this.createdAt,
    required this.label,
    required this.bookmarkLabelId,
    required this.uid,
    required this.updatedAt
  });
  
  final dynamic createdAt;
  final String label;
  final String bookmarkLabelId;
  final String uid;
  final dynamic updatedAt;

  factory BookmarkLabel.fromJson(Map<String,dynamic> json) => _$BookmarkLabelFromJson(json);

  Map<String,dynamic> toJson() => _$BookmarkLabelToJson(this);
}