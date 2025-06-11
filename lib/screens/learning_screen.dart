import 'package:flutter/material.dart';
import '../theme_colors.dart';

class LearningScreen extends StatefulWidget {
  final RiseiTheme riseiTheme;
  const LearningScreen({super.key, required this.riseiTheme});

  @override
  State<LearningScreen> createState() => _LearningScreenState();
}

class _LearningScreenState extends State<LearningScreen> {
  String selectedCategory = "All";
  String searchQuery = "";

  final List<Map<String, dynamic>> categories = [
    {"label": "All", "icon": Icons.grid_view},
    {"label": "Art", "icon": Icons.palette},
    {"label": "Coding", "icon": Icons.code},
    {"label": "Marketing", "icon": Icons.campaign},
    {"label": "Business", "icon": Icons.business_center},
    {"label": "Science", "icon": Icons.science},
    {"label": "Maths", "icon": Icons.calculate},
    {"label": "English", "icon": Icons.language},
    {"label": "Accounting", "icon": Icons.account_balance},
  ];

  final List<Map<String, dynamic>> courses = [
    {
      "image": "assets/images/design_thinking_fundamentals.jpg", // Local asset for Design Thinking Fundamentals
      "title": "Design Thinking Fundamental",
      "tutor": "Robert Green",
      "price": "\$180",
      "rating": 4.8,
      "lessons": 32,
      "bestSeller": true,
      "category": "Art",
    },
    {
      "image": "https://images.unsplash.com/photo-1503676382389-4809596d5290?auto=format&fit=crop&w=400&q=80",
      "title": "3D Illustration Design",
      "tutor": "John Doe",
      "price": "\$250",
      "rating": 4.9,
      "lessons": 24,
      "bestSeller": false,
      "category": "Art",
    },
    {
      "image": "https://images.unsplash.com/photo-1461749280684-dccba630e2f6?auto=format&fit=crop&w=400&q=80",
      "title": "Flutter Coding Bootcamp",
      "tutor": "Jenny Fox",
      "price": "\$99",
      "rating": 4.7,
      "lessons": 20,
      "bestSeller": true,
      "category": "Coding",
    },
    {
      "image": "https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=400&q=80",
      "title": "Digital Marketing 101",
      "tutor": "Albert Smith",
      "price": "\$120",
      "rating": 4.6,
      "lessons": 18,
      "bestSeller": false,
      "category": "Marketing",
    },
  ];

  final List<Map<String, dynamic>> mentors = [
    {
      "image": "https://randomuser.me/api/portraits/men/11.jpg",
      "name": "Robert Green",
      "label": "Design Tutor",
      "category": "Art",
    },
    {
      "image": "https://randomuser.me/api/portraits/women/25.jpg",
      "name": "Jenny Fox",
      "label": "Coding Tutor",
      "category": "Coding",
    },
    {
      "image": "https://randomuser.me/api/portraits/men/32.jpg",
      "name": "John Doe",
      "label": "Marketing Tutor",
      "category": "Marketing",
    },
    {
      "image": "https://randomuser.me/api/portraits/men/44.jpg",
      "name": "Albert Smith",
      "label": "Business Mentor",
      "category": "Business",
    },
  ];

