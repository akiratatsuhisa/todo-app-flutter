import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/page/home/bloc/home_bloc.dart';
import 'package:mobile/page/home/home_page.dart';
import 'package:mobile/page/todo/bloc/archived_list_bloc.dart';
import 'package:mobile/page/todo/bloc/todo_list_bloc.dart';
import 'package:mobile/page/todo_create/todo_create_page.dart';
import 'package:mobile/page/todo_detail/todo_detail_page.dart';
import 'package:mobile/page/todo/cubit/todo_bottom_nav_bar_cubit.dart';
import 'package:mobile/page/todo/todo_page.dart';
import 'package:mobile/page/todo_update/todo_update_page.dart';
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
        create: (context) => HomeBloc(),
        child: const HomePage(),
      ),
    ),
    GoRoute(
      path: Routes.todo.path,
      name: Routes.todo.name,
      builder: (context, state) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => TodoBottomNavBarCubit(),
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
    GoRoute(
      path: '${Routes.todoDetail.path}/:id',
      name: Routes.todoDetail.name,
      builder: (context, state) => BlocProvider(
        create: (context) => HomeBloc(),
        child: const TodoDetailPage(),
      ),
    ),
    GoRoute(
      path: Routes.todoCreate.path,
      name: Routes.todoCreate.name,
      builder: (context, state) => BlocProvider(
        create: (context) => HomeBloc(),
        child: const TodoCreatePage(),
      ),
    ),
    GoRoute(
      path: '${Routes.todoUpdate.path}/:id',
      name: Routes.todoUpdate.name,
      builder: (context, state) => BlocProvider(
        create: (context) => HomeBloc(),
        child: TodoUpdatePage(id: state.pathParameters['id']!),
      ),
    ),
  ],
);
