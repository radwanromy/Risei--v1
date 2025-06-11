import 'package:flutter/material.dart';

class LearningScreen extends StatelessWidget {
  const LearningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 0,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          children: [
            const SizedBox(height: 24),
            // Greeting and Notification
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Hi, ",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          "John 👋",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1877F2),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "Let's start learning!",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 22,
                  child: Icon(Icons.notifications, color: Color(0xFF1877F2)),
                ),
              ],
            ),
            const SizedBox(height: 22),
            // Search Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(Icons.search, color: Colors.grey),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Search",
                        border: InputBorder.none,
                        isDense: true,
                      ),
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Icon(Icons.tune, color: Color(0xFF1877F2)),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Categories
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Categories",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    "See all",
                    style: TextStyle(
                      color: Color(0xFF1877F2),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 80,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _CategoryIcon(
                    label: "Art",
                    icon: Icons.palette,
                  ),
                  _CategoryIcon(
                    label: "Coding",
                    icon: Icons.code,
                  ),
                  _CategoryIcon(
                    label: "Marketing",
                    icon: Icons.campaign,
                  ),
                  _CategoryIcon(
                    label: "Business",
                    icon: Icons.business_center,
                  ),
                  _CategoryIcon(
                    label: "Science",
                    icon: Icons.science,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Popular Course
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Popular Course",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    "See all",
                    style: TextStyle(
                      color: Color(0xFF1877F2),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 210,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _CourseCard(
                    image: "https://images.unsplash.com/photo-1517520287167-4bbf64a00d66?auto=format&fit=crop&w=400&q=80",
                    title: "Design Thinking Fundamental",
                    tutor: "Robert Green",
                    price: "\$180",
                    rating: 4.8,
                    lessons: 32,
                    bestSeller: true,
                  ),
                  _CourseCard(
                    image: "https://images.unsplash.com/photo-1503676382389-4809596d5290?auto=format&fit=crop&w=400&q=80",
                    title: "3D Illustration Design",
                    tutor: "John Doe",
                    price: "\$250",
                    rating: 4.9,
                    lessons: 24,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            // Top Mentor
            Text(
              "Top Mentor",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 86,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _MentorCard(
                    image: "https://randomuser.me/api/portraits/men/11.jpg",
                    name: "Robert Green",
                    label: "Design Tutor",
                  ),
                  _MentorCard(
                    image: "https://randomuser.me/api/portraits/women/25.jpg",
                    name: "Jenny Fox",
                    label: "Coding Tutor",
                  ),
                  _MentorCard(
                    image: "https://randomuser.me/api/portraits/men/32.jpg",
                    name: "John Doe",
                    label: "Marketing Tutor",
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: _BottomBar(),
    );
  }
}

class _CategoryIcon extends StatelessWidget {
  final String label;
  final IconData icon;
  const _CategoryIcon({
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 18),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Color(0xFFE9F0FA),
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(18),
            child: Icon(icon, size: 30, color: Color(0xFF1877F2)),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _CourseCard extends StatelessWidget {
  final String image;
  final String title;
  final String tutor;
  final String price;
  final double rating;
  final int lessons;
  final bool bestSeller;

  const _CourseCard({
    required this.image,
    required this.title,
    required this.tutor,
    required this.price,
    required this.rating,
    required this.lessons,
    this.bestSeller = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      margin: const EdgeInsets.only(right: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 9,
            spreadRadius: 2,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
            child: Image.network(
              image,
              height: 108,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (bestSeller)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Color(0xFFFFD700).withOpacity(0.22),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "Best Seller",
                      style: TextStyle(
                        color: Color(0xFFE9B200),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                if (bestSeller) SizedBox(height: 4),
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.star, size: 16, color: Color(0xFFF9A825)),
                    SizedBox(width: 3),
                    Text(rating.toString(), style: TextStyle(fontWeight: FontWeight.w600)),
                    SizedBox(width: 8),
                    Text("$lessons Lessons", style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  tutor,
                  style: TextStyle(
                    color: Color(0xFF1877F2),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  price,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MentorCard extends StatelessWidget {
  final String image;
  final String name;
  final String label;
  const _MentorCard({
    required this.image,
    required this.name,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 88,
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(image),
            radius: 28,
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: 0,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Color(0xFF1877F2),
      unselectedItemColor: Colors.grey,
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.play_circle), label: "My Course"),
        BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: "Bookmark"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
      ],
    );
  }
}
