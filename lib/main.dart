import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
    "assets/icons/sun.png",
    "assets/icons/note.png",
    "assets/icons/jar.png",
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

        children: const [
          CenterPage(title: 'Home', color: Colors.white),
          CenterPage(title: 'Search', color: Colors.pinkAccent),
          CenterPage(title: 'Profile', color: Colors.lightGreenAccent),
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
          Color color = i == _currentIndex? Colors.blue : Colors.black;
          return Material(
            color: Colors.transparent,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _onNavTapped(i);
                });
              },
              child: SingleChildScrollView(
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
                      child: ImageIcon(
                        AssetImage(icon),
                        color: color,
                        size: 24,
                      ),
                    ),
                    Text (
                      _navName[i],
                      style: TextStyle(
                        color: color,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(
                      height: 24,
                    ),
                  ] 
                ),
              ),
            )
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
