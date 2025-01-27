import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/constant.dart';
import 'package:mobile/page/todo_save/bloc/todo_save_bloc.dart';
import 'package:mobile/widget/failure_content.dart';

class TodoSavePage extends StatefulWidget {
  final String? initId;

  const TodoSavePage({
    super.key,
    this.initId,
  });

  @override
  State<TodoSavePage> createState() => _TodoSavePageState();
}

class _TodoSavePageState extends State<TodoSavePage> {
  final _formKey = GlobalKey<FormState>();

  late final TodoSaveBloc _bloc;

  late final TextEditingController _textController;
  late final TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();

    _textController = TextEditingController();
    _descriptionController = TextEditingController();

    _bloc = context.read<TodoSaveBloc>();
    _initialize();
  }

  @override
  void dispose() {
    _textController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _initialize() => _bloc.add(TodoSaveInitialized(id: widget.initId));

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? true)) {
      return;
    }

    final text = _textController.text.trim();
    final description = _descriptionController.text.trim();

    _bloc.add(
      TodoSaveSubmitted(
        id: widget.initId,
        text: text,
        description: description == '' ? null : description,
      ),
    );
  }

  Widget _buildBody(BuildContext context, TodoSaveState state) {
    final readOnly = state is! TodoSaveInProgress;

    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(Constant.space6),
        children: [
          TextFormField(
            controller: _textController,
            decoration: const InputDecoration(
              label: Text("Text"),
            ),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) {
              value = value?.trim() ?? '';

              if (value == '') {
                return "The Text field can't be empty.";
              }

              if (value.length > 36) {
                return "The Text field must be less than 36 characters.";
              }

              return null;
            },
            readOnly: readOnly,
          ),
          const SizedBox(height: Constant.space6),
          TextFormField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              label: Text("Description"),
            ),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) {
              value = value?.trim() ?? '';

              if (value != '' && value.length > 256) {
                return "The Text field must be less than 256 characters.";
              }

              return null;
            },
            readOnly: readOnly,
          ),
          const SizedBox(height: Constant.space6),
          FilledButton(
            onPressed: readOnly ? null : _submit,
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
        if (state is TodoSaveLoaded) {
          _textController.text = state.todo.text;
          _descriptionController.text = state.todo.description ?? '';
        }
        if (state is TodoSaveSuccess) {
          GoRouter.of(context).pop(state.todo);
        }
      },
      builder: (context, state) => Scaffold(
        appBar: AppBar(
          title: Text(widget.initId == null ? "Create Todo" : "Update Todo"),
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
              onRetryPressed: _initialize,
            ),
          _ => _buildBody(context, state),
        },
      ),
    );
  }
}
