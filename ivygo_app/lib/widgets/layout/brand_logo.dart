import 'package:flutter/material.dart';
import 'package:ivygo_app/core/theme/app_theme.dart';

/// The standard Ivygo brand logo with optional name.
class BrandLogo extends StatelessWidget {
  final bool showName;
  final double size;

  const BrandLogo({
    super.key,
    this.showName = true,
    this.size = 40,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.appColors;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            // color: colors.primary,
            borderRadius: BorderRadius.circular(size * 0.25),
            border: Border.all(color: colors.primary),
          ),

          child: Image.asset('assets/images/logo.png'),

          // child: Icon(
          //   Icons.electric_bolt_rounded,
          //   color: theme.brightness == Brightness.light ? Colors.white : Colors.black,
          //   size: size * 0.55,
          // ),
        ),
        if (showName) ...[
          const SizedBox(width: 10),
          Text(
            'Ivygo',
            style: theme.textTheme.headlineLarge?.copyWith(
              color: colors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ],
    );
  }
}
