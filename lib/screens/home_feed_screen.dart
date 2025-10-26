// home_feed_screen.dart
// Main feed: stories, filter, AI suggestions, and main video list.
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/story_widget.dart';
import '../widgets/food_video_card.dart';
import '../widgets/filter_widget.dart';
import '../services/ai_suggestions_service.dart';
import 'cart_screen.dart';
import 'profile_screen.dart';
import 'orders_screen.dart';
import 'search_screen.dart';

class HomeFeedScreen extends StatefulWidget {
  @override
  _HomeFeedScreenState createState() => _HomeFeedScreenState();
}

class _HomeFeedScreenState extends State<HomeFeedScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser;

  // Filters state
  String _searchText = '';
  String? _vegFilterSelected;
  double _minPriceFilter = 0;
  double _maxPriceFilter = 1000;

  List<Map<String, dynamic>> _suggestedDishes = [];

  @override
  void initState() {
    super.initState();
    // Load AI suggestions for logged in user (demo fallback if null)
    loadAISuggestions(user?.uid ?? 'demoUserId');
  }

  void loadAISuggestions(String userId) async {
    final ai = AISuggestionService();
    _suggestedDishes = await ai.getSuggestions(userId);
    setState(() {});
  }

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      buildFeedPage(),
      SearchScreen(),
      Container(child: Center(child: Text('Explore'))),
      OrdersScreen(),
      ProfileScreen(),
    ];

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.trending_up), label: 'Explore'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: 'Orders'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.shopping_cart),
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CartScreen())),
      ),
    );
  }

  Widget buildFeedPage() {
    return SafeArea(
      child: Column(
        children: [
          FilterWidget(onApplyFilter: (searchText, vegFilter, minPrice, maxPrice) {
            setState(() {
              _searchText = (searchText ?? '').toLowerCase();
              _vegFilterSelected = vegFilter;
              _minPriceFilter = minPrice ?? 0;
              _maxPriceFilter = maxPrice ?? 1000;
            });
          }),
          // Stories
          Container(
            height: 100,
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('Shops').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
                final shops = snapshot.data!.docs;
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: shops.length,
                  itemBuilder: (context, index) {
                    final s = shops[index];
                    return StoryWidget(
                      shopName: s['name'] ?? 'Shop',
                      profilePic: s['profilePic'] ?? '',
                      isVerified: s['isVerified'] ?? false,
                      storyImages: List<String>.from(s['storyImages'] ?? []),
                    );
                  },
                );
              },
            ),
          ),

          // AI Suggestions horizontal
          if (_suggestedDishes.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Recommended for you', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Container(
                    height: 220,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _suggestedDishes.length,
                      itemBuilder: (context, index) {
                        final dish = _suggestedDishes[index];
                        return Container(
                          width: 180,
                          margin: EdgeInsets.symmetric(horizontal: 6),
                          child: FoodVideoCard(
                            shopName: dish['shopName'] ?? 'Shop',
                            shopVerified: dish['shopVerified'] ?? false,
                            dishName: dish['name'] ?? 'Dish',
                            videoUrl: dish['videoUrl'] ?? '',
                            rating: (dish['rating'] ?? 0).toDouble(),
                            price: (dish['price'] ?? 0).toDouble(),
                            isVegetarian: dish['isVegetarian'] ?? false,
                            dishId: dish['id'] ?? '',
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

          // Feed list
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('Dishes').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
                final dishes = snapshot.data!.docs.map((d) {
                  final m = d.data() as Map<String, dynamic>;
                  m['id'] = d.id;
                  return m;
                }).toList();

                final filtered = dishes.where((dish) {
                  final name = (dish['name'] ?? '').toString().toLowerCase();
                  final shopName = (dish['shopName'] ?? '').toString().toLowerCase();

                  bool matchesSearch = _searchText.isEmpty || name.contains(_searchText) || shopName.contains(_searchText);
                  bool matchesVeg = _vegFilterSelected == null ||
                      (_vegFilterSelected == 'Veg' && (dish['isVegetarian'] ?? false)) ||
                      (_vegFilterSelected == 'Non-Veg' && !(dish['isVegetarian'] ?? false));
                  double price = (dish['price'] ?? 0).toDouble();
                  bool matchesPrice = price >= _minPriceFilter && price <= _maxPriceFilter;

                  return matchesSearch && matchesVeg && matchesPrice;
                }).toList();

                return ListView.builder(
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final dish = filtered[index];
                    return FoodVideoCard(
                      shopName: dish['shopName'] ?? 'Shop',
                      shopVerified: dish['shopVerified'] ?? false,
                      dishName: dish['name'] ?? 'Dish',
                      videoUrl: dish['videoUrl'] ?? '',
                      rating: (dish['rating'] ?? 0).toDouble(),
                      price: (dish['price'] ?? 0).toDouble(),
                      isVegetarian: dish['isVegetarian'] ?? false,
                      dishId: dish['id'] ?? '',
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
