import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/page/todo/archived_list_page.dart';
import 'package:mobile/page/todo/cubit/todo_bottom_nav_bar_cubit.dart';
import 'package:mobile/page/todo/todo_list_page.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  late final TodoBottomNavBarCubit cubit;

  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    cubit = context.read<TodoBottomNavBarCubit>();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  _buildNav(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: context
          .select((TodoBottomNavBarCubit cubit) => cubit.state.currentIndex),
      onTap: (index) {
        cubit.setTab(index);
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
      onPageChanged: (index) {
        cubit.setTab(index);
      },
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
