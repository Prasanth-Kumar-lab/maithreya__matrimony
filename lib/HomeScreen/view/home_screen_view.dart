/*
import 'package:animate_do/animate_do.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_swipecards/flutter_swipecards.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:lottie/lottie.dart';
import 'package:matrimony/UserProfile/controller/userProfile_controller.dart';
import 'package:matrimony/UserProfile/view/UsersProfile.dart';
import 'package:matrimony/constants/constants.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../MatchPage/view/match_page.dart';
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

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {

  late HomeController _controller;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  bool _isGridView = false;
  late ScrollController _scrollController;
  bool _showBottomBar = true;
  String? _loadingUserId;


  late AnimationController _closeAnimController;
  late AnimationController _favoriteAnimController;
  late AnimationController _starAnimController;

  void _viewUserProfile(String userId) async {
    setState(() {
      _loadingUserId = userId;
    });
    final userProfile = await _controller.fetchMyProfile(userId);
    setState(() {
      _loadingUserId = null;
    });
    if (userProfile != null) {
      Get.to(() => UsersProfileScreen(user: userProfile));
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
    _controller = Get.put(HomeController(userId: widget.userId));
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();

    _closeAnimController = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    _favoriteAnimController = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    _starAnimController = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));

    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);

    _initializeAndSyncDeviceToken();
  }
  Future<void> _initializeAndSyncDeviceToken() async {
    try {
      final FirebaseMessaging messaging = FirebaseMessaging.instance;
      String? token = await messaging.getToken();
      if (token != null) {
        print("Current device token: $token");
        await _updateDeviceToken(token);
      }

      // Continuously listen for token refresh
      FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
        print("Device token refreshed: $newToken");
        await _updateDeviceToken(newToken);
      });
    } catch (e) {
      print("Error initializing FCM token: $e");
    }
  }

  Future<void> _updateDeviceToken(String token) async {
    try {
      // Fetch current user profile
      final fetchedProfile = await _controller.fetchMyProfile(widget.userId);

      if (fetchedProfile == null) {
        print("Could not fetch user profile to update token.");
        return;
      }

      // Initialize controller safely
      final profileController = Get.put(MyProfileController(fetchedProfile), tag: fetchedProfile.userId);

      // Ensure device_token list exists and is of type List<String>
      List<String> tokens = [];
      if (fetchedProfile.deviceToken != null && fetchedProfile.deviceToken is List) {
        tokens = List<String>.from(fetchedProfile.deviceToken!);
      }

      // Only add new token if it's not already in the list
      if (!tokens.contains(token)) {
        tokens.add(token);
        print("\u{1F4F1}Updating device token: $tokens");

        await profileController.updateProfile({
          'user_id': fetchedProfile.userId,
          'name': fetchedProfile.name,
          'age': fetchedProfile.age,
          'gender': fetchedProfile.gender,
          'date_of_birth': fetchedProfile.dateOfBirth,
          'device_token': tokens,
        });
      } else {
        print("Token already exists in the list, no update needed.");
      }
    } catch (e) {
      print("Failed to update device token: $e");
    }
  }


  @override
  void dispose() {
    _scrollController.dispose();
    _animationController.dispose();
    _closeAnimController.dispose();
    _favoriteAnimController.dispose();
    _starAnimController.dispose();
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.indigo.withOpacity(0.5),
                  child: IconButton(
                    icon: Icon(Icons.favorite_border, color: AppColors.iconColor),
                    tooltip: 'Favorites',
                    onPressed: () {
                      // Navigate using controller’s currentUserId
                      Get.to(() => MatchesScreen(userId: _controller.currentUserId));
                    },
                  ),
                ),
                Positioned(
                  top: 6,
                  right: 6,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                  ),
                ),
              ],
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
          content = const Center(child: Text(''));//No users found
        } else {
          content = Column(
            children: [
              const SizedBox(height: 6),
              Expanded(
                child: Stack(
                  children: [
                    _isGridView
                        ? _buildGridView()
                        : Column(
                      children: [
                        Expanded(child: _buildSwipeCardView(MediaQuery.of(context).size)),
                        if (!_isGridView) _buildActionButtons(),
                      ],
                    ),
                  ],
                ),
              ),
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
                  child: Lottie.asset(LottieAssets.fetchingProfile, height: 120, width: 120),
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
      maxHeight: size.height * 0.99,
      maxWidth: size.width,
      minHeight: size.height * 0.55,
      minWidth: size.width * 0.9,
      orientation: AmassOrientation.top,
      totalNum: _controller.users.length,
      stackNum: 2,
      swipeUp: true,
      swipeDown: true,
      swipeUpdateCallback: (DragUpdateDetails details, Alignment align) {
        // Reset all controllers to 0.0 first (prevents lingering from prior drags)
        _closeAnimController.value = 0.0;
        _favoriteAnimController.value = 0.0;
        _starAnimController.value = 0.0;

        // Threshold for detecting meaningful direction (adjust for sensitivity; 0.1 ~10% of card width/height)
        const double directionThreshold = 0.1;
        double progress = 0.0;

        // Detect direction and set progress based on alignment (normalized -1 to 1)
        if (align.x < -directionThreshold) {
          // Left swipe (close)
          progress = (-align.x).clamp(0.0, 1.0);
          _closeAnimController.value = progress;
        } else if (align.x > directionThreshold) {
          // Right swipe (star/like)
          progress = align.x.clamp(0.0, 1.0);
          _starAnimController.value = progress;
        } else if (align.y < -directionThreshold) {
          // Up swipe (favorite)
          progress = (-align.y).clamp(0.0, 1.0);
          _favoriteAnimController.value = progress;
        } else if (align.y > directionThreshold) {
          // Down swipe (no animation)
          progress = align.y.clamp(0.0, 1.0);
          // Optionally add a down controller here if needed
        }
        // Tiny movements (< threshold) keep all at 0.0 (no animation)
      },
      cardBuilder: (context, index) {
        final user = _controller.users[index];
        // Removed _controller.currentIndex.value = index to avoid build-time updates
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
        // Update cardIndex after swipe (separate from tab index)
        if (index < _controller.users.length - 1) {
          _controller.cardIndex.value = index + 1;
        } else {
          _controller.cardIndex.value = 0; // Reset to start if at the end
        }
        // Trigger completion animations based on swipe orientation
        switch (orientation) {
          case CardSwipeOrientation.left:
            _closeAnimController.value = 1.0;
            _closeAnimController.reverse();
            break;
          case CardSwipeOrientation.right:
            _starAnimController.value = 1.0;
            _starAnimController.reverse();
            break;
          case CardSwipeOrientation.up:
            _favoriteAnimController.value = 1.0;
            _favoriteAnimController.reverse();
            break;
          case CardSwipeOrientation.down:
          // No animation for down swipe
            break;
          case CardSwipeOrientation.recover:
          // Optional: Add recovery behavior if needed
            break;
        }
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
                'assets/default.jpg',
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
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                            user.name,
                            style: AppColors.swipeGridCardsTextStyle
                        ),
                        Text(
                            ', ${user.age}',
                            style: AppColors.swipeGridCardsTextStyle
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.white70, size: 16),
                        SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            user.location,
                            style: AppColors.swipeGridCardsSubTextStyle,
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
                  child: Lottie.asset(LottieAssets.fetchingProfile, height: 120, width: 120),
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
            tabBackgroundColor: AppColors.tabBackgroundColorbtmNavBar!,
            color: Colors.grey[600],
            tabs: [
              _buildGButton(Icons.home, 'Home', 0),
              _buildGButton(Icons.favorite, 'Matches', 1),
              _buildGButton(Icons.person, 'Profile', 2),
              _buildGButton(Icons.workspace_premium, 'Upgrade', 3),
            ],
            selectedIndex: _controller.selectedTabIndex.value,
            onTabChange: (index) async {
              if (index == 2) {
                // Profile tab index (now index 2 since Messages was removed)
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
                _controller.setSelectedTabIndex(index);
              }
            },
          )),
        ),
      ),
    );
  }

  GButton _buildGButton(IconData icon, String text, int index) {
    bool isSelected = _controller.selectedTabIndex.value == index;
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
                  'assets/default.jpg',
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
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                            user.name,
                            style: AppColors.swipeGridCardsTextStyle
                        )
                            .animate(onPlay: (controller) => controller.repeat())
                            .shimmer(
                          duration: 2500.ms,
                          color: Colors.black,
                        ),
                        Text(
                            ', ${user.age}',
                            style: AppColors.swipeGridCardsTextStyle
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined, color: Colors.white70, size: 16),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            user.location,
                            style: AppColors.swipeGridCardsSubTextStyle,
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
            if (isLoading)
              Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Lottie.asset(LottieAssets.fetchingProfile, height: 120, width: 120),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    final Gradient commonGradient = LinearGradient(
      colors: [Color(0xFF667EEA), Color(0xFF764BA2)], // Violet-Blue gradient
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildPremiumActionButton(
            icon: ActionButtonIcons.closeIcon,
            gradient: commonGradient,
            onTap: _controller.swipeLeft,
            iconColor: ActionButtonIcons.majorActionButtonColors,
            badge: null,
            size: 60,
            animController: _closeAnimController,
          ),
          _buildPremiumActionButton(
            icon: ActionButtonIcons.refreshIcon,
            gradient: commonGradient,
            onTap: () async {
              await _controller.fetchUserProfiles(); // Refresh user profiles
            },
            iconColor: ActionButtonIcons.minorActionButtonColors,
            badge: null,
            size: 50,
            animController: null,
          ),
          _buildPremiumActionButton(
            icon: ActionButtonIcons.favouriteIcon,
            gradient: commonGradient,
            onTap: _controller.swipeUp,
            iconColor: ActionButtonIcons.majorActionButtonColors,
            badge: null,
            size: 70,
            animController: _favoriteAnimController,
          ),
          _buildPremiumActionButton(
            icon: ActionButtonIcons.sendIcon,
            gradient: commonGradient,
            onTap: () => _controller.launchMessaging(),
            iconColor: ActionButtonIcons.minorActionButtonColors,
            badge: null,
            size: 50,
            animController: null,
          ),
          _buildPremiumActionButton(
            icon: ActionButtonIcons.callIcon,
            gradient: commonGradient,
            onTap: () => _controller.launchCall(),
            iconColor: ActionButtonIcons.majorActionButtonColors,
            badge: null,
            size: 60,
            animController: null,
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumActionButton({
    required IconData icon,
    required Gradient gradient,
    String? label, // Made optional
    required VoidCallback onTap,
    required Color iconColor,
    required Widget? badge,
    required double size,
    AnimationController? animController,
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
                  if (animController != null)
                    AnimatedBuilder(
                      animation: animController,
                      builder: (context, child) {
                        final scaleValue =
                            Tween<double>(begin: 1.0, end: 1.5).animate(animController).value;
                        final colorValue = ColorTween(
                          begin: iconColor,
                          end: Colors.green,
                        ).animate(animController).value;
                        return Transform.scale(
                          scale: scaleValue,
                          child: Icon(
                            icon,
                            color: colorValue,
                            size: 28,
                          ),
                        );
                      },
                    )
                  else
                    Icon(
                      icon,
                      color: iconColor,
                      size: 28,
                    ),
                  if (label != null) ...[
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
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
*/
import 'package:animate_do/animate_do.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_swipecards/flutter_swipecards.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:lottie/lottie.dart';
import 'package:matrimony/UserProfile/controller/userProfile_controller.dart';
import 'package:matrimony/UserProfile/view/UsersProfile.dart';
import 'package:matrimony/constants/constants.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../MatchPage/view/match_page.dart';
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
class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late HomeController _controller;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  bool _isGridView = false;
  late ScrollController _scrollController;
  bool _showBottomBar = true;
  String? _loadingUserId;
  late AnimationController _closeAnimController;
  late AnimationController _favoriteAnimController;
  late AnimationController _starAnimController;
  String _searchQuery = '';
  late TextEditingController _searchController;
  bool _isFavoriteAnimating = false;

  void _viewUserProfile(String userId) async {
    setState(() {
      _loadingUserId = userId;
    });
    final userProfile = await _controller.fetchMyProfile(userId);
    setState(() {
      _loadingUserId = null;
    });
    if (userProfile != null) {
      Get.to(() => UsersProfileScreen(user: userProfile));
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
    _controller = Get.put(HomeController(userId: widget.userId));
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
    _closeAnimController = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    _favoriteAnimController = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    _starAnimController = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    _searchController = TextEditingController();
    _initializeAndSyncDeviceToken();
  }
  Future<void> _initializeAndSyncDeviceToken() async {
    try {
      final FirebaseMessaging messaging = FirebaseMessaging.instance;
      String? token = await messaging.getToken();
      if (token != null) {
        print("Current device token: $token");
        await _updateDeviceToken(token);
      }
      // Continuously listen for token refresh
      FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
        print("Device token refreshed: $newToken");
        await _updateDeviceToken(newToken);
      });
    } catch (e) {
      print("Error initializing FCM token: $e");
    }
  }
  Future<void> _updateDeviceToken(String token) async {
    try {
      // Fetch current user profile
      final fetchedProfile = await _controller.fetchMyProfile(widget.userId);
      if (fetchedProfile == null) {
        print("Could not fetch user profile to update token.");
        return;
      }
      // Initialize controller safely
      final profileController = Get.put(MyProfileController(fetchedProfile), tag: fetchedProfile.userId);
      // Ensure device_token list exists and is of type List<String>
      List<String> tokens = [];
      if (fetchedProfile.deviceToken != null && fetchedProfile.deviceToken is List) {
        tokens = List<String>.from(fetchedProfile.deviceToken!);
      }
      // Only add new token if it's not already in the list
      if (!tokens.contains(token)) {
        tokens.add(token);
        print("\u{1F4F1}Updating device token: $tokens");
        await profileController.updateProfile({
          'user_id': fetchedProfile.userId,
          'name': fetchedProfile.name,
          'age': fetchedProfile.age,
          'gender': fetchedProfile.gender,
          'date_of_birth': fetchedProfile.dateOfBirth,
          'device_token': tokens,
        });
      } else {
        print("Token already exists in the list, no update needed.");
      }
    } catch (e) {
      print("Failed to update device token: $e");
    }
  }
  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _animationController.dispose();
    _closeAnimController.dispose();
    _favoriteAnimController.dispose();
    _starAnimController.dispose();
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
            'Maithreya',
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
                    if (!_isGridView) {
                      _searchQuery = '';
                      _searchController.clear();
                    }
                  });
                },
              ),
            ),
          ),
          /*Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.indigo.withOpacity(0.5),
                  child: IconButton(
                    icon: Icon(Icons.favorite_border, color: AppColors.iconColor),
                    tooltip: 'Favorites',
                    onPressed: () {
                      // Navigate using controller’s currentUserId
                      Get.to(() => MatchesScreen(userId: _controller.currentUserId));
                    },
                  ),
                ),
                Positioned(
                  top: 6,
                  right: 6,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                  ),
                ),
              ],
            ),
          ),*/
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
          content = const Center(child: Text(''));//No users found
        } else {
          content = Column(
            children: [
              const SizedBox(height: 6),
              Expanded(
                child: Stack(
                  children: [
                    _isGridView
                        ? _buildGridViewWithSearch()
                        : Column(
                      children: [
                        Expanded(child: _buildSwipeCardView(MediaQuery.of(context).size)),
                        if (!_isGridView) _buildActionButtons(),
                      ],
                    ),
                  ],
                ),
              ),
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
                  child: Lottie.asset(LottieAssets.fetchingProfile, height: 120, width: 120),
                ),
              ),
          ],
        );
      }),
    );
  }
  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(horizontal: 12),
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
        decoration: InputDecoration(
          hintText: 'Search by age, location, profession, qualification...',
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
            icon: const Icon(Icons.clear, color: Colors.grey),
            onPressed: () {
              _searchController.clear();
              setState(() {
                _searchQuery = '';
              });
            },
          )
              : null,
          hintStyle: const TextStyle(color: Colors.grey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
          ),
          filled: true,
          fillColor: Colors.white.withOpacity(0.9),
        ),
      ),
    );
  }
  Widget _buildGridViewWithSearch() {
    final filteredUsers = _controller.users.where((user) {
      if (_searchQuery.isEmpty) return true;
      final query = _searchQuery.toLowerCase();
      return user.age.toString().contains(_searchQuery) ||
          user.location.toLowerCase().contains(query) ||
          user.profession.toLowerCase().contains(query) ||
          user.qualification.toLowerCase().contains(query);
    }).toList();
    return Column(
      children: [
        _buildSearchBar(),
        Expanded(
          child: _buildGridView(filteredUsers),
        ),
      ],
    );
  }
  Widget _buildSwipeCardView(Size size) {
    return TinderSwapCard(
      cardController: _controller.cardController,
      maxHeight: size.height * 0.99,
      maxWidth: size.width,
      minHeight: size.height * 0.55,
      minWidth: size.width * 0.9,
      orientation: AmassOrientation.top,
      totalNum: _controller.users.length,
      stackNum: 2,
      swipeUp: true,
      swipeDown: true,
      swipeUpdateCallback: (DragUpdateDetails details, Alignment align) {
        // Reset all controllers to 0.0 first (prevents lingering from prior drags)
        _closeAnimController.value = 0.0;
        _favoriteAnimController.value = 0.0;
        _starAnimController.value = 0.0;
        // Threshold for detecting meaningful direction (adjust for sensitivity; 0.1 ~10% of card width/height)
        const double directionThreshold = 0.1;
        double progress = 0.0;
        // Detect direction and set progress based on alignment (normalized -1 to 1)
        if (align.x < -directionThreshold) {
          // Left swipe (close)
          progress = (-align.x).clamp(0.0, 1.0);
          _closeAnimController.value = progress;
        } else if (align.x > directionThreshold) {
          // Right swipe (star/like)
          progress = align.x.clamp(0.0, 1.0);
          _starAnimController.value = progress;
        } else if (align.y < -directionThreshold) {
          // Up swipe (favorite)
          progress = (-align.y).clamp(0.0, 1.0);
          _favoriteAnimController.value = progress;
        } else if (align.y > directionThreshold) {
          // Down swipe (no animation)
          progress = align.y.clamp(0.0, 1.0);
          // Optionally add a down controller here if needed
        }
        // Tiny movements (< threshold) keep all at 0.0 (no animation)
      },
      cardBuilder: (context, index) {
        final user = _controller.users[index];
        // Removed _controller.currentIndex.value = index to avoid build-time updates
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
        // Update cardIndex after swipe (separate from tab index)
        if (index < _controller.users.length - 1) {
          _controller.cardIndex.value = index + 1;
        } else {
          _controller.cardIndex.value = 0; // Reset to start if at the end
        }
        // Trigger completion animations based on swipe orientation
        switch (orientation) {
          case CardSwipeOrientation.left:
            _closeAnimController.value = 1.0;
            _closeAnimController.reverse();
            break;
          case CardSwipeOrientation.right:
            _starAnimController.value = 1.0;
            _starAnimController.reverse();
            break;
          case CardSwipeOrientation.up:
            _favoriteAnimController.value = 1.0;
            _favoriteAnimController.reverse();
            break;
          case CardSwipeOrientation.down:
          // No animation for down swipe
            break;
          case CardSwipeOrientation.recover:
          // Optional: Add recovery behavior if needed
            break;
        }
      },
    );
  }
  Widget _buildGridView(List<UserProfiles> users) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12).copyWith(bottom: 5),
      child: AnimationLimiter(
        child: GridView.builder(
          controller: _scrollController,
          itemCount: users.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 0.75,
          ),
          itemBuilder: (context, index) {
            final user = users[index];
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
                'assets/default.jpg',
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
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                            user.name,
                            style: AppColors.swipeGridCardsTextStyle
                        ),
                        Text(
                            ', ${user.age}',
                            style: AppColors.swipeGridCardsTextStyle
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.white70, size: 16),
                        SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            user.location,
                            style: AppColors.swipeGridCardsSubTextStyle,
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
                  child: Lottie.asset(LottieAssets.fetchingProfile, height: 120, width: 120),
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
            tabBackgroundColor: AppColors.tabBackgroundColorbtmNavBar!,
            color: Colors.grey[600],
            tabs: [
              _buildGButton(Icons.home, 'Home', 0),
              _buildGButton(Icons.favorite, 'Matches', 1),
              _buildGButton(Icons.person, 'Profile', 2),
              _buildGButton(Icons.workspace_premium, 'Upgrade', 3),
            ],
            selectedIndex: _controller.selectedTabIndex.value,
            onTabChange: (index) async {
              if (index == 2) {
                // Profile tab index (now index 2 since Messages was removed)
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
                _controller.setSelectedTabIndex(index);
              }
            },
          )),
        ),
      ),
    );
  }
  GButton _buildGButton(IconData icon, String text, int index) {
    bool isSelected = _controller.selectedTabIndex.value == index;
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
                  'assets/default.jpg',
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
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                            user.name,
                            style: AppColors.swipeGridCardsTextStyle
                        )
                            .animate(onPlay: (controller) => controller.repeat())
                            .shimmer(
                          duration: 2500.ms,
                          color: Colors.black,
                        ),
                        Text(
                            ', ${user.age}',
                            style: AppColors.swipeGridCardsTextStyle
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined, color: Colors.white70, size: 16),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            user.location,
                            style: AppColors.swipeGridCardsSubTextStyle,
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
            if (isLoading)
              Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Lottie.asset(LottieAssets.fetchingProfile, height: 120, width: 120),
                ),
              ),
          ],
        ),
      ),
    );
  }
  Widget _buildActionButtons() {
    final Gradient commonGradient = const LinearGradient(
      colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildPremiumActionButton(
            icon: ActionButtonIcons.closeIcon,
            gradient: commonGradient,
            onTap: _controller.swipeLeft,
            iconColor: ActionButtonIcons.majorActionButtonColors,
            badge: null,
            size: 60,
          ),
          _buildPremiumActionButton(
            icon: ActionButtonIcons.refreshIcon,
            gradient: commonGradient,
            onTap: () async {
              await _controller.fetchUserProfiles();
            },
            iconColor: ActionButtonIcons.minorActionButtonColors,
            badge: null,
            size: 50,
          ),
          // ❤️ Favourite button with Lottie animation
          _buildPremiumActionButton(
            icon: ActionButtonIcons.favouriteIcon,
            gradient: commonGradient,
            onTap: () async {
              setState(() => _isFavoriteAnimating = true);
              _controller.swipeUp();

              // Wait for animation to finish before hiding Lottie
              await Future.delayed(const Duration(seconds: 2));
              if (mounted) setState(() => _isFavoriteAnimating = false);
            },
            iconColor: ActionButtonIcons.majorActionButtonColors,
            badge: null,
            size: 70,
            showLottie: _isFavoriteAnimating,
            lottieAsset: 'assets/like (2).json', // path to your Lottie file
          ),
          _buildPremiumActionButton(
            icon: ActionButtonIcons.sendIcon,
            gradient: commonGradient,
            onTap: () => _controller.launchMessaging(),
            iconColor: ActionButtonIcons.minorActionButtonColors,
            badge: null,
            size: 50,
          ),
          _buildPremiumActionButton(
            icon: ActionButtonIcons.callIcon,
            gradient: commonGradient,
            onTap: () => _controller.launchCall(),
            iconColor: ActionButtonIcons.majorActionButtonColors,
            badge: null,
            size: 60,
          ),
        ],
      ),
    );
  }
  Widget _buildPremiumActionButton({
    required IconData icon,
    required Gradient gradient,
    String? label,
    required VoidCallback onTap,
    required Color iconColor,
    required Widget? badge,
    required double size,
    bool showLottie = false,
    String? lottieAsset,
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
              child: showLottie && lottieAsset != null
                  ? Lottie.asset(
                lottieAsset,
                repeat: false,
                fit: BoxFit.cover,
              )
                  : Icon(
                icon,
                color: iconColor,
                size: 28,
              ),
            ),
          ),
        ),
        if (label != null) ...[
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.1,
            ),
          ),
        ],
      ],
    );
  }
}
