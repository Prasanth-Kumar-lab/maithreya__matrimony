/*
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_swipecards/flutter_swipecards.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:matrimony/constants/constants.dart';
import '../controller/home_screen_controller.dart';
import '../model/home_screen_model.dart';
import 'package:flutter_animate/flutter_animate.dart';

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
  late ScrollController _scrollController;
  bool _showBottomBar = true;


  @override
  void initState() {
    super.initState();
    _controller = Get.find<HomeController>();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();

// Add scroll listener
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }


  @override
  void dispose() {
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }
  void _onScroll() {
    if (!_isGridView) return; // Only handle scroll when grid view is active

    if (_scrollController.position.userScrollDirection == ScrollDirection.reverse) {
      if (_showBottomBar) {
        setState(() {
          _showBottomBar = false;
        });
      }
    } else if (_scrollController.position.userScrollDirection == ScrollDirection.forward) {
      if (!_showBottomBar) {
        setState(() {
          _showBottomBar = true;
        });
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: [Colors.black, Colors.black],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
            blendMode: BlendMode.srcIn,
            child: Text(
              'Jeevan Saathiya',
              style: GoogleFonts.abyssinicaSil(
                fontSize: 23,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.2,
              ),
            )
        ).animate(onPlay: (controller) => controller.repeat()).shimmer(
          duration: 2000.ms,
          color: Colors.white,
        ),
        backgroundColor: AppColors.bgThemeColor,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: CircleAvatar(
              backgroundColor: Colors.indigo.withOpacity(0.5),
              child: IconButton(
                icon: Icon(
                  _isGridView ? Icons.grid_view : Icons.repeat,
                  color: AppColors.iconColor,
                ),
                tooltip: _isGridView ? 'Swipe View' : 'Grid View',
                onPressed: () {
                  setState(() {
                    _isGridView = !_isGridView;
                  });
                },
              ),
            ),
          ),
        ],
      ),
      backgroundColor: AppColors.bgThemeColor,
      bottomNavigationBar: (!_isGridView || _showBottomBar)
          ? AnimatedSlide(
        offset: (!_showBottomBar && _isGridView) ? const Offset(0, 1) : Offset.zero,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        child: AnimatedOpacity(
          opacity: (!_showBottomBar && _isGridView) ? 0.0 : 1.0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: _buildBottomNavBar(),
        ),
      )
          : null, // removes bottomNavigationBar space completely

      body: Column(
        children: [
          const SizedBox(height: 6),
          Expanded(
            flex: 6,
            child: _isGridView ? _buildGridView() : _buildSwipeCardView(size),
          ),
          if (!_isGridView) ...[
            _buildActionButtons(),
            const SizedBox(height: 0),
          ],
          if (!_isGridView) SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildSwipeCardView(Size size) {
    return TinderSwapCard(
      cardController: _controller.cardController,
      maxHeight: size.height * 0.60,
      maxWidth: size.width,
      minHeight: size.height * 0.55,
      minWidth: size.width * 0.8,
      orientation: AmassOrientation.top,
      totalNum: _controller.users.length,
      stackNum: 2,
      swipeUp: true,
      swipeDown: true,
      cardBuilder: (context, index) {
        final user = _controller.users[index];
        return AnimationConfiguration.staggeredList(
          position: index,
          duration: const Duration(milliseconds: 600),
          delay: const Duration(milliseconds: 150),
          child: SlideAnimation(
            verticalOffset: 50.0,
            child: FadeInAnimation(
              child: ScaleAnimation(
                scale: 0.9,
                child: _buildCard(user),
              ),
            ),
          ),
        );
      },
      swipeCompleteCallback: (CardSwipeOrientation orientation, int index) {
// Add logic here if needed
      },
    );
  }

  Widget _buildGridView() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12).copyWith(bottom: 5),
      child: AnimationLimiter(
        child: GridView.builder(
          controller: _scrollController, // << Add this line
          itemCount: _controller.users.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 0.75,
          ),
          itemBuilder: (context, index) {
            final user = _controller.users[index];
            return AnimationConfiguration.staggeredGrid(
              position: index,
              columnCount: 2,
              duration: const Duration(milliseconds: 600),
              delay: const Duration(milliseconds: 150),
              child: SlideAnimation(
                verticalOffset: 50.0,
                child: FadeInAnimation(
                  child: ScaleAnimation(
                    scale: 0.9,
                    child: _buildGridCard(user),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }


  Widget _buildGridCard(UserProfiles user) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(user.imagePath,
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
          ),
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
                          overflow: TextOverflow.ellipsis,
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
    return Container(
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
        child: Container(
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.symmetric(horizontal: 8),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.indigo.shade400,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                blurRadius: 10,
                spreadRadius: 1,
                color: Colors.black.withOpacity(0.05),
              ),
            ],
          ),
          child: Obx(() => GNav(
            gap: 4,
            activeColor: Colors.orange[800],
            iconSize: 24,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            duration: Duration(milliseconds: 500),
            tabBackgroundColor: Colors.white!,
            color: Colors.grey[600],
            tabs: [
              _buildGButton(Icons.home, 'Home', 0),
              _buildGButton(Icons.favorite, 'Matches', 1),
              _buildGButton(Icons.message_outlined, 'Messages', 2),
              _buildGButton(Icons.person, 'Profile', 3),
              _buildGButton(Icons.workspace_premium, 'Upgrade', 4),
            ],
            selectedIndex: _controller.currentIndex.value,
            onTabChange: (index) {
              _controller.setCurrentIndex(index);
            },
          )),
        ),
      ),
    );
  }

  GButton _buildGButton(IconData icon, String text, int index) {
    bool isSelected = _controller.currentIndex.value == index;

    Widget iconWidget = Icon(
      icon,
      size: 28,
      color: isSelected ? Colors.black : AppColors.iconColor,
    );

    return GButton(
      icon: icon,
      text: text,
      textStyle: TextStyle(
        color: AppColors.textColor,
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
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              user.imagePath,
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
            ),
          ),
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
          Positioned(
            left: 16,
            bottom: 0,
            right: 16,
            child: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
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
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined, color: Colors.white70, size: 16),
                      SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          user.location,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                          overflow: TextOverflow.ellipsis,
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
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.bgThemeColor.withOpacity(0.8),
              AppColors.bgThemeColor.withOpacity(0.95),
              AppColors.bgThemeColor,
            ],
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 20,
              spreadRadius: 2,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildPremiumActionButton(
                icon: Icons.close_rounded,
                gradient: LinearGradient(
                  colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                ),
                label: 'Pass',
                onTap: _controller.swipeLeft,
                iconColor: Colors.white,
                badge: null,
                size: 60,  // smaller size
              ),
              _buildPremiumActionButton(
                icon: Icons.favorite_rounded,
                gradient: LinearGradient(
                  colors: [Color(0xFFF5576C), Color(0xFFF093FB)],
                ),
                label: 'Like',
                onTap: _controller.swipeRight,
                iconColor: Colors.white,
                badge: null,
                size: 70,  // increased size
              ),
              _buildPremiumActionButton(
                icon: Icons.star_rounded,
                gradient: LinearGradient(
                  colors: [Color(0xFFFFD200), Color(0xFFF7971E)],
                ),
                label: 'Shortlist',
                onTap: _controller.swipeUp,
                iconColor: Colors.white,
                badge: null,
                size: 60,  // smaller size
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildPremiumActionButton({
    required IconData icon,
    required Gradient gradient,
    required String label,
    required VoidCallback onTap,
    required Color iconColor,
    required Widget? badge,
    required double size,  // new size parameter
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: gradient.colors.first.withOpacity(0.4),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
              width: 1.5,
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(20),
              splashColor: Colors.white.withOpacity(0.2),
              highlightColor: Colors.white.withOpacity(0.1),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, color: iconColor, size: 28),
                  const SizedBox(height: 4),
                  Text(
                    label,
                    style: TextStyle(
                      color: AppColors.textColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

}*/
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_swipecards/flutter_swipecards.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:lottie/lottie.dart';
import 'package:matrimony/constants/constants.dart';
import '../../UserProfile/view/user_profile_view.dart';
import '../controller/home_screen_controller.dart';
import '../model/home_screen_model.dart';
import 'package:flutter_animate/flutter_animate.dart';

