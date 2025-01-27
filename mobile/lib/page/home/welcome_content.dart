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

  Widget _buildLayout({
    required Widget child,
    required Widget leading,
    required Widget trailing,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(child: child),
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

  Widget _buildPage1() {
    const content = Center(
      child: Text("Page 1"),
    );

    return _buildLayout(
      leading: FilledButton.tonal(
        onPressed: () => _bloc.add(const HomePageIncreased()),
        child: const Text("Continue"),
      ),
      trailing: TextButton(
        onPressed: () => _bloc.add(const HomeWelcomeReadingCompleted()),
        child: const Text("Skip"),
      ),
      child: content,
    );
  }

  Widget _buildPage2() {
    const content = Center(
      child: Text("Page 2"),
    );

    return _buildLayout(
      leading: FilledButton.tonal(
        onPressed: () => _bloc.add(const HomePageIncreased()),
        child: const Text("Continue"),
      ),
      trailing: OutlinedButton(
        onPressed: () => _bloc.add(const HomePageDecreased()),
        child: const Text("Back"),
      ),
      child: content,
    );
  }

  Widget _buildPage3() {
    const content = Center(
      child: Text("Page 3"),
    );

    return _buildLayout(
      leading: FilledButton(
        onPressed: () => _bloc.add(const HomeWelcomeReadingCompleted()),
        child: const Text("Get Started"),
      ),
      trailing: OutlinedButton(
        onPressed: () => _bloc.add(const HomePageDecreased()),
        child: const Text("Back"),
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
            _buildPage1(),
            _buildPage2(),
            _buildPage3(),
          ],
        ),
      ),
    );
  }
}
