import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:thenotes/pages/explore_page.dart';
import 'package:thenotes/pages/search.dart';
import 'package:thenotes/pages/welcome_page.dart';

class HomePage extends StatefulWidget {
  static String id = "Homepage";
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Widget> _pages = [
    const SearchPage(),
    const WelcomePage(),
    const ExplorePage(),
  ];

  int _selectedIndex = 1;

  final controller = PageController(initialPage: 1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.black,
      body: PageView(
        controller: controller,
        onPageChanged: (value) {
          setState(() {
            _selectedIndex = value;
          });
        },
        children: [
          const SearchPage(),
          const WelcomePage(),
          const ExplorePage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
            controller.animateToPage(_selectedIndex,
                duration: Duration(milliseconds: 500), curve: Curves.ease);
          });
        },
        backgroundColor: const Color.fromARGB(255, 20, 19, 19),
        selectedItemColor: const Color.fromARGB(255, 247, 11, 58),
        unselectedItemColor: Colors.white,
        showSelectedLabels: true,
        showUnselectedLabels: false,
        items: [
          BottomNavigationBarItem(
            icon: Icon(_selectedIndex == 0
                ? Iconsax.search_normal
                : Iconsax.search_normal),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(_selectedIndex == 1 ? Iconsax.home5 : Iconsax.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(_selectedIndex == 2
                ? Iconsax.flash_circle5
                : Iconsax.flash_circle),
            label: 'Explore',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 247, 11, 58),
        onPressed: () {
          Navigator.pushNamed(context, 'Upload');
        },
        child: const Icon(Iconsax.folder_add5),
      ),
    );
  }
}