class HomeScreen extends StatefulWidget {
  final String userId;
  const HomeScreen({Key? key, required this.userId}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late HomeController _controller;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  bool _isGridView = false;
  late ScrollController _scrollController;
  bool _showBottomBar = true;
  String? _loadingUserId;

  void _viewUserProfile(String userId) async {
    setState(() {
      _loadingUserId = userId;
    });

    final userProfile = await _controller.fetchMyProfile(userId);

    setState(() {
      _loadingUserId = null;
    });

    if (userProfile != null) {
      Get.to(() => MyProfileScreen(user: userProfile));
    } else {
      Get.snackbar(
        "Error",
        "Failed to load profile.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }



  @override
  void initState() {
    super.initState();
    _controller = Get.find<HomeController>();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();

    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_isGridView) return;

    if (_scrollController.position.userScrollDirection == ScrollDirection.reverse) {
      if (_showBottomBar) {
        setState(() {
          _showBottomBar = false;
        });
      }
    } else if (_scrollController.position.userScrollDirection == ScrollDirection.forward) {
      if (!_showBottomBar) {
        setState(() {
          _showBottomBar = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: [Colors.black, Colors.black],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
          blendMode: BlendMode.srcIn,
          child: Text(
            'Jeevan Saathiya',
            style: GoogleFonts.abyssinicaSil(
              fontSize: 23,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 1.2,
            ),
          ),
        ).animate(onPlay: (controller) => controller.repeat()).shimmer(
          duration: 2000.ms,
          color: Colors.white,
        ),
        backgroundColor: AppColors.bgThemeColor,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          //Text('User Id: ${widget.userId}'),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: CircleAvatar(
              backgroundColor: Colors.indigo.withOpacity(0.5),
              child: IconButton(
                icon: Icon(
                  _isGridView ? Icons.grid_view : Icons.repeat,
                  color: AppColors.iconColor,
                ),
                tooltip: _isGridView ? 'Swipe View' : 'Grid View',
                onPressed: () {
                  setState(() {
                    _isGridView = !_isGridView;
                  });
                },
              ),
            ),
          ),
        ],
      ),
      backgroundColor: AppColors.bgThemeColor,
      bottomNavigationBar: (!_isGridView || _showBottomBar)
          ? AnimatedSlide(
        offset: (!_showBottomBar && _isGridView) ? const Offset(0, 1) : Offset.zero,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        child: AnimatedOpacity(
          opacity: (!_showBottomBar && _isGridView) ? 0.0 : 1.0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: _buildBottomNavBar(),
        ),
      )
          : null,
      body: Obx(() {
        Widget content;

        if (_controller.isLoading.value) {
          content = const Center(child: CircularProgressIndicator());
        } else if (_controller.errorMessage.value.isNotEmpty) {
          content = Center(child: Text(_controller.errorMessage.value));
        } else if (_controller.users.isEmpty) {
          content = const Center(child: Text('No users found'));
        } else {
          content = Column(
            children: [
              const SizedBox(height: 6),
              Expanded(
                flex: 6,
                child: _isGridView ? _buildGridView() : _buildSwipeCardView(MediaQuery.of(context).size),
              ),
              if (!_isGridView) ...[
                _buildActionButtons(),
                const SizedBox(height: 0),
                SizedBox(height: 30),
              ],
            ],
          );
        }

        return Stack(
          children: [
            content,

            // Loader when tapping "Profile" from bottom nav
            if (_loadingUserId == "profileTab")
              Container(
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: Lottie.asset('assets/fetching.json', height: 120, width: 120),
                ),
              ),
          ],
        );
      }),
    );
  }

