import 'package:hive_flutter/hive_flutter.dart';
import 'package:smart_text_assistant/models/saved_item.dart';
import 'package:uuid/uuid.dart';

class StorageService {
  static const String boxName = 'saved_items';
  static late Box<SavedItem> _box;

  static Future<void> init() async {
    _box = await Hive.openBox<SavedItem>(boxName);
  }

  /// 保存项目
  static Future<void> saveItem(SavedItem item) async {
    await _box.put(item.id, item);
  }

  /// 获取所有项目
  static List<SavedItem> getAllItems() {
    return _box.values.toList();
  }

  /// 按 ID 获取项目
  static SavedItem? getItem(String id) {
    return _box.get(id);
  }

  /// 删除项目
  static Future<void> deleteItem(String id) async {
    await _box.delete(id);
  }

  /// 清空所有项目
  static Future<void> clearAll() async {
    await _box.clear();
  }

  /// 创建新的 SavedItem
  static SavedItem createItem({
    required String originalText,
    String? translation,
    String? explanation,
    String? searchResult,
    String? source,
  }) {
    return SavedItem(
      id: const Uuid().v4(),
      originalText: originalText,
      translation: translation,
      explanation: explanation,
      searchResult: searchResult,
      createdAt: DateTime.now(),
      source: source,
    );
  }
}
