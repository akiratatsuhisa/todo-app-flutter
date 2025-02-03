import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/constant.dart';
import 'package:mobile/page/home/bloc/home_bloc.dart';
import 'package:mobile/widget/bullet_list.dart';

class WelcomeContent extends StatefulWidget {
  const WelcomeContent({super.key});

  @override
  State<WelcomeContent> createState() => _WelcomeContentState();
}

class _WelcomeContentState extends State<WelcomeContent> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state is! HomeInProgress) {
            return;
          }

          _pageController.animateToPage(
            state.currentIndex,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOut,
          );
        },
        child: PageView(
          controller: _pageController,
          onPageChanged: (value) => context.read<HomeBloc>().add(
                HomePageSet(index: value),
              ),
          children: const <Widget>[
            _Page1(),
            _Page2(),
            _Page3(),
          ],
        ),
      ),
    );
  }
}

class _Layout extends StatelessWidget {
  final int currentIndex;
  final Widget child;
  final Widget leading;
  final Widget trailing;

  const _Layout({
    required this.currentIndex,
    required this.child,
    required this.leading,
    required this.trailing,
  });

  Widget _buildCircle(
    BuildContext context, {
    required int pageIndex,
    required int currentIndex,
  }) {
    final theme = Theme.of(context);

    return Container(
      width: Constant.space4,
      height: Constant.space4,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: currentIndex == pageIndex
            ? theme.colorScheme.primary
            : theme.colorScheme.primaryContainer,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: child),
          const SizedBox(height: Constant.space6),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildCircle(context, currentIndex: currentIndex, pageIndex: 0),
              const SizedBox(width: Constant.space5),
              _buildCircle(context, currentIndex: currentIndex, pageIndex: 1),
              const SizedBox(width: Constant.space5),
              _buildCircle(context, currentIndex: currentIndex, pageIndex: 2),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(Constant.space6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                leading,
                const SizedBox(height: Constant.space2),
                trailing,
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Page1 extends StatelessWidget {
  const _Page1();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bloc = context.read<HomeBloc>();

    final content = Padding(
      padding: const EdgeInsets.all(Constant.space6),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/business-interview.png'),
          Text(
            "Welcome to Todo",
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineSmall,
          ),
          const SizedBox(height: Constant.space2),
          Text(
            "Organize your tasks effortlessly",
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.tertiary,
            ),
          ),
        ],
      ),
    );

    return _Layout(
      currentIndex: 0,
      leading: FilledButton.tonalIcon(
        icon: const Icon(Icons.arrow_forward),
        iconAlignment: IconAlignment.end,
        label: const Text("Continue"),
        onPressed: () => bloc.add(const HomePageIncreased()),
      ),
      trailing: TextButton(
        child: const Text("Skip"),
        onPressed: () => bloc.add(const HomeWelcomeReadingCompleted()),
      ),
      child: content,
    );
  }
}

class _Page2 extends StatelessWidget {
  const _Page2();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bloc = context.read<HomeBloc>();

    final content = Padding(
      padding: const EdgeInsets.all(Constant.space6),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/task-list.png'),
          const SizedBox(height: Constant.space5),
          Text(
            "Stay on Top of Your To-Dos",
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineSmall,
          ),
          const SizedBox(height: Constant.space3),
          Text(
            "Plan, organize, and complete your tasks",
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.tertiary,
            ),
          ),
          const SizedBox(height: Constant.space2),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: Constant.space4),
            child: BulletList(children: [
              Text(
                "Create detailed to-do lists for every goal",
              ),
              Text(
                "Mark tasks as done and archive them when completed",
              ),
              Text(
                "Full control with CRUD functionality: Add, Edit, Delete",
              ),
            ]),
          ),
        ],
      ),
    );

    return _Layout(
      currentIndex: 1,
      leading: FilledButton.tonalIcon(
        icon: const Icon(Icons.arrow_forward),
        iconAlignment: IconAlignment.end,
        label: const Text("Continue"),
        onPressed: () => bloc.add(const HomePageIncreased()),
      ),
      trailing: TextButton.icon(
        icon: const Icon(Icons.arrow_back),
        iconAlignment: IconAlignment.start,
        label: const Text("Back"),
        onPressed: () => bloc.add(const HomePageDecreased()),
      ),
      child: content,
    );
  }
}

class _Page3 extends StatelessWidget {
  const _Page3();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bloc = context.read<HomeBloc>();

    final content = Padding(
      padding: const EdgeInsets.all(Constant.space6),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/business-leader.png'),
          const SizedBox(height: Constant.space5),
          const SizedBox(height: Constant.space5),
          Text(
            "Your Productivity Partner",
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineSmall,
          ),
          const SizedBox(height: Constant.space3),
          Text(
            "Unlock your full potential",
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.tertiary,
            ),
          ),
          const SizedBox(height: Constant.space2),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: Constant.space4),
            child: BulletList(children: [
              Text(
                "Start your journey toward better task management today",
              ),
              Text(
                "Set goals and watch your achievements grow",
              ),
              Text(
                "Enjoy a seamless experience to boost productivity",
              ),
            ]),
          ),
        ],
      ),
    );

    return _Layout(
      currentIndex: 2,
      leading: FilledButton.icon(
        icon: const Icon(Icons.start),
        iconAlignment: IconAlignment.end,
        label: const Text("Get Started"),
        onPressed: () => bloc.add(const HomeWelcomeReadingCompleted()),
      ),
      trailing: OutlinedButton.icon(
        icon: const Icon(Icons.arrow_back),
        iconAlignment: IconAlignment.start,
        label: const Text("Back"),
        onPressed: () => bloc.add(const HomePageDecreased()),
      ),
      child: content,
    );
  }
}
