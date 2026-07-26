import 'package:flutter/material.dart';

class AboutUsView extends StatelessWidget {
  const AboutUsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Column(
          children: [
            // Custom Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Color(0xFF64748B),
                        size: 20,
                      ),
                    ),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'About Us',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF334155),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 44), // To balance the back button
                ],
              ),
            ),
            
            // Content
            Expanded(
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 8),
                padding: const EdgeInsets.all(20),
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
                child: const SingleChildScrollView(
                  child: Text(
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam non fermentum tortor. Aenean quis porttitor ante, sit amet egestas risus. Sed congue dolor tortor, ac egestas dui egestas nec. Nullam consectetur mattis maximus. Etiam id nisl id neque tempus euismod sed sit amet sem. Nullam luctus sed ipsum sit amet tincidunt. Praesent aliquet tortor odio, dapibus tincidunt tellus laoreet sed. Suspendisse id fringilla enim. Nunc sed venenatis turpis. Aenean vitae eros non lorem porttitor auctor. Quisque turpis nisl, efficitur nec facilisis quis, bibendum vitae metus. Pellentesque suscipit libero nunc, gravida blandit lorem iaculis a. Donec pulvinar quis magna cursus luctus. Sed venenatis nulla at massa tristique tempor. Pellentesque non maximus eros. Donec semper ex dui, ut semper mi convallis sit amet.\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam non fermentum tortor. Aenean quis porttitor ante, sit amet egestas risus. Sed congue dolor tortor, ac egestas dui egestas nec. Nullam consectetur mattis maximus. Etiam id nisl id neque tempus euismod sed sit amet sem. Nullam luctus sed ipsum sit amet tincidunt. Praesent aliquet tortor odio, dapibus tincidunt tellus laoreet sed. Suspendisse id fringilla enim. Nunc sed venenatis turpis. Aenean vitae eros non lorem porttitor auctor. Quisque turpis nisl, efficitur nec facilisis quis, bibendum vitae metus. Pellentesque suscipit libero nunc, gravida blandit lorem iaculis a. Donec pulvinar quis magna cursus luctus. Sed venenatis nulla at massa tristique tempor. Pellentesque non maximus eros. Donec semper ex dui, ut semper mi convallis sit amet.',
                    style: TextStyle(
                      fontSize: 14.5,
                      color: Color(0xFF64748B),
                      height: 1.5,
                    ),
                    textAlign: TextAlign.justify,
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
