import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

void showShareAppDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) => const ShareAppDialog(),
  );
}

class ShareAppDialog extends StatefulWidget {
  const ShareAppDialog({super.key});

  @override
  State<ShareAppDialog> createState() => _ShareAppDialogState();
}

class _ShareAppDialogState extends State<ShareAppDialog> {
  static const String appLink =
      'https://play.google.com/store/apps/details?id=com.mediseba.mediseba';
  static const String shareMessage =
      'মেডি সেবা - আপনার স্বাস্থ্যসেবা এখন এক ক্লিকে!\n'
      'স্বাস্থ্য বিষয়ক জিজ্ঞাসা, ডাক্তার সিরিয়াল ও জরুরি সেবার জন্য ইনস্টল করুন MediSeba অ্যাপ:\n'
      '$appLink';

  bool _isCopied = false;

  void _copyToClipboard() {
    Clipboard.setData(const ClipboardData(text: appLink));
    setState(() => _isCopied = true);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Link copied to clipboard! 📋'),
        duration: Duration(seconds: 2),
        backgroundColor: Color(0xFF0F9D58),
      ),
    );

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _isCopied = false);
    });
  }

  Future<void> _shareToPlatform(String platform) async {
    final encodedMsg = Uri.encodeComponent(shareMessage);
    final encodedUrl = Uri.encodeComponent(appLink);

    Uri? uri;
    switch (platform) {
      case 'facebook':
        uri = Uri.parse('https://www.facebook.com/sharer/sharer.php?u=$encodedUrl');
        break;
      case 'x':
        uri = Uri.parse('https://twitter.com/intent/tweet?text=$encodedMsg');
        break;
      case 'whatsapp':
        uri = Uri.parse('whatsapp://send?text=$encodedMsg');
        break;
      case 'telegram':
        uri = Uri.parse('https://t.me/share/url?url=$encodedUrl&text=$encodedMsg');
        break;
      case 'linkedin':
        uri = Uri.parse('https://www.linkedin.com/sharing/share-offsite/?url=$encodedUrl');
        break;
    }

    if (uri != null) {
      try {
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        } else {
          // Fallback to system share
          await SharePlus.instance.share(shareMessage, subject: 'MediSeba App');
        }
      } catch (_) {
        await SharePlus.instance.share(shareMessage, subject: 'MediSeba App');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          // Main Content Card
          Container(
            margin: const EdgeInsets.only(top: 28),
            padding: const EdgeInsets.fromLTRB(20, 36, 20, 24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.12),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Top Right Close (X) Button
                Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Color(0xFFF1F5F9),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close_rounded,
                        size: 18,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ),
                ),

                // Title
                const Text(
                  'Share with Friends',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 6),

                // Subtitle
                const Text(
                  'Sharing is caring! Invite your friends to MediSeba for trusted healthcare.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF64748B),
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 24),

                // Section Label: Share your link
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Share your link',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF334155),
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                // Link Box with Copy Button
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Text(
                          appLink,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF475569),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: _copyToClipboard,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: _isCopied ? const Color(0xFFDCFCE7) : const Color(0xFFEEF2FF),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            _isCopied ? Icons.check_rounded : Icons.copy_rounded,
                            size: 18,
                            color: _isCopied ? const Color(0xFF0F9D58) : const Color(0xFF6366F1),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Section Label: Share to
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Share to',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF334155),
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                // Horizontal Social Share Buttons
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildSocialButton(
                        label: 'Facebook',
                        iconData: Icons.facebook,
                        bgColor: const Color(0xFF1877F2),
                        onTap: () => _shareToPlatform('facebook'),
                      ),
                      const SizedBox(width: 14),
                      _buildSocialButton(
                        label: 'X',
                        iconData: Icons.alternate_email_rounded,
                        bgColor: Colors.black,
                        onTap: () => _shareToPlatform('x'),
                      ),
                      const SizedBox(width: 14),
                      _buildSocialButton(
                        label: 'WhatsApp',
                        iconData: Icons.chat_bubble_rounded,
                        bgColor: const Color(0xFF25D366),
                        onTap: () => _shareToPlatform('whatsapp'),
                      ),
                      const SizedBox(width: 14),
                      _buildSocialButton(
                        label: 'Telegram',
                        iconData: Icons.send_rounded,
                        bgColor: const Color(0xFF0088CC),
                        onTap: () => _shareToPlatform('telegram'),
                      ),
                      const SizedBox(width: 14),
                      _buildSocialButton(
                        label: 'LinkedIn',
                        iconData: Icons.work_rounded,
                        bgColor: const Color(0xFF0A66C2),
                        onTap: () => _shareToPlatform('linkedin'),
                      ),
                      const SizedBox(width: 14),
                      _buildSocialButton(
                        label: 'More',
                        iconData: Icons.share_rounded,
                        bgColor: const Color(0xFF0F9D58),
                        onTap: () {
                          Navigator.pop(context);
                          SharePlus.instance.share(shareMessage, subject: 'MediSeba App');
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Top Floating Link Badge (Matching 2nd Screenshot)
          Positioned(
            top: 0,
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.link_rounded,
                color: Color(0xFF0F9D58),
                size: 28,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButton({
    required String label,
    required IconData iconData,
    required Color bgColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: bgColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: bgColor.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Icon(
              iconData,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }
}
