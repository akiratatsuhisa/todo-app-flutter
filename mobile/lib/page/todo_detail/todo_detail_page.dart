import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/constant.dart';
import 'package:mobile/page/todo_detail/bloc/todo_detail_bloc.dart';
import 'package:mobile/widget/failure_content.dart';

enum _TodoState { archived, done }

class TodoDetailPage extends StatelessWidget {
  final String id;

  const TodoDetailPage({super.key, required this.id});

  Widget _buildBody(BuildContext context, TodoDetailLoaded state) {
    final theme = Theme.of(context);

    final card = Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: Constant.space4,
          horizontal: Constant.space5,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Text",
              style: theme.textTheme.titleMedium,
            ),
            Text(state.todo.text),
            if (state.todo.description != null) ...[
              const Divider(),
              Text(
                "Description",
                style: theme.textTheme.titleSmall,
              ),
              Text(
                state.todo.description!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onPrimaryContainer.withAlpha(0xCF),
                ),
              ),
            ],
            const SizedBox(height: Constant.space2),
            SegmentedButton(
              emptySelectionAllowed: true,
              multiSelectionEnabled: true,
              showSelectedIcon: false,
              segments: const [
                ButtonSegment(
                  value: _TodoState.done,
                  label: Text('Done'),
                  icon: Icon(Icons.done),
                ),
                ButtonSegment(
                  value: _TodoState.archived,
                  label: Text('Archived'),
                  icon: Icon(Icons.archive),
                ),
              ],
              selected: <_TodoState>{
                if (state.todo.done) _TodoState.done,
                if (state.todo.archived) _TodoState.archived,
              },
              onSelectionChanged: (value) {
                if ((value.contains(_TodoState.done) && !state.todo.done) ||
                    (!value.contains(_TodoState.done) && state.todo.done)) {
                  context
                      .read<TodoDetailBloc>()
                      .add(const TodoDetailDoneToggled());
                }

                if ((value.contains(_TodoState.archived) &&
                        !state.todo.archived) ||
                    (!value.contains(_TodoState.archived) &&
                        state.todo.archived)) {
                  context
                      .read<TodoDetailBloc>()
                      .add(const TodoDetailArchivedToggled());
                }
              },
            ),
          ],
        ),
      ),
    );

    return ListView(
      padding: const EdgeInsets.all(Constant.space6),
      children: [
        card,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Todo"),
      ),
      body: BlocBuilder<TodoDetailBloc, TodoDetailState>(
        builder: (context, state) => switch (state) {
          TodoDetailFailure _ => FailureContent(
              state: state,
              onRetryPressed: () => context.read<TodoDetailBloc>().add(
                    TodoDetailInitialized(id: id),
                  ),
            ),
          TodoDetailLoaded state => _buildBody(context, state),
          _ => const Center(
              child: CircularProgressIndicator(),
            ),
        },
      ),
    );
  }
}
