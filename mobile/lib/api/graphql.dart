import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class GraphQLApi {
  final FirebaseAuth _firebaseAuth;

  late final GraphQLClient _client;

  GraphQLApi({
    FirebaseAuth? firebaseAuth,
  }) : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance {
    final httpLink = HttpLink('http://10.0.2.2:6000/graphql');

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
    final token = await _firebaseAuth.currentUser?.getIdToken();
    return 'Bearer $token';
  }

  getClient() {
    return _client;
  }
}
