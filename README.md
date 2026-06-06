# Smart Text Assistant

一款强大的文字处理工具，可以在任何应用选中文字后弹出的菜单增加翻译、搜索、解释、保存到 APP（或 Obsidian），APP 中可以设置翻译、解释使用 LLM 的 base_url、model、key 并支持自定义提示词。保存的内容支持导出到 Markdown 文件。

## ✨ 核心功能

- 🎯 **文字选中菜单**：在任何应用中选中文字后弹出操作菜单
- 🌐 **翻译**：支持多语言翻译（基于 LLM）
- 🔍 **搜索**：快速搜索选中的文字
- 💡 **解释**：智能解释文字含义
- 💾 **保存**：保存到本地或 Obsidian
- ⚙️ **自定义配置**：支持设置 LLM 的 base_url、model、key 并自定义提示词
- 📤 **导出**：支持导出为 Markdown、纯文本、JSON 格式

## 🛠 技术栈

- **框架**：Flutter 3.x + Dart 3.x
- **状态管理**：Riverpod
- **本地存储**：Hive + SQLite
- **HTTP 客户端**：Dio
- **分享集成**：receive_sharing_intent

## 📦 系统要求

- Flutter SDK >= 3.0
- Dart >= 3.0
- iOS: Xcode 14+
- Android: Android Studio + SDK 21+

## 🚀 快速开始

### 1. 克隆仓库

```bash
git clone https://github.com/dxl681505/app.git
cd app
```

### 2. 安装依赖

```bash
flutter pub get
```

### 3. 生成代码

```bash
flutter pub run build_runner build
```

### 4. 配置 LLM

复制 `.env.example` 文件到 `.env` 并配置 LLM 参数：

```bash
cp .env.example .env
```

编辑 `.env` 文件：

```
LLM_BASE_URL=https://api.openai.com/v1
LLM_MODEL=gpt-3.5-turbo
LLM_API_KEY=your-actual-api-key
```

### 5. 运行应用

```bash
# Android
flutter run -d android

# iOS
flutter run -d ios
```

## 📱 使用方法

### Android

1. 在任何应用中选中文字
2. 点击"分享"
3. 选择"Smart Text Assistant"
4. 选择所需操作（翻译、搜索、解释、保存）
5. 结果将在应用中显示或保存

### iOS

1. 在任何应用中选中文字
2. 点击"共享"
3. 向下滚动选择"Smart Text Assistant"
4. 选择所需操作
5. 结果将在应用中显示或保存

## 🔧 配置

### LLM 配置

支持任何兼容 OpenAI API 的 LLM 服务：

- **OpenAI** (gpt-3.5-turbo, gpt-4, 等)
- **Anthropic Claude**
- **本地 Ollama**
- **LM Studio**
- **其他兼容服务**

在应用设置中配置：
- **Base URL**: LLM 服务的 API 端点
- **Model**: 模型名称
- **API Key**: API 访问密钥

### 自定义提示词

可以在设置中自定义：
- 翻译提示词
- 解释提示词

## 💾 保存位置

### 本地存储
- 保存到应用本地数据库
- 随时查看和管理

### Obsidian 集成
- 直接保存到 Obsidian Vault
- 与笔记系统完整集成
- 自动生成链接

## 📤 导出格式

支持导出为以下格式：

- **Markdown (.md)** - 最推荐，支持链接和格式
- **纯文本 (.txt)** - 简单易读
- **JSON (.json)** - 数据交换格式

## 📚 文档

- [安装指南](./docs/SETUP.md)
- [API 文档](./docs/API.md)
- [项目结构](./docs/PROJECT_STRUCTURE.md)
- [贡献指南](./CONTRIBUTING.md)

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

## 📄 许可证

MIT License

## 👤 作者

- GitHub: [@dxl681505](https://github.com/dxl681505)

## 🆘 支持

如有问题或建议，请提交 [Issue](https://github.com/dxl681505/app/issues)。
