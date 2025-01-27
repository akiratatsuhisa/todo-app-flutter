import 'dart:async';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GraphQLApi {
  final SharedPreferences _preferences;
  late final GraphQLClient _client;

  GraphQLApi({
    required SharedPreferences preferences,
  }) : _preferences = preferences {
    final httpLink = HttpLink('http://10.0.2.2:8080/graphql');

    final authLink = AuthLink(
      getToken: _getToken,
    );

    final link = authLink.concat(httpLink);

    _client = GraphQLClient(
      link: link,
      cache: GraphQLCache(
        store: InMemoryStore(),
      ),
      defaultPolicies: DefaultPolicies(
        query: Policies(fetch: FetchPolicy.noCache),
      ),
    );
  }

  FutureOr<String?> _getToken() async {
    // final token = preferences.getString('access_token');
    // // check token's expiry time
    // // Refresh token if needed
    // // await ...
    // return token;

    return null;
  }

  getClient() {
    return _client;
  }
}
