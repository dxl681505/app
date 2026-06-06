import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:logger/logger.dart';

class ShareHandlerService {
  static final Logger _logger = Logger();

  /// 初始化分享处理
  static Future<void> initShareHandler(
    Function(String) onTextReceived,
  ) async {
    try {
      ReceiveSharingIntent.getInitialText().then((String? value) {
        if (value != null && value.isNotEmpty) {
          _logger.i('Received text from share: $value');
          onTextReceived(value);
        }
      });

      ReceiveSharingIntent.textStream.listen(
        (String value) {
          _logger.i('Received text stream: $value');
          onTextReceived(value);
        },
        onError: (err) {
          _logger.e('Share handler error: $err');
        },
      );
    } catch (e) {
      _logger.e('Init share handler error: $e');
    }
  }
}
