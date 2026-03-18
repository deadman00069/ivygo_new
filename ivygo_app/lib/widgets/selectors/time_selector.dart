import 'package:flutter/material.dart';
import 'package:ivygo_app/core/theme/app_theme.dart';

/// A time picker field styled for the app.
class TimeSelector extends StatelessWidget {
  final TimeOfDay selectedTime;
  final Function(TimeOfDay) onTimeSelected;
  final String? availableRange;

  const TimeSelector({
    super.key,
    required this.selectedTime,
    required this.onTimeSelected,
    this.availableRange,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final theme = Theme.of(context);

    return InkWell(
      onTap: () async {
        final TimeOfDay? time = await showTimePicker(
          context: context,
          initialTime: selectedTime,
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.light(
                  primary: colors.primary,
                ),
              ),
              child: child!,
            );
          },
        );
        if (time != null) {
          onTimeSelected(time);
        }
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colors.primary, width: 1),
        ),
        child: Row(
          children: [
            Icon(Icons.schedule_rounded, color: colors.primary, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                selectedTime.format(context),
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: colors.textPrimary,
                ),
              ),
            ),
            Icon(Icons.keyboard_arrow_down_rounded, color: colors.textSecondary),
          ],
        ),
      ),
    );
  }
}
