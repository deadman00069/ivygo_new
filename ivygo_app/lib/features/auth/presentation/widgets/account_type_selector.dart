import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../screens/create_account_screen.dart';

class AccountTypeSelector extends ConsumerWidget {
  const AccountTypeSelector({super.key});

  static const List<String> _accountTypes = [
    'Resident',
    'Business',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedAccountType = ref.watch(selectedAccountTypeProvider);
    final selectedIndex = _accountTypes.indexOf(selectedAccountType);

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: context.appColors.surfaceElevated,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: context.appColors.border,
          width: 0.5,
        ),
      ),
      child: Stack(
        children: [
          // Moving background indicator
          AnimatedAlign(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            alignment:
                selectedIndex == 0 ? Alignment.centerLeft : Alignment.centerRight,
            child: FractionallySizedBox(
              widthFactor: 0.5,
              child: Container(
                height: 42,
                decoration: BoxDecoration(
                  color: context.appColors.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: context.appColors.primary,
                    width: 1.5,
                  ),
                ),
              ),
            ),
          ),
          // Interactive areas
          Row(
            children: _accountTypes.map((type) {
              final isSelected = selectedAccountType == type;
              return Expanded(
                child: GestureDetector(
                  onTap: () =>
                      ref.read(selectedAccountTypeProvider.notifier).state = type,
                  behavior: HitTestBehavior.opaque,
                  child: SizedBox(
                    height: 42,
                    child: Center(
                      child: Text(
                        type,
                        style: TextStyle(
                          color: isSelected
                              ? context.appColors.primary
                              : context.appColors.textSecondary,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w400,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
