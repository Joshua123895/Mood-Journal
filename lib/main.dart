import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'mood/mood.dart' show MoodPage;
import 'home/home.dart' show HomePage;
import 'journal/journal.dart' show JournalPage;
import 'services/mood_service_instance.dart';
import 'theme/app_constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); 

  // Lock the app to portrait mode (both up and down).
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await moodService.init();

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
          HomePage(),
          JournalPage(),
          MoodPage(),
        ],
      ),

      bottomNavigationBar: _navBar(),
    );
  }

  Widget _navBar() {
    return Container(
      height: Sizes.navBarHeight,
      margin: EdgeInsets.only(
        left: Insets.xl, 
        right: Insets.xl, 
        bottom: MediaQuery.of(context).padding.bottom + Insets.base,
      ),
      decoration: BoxDecoration(
        color: AppColors.navBar, 
        borderRadius: BorderRadius.circular(Radii.xl),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: _navIcons.map((icon) {
          final int i = _navIcons.indexOf(icon);
          bool isActive = i == _currentIndex;
          Color color = isActive ? Colors.blue : Colors.black;
          return Expanded (
            child: Material (
              color: Colors.transparent,
              child: InkWell(
                onTap: () => _onNavTapped(i),
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                hoverColor: Colors.transparent,
                borderRadius: BorderRadius.circular(Radii.lg),
                child: SizedBox.expand(
                  child: Column(
                    children: [
                      Container (
                        alignment: Alignment.center,
                        margin: const EdgeInsets.only(
                          left: Insets.xxl,
                          right: Insets.xxl,
                          bottom: 0,
                          top: Insets.lg,
                        ),
                        child: SvgPicture.asset(
                          icon,
                          width: Sizes.navIcon,
                          height: Sizes.navIcon,
                          colorFilter: ColorFilter.mode(
                            color,
                            BlendMode.srcIn
                          ),
                        ),
                      ),
                      Text (
                        _navName[i],
                        style: TextStyle(
                          color: color,
                          fontSize: FontSizes.sm,
                          fontWeight: FontWeights.medium,
                        ),
                      ),
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
          fontSize: FontSizes.hero,
          fontWeight: FontWeights.bold,
        ),
      ),
    );
  }
}
