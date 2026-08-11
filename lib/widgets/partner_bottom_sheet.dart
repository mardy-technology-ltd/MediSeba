import 'package:flutter/material.dart';
import '../controllers/language_controller.dart';
import '../views/partner/doctor_partner_view.dart';
import '../views/partner/ambulance_partner_view.dart';
import '../views/partner/hospital_partner_view.dart';
import '../views/partner/dealer_partner_view.dart';

void showPartnerBottomSheet(BuildContext context, {LanguageController? languageController}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => PartnerBottomSheet(languageController: languageController),
  );
}

class PartnerBottomSheet extends StatelessWidget {
  final LanguageController? languageController;

  const PartnerBottomSheet({super.key, this.languageController});

  @override
  Widget build(BuildContext context) {
    final lang = languageController ?? LanguageController();

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Top Pill handle
          Container(
            width: 38,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFFCBD5E1),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),

          // Header Title & Close Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.handshake_rounded,
                      color: Color(0xFF008536),
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    lang.tr('মেডিসেবা পার্টনারশিপ', 'MediSeba Partnerships'),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                ],
              ),
              GestureDetector(
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
            ],
          ),
          const SizedBox(height: 6),

          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              lang.tr(
                'আমাদের সাথে যুক্ত হয়ে আপনার স্বাস্থ্যসেবা সার্ভিস সম্প্রসারণ করুন:',
                'Expand your healthcare services by joining hands with us:',
              ),
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF64748B),
              ),
            ),
          ),
          const SizedBox(height: 18),

          // 1. Doctor Partner Card
          _buildPartnerCard(
            context: context,
            iconData: Icons.medical_services_rounded,
            iconBgColor: const Color(0xFFE8F5E9),
            iconColor: const Color(0xFF0F9D58),
            title: lang.tr('ডাক্তার পার্টনার', 'Doctor Partner'),
            subtitle: lang.tr(
              'ডাক্তার পার্টনারশিপ ও ডিজিটাল চেম্বার পোর্টাল',
              'Doctor registration & digital chamber portal',
            ),
            badgeText: lang.tr('ডাক্তার', 'Doctor'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DoctorPartnerView(languageController: languageController),
                ),
              );
            },
          ),

          const SizedBox(height: 12),

          // 2. Ambulance Partner Card
          _buildPartnerCard(
            context: context,
            iconData: Icons.airport_shuttle_rounded,
            iconBgColor: const Color(0xFFFFEBEE),
            iconColor: const Color(0xFFED1C24),
            title: lang.tr('অ্যাম্বুলেন্স পার্টনার', 'Ambulance Partner'),
            subtitle: lang.tr(
              '২৪/৭ জরুরি অ্যাম্বুলেন্স নেটওয়ার্কে যুক্ত হোন',
              'Join 24/7 emergency ambulance network',
            ),
            badgeText: lang.tr('অ্যাম্বুলেন্স', 'Ambulance'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AmbulancePartnerView(languageController: languageController),
                ),
              );
            },
          ),

          const SizedBox(height: 12),

          // 3. Hospital & Diagnostic Center Card
          _buildPartnerCard(
            context: context,
            iconData: Icons.local_hospital_rounded,
            iconBgColor: const Color(0xFFE3F2FD),
            iconColor: const Color(0xFF1565C0),
            title: lang.tr('হাসপাতাল ও ডায়াগনস্টিক সেন্টার', 'Hospital & Diagnostic Center'),
            subtitle: lang.tr(
              'হাসপাতাল টেস্ট, কেবিন ও সার্ভিস পার্টনারশিপ',
              'Hospital tests, cabins & service partnership',
            ),
            badgeText: lang.tr('হাসপাতাল', 'Hospital'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => HospitalPartnerView(languageController: languageController),
                ),
              );
            },
          ),

          const SizedBox(height: 12),

          // 4. Dealer Partner Card
          _buildPartnerCard(
            context: context,
            iconData: Icons.people_alt_rounded,
            iconBgColor: const Color(0xFFFFE0B2),
            iconColor: const Color(0xFFEF6C00),
            title: lang.tr('ডিলার পার্টনার', 'Dealer Partner'),
            subtitle: lang.tr(
              'উপজেলা ও এলাকা পর্যায়ে মেডিসেবার পয়েন্ট পরিচালনা করুন',
              'Operate MediSeba points in upazilas & local areas',
            ),
            badgeText: lang.tr('ডিলার', 'Dealer'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DealerPartnerView(languageController: languageController),
                ),
              );
            },
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildPartnerCard({
    required BuildContext context,
    required IconData iconData,
    required Color iconBgColor,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String badgeText,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFF1F5F9), width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                iconData,
                color: iconColor,
                size: 22,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                badgeText,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: iconColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
