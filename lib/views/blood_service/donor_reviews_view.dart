import 'package:flutter/material.dart';

class ReviewItem {
  final String reviewerName;
  final String reviewerImageUrl;
  final String comment;
  final String date;

  const ReviewItem({
    required this.reviewerName,
    required this.reviewerImageUrl,
    required this.comment,
    this.date = '2 days ago',
  });
}

class DonorReviewsView extends StatelessWidget {
  final String donorName;

  const DonorReviewsView({
    super.key,
    this.donorName = 'Donor',
  });

  static const List<ReviewItem> _dummyReviews = [
    ReviewItem(
      reviewerName: 'Raha',
      reviewerImageUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200&auto=format&fit=crop&q=80',
      comment: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur vel erat sed ex blandit sagittis. Maecenas vitae arcu quis metus fringilla maximus. Integer ac lectus vitae mauris tempus luctus tempus at metus.',
    ),
    ReviewItem(
      reviewerName: 'Raha',
      reviewerImageUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200&auto=format&fit=crop&q=80',
      comment: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur vel erat sed ex blandit sagittis. Maecenas vitae arcu quis metus fringilla maximus. Integer ac lectus vitae mauris tempus luctus tempus at metus.',
    ),
    ReviewItem(
      reviewerName: 'Raha',
      reviewerImageUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200&auto=format&fit=crop&q=80',
      comment: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur vel erat sed ex blandit sagittis. Maecenas vitae arcu quis metus fringilla maximus. Integer ac lectus vitae mauris tempus luctus tempus at metus.',
    ),
    ReviewItem(
      reviewerName: 'Raha',
      reviewerImageUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200&auto=format&fit=crop&q=80',
      comment: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur vel erat sed ex blandit sagittis. Maecenas vitae arcu quis metus fringilla maximus. Integer ac lectus vitae mauris tempus luctus tempus at metus.',
    ),
    ReviewItem(
      reviewerName: 'Raha',
      reviewerImageUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200&auto=format&fit=crop&q=80',
      comment: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur vel erat sed ex blandit sagittis. Maecenas vitae arcu quis metus fringilla maximus. Integer ac lectus vitae mauris tempus luctus tempus at metus.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8FAFC),
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
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
          'Reviews & Comments',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF222222),
          ),
        ),
      ),
      body: SafeArea(
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          itemCount: _dummyReviews.length,
          separatorBuilder: (context, index) => const SizedBox(height: 14),
          itemBuilder: (context, index) {
            final review = _dummyReviews[index];
            return _buildReviewCard(review);
          },
        ),
      ),
    );
  }

  Widget _buildReviewCard(ReviewItem review) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF1F5F9), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipOval(
                child: Image.network(
                  review.reviewerImageUrl,
                  width: 32,
                  height: 32,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 32,
                    height: 32,
                    color: const Color(0xFFF1F5F9),
                    child: const Icon(Icons.person_rounded, size: 20, color: Color(0xFF008744)),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                review.reviewerName,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1E293B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            review.comment,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: Color(0xFF64748B),
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}
