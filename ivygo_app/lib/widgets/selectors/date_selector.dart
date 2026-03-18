import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ivygo_app/core/theme/app_theme.dart';

/// A horizontal week-view date selector.
class DateSelector extends StatelessWidget {
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;

  const DateSelector({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final theme = Theme.of(context);
    final monthYear = DateFormat('MMMM yyyy').format(selectedDate);

    // Create a mock list of dates for the week representation
    final dates = List.generate(7, (index) {
      return selectedDate.add(Duration(days: index - 3));
    });

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        children: [
          _buildHeader(theme, colors, monthYear),
          const SizedBox(height: 24),
          _buildDateGrid(theme, colors, dates),
        ],
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, ThemeColors colors, String monthYear) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          monthYear,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        Row(
          children: [
            Icon(Icons.chevron_left_rounded, color: colors.textSecondary),
            const SizedBox(width: 16),
            Icon(Icons.chevron_right_rounded, color: colors.textPrimary),
          ],
        ),
      ],
    );
  }

  Widget _buildDateGrid(ThemeData theme, ThemeColors colors, List<DateTime> dates) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(7, (index) {
        final date = dates[index];
        final isSelected =
            date.day == selectedDate.day && date.month == selectedDate.month;
        final dayInitial = DateFormat('E').format(date).substring(0, 1);
        final isPast = date
            .isBefore(DateTime.now().subtract(const Duration(days: 1)));

        return GestureDetector(
          onTap: isPast ? null : () => onDateSelected(date),
          child: Column(
            children: [
              Text(
                dayInitial,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                width: 36,
                height: 36,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected ? colors.primary : Colors.transparent,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '${date.day}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: isSelected
                        ? Colors.white
                        : (isPast ? colors.border : colors.textPrimary),
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
