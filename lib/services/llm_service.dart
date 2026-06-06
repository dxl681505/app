import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:smart_text_assistant/models/llm_config.dart';

class LLMService {
  late final Dio _dio;
  final Logger _logger = Logger();
  final LLMConfig config;

  LLMService({required this.config}) {
    _dio = Dio(
      BaseOptions(
        baseUrl: config.baseUrl,
        headers: {
          'Authorization': 'Bearer ${config.apiKey}',
          'Content-Type': 'application/json',
        },
      ),
    );
  }

  /// 翻译文本
  Future<String?> translate(String text) async {
    if (!config.enableTranslation) return null;
    
    try {
      final response = await _dio.post(
        '/chat/completions',
        data: {
          'model': config.model,
          'messages': [
            {
              'role': 'user',
              'content': '${config.translationPrompt}\n\n$text',
            }
          ],
          'temperature': 0.7,
          'max_tokens': 500,
        },
      );

      final content = response.data['choices'][0]['message']['content'];
      return content;
    } catch (e) {
      _logger.e('Translation error: $e');
      return null;
    }
  }

  /// 解释文本
  Future<String?> explain(String text) async {
    if (!config.enableExplanation) return null;
    
    try {
      final response = await _dio.post(
        '/chat/completions',
        data: {
          'model': config.model,
          'messages': [
            {
              'role': 'user',
              'content': '${config.explanationPrompt}\n\n$text',
            }
          ],
          'temperature': 0.7,
          'max_tokens': 500,
        },
      );

      final content = response.data['choices'][0]['message']['content'];
      return content;
    } catch (e) {
      _logger.e('Explanation error: $e');
      return null;
    }
  }

  /// 自定义查询
  Future<String?> query(String prompt, String text) async {
    try {
      final response = await _dio.post(
        '/chat/completions',
        data: {
          'model': config.model,
          'messages': [
            {
              'role': 'user',
              'content': '$prompt\n\n$text',
            }
          ],
          'temperature': 0.7,
          'max_tokens': 500,
        },
      );

      final content = response.data['choices'][0]['message']['content'];
      return content;
    } catch (e) {
      _logger.e('Query error: $e');
      return null;
    }
  }
}
