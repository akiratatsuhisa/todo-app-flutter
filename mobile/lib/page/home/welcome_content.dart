import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/constant.dart';
import 'package:mobile/page/home/bloc/home_bloc.dart';

class WelcomeContent extends StatefulWidget {
  const WelcomeContent({super.key});

  @override
  State<WelcomeContent> createState() => _WelcomeContentState();
}

class _WelcomeContentState extends State<WelcomeContent> {
  late final HomeBloc _bloc;
  late final PageController _pageController;

  static const _circleDiameter = 16.0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    _bloc = context.read<HomeBloc>();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Widget _buildCircle({
    required int pageIndex,
    required int currentIndex,
  }) {
    final theme = Theme.of(context);

    return Container(
      width: _circleDiameter,
      height: _circleDiameter,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: currentIndex == pageIndex
            ? theme.colorScheme.primary
            : theme.colorScheme.primaryContainer,
      ),
    );
  }

  Widget _buildBulletList({required List<Widget> children}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: children.map((child) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("\u2022"),
            const SizedBox(width: Constant.space2),
            Expanded(child: child),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildLayout(
    BuildContext context, {
    required int currentIndex,
    required Widget child,
    required Widget leading,
    required Widget trailing,
  }) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: child),
          const SizedBox(height: Constant.space6),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildCircle(currentIndex: currentIndex, pageIndex: 0),
              const SizedBox(width: Constant.space5),
              _buildCircle(currentIndex: currentIndex, pageIndex: 1),
              const SizedBox(width: Constant.space5),
              _buildCircle(currentIndex: currentIndex, pageIndex: 2),
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

  Widget _buildPage1(BuildContext context) {
    final theme = Theme.of(context);

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

    return _buildLayout(
      context,
      currentIndex: 0,
      leading: FilledButton.tonalIcon(
        icon: const Icon(Icons.arrow_forward),
        iconAlignment: IconAlignment.end,
        label: const Text("Continue"),
        onPressed: () => _bloc.add(const HomePageIncreased()),
      ),
      trailing: TextButton(
        child: const Text("Skip"),
        onPressed: () => _bloc.add(const HomeWelcomeReadingCompleted()),
      ),
      child: content,
    );
  }

  Widget _buildPage2(BuildContext context) {
    final theme = Theme.of(context);

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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Constant.space4),
            child: _buildBulletList(
              children: [
                const Text("Create detailed to-do lists for every goal"),
                const Text(
                    "Mark tasks as done and archive them when completed"),
                const Text(
                    "Full control with CRUD functionality: Add, Edit, Delete"),
              ],
            ),
          ),
        ],
      ),
    );

    return _buildLayout(
      context,
      currentIndex: 1,
      leading: FilledButton.tonalIcon(
        icon: const Icon(Icons.arrow_forward),
        iconAlignment: IconAlignment.end,
        label: const Text("Continue"),
        onPressed: () => _bloc.add(const HomePageIncreased()),
      ),
      trailing: TextButton.icon(
        icon: const Icon(Icons.arrow_back),
        iconAlignment: IconAlignment.start,
        label: const Text("Back"),
        onPressed: () => _bloc.add(const HomePageDecreased()),
      ),
      child: content,
    );
  }

  Widget _buildPage3(BuildContext context) {
    final theme = Theme.of(context);

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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Constant.space4),
            child: _buildBulletList(
              children: [
                const Text(
                    "Start your journey toward better task management today"),
                const Text("Set goals and watch your achievements grow"),
                const Text("Enjoy a seamless experience to boost productivity"),
              ],
            ),
          ),
        ],
      ),
    );

    return _buildLayout(
      context,
      currentIndex: 2,
      leading: FilledButton.icon(
        icon: const Icon(Icons.start),
        iconAlignment: IconAlignment.end,
        label: const Text("Get Started"),
        onPressed: () => _bloc.add(const HomeWelcomeReadingCompleted()),
      ),
      trailing: OutlinedButton.icon(
        icon: const Icon(Icons.arrow_back),
        iconAlignment: IconAlignment.start,
        label: const Text("Back"),
        onPressed: () => _bloc.add(const HomePageDecreased()),
      ),
      child: content,
    );
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
          onPageChanged: (value) => _bloc.add(HomePageSet(index: value)),
          children: [
            _buildPage1(context),
            _buildPage2(context),
            _buildPage3(context),
          ],
        ),
      ),
    );
  }
}
