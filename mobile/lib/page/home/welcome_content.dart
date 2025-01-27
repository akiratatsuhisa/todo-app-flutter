import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  Widget _buildLayout(
    BuildContext context, {
    required int currentIndex,
    required Widget child,
    required Widget leading,
    required Widget trailing,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(child: child),
        const SizedBox(height: 24.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildCircle(currentIndex: currentIndex, pageIndex: 0),
            const SizedBox(width: 20.0),
            _buildCircle(currentIndex: currentIndex, pageIndex: 1),
            const SizedBox(width: 20.0),
            _buildCircle(currentIndex: currentIndex, pageIndex: 2),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              leading,
              const SizedBox(height: 8.0),
              trailing,
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPage1(BuildContext context) {
    const content = Center(
      child: Text("Page 1"),
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
    const content = Center(
      child: Text("Page 2"),
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
    const content = Center(
      child: Text("Page 3"),
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
