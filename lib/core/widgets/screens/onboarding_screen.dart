import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_starter/core/l10n/l10n_extension.dart';
import 'package:flutter_starter/core/routes/app_navigator.dart';
import 'package:flutter_starter/core/routes/route_names.dart';
import 'package:flutter_starter/core/theme/app_durations.dart';
import 'package:flutter_starter/core/theme/app_icon_size.dart';
import 'package:flutter_starter/core/theme/app_radius.dart';
import 'package:flutter_starter/core/theme/app_spacing.dart';
import 'package:flutter_starter/core/widgets/app_button.dart';

class OnboardingScreen extends StatefulWidget {
  final Future<void> Function()? onComplete;

  const OnboardingScreen({super.key, this.onComplete});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _completeOnboarding() async {
    if (widget.onComplete != null) {
      await widget.onComplete!();
    } else {
      unawaited(AppNavigator.pushReplacementNamed(RouteNames.home));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    final slides = [
      (
        icon: Icons.layers_rounded,
        title: l10n.onboardingTitle1,
        description: l10n.onboardingDesc1,
      ),
      (
        icon: Icons.translate_rounded,
        title: l10n.onboardingTitle2,
        description: l10n.onboardingDesc2,
      ),
      (
        icon: Icons.rocket_launch_rounded,
        title: l10n.onboardingTitle3,
        description: l10n.onboardingDesc3,
      ),
    ];

    final isLastPage = _currentPage == slides.length - 1;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: AlignmentDirectional.topEnd,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: TextButton(
                  onPressed: _completeOnboarding,
                  child: Text(l10n.skip),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: slides.length,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                itemBuilder: (context, index) {
                  final slide = slides[index];
                  return Padding(
                    padding: AppSpacing.edgeInsetsAllXxl,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withValues(
                              alpha: 0.12,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            slide.icon,
                            size: AppIconSize.xxl,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        AppSpacing.gapHXxl,
                        Text(
                          slide.title,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        AppSpacing.gapHMd,
                        Text(
                          slide.description,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: AppSpacing.edgeInsetsPage,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      slides.length,
                      (index) => AnimatedContainer(
                        duration: AppDurations.fast,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _currentPage == index ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? theme.colorScheme.primary
                              : theme.colorScheme.outline.withValues(
                                  alpha: 0.4,
                                ),
                          borderRadius: AppRadius.full,
                        ),
                      ),
                    ),
                  ),
                  AppSpacing.gapHXl,
                  AppButton(
                    label: isLastPage ? l10n.getStarted : l10n.next,
                    onPressed: () {
                      if (isLastPage) {
                        _completeOnboarding();
                      } else {
                        _pageController.nextPage(
                          duration: AppDurations.normal,
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
