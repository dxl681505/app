import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:smart_text_assistant/models/saved_item.dart';
import 'package:smart_text_assistant/services/storage_service.dart';
import 'package:smart_text_assistant/widgets/item_card.dart';

class SavedItemsList extends ConsumerStatefulWidget {
  const SavedItemsList({Key? key}) : super(key: key);

  @override
  ConsumerState<SavedItemsList> createState() => _SavedItemsListState();
}

class _SavedItemsListState extends ConsumerState<SavedItemsList> {
  late Box<SavedItem> _box;
  late Stream<BoxEvent> _boxStream;

  @override
  void initState() {
    super.initState();
    _box = Hive.box<SavedItem>('saved_items');
    _boxStream = _box.watch();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<BoxEvent>(
      stream: _boxStream,
      builder: (context, snapshot) {
        final items = StorageService.getAllItems();

        if (items.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.text_fields,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  '暂无保存的项',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            return ItemCard(
              item: items[index],
              onDeleted: () => setState(() {}),
            );
          },
        );
      },
    );
  }
}
