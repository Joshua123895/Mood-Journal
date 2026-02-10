import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); 

  // Lock the app to portrait mode (both up and down).
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyApp());
}

/// Root of the app
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainPage(),
    );
  }
}

/// Main screen with bottom navbar + sliding pages
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;
  final List<String> _navIcons = [
    "assets/icons/sun.svg",
    "assets/icons/journal.svg",
    "assets/icons/jar.svg",
  ];
  final List<String> _navName = ["Home", "Journal", "Mood"];
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNavTapped(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      // ===== MIDDLE CONTENT =====
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },

        children: [
          CenterPage(title: 'Home', color: Colors.white),
          CenterPage(title: 'Search', color: Colors.pinkAccent),
          MoodPage(),
        ],
      ),

      bottomNavigationBar: _navBar(),
    );
  }

  Widget _navBar() {
    return Container(
      height: 72,
      margin: EdgeInsets.only(
        left: 24, 
        right: 24, 
        bottom: MediaQuery.of(context).padding.bottom + 12,
      ),
      decoration: BoxDecoration(
        color: Color(0xFFF5F6FA), 
        // color: Colors.grey.shade50,
        // color: Colors.redAccent,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: _navIcons.map((icon) {
          final int i = _navIcons.indexOf(icon);
          bool isActive = i == _currentIndex;
          Color color = isActive? Colors.blue : Colors.black;
          return Expanded (
            child: Material (
              color: Colors.transparent,
              child: InkWell(
                onTap: () => _onNavTapped(i),
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                hoverColor: Colors.transparent,
                borderRadius: BorderRadius.circular(24),
                child: SizedBox.expand(
                  child: Column(
                    children: [
                      Container (
                        alignment: Alignment.center,
                        margin: const EdgeInsets.only(
                          left: 32,
                          right: 32,
                          bottom: 0,
                          top: 16,
                        ),
                        child: SvgPicture.asset(
                          icon,
                          width: 24,
                          height: 24,
                          colorFilter: ColorFilter.mode(
                            color,
                            BlendMode.srcIn
                          ),
                        ),
                      ),
                      // SvgPicture.asset(
                      //   icon,
                      //   width: 24,
                      //   height: 24,
                      //   colorFilter: ColorFilter.mode(
                      //     color,
                      //     BlendMode.srcIn
                      //   ),
                      // ),
                      Text (
                        _navName[i],
                        style: TextStyle(
                          color: color,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      // SizedBox(
                      //   height: 18,
                      // ),
                    ] 
                  ),
                ),
              )
            ),
          );
        }).toList()
      ),
    );
  }
}

/// Reusable centered page widget
class CenterPage extends StatelessWidget {
  final String title;
  final Color color;

  const CenterPage({
    super.key,
    required this.title,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color.withValues(alpha: 0.1),
      alignment: Alignment.center,
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 36,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class MoodPage extends StatelessWidget {
  const MoodPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // // ===== JAR IMAGE ===== (error)
        // Image.asset(
        //   "assets/images/jar.png",
        //   height: 120,
        // ),
        // ===== BUTTONS =====
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              // Image.asset(
              //   "assets/image/jar.png",
              //   height: 240,
              // ),
              ElevatedButton(
                onPressed: () {
                  _openOverlay(context);
                },
                // onPressed: () {},
                child: const Text("Add Mood +"),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {},
                child: const Text("History"),
              ),
            ],
          ),
        ),

        SizedBox(
          height: MediaQuery.of(context).padding.bottom + 108,
        ),
      ],
    );
  }
  // void _openOverlay(BuildContext context) {
  //   if (!context.mounted) return;

  //   Navigator.of(context, rootNavigator: true).push(
  //     PageRouteBuilder(
  //       opaque: false,
  //       barrierColor: Colors.black.withOpacity(0.4),
  //       pageBuilder: (_, __, ___) => const MoodOverlayPage(),
  //     ),
  //   );
  // }
  void _openOverlay(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false, // 👈 allows transparency
        barrierColor: Colors.black.withAlpha(120),
        pageBuilder: (_, _, _) => const MoodOverlayPage(),
        transitionsBuilder: (_, animation, _, child) {
          final offsetTween = Tween(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).chain(CurveTween(curve: Curves.easeOut));

          return SlideTransition(
            position: animation.drive(offsetTween),
            child: child,
          );
        },
      ),
    );
  }
}

class MoodOverlayPage extends StatelessWidget {
  const MoodOverlayPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ===== HEADER =====
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Text(
                    "What's going on inside?",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const Divider(),

            // ===== CONTENT =====
            Expanded(
              child: Center(
                child: Text(
                  "Mood input goes here",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}