  List<Map<String, dynamic>> get filteredCourses {
    List<Map<String, dynamic>> list = selectedCategory == "All"
        ? courses
        : courses.where((c) => c["category"] == selectedCategory).toList();
    if (searchQuery.trim().isNotEmpty) {
      list = list
          .where((c) =>
              (c["title"] as String).toLowerCase().contains(searchQuery.toLowerCase()) ||
              (c["tutor"] as String).toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
    }
    return list;
  }

  List<Map<String, dynamic>> get filteredMentors {
    List<Map<String, dynamic>> list = selectedCategory == "All"
        ? mentors
        : mentors.where((m) => m["category"] == selectedCategory).toList();
    if (searchQuery.trim().isNotEmpty) {
      list = list
          .where((m) =>
              (m["name"] as String).toLowerCase().contains(searchQuery.toLowerCase()) ||
              (m["label"] as String).toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.riseiTheme;

    return Container(
      decoration: BoxDecoration(
        gradient: theme.backgroundGradient,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              // Header
              Material(
                color: Colors.transparent,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "Hi, ",
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: theme.textWhite,
                                  ),
                                ),
                                Text(
                                  "There 👋",
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: theme.accentBlue,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              "Let's start learning!",
                              style: TextStyle(
                                fontSize: 15,
                                color: theme.textFaint,
                              ),
                            ),
                          ],
                        ),
                      ),
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 22,
                        child: Icon(Icons.notifications, color: theme.accentBlue),
                      ),
                    ],
                  ),
                ),
              ),
              // Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: theme.backgroundGradient.colors[0],
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12.withOpacity(0.04),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.search, color: theme.textFaint),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: "Search",
                            border: InputBorder.none,
                            isDense: true,
                            hintStyle: TextStyle(color: theme.textFaint),
                          ),
                          style: TextStyle(fontSize: 16, color: theme.textWhite),
                          onChanged: (value) {
                            setState(() {
                              searchQuery = value;
                            });
                          },
                        ),
                      ),
                      Icon(Icons.tune, color: theme.accentBlue),
                    ],
                  ),
                ),
              ),
              // Expanded content: All scrollable, no overflow possible
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Categories
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Categories",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: theme.textWhite,
                              ),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: Text(
                                "See all",
                                style: TextStyle(
                                  color: theme.accentBlue,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 80,
                        child: ListView(
                          padding: const EdgeInsets.only(left: 20, right: 8),
                          scrollDirection: Axis.horizontal,
                          children: categories.map((cat) {
                            final isSelected = selectedCategory == cat["label"];
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedCategory = cat["label"];
                                });
                              },
                              child: Container(
                                margin: const EdgeInsets.only(right: 14),
                                padding: const EdgeInsets.symmetric(horizontal: 2),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Flexible(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: isSelected
                                              ? theme.accentBlue
                                              : theme.backgroundGradient.colors[0],
                                          borderRadius: BorderRadius.circular(16),
                                          boxShadow: isSelected
                                              ? [
                                                  BoxShadow(
                                                    color: theme.accentBlue.withOpacity(0.12),
                                                    blurRadius: 8,
                                                    offset: Offset(0, 3),
                                                  )
                                                ]
                                              : null,
                                        ),
                                        padding: const EdgeInsets.all(14),
                                        child: Icon(
                                          cat["icon"],
                                          size: 26,
                                          color: isSelected
                                              ? Colors.white
                                              : theme.accentBlue,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      cat["label"],
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13,
                                        color: isSelected
                                            ? theme.accentBlue
                                            : theme.textWhite,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      // --- Redesigned Popular Course Section ---
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 22, 20, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Popular Course",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: theme.textWhite,
                              ),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: Text(
                                "See all",
                                style: TextStyle(
                                  color: theme.accentBlue,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Polished, non-overflowing cards
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4),
                        child: SizedBox(
                          height: 180,
                          child: filteredCourses.isEmpty
                              ? Center(child: Text("No courses found", style: TextStyle(color: theme.textFaint)))
                              : ListView.separated(
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  scrollDirection: Axis.horizontal,
                                  itemCount: filteredCourses.length,
                                  separatorBuilder: (_, __) => const SizedBox(width: 18),
                                  itemBuilder: (context, idx) {
                                    final course = filteredCourses[idx];
                                    return _PolishedCourseCard(
                                      image: course["image"],
                                      title: course["title"],
                                      tutor: course["tutor"],
                                      price: course["price"],
                                      rating: course["rating"],
                                      lessons: course["lessons"],
                                      bestSeller: course["bestSeller"] ?? false,
                                      theme: theme,
                                    );
                                  },
                                ),
                        ),
                      ),
                      // Mentor Section
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 22, 20, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Top Mentor",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: theme.textWhite,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 98,
                        child: filteredMentors.isEmpty
                            ? Center(child: Text("No mentors found", style: TextStyle(color: theme.textFaint)))
                            : ListView(
                                padding: const EdgeInsets.only(left: 20, right: 8),
                                scrollDirection: Axis.horizontal,
                                children: filteredMentors.map((mentor) {
                                  return _MentorCard(
                                    image: mentor["image"],
                                    name: mentor["name"],
                                    label: mentor["label"],
                                    theme: theme,
                                  );
                                }).toList(),
                              ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PolishedCourseCard extends StatelessWidget {
  final String image;
  final String title;
  final String tutor;
  final String price;
  final double rating;
  final int lessons;
  final bool bestSeller;
  final RiseiTheme theme;

  const _PolishedCourseCard({
    required this.image,
    required this.title,
    required this.tutor,
    required this.price,
    required this.rating,
    required this.lessons,
    required this.bestSeller,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final isAsset = image.startsWith('assets/');
    return Container(
      width: 210,
      height: 180,
      decoration: BoxDecoration(
        color: theme.backgroundGradient.colors[0],
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cover image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: isAsset
                ? Image.asset(
                    image,
                    height: 100,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  )
                : Image.network(
                    image,
                    height: 100,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 100,
                      color: Colors.grey.shade300,
                      child: Icon(Icons.image, color: Colors.grey, size: 30),
                    ),
                  ),
          ),
          // The fix: Wrap the details in Expanded + SingleChildScrollView to avoid overflow
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(7.0),
              child: SingleChildScrollView(
                physics: NeverScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (bestSeller)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 1),
                        decoration: BoxDecoration(
                          color: theme.accentYellow.withOpacity(0.22),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          "Best Seller",
                          style: TextStyle(
                            color: theme.accentYellow,
                            fontWeight: FontWeight.bold,
                            fontSize: 9,
                          ),
                        ),
                      ),
                    if (bestSeller) const SizedBox(height: 2),
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: theme.textWhite,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      tutor,
                      style: TextStyle(
                        color: theme.accentBlue,
                        fontWeight: FontWeight.w500,
                        fontSize: 10,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      children: [
                        Icon(Icons.star, size: 11, color: theme.accentYellow),
                        const SizedBox(width: 2),
                        Text(
                          rating.toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: theme.accentYellow,
                            fontSize: 10,
                          ),
                        ),
                        const SizedBox(width: 7),
                        Icon(Icons.play_circle_fill, size: 11, color: theme.accentBlue),
                        const SizedBox(width: 2),
                        Text(
                          "$lessons lessons",
                          style: TextStyle(
                            color: theme.textFaint,
                            fontSize: 9,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      price,
                      style: TextStyle(
                        color: theme.textWhite,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
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
  final RiseiTheme theme;
  const _MentorCard({
    required this.image,
    required this.name,
    required this.label,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 88,
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: CircleAvatar(
              radius: 28,
              backgroundColor: theme.backgroundGradient.colors[0],
              child: ClipOval(
                child: Image.network(
                  image,
                  fit: BoxFit.cover,
                  width: 56,
                  height: 56,
                  errorBuilder: (context, error, stackTrace) =>
                      Icon(Icons.person, size: 40, color: theme.textFaint),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Flexible(
            child: Text(
              name,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: theme.textWhite),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Flexible(
            child: Text(
              label,
              style: TextStyle(fontSize: 12, color: theme.textFaint),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
