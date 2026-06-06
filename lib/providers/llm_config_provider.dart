import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_text_assistant/models/llm_config.dart';

final llmConfigProvider = StateNotifierProvider<LLMConfigNotifier, LLMConfig>((ref) {
  return LLMConfigNotifier();
});

class LLMConfigNotifier extends StateNotifier<LLMConfig> {
  LLMConfigNotifier() : super(LLMConfig.empty()) {
    _loadConfig();
  }

  Future<void> _loadConfig() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final baseUrl = prefs.getString('llm_baseUrl') ?? '';
      final model = prefs.getString('llm_model') ?? '';
      final apiKey = prefs.getString('llm_apiKey') ?? '';
      final translationPrompt = prefs.getString('llm_translationPrompt') ?? '将以下文本翻译为英文：';
      final explanationPrompt = prefs.getString('llm_explanationPrompt') ?? '请解释以下文本的含义：';

      state = LLMConfig(
        baseUrl: baseUrl,
        model: model,
        apiKey: apiKey,
        translationPrompt: translationPrompt,
        explanationPrompt: explanationPrompt,
      );
    } catch (e) {
      print('Load config error: $e');
    }
  }

  Future<void> updateConfig(LLMConfig config) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('llm_baseUrl', config.baseUrl);
      await prefs.setString('llm_model', config.model);
      await prefs.setString('llm_apiKey', config.apiKey);
      await prefs.setString('llm_translationPrompt', config.translationPrompt);
      await prefs.setString('llm_explanationPrompt', config.explanationPrompt);

      state = config;
    } catch (e) {
      print('Save config error: $e');
    }
  }
}
