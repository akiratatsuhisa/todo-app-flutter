import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/page/todo/archived_list_page.dart';
import 'package:mobile/page/todo/cubit/todo_nav_bar_cubit.dart';
import 'package:mobile/page/todo/todo_list_page.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  late final TodoNavBarCubit _cubit;

  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<TodoNavBarCubit>();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  _buildNav(BuildContext context) {
    return BottomNavigationBar(
      currentIndex:
          context.select((TodoNavBarCubit cubit) => cubit.state),
      onTap: (index) {
        _cubit.setIndex(index);
        _pageController.animateToPage(
          index,
          duration: const Duration(milliseconds: 500),
          curve: Curves.linearToEaseOut,
        );
      },
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
    return PageView(
      controller: _pageController,
      onPageChanged: _cubit.setIndex,
      children: const <Widget>[
        TodoListPage(),
        ArchivedListPage(),
      ],
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
