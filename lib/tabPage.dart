import 'package:flutter/material.dart';
import 'package:local/Auth/Login/lognRiderPage.dart';
import 'package:local/Pages/homePageUser.dart';
import 'package:local/TabPage/history.dart';
import 'package:local/TabPage/profile.dart';

import 'TabPage/homepage.dart';


class TabPage extends StatefulWidget {
  const TabPage({Key? key}) : super(key: key);

  @override
  _TabPageState createState() => _TabPageState();
}

class _TabPageState extends State<TabPage> with SingleTickerProviderStateMixin {
  TabController? tabController;
  int selectedIndex = 0;

  onItemClicked(int index) {
    setState(() {
      selectedIndex = index;
      tabController!.index = selectedIndex;
    });
  }

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  final int _selectedItem = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: tabController,
        children:  [
          HomeTabPage(),
          HistoryPage(),
          ProfilePage()
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.black, borderRadius: BorderRadius.circular(20)),
          child: CustomBottomNavigationBar(
            iconList: const [
              Icons.home,
              Icons.brightness_5_outlined,
              Icons.person,
            ],
            onChange: (index) {
              setState(() {
                selectedIndex = index;
                tabController!.index = selectedIndex;
              });
            },
          ),
        ),
      ),
    );
  }
}

class CustomBottomNavigationBar extends StatefulWidget {
  final int defaultSelectedIndex;

  final Function(int) onChange;
  final List<IconData> iconList;

  const CustomBottomNavigationBar(
      {this.defaultSelectedIndex = 0,
        required this.iconList,
        required this.onChange});

  @override
  _CustomBottomNavigationBarState createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  int _selectedIndex = 0;
  List<IconData> _iconList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _selectedIndex = widget.defaultSelectedIndex;
    _iconList = widget.iconList;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _navBarItemList = [];

    for (var i = 0; i < _iconList.length; i++) {
      _navBarItemList.add(buildNavBarItem(_iconList[i], i));
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: _navBarItemList,
    );
  }

  Widget buildNavBarItem(IconData icon, int index) {
    return GestureDetector(
      onTap: () {
        widget.onChange(index);
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Padding(
        padding:
        const EdgeInsets.only(left: 20.0, right: 20, bottom: 10, top: 10),
        // child: Container(
        //   height: 30,
        //   width: 32,
        //   decoration: index == _selectedIndex
        //       ? BoxDecoration(
        //           color: Colors.white,
        //           borderRadius: BorderRadius.circular(10),
        //           boxShadow: [
        //             BoxShadow(
        //               color: Colors.grey.shade500,
        //               offset: const Offset(4, 4),
        //               spreadRadius: 1,
        //               blurRadius: 2,
        //             ),
        //           ],
        //         )
        //       : BoxDecoration(
        //           color: Colors.white,
        //           borderRadius: BorderRadius.circular(15),
        //           boxShadow: [
        //             BoxShadow(
        //               color: Colors.blue.shade100,
        //               offset: const Offset(5, 8),
        //               spreadRadius: 1,
        //               blurRadius: 5,
        //             ),
        //           ],
        //         ),
        //   child: Icon(
        //     icon,
        //     color: index == _selectedIndex ? Colors.blue : Colors.grey,
        //   ),
        // ),
        child: Icon(
          icon,
          color: index == _selectedIndex ? Colors.yellow : Colors.yellow.shade100,
          size: 35,
        ),
      ),
    );
  }
}
