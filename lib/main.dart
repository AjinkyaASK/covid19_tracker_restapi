import 'dart:io';

import 'package:coronavirus_tracker_global/app/methods/localCache.dart';
import 'package:coronavirus_tracker_global/app/methods/themeManager.dart';
import 'package:coronavirus_tracker_global/app/services/api.dart';
import 'package:coronavirus_tracker_global/app/services/api_service.dart';
import 'package:coronavirus_tracker_global/styles/colors.dart';
import 'package:provider/provider.dart';
import 'package:coronavirus_tracker_global/ui/sliverHeader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

//bool isDarkTheme = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  localCache.makeSureSharedPrefsIsNotNull();
  themeProvider.theme = await themePrefs.getTheme();
  runApp(ChangeNotifierProvider(
    create: (_) {
      return themeProvider;
    },
    child: Consumer<ThemeProvider>(
      builder: (context, value, child) {
        return MaterialApp(
          theme: ThemeData(
            primaryColor: Colors.teal,
            brightness:
                themeProvider.theme ? Brightness.dark : Brightness.light,
          ),
          debugShowCheckedModeBanner: false,
          home: App(),
        );
      },
    ),
  ));
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //isDarkTheme = true;
    return Scaffold(
      backgroundColor:
          CustomColors(dark: themeProvider.theme).backgroundColorSecondary,
      body: Dashboard(),
    );
  }
}

class Dashboard extends StatefulWidget {
  @override
  DashboardState createState() => DashboardState();
}

class DashboardState extends State<Dashboard> {
  String _lastUpdated = DateTime.now().toString();
  String _accessToken = '';
  int _cases = 0;
  int _active = 0;
  int _recovered = 0;
  int _deaths = 0;
  int _todayCases = 0;
  int _todayDeaths = 0;
  int _casesPerMillion = 0;
  int _deathsPerMillion = 0;

  double _recoveryRate = 0;
  double _deathRate = 0;

  DateFormat defaultDateFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ssZ");
  DateFormat prettyDateFormat = DateFormat("dd MMM yyyy HH:mm");

  Future<void> refreshValues() async {
    bool isConnected = false;

    try {
      //Connected to internet
      isConnected = true;
      print('Internet Connection Available');
    } on SocketException catch (e) {
      //Not connected to internet
      print('Internet Connection Not Available: ${e.message}');
    }

    if (isConnected) {
      final apiService = APIService(API.sandbox());
      final accessToken = await apiService.getAccessToken();

      final cases = await apiService.getEndPointData(
        accessToken: accessToken,
        endpoint: Endpoint.cases,
      );
      final active = await apiService.getEndPointData(
        accessToken: accessToken,
        endpoint: Endpoint.active,
      );
      final recovered = await apiService.getEndPointData(
        accessToken: accessToken,
        endpoint: Endpoint.recovered,
      );
      final deaths = await apiService.getEndPointData(
        accessToken: accessToken,
        endpoint: Endpoint.deaths,
      );
      final todayCases = await apiService.getEndPointData(
        accessToken: accessToken,
        endpoint: Endpoint.todayCases,
      );
      final todayDeaths = await apiService.getEndPointData(
        accessToken: accessToken,
        endpoint: Endpoint.todayDeaths,
      );
      final casesPerMillion = await apiService.getEndPointData(
        accessToken: accessToken,
        endpoint: Endpoint.casesPerMillion,
      );
      final deathsPerMillion = await apiService.getEndPointData(
        accessToken: accessToken,
        endpoint: Endpoint.deathsPerMillion,
      );
      final lastUpdated = await apiService.getLastUpdated(
        accessToken: accessToken,
      );

      final recoveryRate = (recovered / (recovered + deaths)) * 100;
      final deathRate = (deaths / (recovered + deaths)) * 100;

      localCache.updateLocalCache(
        cases: cases,
        active: active,
        recovered: recovered,
        deaths: deaths,
        todayCases: todayCases,
        todayDeaths: todayDeaths,
        perMillionCases: casesPerMillion,
        perMillionDeaths: deathsPerMillion,
        recoveryRate: recoveryRate,
        deathRate: deathRate,
        lastUpdated: lastUpdated,
      );

      setState(() {
        _accessToken = accessToken;
        _cases = cases;
        _active = active;
        _recovered = recovered;
        _deaths = deaths;
        _todayCases = todayCases;
        _todayDeaths = todayDeaths;
        _casesPerMillion = casesPerMillion;
        _deathsPerMillion = deathsPerMillion;
        _lastUpdated = lastUpdated;
        _recoveryRate = recoveryRate;
        _deathRate = deathRate;
      });
    } else {}
    return;
  }

