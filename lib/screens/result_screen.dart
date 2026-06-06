import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_text_assistant/providers/llm_config_provider.dart';
import 'package:smart_text_assistant/services/llm_service.dart';
import 'package:smart_text_assistant/services/search_service.dart';
import 'package:smart_text_assistant/services/storage_service.dart';
import 'package:url_launcher/url_launcher.dart';

class ResultScreen extends ConsumerStatefulWidget {
  final String selectedText;

  const ResultScreen({
    Key? key,
    required this.selectedText,
  }) : super(key: key);

  @override
  ConsumerState<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends ConsumerState<ResultScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String? _translation;
  String? _explanation;
  List<SearchResult> _searchResults = [];
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _performOperations();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _performOperations() async {
    final config = ref.read(llmConfigProvider);

    if (!config.isValid) {
      setState(() {
        _error = 'LLM 配置不完整，请先在设置中配置';
      });
      return;
    }

    setState(() => _isLoading = true);

    try {
      final llmService = LLMService(config: config);

      final translation = await llmService.translate(widget.selectedText);
      final explanation = await llmService.explain(widget.selectedText);
      final searchResults = await SearchService().searchWithBing(widget.selectedText);

      setState(() {
        _translation = translation;
        _explanation = explanation;
        _searchResults = searchResults;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = '操作失败: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('处理结果'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveItem,
            tooltip: '保存',
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey[100],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '原文',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 8),
                SelectableText(
                  widget.selectedText,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: '翻译'),
              Tab(text: '解释'),
              Tab(text: '搜索'),
              Tab(text: '更多'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildTranslationTab(),
                _buildExplanationTab(),
                _buildSearchTab(),
                _buildMoreTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTranslationTab() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(child: Text(_error!));
    }

    if (_translation == null) {
      return const Center(child: Text('翻译功能未启用或未获得翻译结果'));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SelectableText(_translation!),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton.icon(
                icon: const Icon(Icons.copy),
                label: const Text('复制'),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: _translation!));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('已复制到剪贴板')),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExplanationTab() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_explanation == null) {
      return const Center(child: Text('解释功能未启用或未获得解释结果'));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SelectableText(_explanation!),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton.icon(
                icon: const Icon(Icons.copy),
                label: const Text('复制'),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: _explanation!));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('已复制到剪贴板')),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchTab() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_searchResults.isEmpty) {
      return const Center(child: Text('没有搜索结果'));
    }

    return ListView.builder(
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final result = _searchResults[index];
        return ListTile(
          title: Text(result.title),
          subtitle: Text(
            result.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: const Icon(Icons.open_in_new),
          onTap: () async {
            final uri = Uri.parse(result.url);
            if (await canLaunchUrl(uri)) {
              await launchUrl(uri, mode: LaunchMode.externalApplication);
            }
          },
        );
      },
    );
  }

  Widget _buildMoreTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ListTile(
          title: const Text('保存到本地'),
          subtitle: const Text('保存到应用数据库'),
          trailing: const Icon(Icons.arrow_forward),
          onTap: _saveItem,
        ),
      ],
    );
  }

  Future<void> _saveItem() async {
    final item = StorageService.createItem(
      originalText: widget.selectedText,
      translation: _translation,
      explanation: _explanation,
    );

    await StorageService.saveItem(item);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('已保存到本地')),
      );
    }
  }
}
