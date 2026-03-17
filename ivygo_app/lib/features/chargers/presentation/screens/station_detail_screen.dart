import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ivygo_app/theme/app_theme.dart';
import 'package:intl/intl.dart';

// --- Providers --- //

final selectedDateProvider = StateProvider.autoDispose<DateTime>((ref) {
  // Default to today
  return DateTime.now();
});

final selectedTimeProvider = StateProvider.autoDispose<TimeOfDay>((ref) {
  // Default to 11:30 AM
  return const TimeOfDay(hour: 11, minute: 30);
});

final selectedDurationIndexProvider = StateProvider.autoDispose<int>((ref) {
  // Default to 1 hr (index 1)
  return 1;
});

// --- Mock Data --- //

const List<String> durationLabels = ['30 min', '1 hr', '2 hr', '3 hr', '4 hr'];
const List<double> durationMultipliers = [0.5, 1.0, 2.0, 3.0, 4.0];
const double baseCostPerHour = 8.05;

// --- Screen --- //

class StationDetailScreen extends ConsumerWidget {
  final String stationId;
  const StationDetailScreen({super.key, required this.stationId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colors = context.appColors;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded,
              color: colors.textPrimary, size: 20),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Charger Details',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.share_outlined, color: colors.textPrimary, size: 22),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              // Image Placeholder
              Container(
                width: double.infinity,
                height: 180,
                decoration: BoxDecoration(
                  color: colors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.energy_savings_leaf_rounded,
                      size: 40,
                      color: colors.primary,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'No photo provided',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Charger Info Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: colors.border, width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'ALLAMBIE HEIGHTS CHARGER',
                          style: theme.textTheme.labelMedium?.copyWith(
                            letterSpacing: 0.5,
                            color: colors.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: colors.primary.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'AVAILABLE',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: colors.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Type 2 · 7KW',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: colors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Icon(Icons.location_on_outlined,
                              size: 16, color: colors.primary),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '123 Skyline Drive, Allambie Heights, NSW 2100',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Divider(color: colors.border),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildInfoColumn(context, label: '/kWh', value: '\$0.45'),
                        _buildInfoColumnWithIcon(context,
                            icon: Icons.bolt_rounded, value: '7KW'),
                        _buildInfoColumnWithIcon(context,
                            icon: Icons.energy_savings_leaf_rounded,
                            value: 'GREEN'),
                        _buildInfoColumnWithIcon(context,
                            icon: Icons.ev_station_rounded, value: 'TYPE 2'),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),
              
              // Select Date Title
              Text(
                'Select Date',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              
              const _DateSelectionCard(),

              const SizedBox(height: 32),

              // Select Arrival Time Title
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Select Arrival Time',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: colors.primary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Available times: 8:00 AM - 3:45 PM',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: colors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const _TimeSelectionField(),

              const SizedBox(height: 32),

              // Charging Duration Title
              Text(
                'Charging Duration',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              const _DurationSelectionRow(),
              const SizedBox(height: 16),
              const _CostEstimationPill(),

              const SizedBox(height: 32),

              // Location Map Title
              Text(
                'Location',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              
              // Map Placeholder
              Container(
                height: 160,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: colors.border),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: CustomPaint(
                          painter: _LocationGridPainter(color: colors.border),
                        ),
                      ),
                      Center(
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: colors.primary.withValues(alpha: 0.3),
                            shape: BoxShape.circle,
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: colors.primary,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.ev_station_rounded,
                                color: Colors.white, size: 20),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 100), // padding for bottom bar
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          bottom: MediaQuery.of(context).padding.bottom + 20,
          top: 20,
        ),
        decoration: BoxDecoration(
          color: colors.background,
          border: Border(top: BorderSide(color: colors.border, width: 1)),
        ),
        child: ElevatedButton(
          onPressed: () {
            context.push('/home/booking');
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: colors.primary,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Next Step',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
              SizedBox(width: 8),
              Icon(Icons.arrow_forward_ios_rounded, size: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoColumn(BuildContext context,
      {required String label, required String value}) {
    final colors = context.appColors;
    final theme = Theme.of(context);
    return Column(
      children: [
        Text(
          value,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: colors.warning,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: colors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoColumnWithIcon(BuildContext context,
      {required IconData icon, required String value}) {
    final colors = context.appColors;
    final theme = Theme.of(context);
    return Column(
      children: [
        Icon(icon, size: 18, color: colors.primary),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: colors.textSecondary,
          ),
        ),
      ],
    );
  }
}

// --- Specific Selection Widgets --- //

class _DateSelectionCard extends ConsumerWidget {
  const _DateSelectionCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final theme = Theme.of(context);
    final selectedDate = ref.watch(selectedDateProvider);
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
          Row(
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
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(7, (index) {
              final date = dates[index];
              final isSelected = date.day == selectedDate.day && date.month == selectedDate.month;
              final dayInitial = DateFormat('E').format(date).substring(0, 1);
              final isPast = date.isBefore(DateTime.now().subtract(const Duration(days: 1)));

              return GestureDetector(
                onTap: isPast ? null : () {
                  ref.read(selectedDateProvider.notifier).state = date;
                },
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
          ),
        ],
      ),
    );
  }
}

class _TimeSelectionField extends ConsumerWidget {
  const _TimeSelectionField();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final theme = Theme.of(context);
    final selectedTime = ref.watch(selectedTimeProvider);

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
          ref.read(selectedTimeProvider.notifier).state = time;
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

class _DurationSelectionRow extends ConsumerWidget {
  const _DurationSelectionRow();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(selectedDurationIndexProvider);
    final colors = context.appColors;
    final theme = Theme.of(context);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          durationLabels.length,
          (index) {
            final isSelected = index == selectedIndex;
            return Padding(
              padding: const EdgeInsets.only(right: 12),
              child: GestureDetector(
                onTap: () {
                  ref.read(selectedDurationIndexProvider.notifier).state = index;
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected ? colors.primary : colors.surface,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: isSelected ? colors.primary : colors.border,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    durationLabels[index],
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: isSelected ? Colors.white : colors.textSecondary,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _CostEstimationPill extends ConsumerWidget {
  const _CostEstimationPill();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final theme = Theme.of(context);
    final index = ref.watch(selectedDurationIndexProvider);
    
    final cost = baseCostPerHour * durationMultipliers[index];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: colors.warning.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.bolt_rounded, size: 16, color: colors.warning),
          const SizedBox(width: 6),
          Text(
            'Est. cost: \$${cost.toStringAsFixed(2)}',
            style: theme.textTheme.labelLarge?.copyWith(
              color: colors.warning,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

// --- Map Painter --- //

class _LocationGridPainter extends CustomPainter {
  final Color color;
  const _LocationGridPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = color
      ..strokeWidth = 0.5;

    for (double x = 0; x < size.width; x += 20) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y < size.height; y += 20) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

