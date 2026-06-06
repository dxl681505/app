import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_text_assistant/screens/result_screen.dart';
import 'package:smart_text_assistant/screens/settings_screen.dart';
import 'package:smart_text_assistant/services/share_handler_service.dart';
import 'package:smart_text_assistant/services/storage_service.dart';
import 'package:smart_text_assistant/widgets/saved_items_list.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await StorageService.init();

    if (mounted) {
      await ShareHandlerService.initShareHandler((selectedText) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ResultScreen(selectedText: selectedText),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Text Assistant'),
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ),
              );
            },
            tooltip: '设置',
          ),
        ],
      ),
      body: const SavedItemsList(),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'fab_manual',
            tooltip: '手动输入',
            onPressed: _showManualInputDialog,
            child: const Icon(Icons.edit),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            heroTag: 'fab_add',
            tooltip: '添加项',
            onPressed: _showAddItemDialog,
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }

  void _showManualInputDialog() {
    String text = '';
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('输入文本进行处理'),
          content: TextField(
            onChanged: (value) => text = value,
            maxLines: 5,
            decoration: const InputDecoration(
              hintText: '输入要处理的文本',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () {
                if (text.isNotEmpty) {
                  Navigator.pop(context);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ResultScreen(selectedText: text),
                    ),
                  );
                }
              },
              child: const Text('处理'),
            ),
          ],
        );
      },
    );
  }

  void _showAddItemDialog() {
    String text = '';
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('添加新项'),
          content: TextField(
            onChanged: (value) => text = value,
            maxLines: 5,
            decoration: const InputDecoration(
              hintText: '输入文本',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () {
                if (text.isNotEmpty) {
                  final item = StorageService.createItem(
                    originalText: text,
                  );
                  StorageService.saveItem(item);
                  Navigator.pop(context);
                  setState(() {});
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('项目已保存')),
                  );
                }
              },
              child: const Text('保存'),
            ),
          ],
        );
      },
    );
  }
}
