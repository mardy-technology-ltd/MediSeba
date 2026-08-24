import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LiveChatFabWidget extends StatefulWidget {
  const LiveChatFabWidget({super.key});

  @override
  State<LiveChatFabWidget> createState() => _LiveChatFabWidgetState();
}

class _LiveChatFabWidgetState extends State<LiveChatFabWidget> {
  bool _isOpen = false;

  void _toggleChat() {
    setState(() {
      _isOpen = !_isOpen;
    });

    if (_isOpen) {
      showDialog(
        context: context,
        barrierDismissible: true,
        barrierColor: Colors.black.withValues(alpha: 0.3),
        builder: (context) => const LiveChatDialog(),
      ).then((_) {
        if (mounted) {
          setState(() {
            _isOpen = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        FloatingActionButton(
          backgroundColor: const Color(0xFF005C45),
          elevation: 6,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          onPressed: _toggleChat,
          child: Icon(
            _isOpen ? Icons.close_rounded : Icons.chat_bubble_rounded,
            color: Colors.white,
            size: 24,
          ),
        ),
        if (!_isOpen)
          Positioned(
            top: 2,
            right: 2,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Color(0xFFEF4444),
                shape: BoxShape.circle,
              ),
              child: const Text(
                '1',
                style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
              ),
            ),
          ),
      ],
    );
  }
}

class LiveChatDialog extends StatefulWidget {
  const LiveChatDialog({super.key});

  @override
  State<LiveChatDialog> createState() => _LiveChatDialogState();
}

class _LiveChatDialogState extends State<LiveChatDialog> {
  static const darkGreen = Color(0xFF005C45);
  static const brandGreen = Color(0xFF00A859);
  static const textDark = Color(0xFF0F172A);
  static const textMuted = Color(0xFF64748B);

  final TextEditingController _msgController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  late List<Map<String, String>> _messages;

  @override
  void initState() {
    super.initState();
    _messages = [
      {
        'sender': 'bot',
        'text': 'স্বাগতম মেডিসেবা লাইভ সাপোর্টে! 👋 আমরা কীভাবে আপনাকে সাহায্য করতে পারি?',
        'time': 'এখন',
      },
    ];
  }

  @override
  void dispose() {
    _msgController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;

    final userMsg = text.trim();
    _msgController.clear();

    setState(() {
      _messages.add({
        'sender': 'user',
        'text': userMsg,
        'time': 'এখন',
      });
    });

    _scrollToBottom();

    // Automated bot reply after short delay
    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;

      String botReply = 'ধন্যবাদ যোগাযোগের জন্য! আমাদের প্রতিনিধি খুব শীঘ্রই আপনার সাথে যুক্ত হবেন। কল করুন: 09647111666';

      if (userMsg.contains('ডাক্তার') || userMsg.contains('অ্যাপয়েন্টমেন্ট')) {
        botReply = 'ডাক্তার অ্যাপয়েন্টমেন্টের জন্য অনুগ্রহ করে "ডাক্তার ম্যানেজমেন্ট" প্যানেলে অথবা অনলাইন ডিরেক্টরিতে সার্চ করুন।';
      } else if (userMsg.contains('অ্যাম্বুলেন্স')) {
        botReply = 'জরুরি ২৪/৭ অ্যাম্বুলেন্স সেবার জন্য আমাদের হটলাইনে কল করুন: 09647111666।';
      } else if (userMsg.contains('ওষুধ') || userMsg.contains('অর্ডার')) {
        botReply = 'ওষুধ অর্ডারের জন্য মেডিসিন ইনভেন্টরি অথবা ই-ফার্মেসি সেকশন থেকে যেকোনো ওষুধ নির্বাচন করুন।';
      }

      setState(() {
        _messages.add({
          'sender': 'bot',
          'text': botReply,
          'time': 'এখন',
        });
      });

      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _makeCall(String phone) async {
    final Uri uri = Uri.parse('tel:$phone');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _openWhatsApp() async {
    final Uri uri = Uri.parse('https://wa.me/8809647111666');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      alignment: Alignment.bottomRight,
      insetPadding: const EdgeInsets.only(bottom: 24, right: 16, left: 16, top: 40),
      child: Container(
        width: 380,
        height: 520,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.18),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            // 1. Header (Teal-Green Gradient)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: const BoxDecoration(
                color: darkGreen,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Row(
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 19,
                        backgroundColor: brandGreen,
                        child: const Text(
                          'MS',
                          style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981),
                          shape: BoxShape.circle,
                          border: Border.all(color: darkGreen, width: 1.5),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Row(
                          children: [
                            Text(
                              'মেডিসেবা ইনস্ট্যান্ট লাইভ চ্যাট',
                              style: TextStyle(color: Colors.white, fontSize: 13.5, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 4),
                            Icon(Icons.verified_user_rounded, color: Colors.white70, size: 14),
                          ],
                        ),
                        SizedBox(height: 1),
                        Text(
                          'অনলাইনে আছেন • গড়ে ৭ মিনিটে উত্তর',
                          style: TextStyle(color: Colors.white70, fontSize: 10.5),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, color: Colors.white, size: 20),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            // 2. Action Bar (WhatsApp & Phone Call Buttons)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              color: const Color(0xFFECFDF5),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: brandGreen,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                      ),
                      onPressed: _openWhatsApp,
                      icon: const Icon(Icons.chat_outlined, size: 15),
                      label: const Text(
                        'হোয়াটসঅ্যাপ চ্যাট',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0F172A),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                      ),
                      onPressed: () => _makeCall('09647111666'),
                      icon: const Icon(Icons.phone_in_talk_rounded, size: 15),
                      label: const Text(
                        'কল 09647111666',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 3. Messages List Area
            Expanded(
              child: Container(
                color: const Color(0xFFF8FAFC),
                child: ListView(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(12),
                  children: [
                    ..._messages.map((msg) {
                      final isUser = msg['sender'] == 'user';
                      return Align(
                        alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(12),
                          constraints: const BoxConstraints(maxWidth: 270),
                          decoration: BoxDecoration(
                            color: isUser ? brandGreen : Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(16),
                              topRight: const Radius.circular(16),
                              bottomLeft: Radius.circular(isUser ? 16 : 4),
                              bottomRight: Radius.circular(isUser ? 4 : 16),
                            ),
                            border: isUser ? null : Border.all(color: const Color(0xFFE2E8F0)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.02),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                msg['text']!,
                                style: TextStyle(
                                  fontSize: 12.5,
                                  color: isUser ? Colors.white : textDark,
                                  fontWeight: isUser ? FontWeight.w600 : FontWeight.w500,
                                  height: 1.35,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                msg['time']!,
                                style: TextStyle(
                                  fontSize: 9.5,
                                  color: isUser ? Colors.white70 : textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),

                    // Quick Action Chips Row
                    const SizedBox(height: 6),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildQuickActionChip('👨‍⚕️ ডাক্তার অ্যাপয়েন্টমেন্ট'),
                          _buildQuickActionChip('🚑 অ্যাম্বুলেন্স সেবা'),
                          _buildQuickActionChip('💊 ওষুধ অর্ডার'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 4. Bottom Input Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
                border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: TextField(
                        controller: _msgController,
                        style: const TextStyle(fontSize: 12),
                        onSubmitted: _sendMessage,
                        decoration: const InputDecoration(
                          hintText: 'এখানে বার্তা টাইপ করুন...',
                          hintStyle: TextStyle(fontSize: 11.5, color: textMuted),
                          contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: brandGreen,
                    child: IconButton(
                      icon: const Icon(Icons.send_rounded, color: Colors.white, size: 18),
                      onPressed: () => _sendMessage(_msgController.text),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionChip(String label) {
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: InkWell(
        onTap: () => _sendMessage(label),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Text(
            label,
            style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: textDark),
          ),
        ),
      ),
    );
  }
}

/// Helper function to trigger Live Chat modal directly from anywhere
void showLiveChatModal(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.black.withValues(alpha: 0.3),
    builder: (context) => const LiveChatDialog(),
  );
}
