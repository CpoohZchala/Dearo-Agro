import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';

import '../services/gemini_chat_service.dart';

class ChatMessage {
  final String text;
  final bool isUser;

  const ChatMessage({
    required this.text,
    required this.isUser,
  });
}

class AgriChatbotScreen extends StatefulWidget {
  const AgriChatbotScreen({super.key});

  @override
  State<AgriChatbotScreen> createState() => _AgriChatbotScreenState();
}

class _AgriChatbotScreenState extends State<AgriChatbotScreen> {
  static const Color primaryGreen = Color(0xFF4D9A55);
  static const Color darkGreen = Color(0xFF276B35);
  static const Color pageBackground = Color(0xFFF4F8F3);

  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final GeminiChatService _geminiChatService = GeminiChatService();

  String? _previousInteractionId;
  bool _isSending = false;

  final List<ChatMessage> _messages = [
    const ChatMessage(
      isUser: false,
      text: '''
## Welcome to AgriChatbot 🌾

**සිංහලෙන් හෝ English වලින් ඔබගේ ගොවිපල ප්‍රශ්නය අහන්න.**

වී වගාව, එළවළු, පස, පොහොර, ජලය, කෘමි හානි සහ වගා ගැටලු ගැන උදව් ලබාගන්න.

---

**Ask your farming questions in Sinhala or English.**

Get help with crops, soil, irrigation, pests, plant diseases, compost, and farming practices.
''',
    ),
  ];

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage([String? quickQuestion]) async {
    final question = (quickQuestion ?? _messageController.text).trim();

    if (question.isEmpty || _isSending) return;

    setState(() {
      _messages.add(
        ChatMessage(
          text: question,
          isUser: true,
        ),
      );

      _isSending = true;
    });

    _messageController.clear();
    _scrollToBottom();

    try {
      final result = await _geminiChatService.askQuestion(
        question: question,
        previousInteractionId: _previousInteractionId,
      );

      if (!mounted) return;

      setState(() {
        _messages.add(
          ChatMessage(
            text: result.text,
            isUser: false,
          ),
        );

        _previousInteractionId = result.interactionId;
      });
    } on GeminiChatException catch (error) {
      if (!mounted) return;

      setState(() {
        _messages.add(
          ChatMessage(
            isUser: false,
            text: '''
## සිංහල

**දෝෂයක් ඇති විය**

${error.message}

---

## English

**An error occurred**

${error.message}
''',
          ),
        );
      });
    } finally {
      if (mounted) {
        setState(() {
          _isSending = false;
        });
      }

      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;

      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOut,
      );
    });
  }

  Future<void> _showClearDialog() async {
    final shouldClear = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          title: const Text('Clear conversation?'),
          content: const Text(
            'Your current AgriChatbot messages will be removed.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Cancel'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: primaryGreen,
              ),
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text('Clear'),
            ),
          ],
        );
      },
    );

    if (shouldClear == true) {
      setState(() {
        _previousInteractionId = null;

        _messages
          ..clear()
          ..add(
            const ChatMessage(
              isUser: false,
              text: '''
## New conversation started 🌾

**සිංහලෙන් හෝ English වලින් ඔබගේ ගොවිපල ප්‍රශ්නය අහන්න.**

Ask your next farming question in Sinhala or English.
''',
            ),
          );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final showQuickQuestions = _messages.length == 1 && !_isSending;

    return Scaffold(
      backgroundColor: pageBackground,
      appBar: AppBar(
        elevation: 0,
        foregroundColor: Colors.white,
        backgroundColor: primaryGreen,
        surfaceTintColor: Colors.transparent,
        titleSpacing: 4,
        title: const Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: Color(0x33FFFFFF),
              child: Icon(
                Icons.agriculture_rounded,
                color: Colors.white,
                size: 22,
              ),
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AgriChatbot',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  'Your farming assistant',
                  style: TextStyle(
                    fontSize: 11,
                    color: Color(0xDFFFFFFF),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Clear chat',
            onPressed: _showClearDialog,
            icon: const Icon(Icons.delete_outline_rounded),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 16),
            decoration: const BoxDecoration(
              color: primaryGreen,
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(26),
              ),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.circle,
                  color: Color(0xFFB9F7BB),
                  size: 10,
                ),
                SizedBox(width: 7),
                Text(
                  'Online • Ready to help your farm',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              controller: _scrollController,
              keyboardDismissBehavior:
              ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
              children: [
                for (final message in _messages)
                  _MessageBubble(message: message),

                if (showQuickQuestions)
                  _QuickQuestions(
                    onQuestionSelected: _sendMessage,
                  ),

                if (_isSending) const _TypingBubble(),
              ],
            ),
          ),
          _ChatInput(
            controller: _messageController,
            isSending: _isSending,
            onSend: _sendMessage,
          ),
        ],
      ),
    );
  }
}

