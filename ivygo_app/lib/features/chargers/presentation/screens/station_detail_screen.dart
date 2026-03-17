import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ivygo_app/theme/app_theme.dart';

final selectedConnectorProvider = StateProvider.autoDispose<int>((ref) => 0);

class StationDetailScreen extends ConsumerWidget {
  final String stationId;
  const StationDetailScreen({super.key, required this.stationId});

  static const List<Map<String, dynamic>> _connectors = [
    {'type': 'CCS2', 'kw': 150, 'status': 'available', 'price': '\$0.35/kWh'},
    {'type': 'CHAdeMO', 'kw': 50, 'status': 'available', 'price': '\$0.28/kWh'},
    {'type': 'Type 2', 'kw': 22, 'status': 'in_use', 'price': '\$0.18/kWh'},
    {'type': 'Type 2', 'kw': 22, 'status': 'available', 'price': '\$0.18/kWh'},
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final selectedConnector = ref.watch(selectedConnectorProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const _StationAppBar(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _StationHeader(theme: theme),
                  const SizedBox(height: 16),
                  const _QuickInfoRow(),
                  const SizedBox(height: 24),
                  Divider(color: context.appColors.divider),
                  const SizedBox(height: 20),
                  Text('Select Connector', style: theme.textTheme.titleLarge),
                  const SizedBox(height: 12),
                  const _ConnectorGrid(connectors: _connectors),
                  const SizedBox(height: 24),
                  Text('Amenities', style: theme.textTheme.titleLarge),
                  const SizedBox(height: 12),
                  const _AmenitiesGrid(),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _BottomActionPanel(
        connector: _connectors[selectedConnector],
      ),
    );
  }
}

class _StationAppBar extends StatelessWidget {
  const _StationAppBar();

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 220,
      pinned: true,
      leading: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: context.appColors.surface.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(Icons.arrow_back_ios_new_rounded,
              size: 16, color: context.appColors.textPrimary),
        ),
        onPressed: () => context.go('/home/chargers'),
      ),
      actions: [
        IconButton(
          icon: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: context.appColors.surface.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.bookmark_outline_rounded,
                size: 18, color: context.appColors.textPrimary),
          ),
          onPressed: () {},
        ),
        const SizedBox(width: 8),
        IconButton(
          icon: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: context.appColors.surface.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.share_outlined,
                size: 18, color: context.appColors.textPrimary),
          ),
          onPressed: () {},
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF0D1F20), Color(0xFF0D1117)],
                ),
              ),
              child: CustomPaint(
                painter: _StationMapPainter(),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: context.appColors.primary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: context.appColors.primary.withValues(alpha: 0.5),
                          blurRadius: 20,
                          spreadRadius: 4,
                        ),
                      ],
                    ),
                    child: const Icon(Icons.electric_bolt_rounded,
                        color: Colors.black, size: 24),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: context.appColors.surface.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'City Center Hub',
                      style: TextStyle(
                        color: context.appColors.textPrimary,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
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

class _StationHeader extends StatelessWidget {
  final ThemeData theme;
  const _StationHeader({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'City Center Hub',
                style: theme.textTheme.headlineLarge,
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.location_on_rounded,
                      size: 14, color: context.appColors.textMuted),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      '12 Main Street, Downtown',
                      style: theme.textTheme.bodyMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              children: [
                Icon(Icons.star_rounded,
                    color: context.appColors.warning, size: 16),
                const SizedBox(width: 4),
                Text(
                  '4.8',
                  style: theme.textTheme.titleMedium,
                ),
              ],
            ),
            Text(
              '(128 reviews)',
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
      ],
    );
  }
}

class _QuickInfoRow extends StatelessWidget {
  const _QuickInfoRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _QuickInfoChip(
          icon: Icons.schedule_rounded,
          label: 'Open 24/7',
          color: context.appColors.success,
        ),
        const SizedBox(width: 8),
        _QuickInfoChip(
          icon: Icons.directions_car_rounded,
          label: '0.3 km away',
          color: context.appColors.accent,
        ),
        const SizedBox(width: 8),
        _QuickInfoChip(
          icon: Icons.ev_station_rounded,
          label: '3/8 free',
          color: context.appColors.primary,
        ),
      ],
    );
  }
}

