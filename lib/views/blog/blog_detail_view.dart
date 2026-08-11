import 'package:flutter/material.dart';
import '../../controllers/language_controller.dart';
import '../doctors/doctor_list_view.dart';

class BlogArticleModel {
  final String categoryBadge;
  final Color categoryBgColor;
  final Color categoryTextColor;
  final String readTime;
  final String title;
  final String summary;
  final String doctorName;
  final String doctorDegree;
  final String publishDate;
  final List<Map<String, String>> points;

  BlogArticleModel({
    required this.categoryBadge,
    required this.categoryBgColor,
    required this.categoryTextColor,
    required this.readTime,
    required this.title,
    required this.summary,
    required this.doctorName,
    required this.doctorDegree,
    required this.publishDate,
    required this.points,
  });
}

class BlogDetailView extends StatefulWidget {
  final BlogArticleModel article;
  final LanguageController? languageController;

  const BlogDetailView({
    super.key,
    required this.article,
    this.languageController,
  });

  @override
  State<BlogDetailView> createState() => _BlogDetailViewState();
}

class _BlogDetailViewState extends State<BlogDetailView> {
  late final LanguageController _langController;

  static const brandGreen = Color(0xFF0F9D58);
  static const textDark = Color(0xFF0F172A);
  static const textMuted = Color(0xFF475569);

  @override
  void initState() {
    super.initState();
    _langController = widget.languageController ?? LanguageController();
  }

  @override
  Widget build(BuildContext context) {
    final article = widget.article;

    return ListenableBuilder(
      listenable: _langController,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: const Color(0xFFF8FAFC),
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            scrolledUnderElevation: 0,
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: textDark, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              _langController.tr('ব্লগ বিস্তারিত', 'Article Detail'),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textDark,
              ),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. TOP BACK TO BLOGS BUTTON
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: const BorderSide(color: Color(0xFFCBD5E1), width: 1),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  ),
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back_rounded, size: 16, color: Color(0xFF334155)),
                  label: Text(
                    _langController.tr('ব্লগে ফিরে যান', 'Back to Blogs'),
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF334155)),
                  ),
                ),

                const SizedBox(height: 14),

                // 2. MAIN ARTICLE CARD CONTAINER
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 14,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category Badge + Read Time Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: article.categoryBgColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              article.categoryBadge,
                              style: TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w800,
                                color: article.categoryTextColor,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(Icons.access_time_rounded, size: 14, color: Color(0xFF94A3B8)),
                              const SizedBox(width: 4),
                              Text(
                                article.readTime,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF94A3B8),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 14),

                      // Article Main Title
                      Text(
                        article.title,
                        style: const TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.w900,
                          color: textDark,
                          height: 1.3,
                          letterSpacing: -0.3,
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Doctor Author Profile Container
                      Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: const BoxDecoration(
                              color: Color(0xFFDCFCE7),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.person_rounded,
                              color: brandGreen,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  article.doctorName,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                    color: textDark,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  article.doctorDegree,
                                  style: const TextStyle(
                                    fontSize: 11.5,
                                    color: Color(0xFF64748B),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  article.publishDate,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Color(0xFF94A3B8),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 18),
                      const Divider(height: 1, color: Color(0xFFF1F5F9)),
                      const SizedBox(height: 18),

                      // Opening Summary Paragraph
                      Text(
                        article.summary,
                        style: const TextStyle(
                          fontSize: 14,
                          color: textMuted,
                          height: 1.6,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      const SizedBox(height: 18),

                      // Article Points List
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: article.points.map((point) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  point['pointTitle'] ?? '',
                                  style: const TextStyle(
                                    fontSize: 14.5,
                                    fontWeight: FontWeight.bold,
                                    color: textDark,
                                    height: 1.4,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  point['pointBody'] ?? '',
                                  style: const TextStyle(
                                    fontSize: 13.5,
                                    color: textMuted,
                                    height: 1.55,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 10),

                      // Doctor Consultation CTA Banner Card (Mint Green)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F5E9),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFC8E6C9), width: 1),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _langController.tr('অভিজ্ঞ ডাক্তারদের থেকে পরামর্শ নিতে চান?', 'Want consultation from expert doctors?'),
                              style: const TextStyle(
                                fontSize: 14.5,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1B5E20),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _langController.tr(
                                'ঘরে বসেই ভিডিও কনসালটেশনের জন্য এখনই অ্যাপয়েন্টমেন্ট বুক করুন।',
                                'Book an appointment now for video consultation from home.',
                              ),
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF2E7D32),
                                height: 1.4,
                              ),
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              height: 42,
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: brandGreen,
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => DoctorListView(languageController: _langController),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.video_call_rounded, size: 18),
                                label: Text(
                                  _langController.tr('ডাক্তার দেখান', 'Consult Doctor'),
                                  style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }
}