class _QuickQuestions extends StatelessWidget {
  final Future<void> Function(String question) onQuestionSelected;

  const _QuickQuestions({
    required this.onQuestionSelected,
  });

  @override
  Widget build(BuildContext context) {
    final questions = [
      'මගේ වී වගාවේ කොළ කහ පාට වෙලා',
      'How often should I water tomato plants?',
      'කොම්පෝස්ට් පොහොර භාවිතා කරන්නේ කොහොමද?',
    ];

    return Container(
      margin: const EdgeInsets.only(
        left: 46,
        top: 4,
        bottom: 18,
      ),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFE1ECE1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Try a quick question',
            style: TextStyle(
              color: Color(0xFF397441),
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: questions.map((question) {
              return InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () => onQuestionSelected(question),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 9,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F8EF),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    question,
                    style: const TextStyle(
                      color: Color(0xFF397441),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final ChatMessage message;

  const _MessageBubble({
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;
    final screenWidth = MediaQuery.of(context).size.width;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: screenWidth * 0.88,
        ),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: isUser
              ? _UserBubble(text: message.text)
              : _BotBubble(text: message.text),
        ),
      ),
    );
  }
}

class _UserBubble extends StatelessWidget {
  final String text;

  const _UserBubble({
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 17,
        vertical: 14,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF4D9A55),
            Color(0xFF397C45),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(22),
          topRight: Radius.circular(22),
          bottomLeft: Radius.circular(22),
          bottomRight: Radius.circular(5),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 15.5,
          fontWeight: FontWeight.w500,
          height: 1.45,
        ),
      ),
    );
  }
}

class _BotBubble extends StatelessWidget {
  final String text;

  const _BotBubble({
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 38,
          width: 38,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                Color(0xFF6CBF70),
                Color(0xFF317A3C),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: const Icon(
            Icons.agriculture_rounded,
            color: Colors.white,
            size: 21,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Container(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(5),
                topRight: Radius.circular(22),
                bottomLeft: Radius.circular(22),
                bottomRight: Radius.circular(22),
              ),
              border: Border.all(
                color: const Color(0xFFE3EDE1),
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x10000000),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: MarkdownBody(
              data: text,
              selectable: true,
              styleSheet: MarkdownStyleSheet(
                p: const TextStyle(
                  color: Color(0xFF263128),
                  fontSize: 15.5,
                  height: 1.55,
                ),
                pPadding: const EdgeInsets.only(bottom: 8),
                h2: const TextStyle(
                  color: Color(0xFF2E773A),
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
                h2Padding: const EdgeInsets.only(
                  top: 4,
                  bottom: 8,
                ),
                h3: const TextStyle(
                  color: Color(0xFF357A40),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                h3Padding: const EdgeInsets.only(
                  top: 5,
                  bottom: 4,
                ),
                strong: const TextStyle(
                  color: Color(0xFF1E3722),
                  fontSize: 15.5,
                  fontWeight: FontWeight.bold,
                ),
                listBullet: const TextStyle(
                  color: Color(0xFF3C8B48),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                listIndent: 22,
                blockSpacing: 8,
                horizontalRuleDecoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: Color(0xFFE1ECE1),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _TypingBubble extends StatelessWidget {
  const _TypingBubble();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 38,
          width: 38,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFF4D9A55),
          ),
          child: const Icon(
            Icons.agriculture_rounded,
            color: Colors.white,
            size: 20,
          ),
        ),
        const SizedBox(width: 10),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 13,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xFFE3EDE1),
            ),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 17,
                height: 17,
                child: CircularProgressIndicator(
                  strokeWidth: 2.2,
                  color: Color(0xFF4D9A55),
                ),
              ),
              SizedBox(width: 10),
              Text(
                'AgriChatbot is typing...',
                style: TextStyle(
                  color: Color(0xFF4B5C4E),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ChatInput extends StatelessWidget {
  final TextEditingController controller;
  final bool isSending;
  final Future<void> Function() onSend;

  const _ChatInput({
    required this.controller,
    required this.isSending,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(
              color: Color(0xFFE6EFE5),
            ),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F6F0),
                  borderRadius: BorderRadius.circular(26),
                ),
                child: TextField(
                  controller: controller,
                  minLines: 1,
                  maxLines: 4,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => onSend(),
                  style: const TextStyle(
                    color: Color(0xFF27312A),
                    fontSize: 15.5,
                  ),
                  decoration: const InputDecoration(
                    hintText: 'ඔබගේ ගොවිපල ප්‍රශ්නය ලියන්න...',
                    hintStyle: TextStyle(
                      color: Color(0xFF849087),
                      fontSize: 14.5,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 13,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(28),
                onTap: isSending ? null : onSend,
                child: Ink(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF5DAC63),
                        Color(0xFF337C40),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x334D9A55),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    isSending ? Icons.hourglass_top_rounded : Icons.send_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}