import 'dart:math' as math;
import 'package:flutter/material.dart';

void main() {
  runApp(const CleanDroidApp());
}

class CleanDroidColors {
  static const Color background = Color(0xFF0F141C);
  static const Color surface = Color(0xFF0F141C);
  static const Color surfaceContainer = Color(0xFF1B2028);
  static const Color surfaceContainerLow = Color(0xFF171C24);
  static const Color surfaceContainerHigh = Color(0xFF252A33);
  static const Color surfaceContainerHighest = Color(0xFF30353E);
  static const Color surfaceBright = Color(0xFF343942);

  static const Color primary = Color(0xFF44EDB7);
  static const Color primaryContainer = Color(0xFF00D09C);
  static const Color onPrimary = Color(0xFF003828);
  static const Color onPrimaryContainer = Color(0xFF00533C);

  static const Color secondary = Color(0xFFB0C6FF);
  static const Color secondaryContainer = Color(0xFF0068ED);
  static const Color onSecondary = Color(0xFF002D6E);

  static const Color tertiary = Color(0xFFFFC5C1);
  static const Color tertiaryContainer = Color(0xFFFF9D97);
  static const Color onTertiaryContainer = Color(0xFF960016);

  static const Color error = Color(0xFFFFB4AB);
  static const Color onSurface = Color(0xFFDEE2EE);
  static const Color onSurfaceVariant = Color(0xFFBACAC1);
}

class CleanDroidApp extends StatelessWidget {
  const CleanDroidApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CleanDroid - Junk Cleaner',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: CleanDroidColors.background,
        colorScheme: const ColorScheme.dark(
          primary: CleanDroidColors.primary,
          onPrimary: CleanDroidColors.onPrimary,
          surface: CleanDroidColors.surface,
          onSurface: CleanDroidColors.onSurface,
          secondary: CleanDroidColors.secondary,
          error: CleanDroidColors.error,
        ),
        useMaterial3: true,
      ),
      home: const MainNavigationShell(),
    );
  }
}

class MainNavigationShell extends StatefulWidget {
  const MainNavigationShell({super.key});

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  int _currentIndex = 0;

  void navigateToTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      StorageOverviewScreen(onNavigateToCategories: () => navigateToTab(1)),
      JunkCategorySelectionScreen(
        onNavigateToFileInspector: () => navigateToTab(2),
        onCleanSuccess: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctx) => CleanCompleteSummaryScreen(
                onDone: () {
                  Navigator.of(ctx).pop();
                  navigateToTab(0);
                },
              ),
            ),
          );
        },
      ),
      GranularFileInspectorScreen(
        onDeleteComplete: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctx) => CleanCompleteSummaryScreen(
                onDone: () {
                  Navigator.of(ctx).pop();
                  navigateToTab(0);
                },
              ),
            ),
          );
        },
      ),
      const DeepOverviewScreen(),
    ];

    return Scaffold(
      backgroundColor: CleanDroidColors.background,
      body: screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: CleanDroidColors.surfaceContainerLow,
          border: Border(
            top: BorderSide(color: CleanDroidColors.surfaceContainerHigh, width: 1),
          ),
        ),
        child: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: navigateToTab,
          backgroundColor: Colors.transparent,
          indicatorColor: CleanDroidColors.primary.withValues(alpha: 0.18),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.cleaning_services_outlined, color: CleanDroidColors.onSurfaceVariant),
              selectedIcon: Icon(Icons.cleaning_services, color: CleanDroidColors.primary),
              label: 'Overview',
            ),
            NavigationDestination(
              icon: Icon(Icons.category_outlined, color: CleanDroidColors.onSurfaceVariant),
              selectedIcon: Icon(Icons.category, color: CleanDroidColors.primary),
              label: 'Categories',
            ),
            NavigationDestination(
              icon: Icon(Icons.folder_open_outlined, color: CleanDroidColors.onSurfaceVariant),
              selectedIcon: Icon(Icons.folder_open, color: CleanDroidColors.primary),
              label: 'Inspector',
            ),
            NavigationDestination(
              icon: Icon(Icons.speed_outlined, color: CleanDroidColors.onSurfaceVariant),
              selectedIcon: Icon(Icons.speed, color: CleanDroidColors.primary),
              label: 'Deep Scan',
            ),
          ],
        ),
      ),
    );
  }
}

// -------------------------------------------------------------
// SCREEN 2: STORAGE OVERVIEW DASHBOARD
// -------------------------------------------------------------
class StorageOverviewScreen extends StatelessWidget {
  final VoidCallback onNavigateToCategories;

  const StorageOverviewScreen({super.key, required this.onNavigateToCategories});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          // App Bar Row
          _buildHeader(context),
          const SizedBox(height: 16),

