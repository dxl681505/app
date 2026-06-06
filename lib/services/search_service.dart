import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

class SearchService {
  late final Dio _dio;
  final Logger _logger = Logger();

  SearchService() {
    _dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );
  }

  /// 使用必应搜索
  Future<List<SearchResult>> searchWithBing(String query) async {
    try {
      final encodedQuery = Uri.encodeComponent(query);
      final url = 'https://www.bing.com/search?q=$encodedQuery';

      return [
        SearchResult(
          title: '搜索结果来自必应',
          url: url,
          description: '点击打开搜索结果',
          source: 'Bing',
        ),
      ];
    } catch (e) {
      _logger.e('Bing search error: $e');
      return [];
    }
  }
}

class SearchResult {
  final String title;
  final String url;
  final String description;
  final String source;

  SearchResult({
    required this.title,
    required this.url,
    required this.description,
    required this.source,
  });

  @override
  String toString() => '$title\n$description\n$url';
}
