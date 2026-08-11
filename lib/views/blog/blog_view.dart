import 'package:flutter/material.dart';
import '../../controllers/language_controller.dart';
import 'blog_detail_view.dart';

class BlogView extends StatefulWidget {
  final LanguageController? languageController;

  const BlogView({super.key, this.languageController});

  @override
  State<BlogView> createState() => _BlogViewState();
}

class _BlogViewState extends State<BlogView> {
  late final LanguageController _langController;

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  static const brandGreen = Color(0xFF0F9D58);
  static const textDark = Color(0xFF0F172A);
  static const textMuted = Color(0xFF64748B);

  @override
  void initState() {
    super.initState();
    _langController = widget.languageController ?? LanguageController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openArticleDetail(BlogArticleModel article) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlogDetailView(
          article: article,
          languageController: _langController,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _langController,
      builder: (context, _) {
        final articles = [
          // Article 1: Gynae & Newborn (Matches Screenshot)
          BlogArticleModel(
            categoryBadge: _langController.tr('স্ত্রী ও প্রসূতি', 'Gynecology'),
            categoryBgColor: const Color(0xFFFCE4EC),
            categoryTextColor: const Color(0xFFD81B60),
            readTime: _langController.tr('৬ মিনিট পড়া', '6 min read'),
            title: _langController.tr(
              'গর্ভবতী মা ও নবজাতক শিশুর সঠিক যত্ন গাইডলাইন',
              'Proper Care Guidelines for Pregnant Mothers & Newborns',
            ),
            summary: _langController.tr(
              'গর্ভকালীন সময় এবং সন্তান জন্মের পর প্রথম ৩ মাস মা ও নবজাতক দুজনের জন্যই অত্যন্ত সংবেদনশীল সময়। সঠিক পরিচর্যা ও ডাক্তারের নিয়মিত চেকআপ মা ও শিশুকে নিরাপদ রাখে।',
              'Pregnancy period & initial 3 months after birth are delicate. Proper care & regular doctor checkups keep mother & baby safe.',
            ),
            doctorName: 'Dr. Nusrat Jahan',
            doctorDegree: _langController.tr(
              'MBBS, FCPS (Gynae), Rajshahi Medical College',
              'MBBS, FCPS (Gynae), Rajshahi Medical College',
            ),
            publishDate: _langController.tr('প্রকাশিত: ৩০ জুলাই, ২০২৬', 'Published: 30 July, 2026'),
            points: [
              {
                'pointTitle': _langController.tr('১. নিয়মিত অ্যান্টেনেটাল চেকআপ (ANC):', '1. Regular Antenatal Checkup (ANC):'),
                'pointBody': _langController.tr(
                  'গর্ভধারণের পর অন্তত ৪ বার রেজিস্টার্ড গাইনোকোলজিস্টের পরামর্শ নিয়ে রুটিন চেকআপ করাতে হবে।',
                  'Routine checkups at least 4 times after pregnancy with a registered gynecologist.',
                ),
              },
              {
                'pointTitle': _langController.tr('২. আয়রন ও ফোলিক অ্যাসিড গ্রহণ:', '2. Iron & Folic Acid Intake:'),
                'pointBody': _langController.tr(
                  'ডাক্তারের নির্দেশনামতো পর্যাপ্ত আয়রন, ক্যালসিয়াম ও ফোলিক অ্যাসিডের প্রয়োজনীয় ট্যাবলেট গ্রহণ নিশ্চিত করুন।',
                  'Ensure intake of essential iron, calcium & folic acid tablets as advised by doctor.',
                ),
              },
              {
                'pointTitle': _langController.tr('৩. নবজাতকের মাতৃদুগ্ধ পান:', '3. Newborn Breastfeeding:'),
                'pointBody': _langController.tr(
                  'জন্মের পর প্রথম ৬ মাস শিশুকে শুধুমাত্র মায়ের বুকের দুধ পান করাতে হবে, কোন বাড়তি পানি বা মধু দেওয়া যাবে না।',
                  'Only breastfeed the baby for first 6 months, no extra water or honey should be given.',
                ),
              },
            ],
          ),

          // Article 2: Cardiology
          BlogArticleModel(
            categoryBadge: _langController.tr('কার্ডিওলজি', 'Cardiology'),
            categoryBgColor: const Color(0xFFFFEBEE),
            categoryTextColor: const Color(0xFFE53935),
            readTime: _langController.tr('৪ মিনিট পড়া', '4 min read'),
            title: _langController.tr(
              'হৃদরোগ প্রতিরোধে করণীয় ও স্বাস্থ্যকর জীবনযাপন',
              'Cardiovascular Disease Prevention & Healthy Lifestyle',
            ),
            summary: _langController.tr(
              'দৈনন্দিন খাদ্যাভ্যাস ও ব্যায়ামের মাধ্যমে হৃদরোগের ঝুঁকি কিভাবে কমাবেন সে সম্পর্কে অভিজ্ঞ ডাক্তারের পরামর্শ।',
              'Doctor advice on how to reduce heart disease risks through daily diet & exercise.',
            ),
            doctorName: 'Dr. Ahmed Rahman',
            doctorDegree: _langController.tr(
              'MBBS, MD (Cardiology), National Heart Institute',
              'MBBS, MD (Cardiology), National Heart Institute',
            ),
            publishDate: _langController.tr('প্রকাশিত: ২৮ জুলাই, ২০২৬', 'Published: 28 July, 2026'),
            points: [
              {
                'pointTitle': _langController.tr('১. নিয়মিত শারীরিক ব্যায়াম ও হাঁটা:', '1. Regular Physical Exercise:'),
                'pointBody': _langController.tr(
                  'প্রতিদিন অন্তত ৩০ মিনিট দ্রুত হাঁটা বা অ্যারোবিক ব্যায়াম রক্তসঞ্চালন বৃদ্ধি করে ও হার্ট সুস্থ রাখে।',
                  'Walking 30 mins daily increases blood circulation & keeps heart healthy.',
                ),
              },
              {
                'pointTitle': _langController.tr('২. অতিরিক্ত চর্বি ও কোলেস্টেরল পরিহার:', '2. Avoid Excess Fat & Cholesterol:'),
                'pointBody': _langController.tr(
                  'ফাস্টফুড, প্রসেসড ফুড ও অতিরিক্ত লবণযুক্ত খাবার কমিয়ে তাজা শাকসবজি ও ফলমূল খাওয়ার অভ্যাস করুন।',
                  'Reduce fast food & salty meals, include fresh vegetables & fruits in daily diet.',
                ),
              },
            ],
          ),

          // Article 3: Medicine
          BlogArticleModel(
            categoryBadge: _langController.tr('মেডিসিন', 'Medicine'),
            categoryBgColor: const Color(0xFFE8F5E9),
            categoryTextColor: const Color(0xFF2E7D32),
            readTime: _langController.tr('৫ মিনিট পড়া', '5 min read'),
            title: _langController.tr(
              'গরমের দিনে পানিশূন্যতা ও হিটস্ট্রোক থেকে বাঁচার উপায়',
              'Ways to Prevent Dehydration & Heatstroke in Summer',
            ),
            summary: _langController.tr(
              'তীব্র গরমে সুস্থ থাকতে প্রতিদিন কতটুকু পানি পান করা উচিত এবং কি ধরনের খাবার এড়িয়ে চলা ভালো।',
              'How much water to drink daily & foods to avoid staying healthy in hot weather.',
            ),
            doctorName: 'Dr. Farzana Islam',
            doctorDegree: _langController.tr(
              'MBBS, FCPS (Medicine), BSMMU Dhaka',
              'MBBS, FCPS (Medicine), BSMMU Dhaka',
            ),
            publishDate: _langController.tr('প্রকাশিত: ২৫ জুলাই, ২০২৬', 'Published: 25 July, 2026'),
            points: [
              {
                'pointTitle': _langController.tr('১. পর্যাপ্ত বিশুদ্ধ পানি ও ওআরএস গ্লুকোজ:', '1. Sufficient Pure Water & ORS:'),
                'pointBody': _langController.tr(
                  'গরমে প্রতিদিন অন্তত ৩ থেকে ৪ লিটার পানি পান করুন। বাইরে বের হলে সঙ্গে পানি রাখুন।',
                  'Drink 3-4 liters of water daily in summer. Carry pure water when going outdoors.',
                ),
              },
              {
                'pointTitle': _langController.tr('২. সরাসরি রোদে দীর্ঘক্ষণ না থাকা:', '2. Avoid Prolonged Sun Exposure:'),
                'pointBody': _langController.tr(
                  'দুপুর ১২টা থেকে বিকাল ৩টা পর্যন্ত কড়া রোদে থাকা এড়িয়ে চলুন এবং ছাতা ব্যবহার করুন।',
                  'Avoid direct sunlight between 12 PM to 3 PM & use an umbrella.',
                ),
              },
            ],
          ),

          // Article 4: Orthopedics
          BlogArticleModel(
            categoryBadge: _langController.tr('অর্থোপেডিক্স', 'Orthopedics'),
            categoryBgColor: const Color(0xFFE3F2FD),
            categoryTextColor: const Color(0xFF1565C0),
            readTime: _langController.tr('৪ মিনিট পড়া', '4 min read'),
            title: _langController.tr(
              'হাড় ও জয়েন্টের ব্যথা দূর করার আধুনিক চিকিৎসা',
              'Modern Treatments to Relieve Bone & Joint Pain',
            ),
            summary: _langController.tr(
              'বয়স বাড়ার সাথে সাথে হাড়ের ক্ষয় ও হাঁটু ব্যথার চিকিৎসায় আধুনিক ব্যায়াম ও থেরাপির ভূমিকা।',
              'Role of modern exercises & therapies in treating bone loss & knee pain with aging.',
            ),
            doctorName: 'Dr. Tanvir Hasan',
            doctorDegree: _langController.tr(
              'MBBS, MS (Orthopedics), NITOR Dhaka',
              'MBBS, MS (Orthopedics), NITOR Dhaka',
            ),
            publishDate: _langController.tr('প্রকাশিত: ২০ জুলাই, ২০২৬', 'Published: 20 July, 2026'),
            points: [
              {
                'pointTitle': _langController.tr('১. নিয়মিত থেরাপিউটিক এক্সারসাইজ:', '1. Regular Therapeutic Exercise:'),
                'pointBody': _langController.tr(
                  'হাঁটু ও কোমরের পেশি শক্ত করার জন্য ফিজিওথেরাপিস্টের পরামর্শে হালকা স্ট্রেচিং করুন।',
                  'Do light stretching under physiotherapist advice to strengthen knee & waist muscles.',
                ),
              },
              {
                'pointTitle': _langController.tr('২. সঠিক বসার ভঙ্গি ও উচ্চতা নিয়ন্ত্রণ:', '2. Proper Sitting Posture & Weight Control:'),
                'pointBody': _langController.tr(
                  'দীর্ঘসময় ঝুঁকে কাজ না করা এবং শরীরের অতিরিক্ত ওজন নিয়ন্ত্রণ করে জয়েন্টের চাপ কমান।',
                  'Avoid slouching for long hours & control weight to reduce joint pressure.',
                ),
              },
            ],
          ),
        ];

        final filteredArticles = articles.where((art) {
          if (_searchQuery.trim().isEmpty) return true;
          final query = _searchQuery.trim().toLowerCase();
          return art.title.toLowerCase().contains(query) ||
              art.summary.toLowerCase().contains(query) ||
              art.categoryBadge.toLowerCase().contains(query) ||
              art.doctorName.toLowerCase().contains(query);
        }).toList();

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
              _langController.tr('হেলথ ব্লগ ও আর্টিকেল', 'Health Blog & Articles'),
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
                // 1. HERO BANNER CARD
                _buildHeroCard(),

                const SizedBox(height: 16),

                // 2. SEARCH BAR WIDGET
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFCBD5E1), width: 1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.02),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (val) {
                      setState(() => _searchQuery = val);
                    },
                    style: const TextStyle(fontSize: 13.5, color: textDark, fontWeight: FontWeight.w500),
                    decoration: InputDecoration(
                      hintText: _langController.tr(
                        'রোগের নাম, বিষয় বা ডাক্তারের নাম দিয়ে ব্লগ খুঁজুন...',
                        'Search blogs by disease, topic or doctor name...',
                      ),
                      hintStyle: const TextStyle(fontSize: 12.5, color: Color(0xFF94A3B8)),
                      prefixIcon: const Icon(Icons.search_rounded, color: brandGreen, size: 22),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear_rounded, color: Color(0xFF94A3B8), size: 18),
                              onPressed: () {
                                _searchController.clear();
                                setState(() => _searchQuery = '');
                              },
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                // 3. ARTICLE CARDS LIST OR EMPTY STATE
                if (filteredArticles.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 36),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: const BoxDecoration(
                              color: Color(0xFFF1F5F9),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.search_off_rounded, color: Color(0xFF94A3B8), size: 36),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            _langController.tr('কোনো নিবন্ধ পাওয়া যায়নি', 'No articles found'),
                            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: textDark),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _langController.tr('অন্য কোনো শব্দ দিয়ে পুনরায় অনুসন্ধান করুন', 'Try searching with another keyword'),
                            style: const TextStyle(fontSize: 12.5, color: textMuted),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  Column(
                    children: filteredArticles.map((art) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 14.0),
                        child: _buildArticleCard(
                          categoryBadge: art.categoryBadge,
                          categoryBgColor: art.categoryBgColor,
                          categoryTextColor: art.categoryTextColor,
                          readTime: art.readTime,
                          title: art.title,
                          summary: art.summary,
                          author: art.doctorName,
                          onTap: () => _openArticleDetail(art),
                        ),
                      );
                    }).toList(),
                  ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }

  // 1. HERO BANNER CARD
  Widget _buildHeroCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0F9D58), Color(0xFF047857)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F9D58).withValues(alpha: 0.3),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Badge Pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.25),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.menu_book_rounded,
                  color: Colors.white,
                  size: 15,
                ),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    _langController.tr('স্বাস্থ্য বিষয়ক ব্লগ ও আর্টিকেল (Health Articles)', 'Health Blog & Articles'),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Main Heading
          Text(
            _langController.tr(
              'সুস্থ ও সচেতন জীবনযাপনের জন্য ডাক্তারদের ব্লগ',
              'Doctors Blog for a Healthy & Aware Lifestyle',
            ),
            style: const TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 10),

          // Subtitle Description
          Text(
            _langController.tr(
              'দেশের সেরা ডাক্তারদের স্বাস্থ্য বিষয়ক বিশেষ পরামর্শ, রোগ প্রতিরোধ গাইড এবং পুষ্টি পরামর্শ পড়ুন।',
              'Read expert health tips, disease prevention guides & nutrition advice from country top doctors.',
            ),
            style: TextStyle(
              fontSize: 13,
              color: Colors.white.withValues(alpha: 0.9),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // 2. ARTICLE CARD
  Widget _buildArticleCard({
    required String categoryBadge,
    required Color categoryBgColor,
    required Color categoryTextColor,
    required String readTime,
    required String title,
    required String summary,
    required String author,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Category Badge + Read Time
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: categoryBgColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    categoryBadge,
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w800,
                      color: categoryTextColor,
                    ),
                  ),
                ),
                Text(
                  readTime,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF94A3B8),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Article Title
            Text(
              title,
              style: const TextStyle(
                fontSize: 16.5,
                fontWeight: FontWeight.w900,
                color: textDark,
                letterSpacing: -0.3,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 8),

            // Summary
            Text(
              summary,
              style: const TextStyle(
                fontSize: 12.5,
                color: textMuted,
                height: 1.45,
              ),
            ),

            const SizedBox(height: 14),
            const Divider(height: 1, color: Color(0xFFF1F5F9)),
            const SizedBox(height: 12),

            // Bottom Row: Author + Read More
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.person_outline_rounded,
                      size: 16,
                      color: Color(0xFF64748B),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      author,
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF475569),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      _langController.tr('সম্পূর্ণ পড়ুন', 'Read More'),
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w800,
                        color: brandGreen,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.arrow_forward_rounded,
                      size: 14,
                      color: brandGreen,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
