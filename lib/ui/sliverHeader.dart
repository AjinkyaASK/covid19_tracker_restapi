import 'package:coronavirus_tracker_global/app/methods/themeManager.dart';
import 'package:coronavirus_tracker_global/styles/colors.dart';
import 'package:coronavirus_tracker_global/ui/banners.dart';
import 'package:flutter/material.dart';

class Choice {
  const Choice({this.title, this.icon});

  final String title;
  final IconData icon;
}

class CustomSliverHeaderDelegate extends SliverPersistentHeaderDelegate {
  BuildContext context;

  CustomSliverHeaderDelegate({@required this.context});

  List<Choice> choices = const <Choice>[
    const Choice(title: 'Settings', icon: Icons.settings),
    const Choice(title: 'Logout', icon: Icons.exit_to_app),
  ];

  void onItemMenuPress(Choice choice) {
    switch (choice.title) {
      case 'Item 1':
        //Perform some actions
        break;

      case 'Item 2':
        //Perform some actions
        break;

      default:
        //showSnackBar('Unknown Choice');
        break;
    }
  }

  @override
  double get maxExtent => 266;

  @override
  double get minExtent => 60 + MediaQuery.of(context).padding.top;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    double opacityFactorFeed =
        ((maxExtent - (shrinkOffset + shrinkOffset / 1.5)) / maxExtent);
    double opacityFactor = opacityFactorFeed >= 0 ? opacityFactorFeed : 0;

    //print(scaleFactor);

    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Container(
          color:
              themeProvider.theme ? primaryGreenColorDark : primaryGreenColor,
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 60,
            child: Opacity(
                opacity: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    //Container(),
                    IconButton(
                      padding: EdgeInsets.all(10),
                      icon: Icon(
                        Icons.wb_sunny,
                        size: 30,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        themeProvider.toggleTheme();
                      },
                    ),
                    Text(
                      'Coronavirus Tracker',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    // PopupMenuButton<Choice>(
                    //   //color: Colors.white,
                    //   onSelected: onItemMenuPress,
                    //   icon: Icon(
                    //     Icons.more_horiz,
                    //     size: 30,
                    //     color: Colors.white,
                    //   ),
                    //   itemBuilder: (BuildContext context) {
                    //     return choices.map((Choice choice) {
                    //       return PopupMenuItem<Choice>(
                    //         value: choice,
                    //         child: Row(
                    //           children: <Widget>[
                    //             Icon(
                    //               choice.icon,
                    //               color: Colors.black.withOpacity(0.8),
                    //             ),
                    //             Container(
                    //               width: 10,
                    //             ),
                    //             Text(
                    //               choice.title,
                    //               style: TextStyle(
                    //                 color: Colors.black,
                    //               ),
                    //             )
                    //           ],
                    //         ),
                    //       );
                    //     }).toList();
                    //   },
                    // )
                    Container(),
                  ],
                )),
            margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          ),
        ),
        Opacity(
          opacity:
              opacityFactor * opacityFactor * opacityFactor * opacityFactor,
          child: Container(
            margin: EdgeInsets.only(top: 96),
            padding: EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: themeProvider.theme
                  ? primaryGreenColorDark
                  : primaryGreenColor,
              // boxShadow: [
              //   BoxShadow(
              //       color: CustomColors(dark: isDarkTheme)
              //           .shadowColor
              //           .withOpacity(0.35),
              //       offset: Offset(0, 12),
              //       blurRadius: 20),
              // ],
            ),
            child: buildHelpCard(context),
          ),
        ),
      ],
    );
  }

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}

class CustomSliverHeaderWidget extends StatelessWidget {
  final BuildContext context;
  CustomSliverHeaderWidget({Key key, this.context}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      floating: true,
      delegate: CustomSliverHeaderDelegate(context: context),
    );
  }
}
