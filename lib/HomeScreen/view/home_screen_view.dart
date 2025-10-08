import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_swipecards/flutter_swipecards.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:matrimony/HomeScreen/model/home_screen_model.dart';

import '../controller/home_screen_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late HomeController _controller;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  bool _isGridView = false;

  @override
  void initState() {
    super.initState();
    _controller = HomeController();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Discover',
          style: TextStyle(color: Colors.orange[800], fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.orange[100],
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list, color: Colors.orange),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(
              _isGridView ? Icons.grid_view : Icons.view_carousel_outlined,
              color: Colors.orange,
            ),
            tooltip: _isGridView ? 'Swipe View' : 'Grid View',
            onPressed: () {
              setState(() {
                _isGridView = !_isGridView;
              });
            },
          ),
        ],
      ),
      backgroundColor: Colors.grey[100],
      bottomNavigationBar: _buildBottomNavBar(),
      body: Column(
        children: [
          SizedBox(height: 6,),
          Expanded(
            flex: 6,
            child: _isGridView ? _buildGridView() : _buildSwipeCardView(size),
          ),

          SizedBox(height: 20),
          if (!_isGridView) ...[
            SizedBox(height: 20),
            _buildActionButtons(),
            SizedBox(height: 20),
          ],
          SizedBox(height: 20),
        ],
      ),
    );
  }
  Widget _buildSwipeCardView(Size size) {
    return TinderSwapCard(
      cardController: _controller.cardController,
      maxHeight: size.height * 0.75,
      maxWidth: size.width,
      minHeight: size.height * 0.65,
      minWidth: size.width * 0.8,
      orientation: AmassOrientation.top,
      totalNum: _controller.users.length,
      stackNum: 2,
      swipeUp: true,
      swipeDown: true,
      cardBuilder: (context, index) {
        final user = _controller.users[index];
        return _buildCard(user);
      },
      swipeCompleteCallback: (CardSwipeOrientation orientation, int index) {
        // Add logic here if needed
      },
    );
  }
  Widget _buildGridView() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: GridView.builder(
        itemCount: _controller.users.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 0.75,
        ),
        itemBuilder: (context, index) {
          final user = _controller.users[index];
          return _buildGridCard(user);
        },
      ),
    );
  }
  Widget _buildGridCard(UserProfiles user) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(user.imagePath, fit: BoxFit.cover),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.center,
                colors: [Colors.black.withOpacity(0.6), Colors.transparent],
              ),
            ),
          ),
          Positioned(
            left: 0,
            bottom: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.blueAccent.withOpacity(0.8),
                    Colors.black.withOpacity(0.3),
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${user.name}, ${user.age}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                      .animate(onPlay: (controller) => controller.repeat())
                      .shimmer(
                    duration: 1600.ms,
                    color: Colors.orangeAccent,
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.white70, size: 16),
                      SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          user.location,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                          overflow: TextOverflow.ellipsis, // In case the location is too long
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }



  Widget _buildBottomNavBar() {
    Size size = MediaQuery.of(context).size;
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.transparent,
              boxShadow: [
                BoxShadow(
                  blurRadius: 15,
                  spreadRadius: 2,
                  color: Colors.black.withOpacity(0.1),
                ),
              ],
            ),
            child: SafeArea(
              child: BounceInUp(
                duration: const Duration(milliseconds: 600),
                child: Container(
                  width: size.width, // Ensure it takes full width
                  margin: const EdgeInsets.symmetric(horizontal: 8), // Reduced padding
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.orange[100],
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 10,
                        spreadRadius: 1,
                        color: Colors.black.withOpacity(0.05),
                      ),
                    ],
                  ),
                  child: GNav(
                    gap: 4, // Reduced gap between icon and text
                    activeColor: Colors.orange[800],
                    iconSize: 24,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    duration: const Duration(milliseconds: 500),
                    tabBackgroundColor: Colors.orange[300]!,
                    color: Colors.grey[600],
                    tabs: [
                      _buildGButton(Icons.home, 'Home', 0),
                      _buildGButton(Icons.favorite, 'Matches', 1),
                      _buildGButton(Icons.message_outlined, 'Messages', 2),
                      _buildGButton(Icons.person, 'Profile', 3),
                      _buildGButton(Icons.workspace_premium, 'Upgrade', 4),
                    ],
                    selectedIndex: _controller.currentIndex,
                    onTabChange: (index) {
                      setState(() {
                        _controller.setCurrentIndex(index);
                        _animationController.reset();
                        _animationController.forward();
                      });
                    },
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }


  GButton _buildGButton(IconData icon, String text, int index) {
    bool isSelected = _controller.currentIndex == index;

    Widget iconWidget = Icon(
      icon,
      size: 28,
      color: isSelected ? Colors.orange[800] : Colors.grey[600],
    );

    // Apply shimmer only if selected
    if (isSelected) {
      iconWidget = iconWidget
          .animate(onPlay: (controller) => controller.repeat(),)
          .shimmer(duration: 1200.ms, color: Colors.black);
    }

    return GButton(
      icon: icon,
      text: text,
      textStyle: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w600,
      ),
      leading: ZoomIn(
        child: iconWidget,
      ),
    );
  }


  Widget _buildCard(UserProfiles user) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              user.imagePath,
              fit: BoxFit.cover,
            ),
          ),

          // Gradient overlay (optional for readability)
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.center,
                colors: [Colors.black.withOpacity(0.4), Colors.transparent],
              ),
            ),
          ),

          // Blue semi-transparent container at the bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 80,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.blueAccent.withOpacity(0.8),
                    Colors.black.withOpacity(0.3),
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
            ),
          ),

          // Text content container
          Positioned(
            left: 16,
            bottom: 0,
            right: 16,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                //color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${user.name}, ${user.age}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                      .animate(onPlay: (controller) => controller.repeat())
                      .shimmer(
                    duration: 1700.ms,
                    color: Colors.orangeAccent,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.white70, size: 16),
                      SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          user.location,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                          overflow: TextOverflow.ellipsis, // In case the location is too long
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _actionButton(Icons.close, Colors.blueAccent, _controller.swipeLeft),
        _actionButton(Icons.favorite, Colors.orange, _controller.swipeRight, size: 80),
        _actionButton(Icons.star, Colors.purple, _controller.swipeUp),
      ],
    );
  }

  Widget _actionButton(IconData icon, Color color, VoidCallback onTap, {double size = 60}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          color: color.withOpacity(0.9),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(color: color.withOpacity(0.4), blurRadius: 10, offset: Offset(0, 4)),
          ],
        ),
        child: Icon(icon, color: Colors.white, size: size / 2),
      ),
    );
  }
}
