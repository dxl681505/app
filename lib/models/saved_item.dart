import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'saved_item.g.dart';

@HiveType(typeId: 0)
@JsonSerializable()
class SavedItem extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String originalText;

  @HiveField(2)
  final String? translation;

  @HiveField(3)
  final String? explanation;

  @HiveField(4)
  final String? searchResult;

  @HiveField(5)
  final DateTime createdAt;

  @HiveField(6)
  final String? source;

  SavedItem({
    required this.id,
    required this.originalText,
    this.translation,
    this.explanation,
    this.searchResult,
    required this.createdAt,
    this.source,
  });

  factory SavedItem.fromJson(Map<String, dynamic> json) =>
      _$SavedItemFromJson(json);

  Map<String, dynamic> toJson() => _$SavedItemToJson(this);

  String toMarkdown() {
    final buffer = StringBuffer();
    buffer.writeln('# $originalText');
    buffer.writeln();
    
    if (translation != null) {
      buffer.writeln('## 翻译');
      buffer.writeln(translation);
      buffer.writeln();
    }
    
    if (explanation != null) {
      buffer.writeln('## 解释');
      buffer.writeln(explanation);
      buffer.writeln();
    }
    
    if (searchResult != null) {
      buffer.writeln('## 搜索结果');
      buffer.writeln(searchResult);
      buffer.writeln();
    }
    
    buffer.writeln('---');
    buffer.writeln('保存时间: ${createdAt.toString()}');
    if (source != null) {
      buffer.writeln('来源: $source');
    }
    
    return buffer.toString();
  }
}
