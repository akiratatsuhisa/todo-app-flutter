import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/constant.dart';
import 'package:mobile/page/todo_save/bloc/todo_save_bloc.dart';
import 'package:mobile/widget/failure_content.dart';

class TodoSavePage extends StatelessWidget {
  final String? id;

  const TodoSavePage({
    super.key,
    this.id,
  });

  Widget _buildBody(BuildContext context, TodoSaveInProgress state) {
    return Form(
      child: ListView(
        padding: const EdgeInsets.all(Constant.space6),
        children: [
          TextFormField(
            initialValue: state.text.value,
            decoration: InputDecoration(
              label: Text(state.text.label),
              errorText: state.text.displayError?.message,
            ),
            onChanged: (value) {
              context.read<TodoSaveBloc>().add(
                    TodoSaveFieldChanged(field: state.text.label, value: value),
                  );
            },
          ),
          const SizedBox(height: Constant.space6),
          TextFormField(
            initialValue: state.description.value,
            decoration: InputDecoration(
              label: Text(state.description.label),
              errorText: state.description.displayError?.message,
            ),
            onChanged: (value) {
              context.read<TodoSaveBloc>().add(
                    TodoSaveFieldChanged(
                      field: state.description.label,
                      value: value,
                    ),
                  );
            },
          ),
          const SizedBox(height: Constant.space6),
          FilledButton(
            onPressed: () => context.read<TodoSaveBloc>().add(
                  TodoSaveSubmitted(
                    id: id,
                  ),
                ),
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TodoSaveBloc, TodoSaveState>(
      listener: (context, state) {
        if (state is TodoSaveSuccess) {
          GoRouter.of(context).pop(state.todo);
        }
      },
      builder: (context, state) => Scaffold(
        appBar: AppBar(
          title: Text(id == null ? "Create Todo" : "Update Todo"),
          bottom: state is TodoSaveLoading
              ? const PreferredSize(
                  preferredSize: Size(double.infinity, 4.0),
                  child: LinearProgressIndicator(),
                )
              : null,
        ),
        body: switch (state) {
          TodoSaveFailure _ => FailureContent(
              state: state,
              onRetryPressed: () => context.read<TodoSaveBloc>().add(
                    TodoSaveInitialized(id: id),
                  ),
            ),
          TodoSaveInProgress state => _buildBody(context, state),
          _ => const SizedBox(),
        },
      ),
    );
  }
}
