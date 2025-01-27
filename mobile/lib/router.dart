import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/page/home/bloc/home_bloc.dart';
import 'package:mobile/page/home/home_page.dart';
import 'package:mobile/page/todo/bloc/archived_list_bloc.dart';
import 'package:mobile/page/todo/bloc/todo_list_bloc.dart';
import 'package:mobile/page/todo_save/bloc/todo_save_bloc.dart';
import 'package:mobile/page/todo_save/todo_save_page.dart';
import 'package:mobile/page/todo/cubit/todo_nav_bar_cubit.dart';
import 'package:mobile/page/todo/todo_page.dart';
import 'package:mobile/repository/home_repository.dart';
import 'package:mobile/repository/todo_repository.dart';

enum Routes {
  home(path: '/', name: 'home'),
  todo(path: '/todo', name: 'todo'),
  todoDetail(path: '/todo-detail', name: 'todoDetail'),
  todoCreate(path: '/todo-create', name: 'todoCreate'),
  todoUpdate(path: '/todo-update', name: 'todoUpdate'),
  ;

  const Routes({
    required this.path,
    required this.name,
  });

  final String path;
  final String name;
}

final router = GoRouter(
  routes: [
    GoRoute(
      path: Routes.home.path,
      name: Routes.home.name,
      builder: (context, state) => BlocProvider(
        create: (context) => HomeBloc(
          homeRepository: context.read<HomeRepository>(),
        ),
        child: const HomePage(),
      ),
    ),
    GoRoute(
      path: Routes.todo.path,
      name: Routes.todo.name,
      builder: (context, state) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => TodoNavBarCubit(),
          ),
          BlocProvider(
            create: (context) => TodoListBloc(
              todoRepository: context.read<TodoRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => ArchivedListBloc(
              todoRepository: context.read<TodoRepository>(),
            ),
          ),
        ],
        child: const TodoPage(),
      ),
    ),
    //   GoRoute(
    //     path: '${Routes.todoDetail.path}/:id',
    //     name: Routes.todoDetail.name,
    //     builder: (context, state) => BlocProvider(
    //       create: (context) => HomeBloc(),
    //       child: TodoDetailPage(id: state.pathParameters['id']!),
    //     ),
    //   ),
    GoRoute(
      path: Routes.todoCreate.path,
      name: Routes.todoCreate.name,
      builder: (context, state) => BlocProvider(
        create: (context) => TodoSaveBloc(
          todoRepository: context.read<TodoRepository>(),
        ),
        child: const TodoSavePage(),
      ),
    ),
    GoRoute(
      path: '${Routes.todoUpdate.path}/:id',
      name: Routes.todoUpdate.name,
      builder: (context, state) => BlocProvider(
        create: (context) => TodoSaveBloc(
          todoRepository: context.read<TodoRepository>(),
        ),
        child: TodoSavePage(initId: state.pathParameters['id']),
      ),
    ),
  ],
);