  @override
  void initState() {
    _cases = localCache.cases;
    _active = localCache.active;
    _recovered = localCache.recovered;
    _deaths = localCache.deaths;
    _todayCases = localCache.todayCases;
    _todayDeaths = localCache.todayDeaths;
    _casesPerMillion = localCache.perMillionCases;
    _deathsPerMillion = localCache.perMillionDeaths;
    _lastUpdated = localCache.lastUpdated;
    _recoveryRate = localCache.recoveryRate;
    _deathRate = localCache.deathRate;
    refreshValues();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var date = DateTime.parse(_lastUpdated);
    String dateStr = DateFormat("d MMM yyyy 'at' HH:mm a").format(date);

    return CustomScrollView(
      physics: BouncingScrollPhysics(),
      slivers: <Widget>[
        CustomSliverHeaderWidget(
          context: context,
        ),
        CupertinoSliverRefreshControl(
          onRefresh: refreshValues,
        ),
        SliverToBoxAdapter(
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 60),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 16, bottom: 8),
                  child: Text(
                    'Last updated: $dateStr',
                    style: TextStyle(
                      color: Colors.grey[500],
                    ),
                  ),
                ),
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 6),
                    child: Row(children: <Widget>[
                      Expanded(
                          child: infoCardSmall(
                              title: 'Recovery\nRate',
                              count: '${_recoveryRate.toStringAsFixed(2)}%',
                              color: Colors.green[800])),
                      Expanded(
                          child: infoCardSmall(
                              title: 'Death\nRate',
                              count: '${_deathRate.toStringAsFixed(2)}%',
                              color: Colors.red[800])),
                    ])),
                infoCard(
                  title: 'Today Infected',
                  count: _todayCases.toString(),
                  icon: Icons.trending_up,
                  color: Colors.blueGrey[900],
                ),
                infoCard(
                  title: 'Today Deaths',
                  count: _todayDeaths.toString(),
                  icon: Icons.trending_up,
                  color: Colors.red[800],
                ),
                infoCard(
                  title: 'Confirmed',
                  count: _cases.toString(),
                  icon: Icons.gps_not_fixed,
                  color: Colors.blueGrey[900],
                ),
                infoCard(
                  title: 'Active',
                  count: _active.toString(),
                  icon: Icons.error_outline,
                  color: Colors.indigo[900],
                ),
                infoCard(
                  title: 'Recoveries',
                  count: _recovered.toString(),
                  icon: Icons.check,
                  color: Colors.green[800],
                ),
                infoCard(
                  title: 'Deaths',
                  count: _deaths.toString(),
                  icon: Icons.close,
                  color: Colors.red[800],
                ),
                infoCard(
                  title: 'Per Million Infected',
                  count: _casesPerMillion.toString(),
                  icon: Icons.people_outline,
                  color: Colors.blueGrey[900],
                ),
                infoCard(
                  title: 'Per Million Deaths',
                  count: _deathsPerMillion.toString(),
                  icon: Icons.people_outline,
                  color: Colors.red[800],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 46),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        'Designed and Developed by',
                        style: TextStyle(
                          color: CustomColors(dark: themeProvider.theme)
                              .textColorSecondary,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        'Conceptures',
                        style: TextStyle(
                          color: CustomColors(dark: themeProvider.theme)
                              .textColorPrimary,
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Text(
                        'From Concept to Venture.',
                        style: TextStyle(
                          color: CustomColors(dark: themeProvider.theme)
                              .textColorSecondary,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 16),
                        child: Container(
                          width: 32,
                          height: 2,
                          color: CustomColors(dark: themeProvider.theme)
                              .textColorSecondary,
                        ),
                      ),
                      // Padding(
                      //   padding: EdgeInsets.only(top: 4),
                      //   child: Container(
                      //     width: 12,
                      //     height: 2,
                      //     color:
                      //         CustomColors(dark: isDarkTheme).textColorSecondary,
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget infoCardSmall({String title, String count, Color color}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        color: CustomColors(dark: themeProvider.theme).backgroundColorPrimary,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
              color: CustomColors(dark: themeProvider.theme).shadowColor,
              offset: Offset(0, 10),
              blurRadius: 20),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        clipBehavior: Clip.hardEdge,
        child: Container(
          color: color.withOpacity(0.0),
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color:
                      CustomColors(dark: themeProvider.theme).textColorPrimary,
                ),
              ),
              SizedBox(height: 12),
              Text(
                count,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget infoCard({
    String title = 'Cases',
    String count = '0',
    IconData icon = Icons.accessibility_new,
    Color color = Colors.black54,
  }) {
    Color color2 =
        CustomColors(dark: themeProvider.theme).backgroundColorPrimary;
    if (themeProvider.theme) {
      color2 = color;
      color = Colors.white;
    }

    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      padding: EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: color2,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
              color: CustomColors(dark: themeProvider.theme).shadowColor,
              offset: Offset(0, 10),
              blurRadius: 20),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        clipBehavior: Clip.hardEdge,
        child: Stack(
          children: <Widget>[
            Positioned(
              left: -24,
              bottom: -32,
              child: Icon(
                icon,
                size: 124,
                color: color.withOpacity(0.05),
              ),
            ),
            Container(
              //color: color.withOpacity(0.1),
              padding:
                  EdgeInsets.only(top: 12, bottom: 12, left: 18, right: 12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(bottom: 24),
                    child: Text(
                      title,
                      style: TextStyle(
                        color: color,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Icon(
                        icon,
                        size: 40,
                        color: color.withOpacity(0.9),
                      ),
                      Text(
                        count,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                          color: color,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
