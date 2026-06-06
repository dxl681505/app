import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_text_assistant/models/llm_config.dart';
import 'package:smart_text_assistant/providers/llm_config_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  late TextEditingController _baseUrlController;
  late TextEditingController _modelController;
  late TextEditingController _apiKeyController;
  late TextEditingController _translationPromptController;
  late TextEditingController _explanationPromptController;

  @override
  void initState() {
    super.initState();
    final config = ref.read(llmConfigProvider);
    _baseUrlController = TextEditingController(text: config.baseUrl);
    _modelController = TextEditingController(text: config.model);
    _apiKeyController = TextEditingController(text: config.apiKey);
    _translationPromptController = TextEditingController(text: config.translationPrompt);
    _explanationPromptController = TextEditingController(text: config.explanationPrompt);
  }

  @override
  void dispose() {
    _baseUrlController.dispose();
    _modelController.dispose();
    _apiKeyController.dispose();
    _translationPromptController.dispose();
    _explanationPromptController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('设置'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: ElevatedButton(
                onPressed: _saveSettings,
                child: const Text('保存'),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('LLM 配置'),
            _buildTextField(
              controller: _baseUrlController,
              label: 'Base URL',
              hint: 'https://api.openai.com/v1',
              description: 'LLM 服务的 API 端点',
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _modelController,
              label: 'Model',
              hint: 'gpt-3.5-turbo',
              description: '模型名称',
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _apiKeyController,
              label: 'API Key',
              obscureText: true,
              description: 'API 访问密钥',
            ),
            const SizedBox(height: 32),
            _buildSectionTitle('自定义提示词'),
            _buildTextField(
              controller: _translationPromptController,
              label: '翻译提示词',
              maxLines: 3,
              description: '用于翻译的提示词',
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _explanationPromptController,
              label: '解释提示词',
              maxLines: 3,
              description: '用于解释的提示词',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    String? description,
    bool obscureText = false,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          obscureText: obscureText,
          maxLines: maxLines,
          decoration: InputDecoration(
            labelText: label,
            hintText: hint,
            border: const OutlineInputBorder(),
          ),
        ),
        if (description != null) ...
          [
            const SizedBox(height: 8),
            Text(
              description,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ]
      ],
    );
  }

  Future<void> _saveSettings() async {
    final newConfig = LLMConfig(
      baseUrl: _baseUrlController.text,
      model: _modelController.text,
      apiKey: _apiKeyController.text,
      translationPrompt: _translationPromptController.text,
      explanationPrompt: _explanationPromptController.text,
    );

    await ref.read(llmConfigProvider.notifier).updateConfig(newConfig);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('设置已保存')),
      );
      Navigator.pop(context);
    }
  }
}
