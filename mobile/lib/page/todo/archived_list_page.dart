import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/page/todo/bloc/archived_list_bloc.dart';
import 'package:mobile/widget/ErrorContent.dart';

class ArchivedListPage extends StatefulWidget {
  const ArchivedListPage({super.key});

  @override
  State<ArchivedListPage> createState() => _ArchivedListPageState();
}

class _ArchivedListPageState extends State<ArchivedListPage> {
  static const title = "Archived Todo List";

  late final ArchivedListBloc bloc;

  Future<void> _fetchData() async => bloc.add(const ArchivedListDataFetched());

  @override
  initState() {
    super.initState();
    bloc = context.read<ArchivedListBloc>();

    if (bloc.state is ArchivedListInitial) {
      _fetchData();
    }
  }

  PreferredSizeWidget _buildDefaultAppBar(BuildContext context) {
    return AppBar(
      title: const Text(title),
    );
  }

  PreferredSizeWidget _buildLoadedtAppBar(BuildContext context) {
    return AppBar(
      title: const Text(title),
    );
  }

  Widget _buildDefaultBody(BuildContext context) {
    return BlocBuilder<ArchivedListBloc, ArchivedListState>(
      builder: (context, state) => ErrorContent(
        state: state,
        onRetryPressed: _fetchData,
      ),
    );
  }

  Widget _buildLoadedBody(BuildContext context) {
    return BlocBuilder<ArchivedListBloc, ArchivedListState>(
        builder: (context, state) {
      if (state is! ArchivedListSuccess) {
        return const SizedBox();
      }

      final list = ListView.separated(
        itemCount: state.items.length,
        itemBuilder: (context, index) {
          final currentItem = state.items[index];

          return ListTile(
            title: Text(currentItem.text),
            subtitle: currentItem.description == null
                ? null
                : Text(currentItem.description!),
            leading: Checkbox(
              value: currentItem.done,
              onChanged: null,
            ),
            trailing: GestureDetector(
              child: const Icon(Icons.restore),
              onTap: () =>
                  bloc.add(ArchivedListItemToggleArchived(id: currentItem.id)),
            ),
          );
        },
        separatorBuilder: (context, index) => const Divider(height: 0.0),
      );

      return RefreshIndicator(
        onRefresh: _fetchData,
        child: list,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ArchivedListBloc, ArchivedListState>(
      buildWhen: (previous, current) {
        return previous.runtimeType != current.runtimeType;
      },
      builder: (context, state) => switch (state) {
        ArchivedListSuccess _ => Scaffold(
            appBar: _buildLoadedtAppBar(context),
            body: _buildLoadedBody(context),
          ),
        _ => Scaffold(
            appBar: _buildDefaultAppBar(context),
            body: _buildDefaultBody(context),
          ),
      },
    );
  }
}
