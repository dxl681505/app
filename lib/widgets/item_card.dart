import 'package:flutter/material.dart';
import 'package:smart_text_assistant/models/saved_item.dart';
import 'package:smart_text_assistant/screens/result_screen.dart';
import 'package:smart_text_assistant/services/storage_service.dart';

class ItemCard extends StatelessWidget {
  final SavedItem item;
  final VoidCallback? onDeleted;

  const ItemCard({
    Key? key,
    required this.item,
    this.onDeleted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ResultScreen(selectedText: item.originalText),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.originalText,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              if (item.translation != null) ...
                [
                  Text(
                    '翻译: ${item.translation}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 4),
                ]
              ,
              if (item.explanation != null) ...
                [
                  Text(
                    '解释: ${item.explanation}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 4),
                ]
              ,
              Text(
                item.createdAt.toString(),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[500],
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    icon: const Icon(Icons.delete),
                    label: const Text('删除'),
                    onPressed: () {
                      _showDeleteConfirmation(context);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认删除'),
        content: const Text('确定要删除这个项吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              StorageService.deleteItem(item.id);
              Navigator.pop(context);
              onDeleted?.call();
            },
            child: const Text('删除'),
          ),
        ],
      ),
    );
  }
}
