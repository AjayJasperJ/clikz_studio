import 'package:clikz_studio/app.dart';
import 'package:clikz_studio/widgets/custom_widgets.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: Scaffold(
        body: Wpad(
          child: ListConfig(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Container(
                    height: displaySize.height * .4,
                    width: displaySize.width,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.onSurface.withValues(alpha: .1),
                      borderRadius: BorderRadius.circular(displaySize.height * .02),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Column(
                    children: List.generate(5, (index) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(height: displaySize.height * .02),
                          Container(
                            height: displaySize.height * .1,
                            width: displaySize.width,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.onSurface.withValues(alpha: .1),
                              borderRadius: BorderRadius.circular(displaySize.height * .02),
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
