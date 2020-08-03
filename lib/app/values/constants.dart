const THEME_MODE = 'THEME_MODE';

enum Cases {
  cases,
  active,
  recovered,
  deaths,
  todayCases,
  todayDeaths,
  casesPerMillion,
  deathsPerMillion,
  recoveryRate,
  deathRate,
  lastUpdated
}

const Map<Cases, String> casesData = {
  Cases.cases: 'cases',
  Cases.active: 'active',
  Cases.recovered: 'recovered',
  Cases.deaths: 'deaths',
  Cases.todayCases: 'todayCases',
  Cases.todayDeaths: 'todayDeaths',
  Cases.casesPerMillion: 'casesPerOneMillion',
  Cases.deathsPerMillion: 'deathsPerOneMillion',
  Cases.recoveryRate: 'recoveryRate',
  Cases.deathRate: 'deathRate',
  Cases.lastUpdated: 'lastUpdated',
};