  Widget _buildSwipeCardView(Size size) {
    return TinderSwapCard(
      cardController: _controller.cardController,
      maxHeight: size.height * 0.60,
      maxWidth: size.width,
      minHeight: size.height * 0.55,
      minWidth: size.width * 0.8,
      orientation: AmassOrientation.top,
      totalNum: _controller.users.length,
      stackNum: 2,
      swipeUp: true,
      swipeDown: true,
      cardBuilder: (context, index) {
        final user = _controller.users[index];
        return AnimationConfiguration.staggeredList(
          position: index,
          duration: const Duration(milliseconds: 600),
          delay: const Duration(milliseconds: 150),
          child: SlideAnimation(
            verticalOffset: 50.0,
            child: FadeInAnimation(
              child: ScaleAnimation(
                scale: 0.9,
                child: _buildCard(user),
              ),
            ),
          ),
        );
      },
      swipeCompleteCallback: (CardSwipeOrientation orientation, int index) {
        // Add logic here if needed
      },
    );
  }

  Widget _buildGridView() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12).copyWith(bottom: 5),
      child: AnimationLimiter(
        child: GridView.builder(
          controller: _scrollController,
          itemCount: _controller.users.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 0.75,
          ),
          itemBuilder: (context, index) {
            final user = _controller.users[index];
            return AnimationConfiguration.staggeredGrid(
              position: index,
              columnCount: 2,
              duration: const Duration(milliseconds: 600),
              delay: const Duration(milliseconds: 150),
              child: SlideAnimation(
                verticalOffset: 50.0,
                child: FadeInAnimation(
                  child: ScaleAnimation(
                    scale: 0.9,
                    child: _buildGridCard(user),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildGridCard(UserProfiles user) {
    final isLoading = _loadingUserId == user.userId;

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: GestureDetector(
        onTap: () => _viewUserProfile(user.userId),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              user.image,
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
              errorBuilder: (context, error, stackTrace) => Image.asset(
                'assets/placeholder.jpg',
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              ),
            ),
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
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            /// Loader overlay when tapping
            if (isLoading)
              Container(
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: Lottie.asset('assets/fetching.json', height: 120, width: 120),
                ),
              ),
          ],
        ),
      ),
    );
  }


  Widget _buildBottomNavBar() {
    Size size = MediaQuery.of(context).size;
    return Container(
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
        child: Container(
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.symmetric(horizontal: 8),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.indigo.shade400,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                blurRadius: 10,
                spreadRadius: 1,
                color: Colors.black.withOpacity(0.05),
              ),
            ],
          ),
          child: Obx(() => GNav(
            gap: 4,
            activeColor: Colors.orange[800],
            iconSize: 24,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            duration: Duration(milliseconds: 500),
            tabBackgroundColor: Colors.white!,
            color: Colors.grey[600],
            tabs: [
              _buildGButton(Icons.home, 'Home', 0),
              _buildGButton(Icons.favorite, 'Matches', 1),
              _buildGButton(Icons.message_outlined, 'Messages', 2),
              _buildGButton(Icons.person, 'Profile', 3),
              _buildGButton(Icons.workspace_premium, 'Upgrade', 4),
            ],
            selectedIndex: _controller.currentIndex.value,
            onTabChange: (index) async {
              if (index == 3) {
                // Profile tab index
                setState(() {
                  _loadingUserId = "profileTab";
                });

                // Simulate loading or fetch user profile logic
                final userProfile = await _controller.fetchMyProfile(widget.userId);

                setState(() {
                  _loadingUserId = null;
                });

                if (userProfile != null) {
                  Get.to(() => MyProfileScreen(user: userProfile));
                } else {
                  Get.snackbar(
                    "Error",
                    "Failed to load profile.",
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.redAccent,
                    colorText: Colors.white,
                  );
                }
              } else {
                _controller.setCurrentIndex(index);
              }
            },
          )),
        ),
      ),
    );
  }

  GButton _buildGButton(IconData icon, String text, int index) {
    bool isSelected = _controller.currentIndex.value == index;

    Widget iconWidget = Icon(
      icon,
      size: 28,
      color: isSelected ? Colors.black : AppColors.iconColor,
    );

    return GButton(
      icon: icon,
      text: text,
      textStyle: TextStyle(
        color: AppColors.textColor,
        fontWeight: FontWeight.w600,
      ),
      leading: ZoomIn(
        child: iconWidget,
      ),
    );
  }

  Widget _buildCard(UserProfiles user) {
    final isLoading = _loadingUserId == user.userId;

    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: GestureDetector(
        onTap: () => _viewUserProfile(user.userId),
        child: Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                user.image,
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
                errorBuilder: (context, error, stackTrace) => Image.asset(
                  'assets/placeholder.jpg',
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                ),
              ),
            ),
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
            Positioned(
              left: 16,
              bottom: 0,
              right: 70, // Space for profile button
              child: Container(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${user.name}, ${user.age}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined, color: Colors.white70, size: 16),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            user.location,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // View Profile Button
            Positioned(
              bottom: 12,
              right: 12,
              child: GestureDetector(
                onTap: () => _viewUserProfile(user.userId),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Text(
                    "Profile",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ).animate(onPlay: (controller) => controller)
                    .shimmer(duration: 2000.ms, color: Colors.white),
              ),
            ),

            /// Loading Indicator Overlay
            if (isLoading)
              Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Lottie.asset('assets/fetching.json', height: 120, width: 120),
                ),
              ),
          ],
        ),
      ),
    );
  }



  Widget _buildActionButtons() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.bgThemeColor.withOpacity(0.8),
              AppColors.bgThemeColor.withOpacity(0.95),
              AppColors.bgThemeColor,
            ],
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 20,
              spreadRadius: 2,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildPremiumActionButton(
                icon: Icons.close_rounded,
                gradient: LinearGradient(
                  colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                ),
                label: 'Pass',
                onTap: _controller.swipeLeft,
                iconColor: Colors.white,
                badge: null,
                size: 60,
              ),
              _buildPremiumActionButton(
                icon: Icons.favorite_rounded,
                gradient: LinearGradient(
                  colors: [Color(0xFFF5576C), Color(0xFFF093FB)],
                ),
                label: 'Like',
                onTap: _controller.swipeRight,
                iconColor: Colors.white,
                badge: null,
                size: 70,
              ),
              _buildPremiumActionButton(
                icon: Icons.star_rounded,
                gradient: LinearGradient(
                  colors: [Color(0xFFFFD200), Color(0xFFF7971E)],
                ),
                label: 'Shortlist',
                onTap: _controller.swipeUp,
                iconColor: Colors.white,
                badge: null,
                size: 60,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPremiumActionButton({
    required IconData icon,
    required Gradient gradient,
    required String label,
    required VoidCallback onTap,
    required Color iconColor,
    required Widget? badge,
    required double size,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: gradient.colors.first.withOpacity(0.4),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
              width: 1.5,
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(20),
              splashColor: Colors.white.withOpacity(0.2),
              highlightColor: Colors.white.withOpacity(0.1),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, color: iconColor, size: 28),
                  const SizedBox(height: 4),
                  Text(
                    label,
                    style: TextStyle(
                      color: AppColors.textColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}