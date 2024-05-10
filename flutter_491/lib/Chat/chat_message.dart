import 'package:dash_chat_2/dash_chat_2.dart';


class CustomChatMessage extends ChatMessage {
  CustomChatMessage({
    required ChatUser user,
    required DateTime createdAt,
    String text = '',
    // Include other parameters as necessary
  }) : super(
    user: user,
    createdAt: createdAt,
    text: text,
    // Pass other necessary arguments as needed
  );

  factory CustomChatMessage.fromJson(Map<String, dynamic> jsonData) {
    if (jsonData['user'] is! Map<String, dynamic>) {
      throw Exception('User data must be a map.');
    }
    return CustomChatMessage(
      user: ChatUser.fromJson(jsonData['user'] as Map<String, dynamic>),
      createdAt: DateTime.parse(jsonData['createdAt']),
      text: jsonData['text'] ?? '',
    );
  }


  @override
  Map<String, dynamic> toJson() {
    final originalJson = super.toJson();
    originalJson.addAll({
      // Add or modify JSON fields if necessary
    });
    return originalJson;
  }
}
