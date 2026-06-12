import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'mood/mood.dart' show MoodPage;
import 'home/home.dart' show HomePage;
import 'journal/journal.dart' show JournalPage;
import 'settings/settings_page.dart';
import 'services/mood_service_instance.dart';
import 'services/notification_service.dart';
import 'theme/app_constants.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
	WidgetsFlutterBinding.ensureInitialized(); 

	// Lock the app to portrait mode (both up and down).
	await SystemChrome.setPreferredOrientations([
		DeviceOrientation.portraitUp,
		DeviceOrientation.portraitDown,
	]);

	await moodService.init();
	await NotificationService().init();

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

class _NavItem {
	final String? svgPath;
	final IconData? materialIcon;
	final String label;

	const _NavItem({this.svgPath, this.materialIcon, required this.label});
}

/// Main screen with bottom navbar + sliding pages
class MainPage extends StatefulWidget {
	const MainPage({super.key});

	@override
	State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
	int _currentIndex = 0;
	final ValueNotifier<DateTime?> _journalTargetDate = ValueNotifier(null);

	static const _navItems = [
		_NavItem(svgPath: "assets/icons/sun.svg", label: "Home"),
		_NavItem(svgPath: "assets/icons/journal.svg", label: "Journal"),
		_NavItem(svgPath: "assets/icons/jar.svg", label: "Mood"),
		_NavItem(materialIcon: Icons.person_outline, label: "Account"),
	];

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

	void _navigateToJournal(DateTime date) {
		_journalTargetDate.value = date;
		_onNavTapped(1);
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
			backgroundColor: Colors.white,
			body: PageView(
				controller: _pageController,
				onPageChanged: (index) => setState(() => _currentIndex = index),
				children: [
					HomePage(onNavigateToJournal: _navigateToJournal),
					JournalPage(journalTargetDate: _journalTargetDate),
					MoodPage(),
					const SettingsPage(),
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
				color: Colors.white,
				borderRadius: BorderRadius.circular(Radii.xl),
				boxShadow: [
					BoxShadow(
						color: Colors.black.withValues(alpha: 0.08),
						blurRadius: 16,
						offset: const Offset(0, -2),
					),
				],
			),
			child: Row(
				crossAxisAlignment: CrossAxisAlignment.start,
				mainAxisAlignment: MainAxisAlignment.spaceEvenly,
				children: _navItems.asMap().entries.map((e) {
					final i = e.key;
					final item = e.value;
					final bool isActive = i == _currentIndex;
					final Color color = isActive ? Colors.black : Colors.grey.shade400;
					return Expanded(
						child: Material(
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
											Container(
												alignment: Alignment.center,
												margin: const EdgeInsets.only(
													left: Insets.xxl,
													right: Insets.xxl,
													bottom: 0,
													top: Insets.lg,
												),
												child: item.svgPath != null
														? SvgPicture.asset(
																item.svgPath!,
																width: Sizes.navIcon,
																height: Sizes.navIcon,
																colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
															)
														: Icon(item.materialIcon, color: color, size: Sizes.navIcon),
											),
											Text(
												item.label,
												style: TextStyle(
													color: color,
													fontSize: FontSizes.sm,
													fontWeight: FontWeights.medium,
												),
											),
										],
									),
								),
							),
						),
					);
				}).toList(),
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
