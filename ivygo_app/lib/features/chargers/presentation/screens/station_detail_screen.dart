import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ivygo_app/core/theme/app_theme.dart';
import 'package:ivygo_app/widgets/widgets.dart';
import 'package:ivygo_app/router/app_routes_name.dart';
// import 'package:intl/intl.dart'; // removed unused

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
        leading: AppBackButton(onPressed: () => context.pop()),
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
              const ChargerInfoCard(
                stationName: 'Allambie Heights Charger',
                stationAddress: '123 Skyline Drive, Allambie Heights, NSW 2100',
                chargingType: 'Type 2',
                powerLevel: '7KW',
                pricing: '\$0.45',
                isAvailable: true,
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
              
              DateSelector(
                selectedDate: ref.watch(selectedDateProvider),
                onDateSelected: (date) =>
                    ref.read(selectedDateProvider.notifier).state = date,
              ),

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
              TimeSelector(
                selectedTime: ref.watch(selectedTimeProvider),
                onTimeSelected: (time) =>
                    ref.read(selectedTimeProvider.notifier).state = time,
              ),

              const SizedBox(height: 32),

              // Charging Duration Title
              Text(
                'Charging Duration',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              DurationSelector(
                labels: durationLabels,
                selectedIndex: ref.watch(selectedDurationIndexProvider),
                onSelected: (index) =>
                    ref.read(selectedDurationIndexProvider.notifier).state =
                        index,
              ),
              const SizedBox(height: 16),
              CostEstimationPill(
                amount: baseCostPerHour *
                    durationMultipliers[
                        ref.watch(selectedDurationIndexProvider)],
              ),

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
        child: PrimaryButton(
          label: 'Next Step',
          icon: Icons.arrow_forward_ios_rounded,
          onPressed: () => context.push(AppRoutes.booking.fullPath),
        ),
      ),
    );
  }

}

// --- Specific Selection Widgets --- //


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

