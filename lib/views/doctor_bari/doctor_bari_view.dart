import 'package:flutter/material.dart';
import 'doctor_details_view.dart';

class DoctorBariView extends StatefulWidget {
  const DoctorBariView({super.key});

  @override
  State<DoctorBariView> createState() => _DoctorBariViewState();
}

class _DoctorBariViewState extends State<DoctorBariView> {
  static const brandGreen = Color(0xFF009245);
  static const textDark = Color(0xFF222222);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.chevron_left_rounded,
                color: Color(0xFF64748B),
                size: 28,
              ),
            ),
          ),
        ),
        title: const Text(
          'ডাক্তার ঘর',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: textDark,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FA),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: 'ডাক্তারের নাম, বিশেষজ্ঞ বা হাসপাতাল...',
                    hintStyle: TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
                    prefixIcon: Icon(Icons.search_rounded, color: Color(0xFF0F9D58)),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                ),
              ),
            ),
            
            // Categories Row
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  _buildCategoryChip('সকল (All)', isSelected: true),
                  const SizedBox(width: 8),
                  _buildCategoryChip('মেডিসিন (Medicine)'),
                  const SizedBox(width: 8),
                  _buildCategoryChip('হৃদরোগ (Cardiology)'),
                  const SizedBox(width: 8),
                  _buildCategoryChip('শিশু (Pediatrics)'),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Doctors List
            Expanded(
              child: Container(
                color: const Color(0xFFF8FAFC), // Very light background for the list area
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  children: [
                    _buildDoctorCard(
                      name: 'ডাঃ মোহাম্মদ আরিফ রহমান',
                      specialty: 'MBBS, FCPS (Medicine), MD (Cardiol...',
                      hospital: 'ঢাকা মেডিকেল কলেজ ও হাসপাতাল',
                      rating: '4.9',
                      reviews: '(128)',
                      price: '৳800',
                      imageUrl: 'https://images.unsplash.com/photo-1612349317150-e413f6a5b16d?q=80&w=200&auto=format&fit=crop',
                      isPremium: true,
                    ),
                    _buildDoctorCard(
                      name: 'ডাঃ ফারজানা আক্তার',
                      specialty: 'MBBS, MS (Gynecology & Obstetrics)',
                      hospital: 'স্কয়ার হাসপাতাল, ঢাকা',
                      rating: '4.8',
                      reviews: '(95)',
                      price: '৳700',
                      imageUrl: 'https://images.unsplash.com/photo-1594824436998-d88623267d3b?q=80&w=200&auto=format&fit=crop',
                      isMediSeba: true,
                    ),
                    _buildDoctorCard(
                      name: 'ডাঃ তামিম হাসান',
                      specialty: 'MBBS, DCH, MD (Pediatrics)',
                      hospital: 'বঙ্গবন্ধু শেখ মুজিব মেডিকেল বিশ্ববিদ্যাল...',
                      rating: '4.7',
                      reviews: '(74)',
                      price: '৳600',
                      imageUrl: 'https://images.unsplash.com/photo-1622253692010-333f2da6031d?q=80&w=200&auto=format&fit=crop',
                    ),
                    _buildDoctorCard(
                      name: 'ডাঃ সায়মা পারভীন',
                      specialty: 'MBBS, DDV (Dermatology)',
                      hospital: 'পপুলার ডায়াগনস্টিক সেন্টার',
                      rating: '4.9',
                      reviews: '(140)',
                      price: '৳1000',
                      imageUrl: 'https://images.unsplash.com/photo-1559839734-2b71ea197ec2?q=80&w=200&auto=format&fit=crop',
                      isPremium: true,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String label, {bool isSelected = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF0F9D58) : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isSelected ? const Color(0xFF0F9D58) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isSelected) ...[
            const Icon(Icons.check, color: Colors.white, size: 16),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: isSelected ? Colors.white : const Color(0xFF475569),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorCard({
    required String name,
    required String specialty,
    required String hospital,
    required String rating,
    required String reviews,
    required String price,
    required String imageUrl,
    bool isPremium = false,
    bool isMediSeba = false,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DoctorDetailsView(
              name: name,
              specialty: specialty,
              hospital: hospital,
              rating: rating,
              reviews: reviews,
              price: price,
              imageUrl: imageUrl,
              isPremium: isPremium,
              isMediSeba: isMediSeba,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Doctor Image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                imageUrl,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 80,
                    height: 80,
                    color: const Color(0xFFE2E8F0),
                    child: const Icon(Icons.person, color: Color(0xFF94A3B8), size: 40),
                  );
                },
              ),
            ),
            const SizedBox(width: 16),
            
            // Doctor Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1E293B),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isPremium || isMediSeba) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: isPremium ? const Color(0xFFFEF3C7) : const Color(0xFFD1FAE5),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: isPremium ? const Color(0xFFF59E0B) : const Color(0xFF10B981),
                            ),
                          ),
                          child: Text(
                            isPremium ? 'Premium' : 'MediSeba',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: isPremium ? const Color(0xFFD97706) : const Color(0xFF047857),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    specialty,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF64748B),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    hospital,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF94A3B8),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.star_rounded, color: Color(0xFFF59E0B), size: 18),
                          const SizedBox(width: 4),
                          Text(
                            rating,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            reviews,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF94A3B8),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        price,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF0F9D58),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
