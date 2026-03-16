import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ivygo_app/theme/app_theme.dart';

class MapHomeScreen extends StatefulWidget {
  const MapHomeScreen({super.key});

  @override
  State<MapHomeScreen> createState() => _MapHomeScreenState();
}

class _MapHomeScreenState extends State<MapHomeScreen> {
  int _currentIndex = 0;

  final List<_NavItem> _navItems = const [
    _NavItem(icon: Icons.map_outlined, activeIcon: Icons.map_rounded, label: 'Map'),
    _NavItem(icon: Icons.ev_station_outlined, activeIcon: Icons.ev_station_rounded, label: 'Chargers'),
    _NavItem(icon: Icons.bookmark_outline_rounded, activeIcon: Icons.bookmark_rounded, label: 'My Bookings'),
    _NavItem(icon: Icons.settings_outlined, activeIcon: Icons.settings_rounded, label: 'Settings'),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Stack(
        children: [
          // Map placeholder
          Container(
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
          ),
          // Top search bar
          SafeArea(
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
                          color: AppColors.surface.withValues(alpha: 0.95),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.border, width: 0.5),
                        ),
                        child: Row(
                          children: [
                            const SizedBox(width: 12),
                            const Icon(Icons.search_rounded,
                                color: AppColors.textMuted, size: 20),
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
                      color: AppColors.surface.withValues(alpha: 0.95),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border, width: 0.5),
                    ),
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.tune_rounded,
                          color: AppColors.textPrimary, size: 20),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Charging station markers on the map
          ..._buildMapMarkers(context),
          // Bottom panel
          Align(
            alignment: Alignment.bottomCenter,
            child: _buildBottomPanel(context, theme),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(context, theme),
    );
  }

  List<Widget> _buildMapMarkers(BuildContext context) {
    final markers = [
      const Offset(0.3, 0.35),
      const Offset(0.6, 0.25),
      const Offset(0.5, 0.5),
      const Offset(0.75, 0.45),
    ];
    final size = MediaQuery.of(context).size;
    return markers.map((pos) {
      return Positioned(
        left: pos.dx * size.width - 20,
        top: pos.dy * size.height - 20,
        child: GestureDetector(
          onTap: () => context.go('/home/station/ev-001'),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.4),
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
    }).toList();
  }

  Widget _buildBottomPanel(BuildContext context, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 96),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.97),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border, width: 0.5),
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
                  Text('Nearby Chargers',
                      style: theme.textTheme.titleLarge),
                  const SizedBox(height: 2),
                  Text('4 stations in your area',
                      style: theme.textTheme.bodySmall),
                ],
              ),
              TextButton(
                onPressed: () => context.go('/home/chargers'),
                style: TextButton.styleFrom(
                    foregroundColor: AppColors.primary),
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

  Widget _buildBottomNav(BuildContext context, ThemeData theme) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border, width: 0.5)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_navItems.length, (i) {
              final item = _navItems[i];
              final isActive = i == _currentIndex;
              return GestureDetector(
                onTap: () {
                  setState(() => _currentIndex = i);
                  if (i == 1) context.go('/home/chargers');
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: isActive
                        ? AppColors.primary.withValues(alpha: 0.1)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isActive ? item.activeIcon : item.icon,
                        color: isActive
                            ? AppColors.primary
                            : AppColors.textMuted,
                        size: 22,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.label,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: isActive
                              ? FontWeight.w600
                              : FontWeight.w400,
                          color: isActive
                              ? AppColors.primary
                              : AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NearbyStationCard extends StatelessWidget {
  final int index;
  const _NearbyStationCard({required this.index});

  static const List<Map<String, dynamic>> _stations = [
    {'name': 'City Center Hub', 'distance': '0.3 km', 'available': 3, 'total': 8, 'kw': '50 kW'},
    {'name': 'Mall Parking', 'distance': '0.7 km', 'available': 1, 'total': 4, 'kw': '22 kW'},
    {'name': 'Business Bay', 'distance': '1.2 km', 'available': 5, 'total': 6, 'kw': '150 kW'},
    {'name': 'Park & Charge', 'distance': '1.8 km', 'available': 0, 'total': 2, 'kw': '7 kW'},
  ];

  @override
  Widget build(BuildContext context) {
    final station = _stations[index % _stations.length];
    final isAvailable = (station['available'] as int) > 0;
    return GestureDetector(
      onTap: () => context.go('/home/station/ev-00${index + 1}'),
      child: Container(
        width: 160,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surfaceCard,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border, width: 0.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.ev_station_rounded,
                    color: isAvailable ? AppColors.primary : AppColors.textMuted,
                    size: 18),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: isAvailable
                        ? AppColors.success.withValues(alpha: 0.15)
                        : AppColors.error.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    isAvailable ? 'Available' : 'Full',
                    style: TextStyle(
                      fontSize: 10,
                      color: isAvailable ? AppColors.success : AppColors.error,
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
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  '${station['distance']} • ${station['kw']}',
                  style: const TextStyle(
                    color: AppColors.textMuted,
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

class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  const _NavItem(
      {required this.icon,
      required this.activeIcon,
      required this.label});
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
    canvas.drawLine(
        Offset(0, size.height * 0.4), Offset(size.width, size.height * 0.4), roadPaint);
    canvas.drawLine(
        Offset(size.width * 0.3, 0), Offset(size.width * 0.3, size.height), roadPaint);
    canvas.drawLine(
        Offset(size.width * 0.7, 0), Offset(size.width * 0.7, size.height), roadPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
