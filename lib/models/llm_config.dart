import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'llm_config.g.dart';

@HiveType(typeId: 1)
@JsonSerializable()
class LLMConfig extends HiveObject {
  @HiveField(0)
  String baseUrl;

  @HiveField(1)
  String model;

  @HiveField(2)
  String apiKey;

  @HiveField(3)
  String translationPrompt;

  @HiveField(4)
  String explanationPrompt;

  @HiveField(5)
  bool enableTranslation;

  @HiveField(6)
  bool enableExplanation;

  LLMConfig({
    required this.baseUrl,
    required this.model,
    required this.apiKey,
    this.translationPrompt = '将以下文本翻译为英文：',
    this.explanationPrompt = '请解释以下文本的含义：',
    this.enableTranslation = true,
    this.enableExplanation = true,
  });

  factory LLMConfig.fromJson(Map<String, dynamic> json) =>
      _$LLMConfigFromJson(json);

  Map<String, dynamic> toJson() => _$LLMConfigToJson(this);

  factory LLMConfig.empty() {
    return LLMConfig(
      baseUrl: '',
      model: '',
      apiKey: '',
    );
  }

  bool get isValid => baseUrl.isNotEmpty && model.isNotEmpty && apiKey.isNotEmpty;
}