class _ConnectorGrid extends ConsumerWidget {
  final List<Map<String, dynamic>> connectors;
  const _ConnectorGrid({required this.connectors});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedConnector = ref.watch(selectedConnectorProvider);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.8,
      ),
      itemCount: connectors.length,
      itemBuilder: (context, i) {
        final connector = connectors[i];
        final isSelected = i == selectedConnector;
        final isAvailable = connector['status'] == 'available';
        return GestureDetector(
          onTap: isAvailable
              ? () => ref.read(selectedConnectorProvider.notifier).state = i
              : null,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isSelected
                  ? context.appColors.primary.withValues(alpha: 0.12)
                  : context.appColors.surfaceCard,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? context.appColors.primary : context.appColors.border,
                width: isSelected ? 1.5 : 0.5,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      connector['type'] as String,
                      style: TextStyle(
                        color: isSelected
                            ? context.appColors.primary
                            : context.appColors.textPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color:
                            isAvailable ? context.appColors.success : context.appColors.warning,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.bolt_rounded,
                        size: 14,
                        color: isSelected
                            ? context.appColors.primary
                            : context.appColors.textMuted),
                    const SizedBox(width: 2),
                    Text(
                      '${connector['kw']} kW',
                      style: TextStyle(
                        fontSize: 12,
                        color: isSelected
                            ? context.appColors.primary
                            : context.appColors.textMuted,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      connector['price'] as String,
                      style: TextStyle(
                        fontSize: 11,
                        color: context.appColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _AmenitiesGrid extends StatelessWidget {
  const _AmenitiesGrid();

  @override
  Widget build(BuildContext context) {
    return const Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _AmenityChip(icon: Icons.wifi_rounded, label: 'Free WiFi'),
        _AmenityChip(icon: Icons.local_parking_rounded, label: 'Parking'),
        _AmenityChip(icon: Icons.restaurant_rounded, label: 'Café nearby'),
        _AmenityChip(icon: Icons.accessible_rounded, label: 'Accessible'),
        _AmenityChip(icon: Icons.security_rounded, label: 'CCTV'),
      ],
    );
  }
}

class _BottomActionPanel extends StatelessWidget {
  final Map<String, dynamic> connector;
  const _BottomActionPanel({required this.connector});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).padding.bottom + 16,
        top: 16,
      ),
      decoration: BoxDecoration(
        color: context.appColors.surface,
        border: Border(top: BorderSide(color: context.appColors.border, width: 0.5)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${connector['kw']} kW • ${connector['type']}',
                      style: Theme.of(context).textTheme.titleMedium),
                  Text(
                    connector['price'] as String,
                    style: TextStyle(
                        color: context.appColors.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 16),
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.electric_bolt_rounded, size: 18),
                label: const Text('Start Charging'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(0, 48),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuickInfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _QuickInfoChip(
      {required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 5),
          Text(label,
              style: TextStyle(
                  fontSize: 12, color: color, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

class _AmenityChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _AmenityChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: context.appColors.surfaceElevated,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: context.appColors.border, width: 0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: context.appColors.textSecondary),
          const SizedBox(width: 6),
          Text(label,
              style: TextStyle(
                  fontSize: 12, color: context.appColors.textSecondary)),
        ],
      ),
    );
  }
}

class _StationMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final roadPaint = Paint()
      ..color = const Color(0xFF1A2F3A)
      ..strokeWidth = 10;
    final gridPaint = Paint()
      ..color = const Color(0xFF162030).withValues(alpha: 0.5)
      ..strokeWidth = 0.5;

    for (double x = 0; x < size.width; x += 30) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y < size.height; y += 30) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }
    canvas.drawLine(Offset(0, size.height * 0.5),
        Offset(size.width, size.height * 0.5), roadPaint);
    canvas.drawLine(Offset(size.width * 0.5, 0),
        Offset(size.width * 0.5, size.height), roadPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