          // Diagnostic Storage Gauge Hero
          _buildStorageHero(),
          const SizedBox(height: 16),

          // Deep Scan Completed Hero Card
          _buildDeepScanCard(context),
          const SizedBox(height: 16),

          // Quick Device Health Metrics
          _buildHealthCards(),
          const SizedBox(height: 16),

          // Organisation & Author Credits Banner
          _buildCreditsBanner(context),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: CleanDroidColors.primary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.auto_delete, color: CleanDroidColors.primary, size: 22),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'CleanDroid',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: CleanDroidColors.onSurface,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: CleanDroidColors.primary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        children: [
                          CircleAvatar(radius: 3, backgroundColor: CleanDroidColors.primary),
                          SizedBox(width: 4),
                          Text(
                            'Optimal',
                            style: TextStyle(fontSize: 10, color: CleanDroidColors.primary, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Text(
                  'Storage Diagnostic',
                  style: TextStyle(fontSize: 12, color: CleanDroidColors.onSurfaceVariant),
                ),
              ],
            ),
          ],
        ),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.info_outline, color: CleanDroidColors.primary),
              tooltip: 'About & Credits',
              onPressed: () => _showAboutDialog(context),
            ),
            InkWell(
              onTap: () => _showAboutDialog(context),
              borderRadius: BorderRadius.circular(16),
              child: const CircleAvatar(
                radius: 16,
                backgroundColor: CleanDroidColors.primary,
                child: Icon(Icons.person, color: CleanDroidColors.onPrimary, size: 20),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCreditsBanner(BuildContext context) {
    return InkWell(
      onTap: () => _showAboutDialog(context),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: CleanDroidColors.surfaceContainer,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: CleanDroidColors.surfaceContainerHigh),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: CleanDroidColors.primary.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.business, color: CleanDroidColors.primary, size: 18),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Nova Technologies',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: CleanDroidColors.onSurface),
                  ),
                  Text(
                    'Idea Acquisition • Author: Abhishek Singh',
                    style: TextStyle(fontSize: 11, color: CleanDroidColors.onSurfaceVariant),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, size: 18, color: CleanDroidColors.onSurfaceVariant),
          ],
        ),
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: CleanDroidColors.surfaceContainer,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: CleanDroidColors.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: CleanDroidColors.primary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.auto_delete, color: CleanDroidColors.primary, size: 26),
                ),
                const SizedBox(width: 14),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'CleanDroid Junk Cleaner',
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: CleanDroidColors.onSurface),
                    ),
                    Text(
                      'Version 1.0.0 • Production Build',
                      style: TextStyle(fontSize: 12, color: CleanDroidColors.onSurfaceVariant),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Organisation Credit Card
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: CleanDroidColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: CleanDroidColors.surfaceContainerHigh),
              ),
              child: const Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: Color(0x330068ED),
                    child: Icon(Icons.business, color: CleanDroidColors.secondary, size: 20),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ORGANISATION',
                          style: TextStyle(fontSize: 10, letterSpacing: 1, color: CleanDroidColors.onSurfaceVariant, fontWeight: FontWeight.w600),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Nova Technologies',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: CleanDroidColors.onSurface),
                        ),
                        Text(
                          'Conceptual Idea Acquisition & Sponsorship',
                          style: TextStyle(fontSize: 11, color: CleanDroidColors.primary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            // Author Credit Card
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: CleanDroidColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: CleanDroidColors.surfaceContainerHigh),
              ),
              child: const Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: Color(0x3344EDB7),
                    child: Icon(Icons.badge, color: CleanDroidColors.primary, size: 20),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'AUTHOR & ARCHITECT',
                          style: TextStyle(fontSize: 10, letterSpacing: 1, color: CleanDroidColors.onSurfaceVariant, fontWeight: FontWeight.w600),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Abhishek Singh',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: CleanDroidColors.onSurface),
                        ),
                        Text(
                          'Lead Mobile Application Developer',
                          style: TextStyle(fontSize: 11, color: CleanDroidColors.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton(
                onPressed: () => Navigator.of(ctx).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: CleanDroidColors.surfaceContainerHigh,
                  foregroundColor: CleanDroidColors.onSurface,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: const Text('Close'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStorageHero() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: CleanDroidColors.surfaceContainer,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: CleanDroidColors.surfaceContainerHigh),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'DEVICE STORAGE',
                    style: TextStyle(
                      fontSize: 11,
                      letterSpacing: 1.2,
                      color: CleanDroidColors.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Internal Shared',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: CleanDroidColors.onSurface),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: CleanDroidColors.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.warning_amber_rounded, size: 14, color: CleanDroidColors.tertiary),
                    SizedBox(width: 4),
                    Text(
                      '74% Capacity',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: CleanDroidColors.tertiary),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Circular Storage Gauge
          SizedBox(
            width: 190,
            height: 190,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(
                  size: const Size(190, 190),
                  painter: StorageRadialGaugePainter(),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'USED SPACE',
                      style: TextStyle(fontSize: 10, letterSpacing: 1, color: CleanDroidColors.onSurfaceVariant),
                    ),
                    const Text(
                      '94.2',
                      style: TextStyle(fontSize: 44, fontWeight: FontWeight.bold, color: CleanDroidColors.onSurface),
                    ),
                    const Text(
                      'GB of 128 GB',
                      style: TextStyle(fontSize: 12, color: CleanDroidColors.onSurfaceVariant),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Multi-Segment Linear Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: SizedBox(
              height: 10,
              child: Row(
                children: [
                  Expanded(flex: 33, child: Container(color: CleanDroidColors.primary)),
                  const SizedBox(width: 2),
                  Expanded(flex: 20, child: Container(color: CleanDroidColors.secondaryContainer)),
                  const SizedBox(width: 2),
                  Expanded(flex: 11, child: Container(color: CleanDroidColors.onSurfaceVariant)),
                  const SizedBox(width: 2),
                  Expanded(flex: 9, child: Container(color: CleanDroidColors.error)),
                  const SizedBox(width: 2),
                  Expanded(flex: 27, child: Container(color: CleanDroidColors.surfaceContainerHigh)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Legend Grid
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildLegendItem('Apps', '42.0 GB', CleanDroidColors.primary),
              _buildLegendItem('Media', '26.2 GB', CleanDroidColors.secondaryContainer),
              _buildLegendItem('System', '14.0 GB', CleanDroidColors.onSurfaceVariant),
              _buildLegendItem('Junk & Cache', '12.0 GB', CleanDroidColors.error),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, String size, Color color) {
    return Row(
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 4),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 10, color: CleanDroidColors.onSurfaceVariant)),
            Text(size, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: CleanDroidColors.onSurface)),
          ],
        ),
      ],
    );
  }

  Widget _buildDeepScanCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            CleanDroidColors.primaryContainer.withValues(alpha: 0.25),
            CleanDroidColors.surfaceContainer,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: CleanDroidColors.primary.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: CleanDroidColors.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.auto_delete, size: 14, color: CleanDroidColors.primary),
                    SizedBox(width: 4),
                    Text(
                      'DEEP SCAN COMPLETED',
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: CleanDroidColors.primary),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: CleanDroidColors.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.cleaning_services, color: CleanDroidColors.primary, size: 24),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '13.15',
                style: TextStyle(fontSize: 38, fontWeight: FontWeight.bold, color: CleanDroidColors.onSurface),
              ),
              SizedBox(width: 6),
              Text(
                'GB',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: CleanDroidColors.primary),
              ),
            ],
          ),
          const Text(
            'Reclaimable files detected across 4 areas',
            style: TextStyle(fontSize: 13, color: CleanDroidColors.onSurfaceVariant),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: onNavigateToCategories,
                  icon: const Icon(Icons.tune, size: 18),
                  label: const Text('Review & Clean'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CleanDroidColors.primary,
                    foregroundColor: CleanDroidColors.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              OutlinedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (ctx) => CleanCompleteSummaryScreen(
                        onDone: () => Navigator.of(ctx).pop(),
                      ),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: CleanDroidColors.onSurface,
                  side: const BorderSide(color: CleanDroidColors.surfaceContainerHigh),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: const Text('Quick Clean'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHealthCards() {
    return Row(
      children: [
        Expanded(
          child: _buildMetricTile(
            icon: Icons.memory,
            title: 'RAM Boost',
            value: '72% Used',
            sub: '+18% Speed gain',
            color: CleanDroidColors.secondary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildMetricTile(
            icon: Icons.thermostat,
            title: 'Battery Temp',
            value: '31.4 °C',
            sub: 'Optimal Range',
            color: CleanDroidColors.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildMetricTile({
    required IconData icon,
    required String title,
    required String value,
    required String sub,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CleanDroidColors.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: CleanDroidColors.surfaceContainerHigh),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: color),
              const SizedBox(width: 6),
              Text(title, style: const TextStyle(fontSize: 12, color: CleanDroidColors.onSurfaceVariant)),
            ],
          ),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: CleanDroidColors.onSurface)),
          const SizedBox(height: 2),
          Text(sub, style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class StorageRadialGaugePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 12;
    const strokeWidth = 14.0;

    // Track
    final trackPaint = Paint()
      ..color = CleanDroidColors.surfaceContainerHigh
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(center, radius, trackPaint);

    // Apps (33%)
    final appsPaint = Paint()
      ..color = CleanDroidColors.primary
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -math.pi / 2, 2 * math.pi * 0.33, false, appsPaint);

    // Media (20%)
    final mediaPaint = Paint()
      ..color = CleanDroidColors.secondaryContainer
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -math.pi / 2 + 2 * math.pi * 0.35, 2 * math.pi * 0.20, false, mediaPaint);

    // Junk (10%)
    final junkPaint = Paint()
      ..color = CleanDroidColors.error
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -math.pi / 2 + 2 * math.pi * 0.57, 2 * math.pi * 0.10, false, junkPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// -------------------------------------------------------------
// SCREEN 1: JUNK CATEGORY SELECTION
// -------------------------------------------------------------
class JunkCategorySelectionScreen extends StatefulWidget {
  final VoidCallback onNavigateToFileInspector;
  final VoidCallback onCleanSuccess;

  const JunkCategorySelectionScreen({
    super.key,
    required this.onNavigateToFileInspector,
    required this.onCleanSuccess,
  });

  @override
  State<JunkCategorySelectionScreen> createState() => _JunkCategorySelectionScreenState();
}

class _JunkCategorySelectionScreenState extends State<JunkCategorySelectionScreen> {
  bool selectAll = true;
  bool apkSelected = true;
  bool photoSelected = true;
  bool cacheSelected = true;
  bool residualSelected = true;

  double get totalSelectedGB {
    double total = 0.0;
    if (apkSelected) total += 1.40;
    if (photoSelected) total += 3.80;
    if (cacheSelected) total += 5.25;
    if (residualSelected) total += 2.70;
    return total;
  }

  void toggleSelectAll(bool? val) {
    final v = val ?? false;
    setState(() {
      selectAll = v;
      apkSelected = v;
      photoSelected = v;
      cacheSelected = v;
      residualSelected = v;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // Header Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Categories', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: CleanDroidColors.onSurface)),
                    Text('Select junk types to clean', style: TextStyle(fontSize: 12, color: CleanDroidColors.onSurfaceVariant)),
                  ],
                ),
                Row(
                  children: [
                    const Text('All', style: TextStyle(fontSize: 13, color: CleanDroidColors.onSurfaceVariant)),
                    Switch(
                      value: selectAll,
                      activeThumbColor: CleanDroidColors.primary,
                      onChanged: toggleSelectAll,
                    ),
                  ],
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                // Space Recovery Impact Card
                _buildImpactCard(),
                const SizedBox(height: 16),

                // Category 1: Obsolete APK Files
                _buildCategoryCard(
                  title: 'Obsolete APK Files',
                  size: '1.40 GB',
                  subtitle: '4 installer packages no longer needed',
                  badge: 'Safe to delete',
                  badgeColor: CleanDroidColors.primary,
                  icon: Icons.android,
                  iconColor: CleanDroidColors.secondary,
                  tags: ['com.spotify.music_v8.9.apk', 'retro_camera_build24.apk'],
                  isSelected: apkSelected,
                  onChanged: (val) => setState(() => apkSelected = val ?? false),
                  onTapDetails: widget.onNavigateToFileInspector,
                ),
                const SizedBox(height: 12),

                // Category 2: Duplicate & Blurry Photos
                _buildCategoryCard(
                  title: 'Duplicate & Blurry Photos',
                  size: '3.80 GB',
                  subtitle: '142 similar or low quality media files',
                  badge: 'Review advised',
                  badgeColor: CleanDroidColors.tertiary,
                  icon: Icons.photo_library,
                  iconColor: CleanDroidColors.tertiary,
                  tags: ['burst_shot_001.jpg', 'burst_shot_002.jpg'],
                  isSelected: photoSelected,
                  onChanged: (val) => setState(() => photoSelected = val ?? false),
                  onTapDetails: widget.onNavigateToFileInspector,
                ),
                const SizedBox(height: 12),

                // Category 3: App Cache & Temporary
                _buildCategoryCard(
                  title: 'App Cache & Temp Files',
                  size: '5.25 GB',
                  subtitle: '18 apps cached network images and temp data',
                  badge: 'Safe to delete',
                  badgeColor: CleanDroidColors.primary,
                  icon: Icons.cached,
                  iconColor: CleanDroidColors.primary,
                  tags: ['Chrome Cache', 'Instagram Cached Media'],
                  isSelected: cacheSelected,
                  onChanged: (val) => setState(() => cacheSelected = val ?? false),
                ),
                const SizedBox(height: 12),

                // Category 4: Residual Junk & System Logs
                _buildCategoryCard(
                  title: 'Residual Junk & Logs',
                  size: '2.70 GB',
                  subtitle: 'Leftover directories from uninstalled apps',
                  badge: 'Safe to delete',
                  badgeColor: CleanDroidColors.primary,
                  icon: Icons.delete_outline,
                  iconColor: CleanDroidColors.secondary,
                  tags: ['crash_dump.log', 'temp_extract/'],
                  isSelected: residualSelected,
                  onChanged: (val) => setState(() => residualSelected = val ?? false),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),

          // Bottom Action Bar
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: CleanDroidColors.surfaceContainerLow,
              border: Border(top: BorderSide(color: CleanDroidColors.surfaceContainerHigh)),
            ),
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: totalSelectedGB > 0 ? widget.onCleanSuccess : null,
                icon: const Icon(Icons.bolt, size: 20),
                label: Text(
                  'Clean Selected (${totalSelectedGB.toStringAsFixed(2)} GB)',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: CleanDroidColors.primary,
                  foregroundColor: CleanDroidColors.onPrimary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImpactCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CleanDroidColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: CleanDroidColors.surfaceContainerHigh),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.speed, size: 16, color: CleanDroidColors.primary),
                  SizedBox(width: 6),
                  Text('Space Recovery Impact', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: CleanDroidColors.onSurface)),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: CleanDroidColors.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  '+28% Free Space',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: CleanDroidColors.primary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: SizedBox(
              height: 8,
              child: Row(
                children: [
                  Expanded(flex: 63, child: Container(color: CleanDroidColors.surfaceBright)),
                  const SizedBox(width: 2),
                  Expanded(flex: 11, child: Container(color: CleanDroidColors.primary)),
                  const SizedBox(width: 2),
                  Expanded(flex: 26, child: Container(color: CleanDroidColors.surfaceContainerHigh)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Used: 94.2 GB', style: TextStyle(fontSize: 11, color: CleanDroidColors.onSurfaceVariant)),
              Text('Freed to: 46.95 GB Free', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: CleanDroidColors.primary)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard({
    required String title,
    required String size,
    required String subtitle,
    required String badge,
    required Color badgeColor,
    required IconData icon,
    required Color iconColor,
    required List<String> tags,
    required bool isSelected,
    required ValueChanged<bool?> onChanged,
    VoidCallback? onTapDetails,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CleanDroidColors.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? CleanDroidColors.primary.withValues(alpha: 0.3) : CleanDroidColors.surfaceContainerHigh,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: iconColor.withValues(alpha: 0.15),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            title,
                            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: CleanDroidColors.onSurface),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: badgeColor.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            badge,
                            style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: badgeColor),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(subtitle, style: const TextStyle(fontSize: 11, color: CleanDroidColors.onSurfaceVariant)),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(size, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: CleanDroidColors.onSurface)),
                  Checkbox(
                    value: isSelected,
                    activeColor: CleanDroidColors.primary,
                    checkColor: CleanDroidColors.onPrimary,
                    onChanged: onChanged,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: tags.map((t) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: CleanDroidColors.surfaceContainerHigh,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(t, style: const TextStyle(fontSize: 10, color: CleanDroidColors.onSurfaceVariant)),
                  )).toList(),
                ),
              ),
              if (onTapDetails != null)
                TextButton(
                  onPressed: onTapDetails,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    minimumSize: const Size(50, 30),
                  ),
                  child: const Row(
                    children: [
                      Text('Inspect', style: TextStyle(fontSize: 11, color: CleanDroidColors.primary)),
                      Icon(Icons.chevron_right, size: 14, color: CleanDroidColors.primary),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

// -------------------------------------------------------------
// SCREEN 3: GRANULAR FILE INSPECTOR
// -------------------------------------------------------------
class GranularFileInspectorScreen extends StatefulWidget {
  final VoidCallback onDeleteComplete;

  const GranularFileInspectorScreen({super.key, required this.onDeleteComplete});

  @override
  State<GranularFileInspectorScreen> createState() => _GranularFileInspectorScreenState();
}

class _GranularFileInspectorScreenState extends State<GranularFileInspectorScreen> {
  String selectedFilter = 'All';
  final Map<String, bool> selectedFiles = {
    'telegram_v10.4.apk': true,
    'spotify_v8.9.apk': true,
    'retro_camera_build24.apk': true,
    'screen_recording_4k.mp4': true,
    'vacation_drone_clip.mov': true,
    'burst_shot_001.jpg': true,
    'burst_shot_002.jpg': true,
  };

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // Header Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Text('Large Files Review', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: CleanDroidColors.onSurface)),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.more_vert, color: CleanDroidColors.onSurfaceVariant),
                  onPressed: () {},
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                // Inspection Staging Hub Card
                _buildStagingCard(),
                const SizedBox(height: 14),

                // Filter Tabs Row
                _buildFilterRow(),
                const SizedBox(height: 14),

                // Category 1: Obsolete APK Packages
                if (selectedFilter == 'All' || selectedFilter == 'APKs') ...[
                  _buildSectionHeader('Obsolete APK Packages', Icons.android, CleanDroidColors.primary, '3 Items • 201 MB'),
                  const SizedBox(height: 8),
                  _buildFileItem('telegram_v10.4.apk', '82 MB', 'Already installed', Icons.send),
                  _buildFileItem('spotify_v8.9.apk', '74 MB', 'Older release version', Icons.music_note),
                  _buildFileItem('retro_camera_build24.apk', '45 MB', 'Unused installer', Icons.camera_alt),
                  const SizedBox(height: 16),
                ],

                // Category 2: Heavy Videos
                if (selectedFilter == 'All' || selectedFilter == 'Videos') ...[
                  _buildSectionHeader('Heavy Videos & Clips', Icons.videocam, CleanDroidColors.secondary, '2 Items • 6.2 GB'),
                  const SizedBox(height: 8),
                  _buildFileItem('screen_recording_4k.mp4', '3.4 GB', 'Saved 14 days ago', Icons.video_file),
                  _buildFileItem('vacation_drone_clip.mov', '2.8 GB', 'Saved 1 month ago', Icons.movie),
                  const SizedBox(height: 16),
                ],

                // Category 3: Duplicate Photos
                if (selectedFilter == 'All' || selectedFilter == 'Photos') ...[
                  _buildSectionHeader('Duplicate Media', Icons.photo_library, CleanDroidColors.tertiary, '2 Items • 28 MB'),
                  const SizedBox(height: 8),
                  _buildFileItem('burst_shot_001.jpg', '14 MB', 'Duplicate of #002', Icons.image),
                  _buildFileItem('burst_shot_002.jpg', '14 MB', 'Exact byte match', Icons.image),
                  const SizedBox(height: 20),
                ],
              ],
            ),
          ),

          // Bottom Action Bar
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: CleanDroidColors.surfaceContainerLow,
              border: Border(top: BorderSide(color: CleanDroidColors.surfaceContainerHigh)),
            ),
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: widget.onDeleteComplete,
                icon: const Icon(Icons.delete_forever, size: 20),
                label: const Text('Delete Staged Files (12.85 GB)', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: CleanDroidColors.error,
                  foregroundColor: CleanDroidColors.onPrimary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStagingCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CleanDroidColors.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: CleanDroidColors.surfaceContainerHigh),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  CircleAvatar(radius: 3, backgroundColor: CleanDroidColors.primary),
                  SizedBox(width: 6),
                  Text('INSPECTION STAGING', style: TextStyle(fontSize: 10, letterSpacing: 1, color: CleanDroidColors.primary, fontWeight: FontWeight.bold)),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: CleanDroidColors.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text('Automated Triage', style: TextStyle(fontSize: 10, color: CleanDroidColors.onSurfaceVariant)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('12.85 GB', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: CleanDroidColors.onSurface)),
                  Text('150 of 154 files staged for purge', style: TextStyle(fontSize: 11, color: CleanDroidColors.onSurfaceVariant)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('Pool Total', style: TextStyle(fontSize: 10, color: CleanDroidColors.onSurfaceVariant)),
                  Text('13.15 GB', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: CleanDroidColors.onSurface)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: SizedBox(
              height: 6,
              child: Row(
                children: [
                  Expanded(flex: 74, child: Container(color: CleanDroidColors.primary)),
                  const SizedBox(width: 2),
                  Expanded(flex: 18, child: Container(color: CleanDroidColors.secondary)),
                  const SizedBox(width: 2),
                  Expanded(flex: 8, child: Container(color: CleanDroidColors.tertiaryContainer)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterRow() {
    final filters = ['All', 'Photos', 'Videos', 'APKs'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters.map((f) {
          final isSelected = selectedFilter == f;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(f),
              selected: isSelected,
              selectedColor: CleanDroidColors.primary,
              backgroundColor: CleanDroidColors.surfaceContainer,
              labelStyle: TextStyle(
                fontSize: 12,
                color: isSelected ? CleanDroidColors.onPrimary : CleanDroidColors.onSurfaceVariant,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              onSelected: (val) => setState(() => selectedFilter = f),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, Color color, String count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 6),
            Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: CleanDroidColors.onSurface)),
          ],
        ),
        Text(count, style: const TextStyle(fontSize: 11, color: CleanDroidColors.onSurfaceVariant)),
      ],
    );
  }

  Widget _buildFileItem(String name, String size, String desc, IconData icon) {
    final isChecked = selectedFiles[name] ?? false;
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: CleanDroidColors.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: CleanDroidColors.surfaceContainerHigh,
            child: Icon(icon, color: CleanDroidColors.primary, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: CleanDroidColors.onSurface)),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(size, style: const TextStyle(fontSize: 11, color: CleanDroidColors.primary, fontWeight: FontWeight.w600)),
                    const SizedBox(width: 6),
                    const Text('•', style: TextStyle(color: CleanDroidColors.onSurfaceVariant)),
                    const SizedBox(width: 6),
                    Text(desc, style: const TextStyle(fontSize: 11, color: CleanDroidColors.onSurfaceVariant)),
                  ],
                ),
              ],
            ),
          ),
          Checkbox(
            value: isChecked,
            activeColor: CleanDroidColors.primary,
            checkColor: CleanDroidColors.onPrimary,
            onChanged: (val) {
              setState(() {
                selectedFiles[name] = val ?? false;
              });
            },
          ),
        ],
      ),
    );
  }
}

