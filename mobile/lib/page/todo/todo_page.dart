import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/page/todo/archived_list_page.dart';
import 'package:mobile/page/todo/cubit/todo_nav_bar_cubit.dart';
import 'package:mobile/page/todo/todo_list_page.dart';

class TodoPage extends StatelessWidget {
  const TodoPage({super.key});

  _buildNav(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: context.select(
        (TodoNavBarCubit cubit) => cubit.state,
      ),
      onTap: (index) => context.read<TodoNavBarCubit>().setIndex(index),
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.list),
          label: 'Todo',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.archive),
          label: 'Archive',
        ),
      ],
    );
  }

  _buildBody(BuildContext context) {
    const pages = [
      TodoListPage(),
      ArchivedListPage(),
    ];

    return BlocBuilder<TodoNavBarCubit, int>(
      builder: (context, state) => pages.elementAt(state),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(context),
      bottomNavigationBar: _buildNav(context),
    );
  }
}
