import 'package:coronavirus_tracker_global/app/values/constants.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalCache {
  SharedPreferences sharedPrefs;

  get cases => sharedPrefs.getInt(casesData[Cases.cases]) ?? 0;
  get active => sharedPrefs.getInt(casesData[Cases.active]) ?? 0;
  get recovered => sharedPrefs.getInt(casesData[Cases.recovered]) ?? 0;
  get deaths => sharedPrefs.getInt(casesData[Cases.deaths]) ?? 0;
  get todayCases => sharedPrefs.getInt(casesData[Cases.todayCases]) ?? 0;
  get todayDeaths => sharedPrefs.getInt(casesData[Cases.todayDeaths]) ?? 0;
  get perMillionCases =>
      sharedPrefs.getInt(casesData[Cases.casesPerMillion]) ?? 0;
  get perMillionDeaths =>
      sharedPrefs.getInt(casesData[Cases.deathsPerMillion]) ?? 0;
  get recoveryRate =>
      sharedPrefs.getDouble(casesData[Cases.recoveryRate]) ?? 0.0;
  get deathRate => sharedPrefs.getDouble(casesData[Cases.deathRate]) ?? 0.0;
  get lastUpdated =>
      sharedPrefs.getString(casesData[Cases.lastUpdated]) ??
      DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(DateTime.now()).toString();

  makeSureSharedPrefsIsNotNull() async {
    if (sharedPrefs == null) {
      sharedPrefs = await SharedPreferences.getInstance();
    }
  }

  updateLocalCache(
      {int cases,
      int active,
      int recovered,
      int deaths,
      int todayCases,
      int todayDeaths,
      int perMillionCases,
      int perMillionDeaths,
      double recoveryRate,
      double deathRate,
      String lastUpdated}) async {
    if (sharedPrefs == null) {
      sharedPrefs = await SharedPreferences.getInstance();
    }
    if (cases != null) sharedPrefs.setInt(casesData[Cases.cases], cases);
    if (active != null) sharedPrefs.setInt(casesData[Cases.active], active);
    if (recovered != null)
      sharedPrefs.setInt(casesData[Cases.recovered], recovered);
    if (deaths != null) sharedPrefs.setInt(casesData[Cases.deaths], deaths);
    if (todayCases != null)
      sharedPrefs.setInt(casesData[Cases.todayCases], todayCases);
    if (todayDeaths != null)
      sharedPrefs.setInt(casesData[Cases.todayDeaths], todayDeaths);
    if (perMillionCases != null)
      sharedPrefs.setInt(casesData[Cases.casesPerMillion], perMillionCases);
    if (perMillionDeaths != null)
      sharedPrefs.setInt(casesData[Cases.deathsPerMillion], perMillionDeaths);
    if (recoveryRate != null)
      sharedPrefs.setDouble(casesData[Cases.recoveryRate], recoveryRate);
    if (deathRate != null)
      sharedPrefs.setDouble(casesData[Cases.deathRate], deathRate);
    if (lastUpdated != null)
      sharedPrefs.setString(casesData[Cases.lastUpdated], lastUpdated);
  }
}

LocalCache localCache = LocalCache();