// -------------------------------------------------------------
// SCREEN 4: CLEAN COMPLETE SUMMARY
// -------------------------------------------------------------
class CleanCompleteSummaryScreen extends StatelessWidget {
  final VoidCallback onDone;

  const CleanCompleteSummaryScreen({super.key, required this.onDone});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CleanDroidColors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          children: [
            // Center Celebration Badge
            const SizedBox(height: 20),
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: CleanDroidColors.primary.withValues(alpha: 0.12),
                    ),
                  ),
                  Container(
                    width: 90,
                    height: 90,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: CleanDroidColors.primaryContainer,
                      boxShadow: [
                        BoxShadow(color: Color(0x5544EDB7), blurRadius: 24, spreadRadius: 4),
                      ],
                    ),
                    child: const Icon(Icons.verified, size: 52, color: CleanDroidColors.onPrimaryContainer),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Headlines
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: CleanDroidColors.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.bolt, size: 14, color: CleanDroidColors.primary),
                    SizedBox(width: 4),
                    Text('CLEAN SUCCESSFUL', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: CleanDroidColors.primary)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              '13.15 GB Freed!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold, color: CleanDroidColors.onSurface),
            ),
            const SizedBox(height: 6),
            const Text(
              'Your device is now running lean, fresh, and fully optimized.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: CleanDroidColors.onSurfaceVariant),
            ),
            const SizedBox(height: 28),

            // Before & After Storage Metric Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: CleanDroidColors.surfaceContainer,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: CleanDroidColors.surfaceContainerHigh),
              ),
              child: Column(
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('BEFORE CLEAN', style: TextStyle(fontSize: 10, color: CleanDroidColors.onSurfaceVariant)),
                          Text('94.2 GB (74%)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: CleanDroidColors.error)),
                        ],
                      ),
                      Icon(Icons.arrow_forward, color: CleanDroidColors.primary, size: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('AFTER CLEAN', style: TextStyle(fontSize: 10, color: CleanDroidColors.onSurfaceVariant)),
                          Text('81.05 GB (63%)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: CleanDroidColors.primary)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: SizedBox(
                      height: 10,
                      child: Row(
                        children: [
                          Expanded(flex: 63, child: Container(color: CleanDroidColors.secondaryContainer)),
                          const SizedBox(width: 2),
                          Expanded(flex: 11, child: Container(color: CleanDroidColors.primary)),
                          const SizedBox(width: 2),
                          Expanded(flex: 26, child: Container(color: CleanDroidColors.surfaceContainerHigh)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: CleanDroidColors.surfaceContainerHigh,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.speed, size: 16, color: CleanDroidColors.primary),
                            SizedBox(width: 6),
                            Text('Estimated performance gain', style: TextStyle(fontSize: 12, color: CleanDroidColors.onSurface)),
                          ],
                        ),
                        Text('+18%', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: CleanDroidColors.primary)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Breakdown List
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: CleanDroidColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Column(
                children: [
                  _SummaryRow(label: 'App Cache Cleared', size: '5.25 GB'),
                  Divider(color: CleanDroidColors.surfaceContainerHigh),
                  _SummaryRow(label: 'Duplicate Photos Removed', size: '3.80 GB'),
                  Divider(color: CleanDroidColors.surfaceContainerHigh),
                  _SummaryRow(label: 'Obsolete APKs Deleted', size: '1.40 GB'),
                  Divider(color: CleanDroidColors.surfaceContainerHigh),
                  _SummaryRow(label: 'Residual Junk Purged', size: '2.70 GB'),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // Done Button
            SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: onDone,
                style: ElevatedButton.styleFrom(
                  backgroundColor: CleanDroidColors.primary,
                  foregroundColor: CleanDroidColors.onPrimary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text('Back to Dashboard', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 18),

            // Organisation & Author Attribution
            const Center(
              child: Column(
                children: [
                  Text(
                    'Idea Acquisition by Nova Technologies',
                    style: TextStyle(fontSize: 12, color: CleanDroidColors.onSurfaceVariant),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Author & Architect: Abhishek Singh',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: CleanDroidColors.primary),
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

class _SummaryRow extends StatelessWidget {
  final String label;
  final String size;

  const _SummaryRow({required this.label, required this.size});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 13, color: CleanDroidColors.onSurfaceVariant)),
          Text(size, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: CleanDroidColors.primary)),
        ],
      ),
    );
  }
}

// -------------------------------------------------------------
// SCREEN 5: STORAGE OVERVIEW (DEEP SCAN / ALTERNATE VIEW)
// -------------------------------------------------------------
class DeepOverviewScreen extends StatelessWidget {
  const DeepOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Deep System Analysis', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: CleanDroidColors.onSurface)),
          const SizedBox(height: 4),
          const Text('Partition & storage health overview', style: TextStyle(fontSize: 12, color: CleanDroidColors.onSurfaceVariant)),
          const SizedBox(height: 16),

          // Partition breakdown cards
          _buildPartitionTile('Internal User Partition', '80.2 GB / 112 GB', 0.71, CleanDroidColors.primary),
          const SizedBox(height: 12),
          _buildPartitionTile('Android System & Vendor', '14.0 GB / 16 GB', 0.87, CleanDroidColors.secondaryContainer),
          const SizedBox(height: 12),
          _buildPartitionTile('Runtime Cache Partition', '12.0 GB / 16 GB', 0.75, CleanDroidColors.error),
          const SizedBox(height: 20),

          // Deep Cleaner Actions
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: CleanDroidColors.surfaceContainer,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('One-Tap Accelerators', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: CleanDroidColors.onSurface)),
                const SizedBox(height: 12),
                _buildActionRow(Icons.rocket_launch, 'Instant RAM Flush', 'Frees ~2.1 GB background memory', () {}),
                const Divider(color: CleanDroidColors.surfaceContainerHigh),
                _buildActionRow(Icons.ac_unit, 'CPU Cooler', 'Cools down device by ~3.2°C', () {}),
                const Divider(color: CleanDroidColors.surfaceContainerHigh),
                _buildActionRow(Icons.security, 'App Permissions Audit', 'Review 12 apps with background storage access', () {}),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Project & Credits Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: CleanDroidColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: CleanDroidColors.surfaceContainerHigh),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.workspace_premium, size: 16, color: CleanDroidColors.primary),
                    SizedBox(width: 8),
                    Text('Project Credits & Attribution', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: CleanDroidColors.onSurface)),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: CleanDroidColors.secondaryContainer.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.business, color: CleanDroidColors.secondary, size: 18),
                    ),
                    const SizedBox(width: 12),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Nova Technologies', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: CleanDroidColors.onSurface)),
                        Text('Acquired Concept & Idea Rights', style: TextStyle(fontSize: 11, color: CleanDroidColors.onSurfaceVariant)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: CleanDroidColors.primary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.person, color: CleanDroidColors.primary, size: 18),
                    ),
                    const SizedBox(width: 12),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Abhishek Singh', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: CleanDroidColors.onSurface)),
                        Text('Original App Author & Architect', style: TextStyle(fontSize: 11, color: CleanDroidColors.onSurfaceVariant)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildPartitionTile(String title, String usage, double percent, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CleanDroidColors.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: CleanDroidColors.surfaceContainerHigh),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: CleanDroidColors.onSurface)),
              Text('${(percent * 100).toInt()}%', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: color)),
            ],
          ),
          const SizedBox(height: 4),
          Text(usage, style: const TextStyle(fontSize: 11, color: CleanDroidColors.onSurfaceVariant)),
          const SizedBox(height: 10),
          LinearProgressIndicator(
            value: percent,
            color: color,
            backgroundColor: CleanDroidColors.surfaceContainerHigh,
            minHeight: 6,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
    );
  }

  Widget _buildActionRow(IconData icon, String title, String subtitle, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: CleanDroidColors.surfaceContainerHigh,
              child: Icon(icon, color: CleanDroidColors.primary, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: CleanDroidColors.onSurface)),
                  Text(subtitle, style: const TextStyle(fontSize: 11, color: CleanDroidColors.onSurfaceVariant)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, size: 18, color: CleanDroidColors.onSurfaceVariant),
          ],
        ),
      ),
    );
  }
}
