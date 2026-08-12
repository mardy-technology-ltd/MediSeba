import 'dart:io';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialMediaItem {
  final String id;
  final String title;
  final String webUrl;
  final List<String> nativeSchemes;
  final String androidPackageName;
  final IconData iconData;
  final Color brandColor;

  const SocialMediaItem({
    required this.id,
    required this.title,
    required this.webUrl,
    required this.nativeSchemes,
    required this.androidPackageName,
    required this.iconData,
    required this.brandColor,
  });
}

class SocialMediaLauncher {
  static const List<SocialMediaItem> items = [
    SocialMediaItem(
      id: 'facebook',
      title: 'Facebook',
      webUrl: 'https://www.facebook.com/mediseba.org/',
      nativeSchemes: [
        'fb://page/mediseba.org/',
        'fb://facewebmodal/f?href=https://www.facebook.com/mediseba.org/',
      ],
      androidPackageName: 'com.facebook.katana',
      iconData: Icons.facebook,
      brandColor: Color(0xFF1877F2),
    ),
    SocialMediaItem(
      id: 'youtube',
      title: 'YouTube',
      webUrl: 'https://www.youtube.com/@mediseba00',
      nativeSchemes: [
        'vnd.youtube://www.youtube.com/@mediseba00',
        'https://www.youtube.com/@mediseba00',
      ],
      androidPackageName: 'com.google.android.youtube',
      iconData: Icons.play_circle_fill_rounded,
      brandColor: Color(0xFFFF0000),
    ),
    SocialMediaItem(
      id: 'instagram',
      title: 'Instagram',
      webUrl: 'https://www.instagram.com/mediseba00/',
      nativeSchemes: [
        'instagram://user?username=mediseba00',
      ],
      androidPackageName: 'com.instagram.android',
      iconData: Icons.camera_alt_rounded,
      brandColor: Color(0xFFE4405F),
    ),
    SocialMediaItem(
      id: 'twitter',
      title: 'X (Twitter)',
      webUrl: 'https://x.com/mediseba00',
      nativeSchemes: [
        'twitter://user?screen_name=mediseba00',
      ],
      androidPackageName: 'com.twitter.android',
      iconData: Icons.alternate_email_rounded,
      brandColor: Color(0xFF0F172A),
    ),
    SocialMediaItem(
      id: 'pinterest',
      title: 'Pinterest',
      webUrl: 'https://www.pinterest.com/mediseba00/',
      nativeSchemes: [
        'pinterest://user/mediseba00/',
      ],
      androidPackageName: 'com.pinterest',
      iconData: Icons.push_pin_rounded,
      brandColor: Color(0xFFE60023),
    ),
    SocialMediaItem(
      id: 'linkedin',
      title: 'LinkedIn',
      webUrl: 'https://www.linkedin.com/in/medi-seba-759b13366/',
      nativeSchemes: [
        'linkedin://in/medi-seba-759b13366/',
        'linkedin://profile/medi-seba-759b13366/',
      ],
      androidPackageName: 'com.linkedin.android',
      iconData: Icons.work_rounded,
      brandColor: Color(0xFF0A66C2),
    ),
  ];

  /// Launch social media app if installed, otherwise redirect to Google Play Store
  static Future<void> open(SocialMediaItem item) async {
    bool launchedInNativeApp = false;

    // 1. Try native schemes
    for (final scheme in item.nativeSchemes) {
      final Uri uri = Uri.parse(scheme);
      try {
        if (await canLaunchUrl(uri)) {
          launchedInNativeApp = await launchUrl(
            uri,
            mode: LaunchMode.externalApplication,
          );
          if (launchedInNativeApp) break;
        }
      } catch (e) {
        debugPrint('Error launching scheme $scheme for ${item.title}: $e');
      }
    }

    // 2. Try web URL with externalNonBrowserApplication to trigger app intent picker
    if (!launchedInNativeApp) {
      final Uri webUri = Uri.parse(item.webUrl);
      try {
        launchedInNativeApp = await launchUrl(
          webUri,
          mode: LaunchMode.externalNonBrowserApplication,
        );
      } catch (e) {
        debugPrint('Error attempting externalNonBrowserApplication for ${item.title}: $e');
      }
    }

    // 3. If native app is NOT installed, redirect to Google Play Store
    if (!launchedInNativeApp) {
      bool playStoreOpened = false;

      if (Platform.isAndroid) {
        // Try market:// scheme first
        final Uri marketUri = Uri.parse('market://details?id=${item.androidPackageName}');
        try {
          if (await canLaunchUrl(marketUri)) {
            playStoreOpened = await launchUrl(
              marketUri,
              mode: LaunchMode.externalApplication,
            );
          }
        } catch (e) {
          debugPrint('Error opening market URI for ${item.title}: $e');
        }

        // Try web Play Store URL if market scheme failed
        if (!playStoreOpened) {
          final Uri playStoreWebUri = Uri.parse(
              'https://play.google.com/store/apps/details?id=${item.androidPackageName}');
          try {
            playStoreOpened = await launchUrl(
              playStoreWebUri,
              mode: LaunchMode.externalApplication,
            );
          } catch (e) {
            debugPrint('Error opening Play Store web URL for ${item.title}: $e');
          }
        }
      }

      // 4. Fallback to opening the web URL in browser if Play Store couldn't open
      if (!playStoreOpened) {
        final Uri webUri = Uri.parse(item.webUrl);
        try {
          await launchUrl(
            webUri,
            mode: LaunchMode.externalApplication,
          );
        } catch (e) {
          debugPrint('Error opening fallback web URL for ${item.title}: $e');
        }
      }
    }
  }
}
