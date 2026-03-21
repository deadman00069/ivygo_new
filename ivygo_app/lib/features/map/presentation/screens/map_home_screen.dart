import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ivygo_app/core/theme/app_theme.dart';
import 'package:ivygo_app/router/app_routes_name.dart';

/// The map screen shown on the Map tab. The [Scaffold] and bottom navigation
/// bar are provided by [MainShellScreen]; this widget only renders map content.
class MapHomeScreen extends StatelessWidget {
  const MapHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Stack(
      children: [
        _MapBackground(),
        _TopSearchBar(),
        _MapMarkers(),
        Align(
          alignment: Alignment.bottomCenter,
          child: _BottomPanel(),
        ),
      ],
    );
  }
}

class _MapBackground extends StatelessWidget {
  const _MapBackground();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0D1117),
            Color(0xFF111827),
            Color(0xFF0D1F12),
          ],
        ),
      ),
      child: CustomPaint(
        painter: _MapGridPainter(),
        child: Container(),
      ),
    );
  }
}

class _MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF1A2332).withValues(alpha: 0.6)
      ..strokeWidth = 0.5;
    const spacing = 40.0;
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
    // Draw some road-like lines
    final roadPaint = Paint()
      ..color = const Color(0xFF21354A)
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(0, size.height * 0.4),
        Offset(size.width, size.height * 0.4), roadPaint);
    canvas.drawLine(Offset(size.width * 0.3, 0),
        Offset(size.width * 0.3, size.height), roadPaint);
    canvas.drawLine(Offset(size.width * 0.7, 0),
        Offset(size.width * 0.7, size.height), roadPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _TopSearchBar extends StatelessWidget {
  const _TopSearchBar();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: context.appColors.surface.withValues(alpha: 0.95),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: context.appColors.border, width: 0.5),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 12),
                      Icon(Icons.search_rounded,
                          color: context.appColors.textMuted, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Search for chargers...',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: context.appColors.surface.withValues(alpha: 0.95),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: context.appColors.border, width: 0.5),
              ),
              child: IconButton(
                onPressed: () {},
                icon: Icon(Icons.tune_rounded,
                    color: context.appColors.textPrimary, size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MapMarkers extends StatelessWidget {
  const _MapMarkers();

  static const List<Offset> _markers = [
    Offset(0.3, 0.35),
    Offset(0.6, 0.25),
    Offset(0.5, 0.5),
    Offset(0.75, 0.45),
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: _markers.map((pos) {
        return Positioned(
          left: pos.dx * size.width - 20,
          top: pos.dy * size.height - 20,
          child: GestureDetector(
            onTap: () =>
                context.go(AppRoutes.stationDetail.getFullPath('ev-001')),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: context.appColors.primary,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: context.appColors.primary.withValues(alpha: 0.4),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: const Icon(Icons.electric_bolt_rounded,
                  color: Colors.black, size: 18),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _BottomPanel extends StatelessWidget {
  const _BottomPanel();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.appColors.surface.withValues(alpha: 0.97),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: context.appColors.border, width: 0.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Nearby Chargers', style: theme.textTheme.titleLarge),
                  const SizedBox(height: 2),
                  Text('4 stations in your area',
                      style: theme.textTheme.bodySmall),
                ],
              ),
              TextButton(
                onPressed: () => context.go(AppRoutes.chargersList.fullPath),
                style: TextButton.styleFrom(
                    foregroundColor: context.appColors.primary),
                child: const Text('See All'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 96,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 4,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, i) => _NearbyStationCard(index: i),
            ),
          ),
        ],
      ),
    );
  }
}

class _NearbyStationCard extends StatelessWidget {
  final int index;
  const _NearbyStationCard({required this.index});

  static const List<Map<String, dynamic>> _stations = [
    {
      'name': 'City Center Hub',
      'distance': '0.3 km',
      'available': 3,
      'total': 8,
      'kw': '50 kW'
    },
    {
      'name': 'Mall Parking',
      'distance': '0.7 km',
      'available': 1,
      'total': 4,
      'kw': '22 kW'
    },
    {
      'name': 'Business Bay',
      'distance': '1.2 km',
      'available': 5,
      'total': 6,
      'kw': '150 kW'
    },
    {
      'name': 'Park & Charge',
      'distance': '1.8 km',
      'available': 0,
      'total': 2,
      'kw': '7 kW'
    },
  ];

  @override
  Widget build(BuildContext context) {
    final station = _stations[index % _stations.length];
    final isAvailable = (station['available'] as int) > 0;
    return GestureDetector(
      onTap: () => context
          .go(AppRoutes.stationDetail.getFullPath('ev-00${index + 1}')),
      child: Container(
        width: 160,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: context.appColors.surfaceCard,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: context.appColors.border, width: 0.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  Icons.ev_station_rounded,
                  color: isAvailable
                      ? context.appColors.primary
                      : context.appColors.textMuted,
                  size: 18,
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: isAvailable
                        ? context.appColors.success.withValues(alpha: 0.15)
                        : context.appColors.error.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    isAvailable ? 'Available' : 'Full',
                    style: TextStyle(
                      fontSize: 10,
                      color: isAvailable
                          ? context.appColors.success
                          : context.appColors.error,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  station['name'] as String,
                  style: TextStyle(
                    color: context.appColors.textPrimary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  '${station['distance']} • ${station['kw']}',
                  style: TextStyle(
                    color: context.appColors.textMuted,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
