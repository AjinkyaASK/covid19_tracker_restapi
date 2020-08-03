import 'package:coronavirus_tracker_global/app/services/api_keys.dart';
import 'package:flutter/material.dart';

enum Endpoint {
  cases,
  active,
  recovered,
  deaths,
  todayCases,
  todayDeaths,
  casesPerMillion,
  deathsPerMillion
}

class API {
  final String apiKey;

  API({@required this.apiKey});

  factory API.sandbox() => API(apiKey: APIKeys.nCovSandboxKey);

  static final String host = 'apigw.nubentos.com';
  static final int port = 443;
  static final String basePath = 't/nubentos.com/ncovapi/2.0.0';

  static Map<Endpoint, String> _paths = {
    Endpoint.cases: 'cases',
    Endpoint.active: 'active',
    Endpoint.recovered: 'recovered',
    Endpoint.deaths: 'deaths',
    Endpoint.todayCases: 'todayCases',
    Endpoint.todayDeaths: 'todayDeaths',
    Endpoint.casesPerMillion: 'casesPerOneMillion',
    Endpoint.deathsPerMillion: 'deathsPerOneMillion',
  };

  Uri endPointUri(Endpoint endpoint) => Uri(
        scheme: 'https',
        host: host,
        port: port,
        path: '$basePath/${_paths[endpoint]}',
      );

  Uri tokenUri() => Uri(
        scheme: 'https',
        host: host,
        port: port,
        path: 'token',
        queryParameters: {'grant_type': 'client_credentials'},
      );
}
