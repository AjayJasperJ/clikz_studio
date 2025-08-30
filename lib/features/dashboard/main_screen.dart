import 'package:clikz_studio/features/auth/auth_screen.dart';
import 'package:clikz_studio/widgets/custom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final displaySize = MediaQuery.of(context).size;
    // Mock data for dashboard
    final totalAudits = 12;
    final upcomingAudits = 3;
    final openIssues = 2;
    final complianceRate = 94;
    final profileImage = 'assets/images/empty_profile.png';
    final logo = 'assets/images/app_logo.png';
    final List<Map<String, String>> upcomingAuditList = [
      {"date": "Sep 2, 10:00 AM", "studio": "Studio A", "auditor": "Ajay", "status": "Scheduled"},
      {"date": "Sep 5, 2:00 PM", "studio": "Studio B", "auditor": "Priya", "status": "In Progress"},
      {"date": "Sep 7, 11:00 AM", "studio": "Studio C", "auditor": "Ajay", "status": "Scheduled"},
    ];
    final List<String> recentActivities = [
      "Lighting Audit completed at Studio A",
      "Equipment Maintenance issue logged",
      "Safety compliance submitted",
    ];
    final List<Map<String, dynamic>> shortcuts = [
      {"icon": Icons.history, "label": "Audit History"},
      {"icon": Icons.camera_alt, "label": "Asset Register"},
      {"icon": Icons.group, "label": "Team Members"},
      {"icon": Icons.settings, "label": "Settings"},
      {"icon": Icons.help_outline, "label": "Help/Support"},
    ];
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              Image.asset(logo, height: 32),
              SizedBox(width: 12),
              Text('ClikzWF', style: theme.textTheme.titleMedium),
            ],
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.notifications_none),
              tooltip: 'Notifications',
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.logout),
              tooltip: 'Logout',
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                if (mounted) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => AuthScreen()),
                    (route) => false,
                  );
                }
              },
            ),
          ],
        ),
        body: Wpad(
          child: ListView(
            children: [
              // Header: Avatar, Greeting
              Row(
                children: [
                  CircleAvatar(radius: 28, backgroundImage: AssetImage(profileImage)),
                  SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      'Hi, ${FirebaseAuth.instance.currentUser?.displayName ?? 'User'}!',
                      style: theme.textTheme.titleLarge,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 18),
              // Dashboard Cards
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _dashboardCard(
                    theme,
                    'Total Audits',
                    totalAudits.toString(),
                    Icons.assignment_turned_in,
                    Colors.blue,
                  ),
                  _dashboardCard(
                    theme,
                    'Upcoming',
                    upcomingAudits.toString(),
                    Icons.event,
                    Colors.orange,
                  ),
                ],
              ),
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _dashboardCard(
                    theme,
                    'Open Issues',
                    openIssues.toString(),
                    Icons.report_problem,
                    Colors.red,
                  ),
                  _dashboardCard(
                    theme,
                    'Compliance',
                    '$complianceRate%',
                    Icons.verified,
                    Colors.green,
                  ),
                ],
              ),
              SizedBox(height: 18),
              // Quick Actions
              Text('Quick Actions', style: theme.textTheme.titleMedium),
              SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.add_task),
                      label: Text('Start New Audit'),
                      onPressed: () {},
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: Icon(Icons.play_arrow),
                      label: Text('Continue Audit'),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: Icon(Icons.cloud_upload),
                      label: Text('Upload Evidence'),
                      onPressed: () {},
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: Icon(Icons.bar_chart),
                      label: Text('View Reports'),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),
              // Upcoming Audits
              Text('Upcoming Audits', style: theme.textTheme.titleMedium),
              SizedBox(height: 8),
              SizedBox(
                height: 120,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: upcomingAuditList.length,
                  separatorBuilder: (context, i) => SizedBox(width: 12),
                  itemBuilder: (context, i) {
                    final audit = upcomingAuditList[i];
                    return Container(
                      width: 220,
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(audit['date']!, style: theme.textTheme.bodySmall),
                          SizedBox(height: 4),
                          Text(audit['studio']!, style: theme.textTheme.titleMedium),
                          SizedBox(height: 4),
                          Text('Auditor: ${audit['auditor']}', style: theme.textTheme.bodySmall),
                          SizedBox(height: 4),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: audit['status'] == 'Scheduled' ? Colors.orange : Colors.blue,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              audit['status']!,
                              style: theme.textTheme.bodySmall!.copyWith(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 24),
              // Recent Activities
              Text('Recent Activities', style: theme.textTheme.titleMedium),
              SizedBox(height: 8),
              ...recentActivities.map(
                (activity) => ListTile(
                  leading: Icon(Icons.check_circle_outline, color: Colors.green),
                  title: Text(activity),
                ),
              ),
              SizedBox(height: 24),
              // Shortcuts
              Text('Shortcuts', style: theme.textTheme.titleMedium),
              SizedBox(height: 8),
              SizedBox(
                height: 80,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: shortcuts.length,
                  separatorBuilder: (context, i) => SizedBox(width: 16),
                  itemBuilder: (context, i) {
                    final shortcut = shortcuts[i];
                    return Column(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: theme.colorScheme.primary.withOpacity(0.15),
                          child: Icon(shortcut['icon'], size: 28, color: theme.colorScheme.primary),
                        ),
                        SizedBox(height: 6),
                        Text(shortcut['label'], style: theme.textTheme.bodySmall),
                      ],
                    );
                  },
                ),
              ),
              SizedBox(height: 24),
              // Analytics/Charts
              Text('Analytics', style: theme.textTheme.titleMedium),
              SizedBox(height: 8),
              Text('Compliance Over Time', style: theme.textTheme.bodyMedium),
              SizedBox(height: 16),
              SizedBox(
                height: 180,
                child: LineChart(
                  LineChartData(
                    minY: 70,
                    maxY: 100,
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: true,
                      getDrawingHorizontalLine: (value) =>
                          FlLine(color: Colors.grey.withOpacity(0.15), strokeWidth: 1),
                      getDrawingVerticalLine: (value) =>
                          FlLine(color: Colors.grey.withOpacity(0.10), strokeWidth: 1),
                    ),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 32,
                          getTitlesWidget: (value, meta) =>
                              Text('${value.toInt()}%', style: TextStyle(fontSize: 12)),
                          interval: 5,
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                            return Padding(
                              padding: EdgeInsets.only(top: 6),
                              child: Text(days[value.toInt()], style: TextStyle(fontSize: 12)),
                            );
                          },
                          interval: 1,
                        ),
                      ),
                      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    ),
                    borderData: FlBorderData(
                      show: true,
                      border: Border.all(color: Colors.grey.withOpacity(0.2)),
                    ),
                    lineBarsData: [
                      LineChartBarData(
                        spots: [
                          FlSpot(0, 80),
                          FlSpot(1, 85),
                          FlSpot(2, 90),
                          FlSpot(3, 92),
                          FlSpot(4, 94),
                          FlSpot(5, 93),
                          FlSpot(6, 95),
                        ],
                        isCurved: true,
                        gradient: LinearGradient(colors: [Colors.green, Colors.lightGreenAccent]),
                        barWidth: 5,
                        isStrokeCapRound: true,
                        belowBarData: BarAreaData(
                          show: true,
                          gradient: LinearGradient(
                            colors: [
                              Colors.green.withOpacity(0.3),
                              Colors.lightGreenAccent.withOpacity(0.1),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                        dotData: FlDotData(
                          show: true,
                          getDotPainter: (spot, percent, bar, index) => FlDotCirclePainter(
                            radius: 5,
                            color: Colors.white,
                            strokeWidth: 3,
                            strokeColor: Colors.green,
                          ),
                        ),
                      ),
                    ],
                    lineTouchData: LineTouchData(
                      enabled: true,
                      touchTooltipData: LineTouchTooltipData(
                        // getTooltipColor: Colors.black87,
                        getTooltipItems: (touchedSpots) => touchedSpots
                            .map(
                              (spot) => LineTooltipItem(
                                '${spot.y.toStringAsFixed(1)}%',
                                TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text('Most Common Issues', style: theme.textTheme.bodyMedium),
              SizedBox(height: 16),
              SizedBox(
                height: 180,
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: 10,
                    gridData: FlGridData(
                      show: true,
                      drawHorizontalLine: true,
                      getDrawingHorizontalLine: (value) =>
                          FlLine(color: Colors.grey.withOpacity(0.15), strokeWidth: 1),
                    ),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 32,
                          getTitlesWidget: (value, meta) =>
                              Text('${value.toInt()}', style: TextStyle(fontSize: 12)),
                          interval: 2,
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            const issues = ['Light', 'Equip', 'Safety', 'Other'];
                            return Padding(
                              padding: EdgeInsets.only(top: 6),
                              child: Text(issues[value.toInt()], style: TextStyle(fontSize: 12)),
                            );
                          },
                          interval: 1,
                        ),
                      ),
                      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    ),
                    borderData: FlBorderData(
                      show: true,
                      border: Border.all(color: Colors.grey.withOpacity(0.2)),
                    ),
                    barGroups: [
                      BarChartGroupData(
                        x: 0,
                        barRods: [
                          BarChartRodData(
                            toY: 8,
                            gradient: LinearGradient(colors: [Colors.red, Colors.orange]),
                            width: 24,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ],
                      ),
                      BarChartGroupData(
                        x: 1,
                        barRods: [
                          BarChartRodData(
                            toY: 5,
                            gradient: LinearGradient(colors: [Colors.orange, Colors.yellow]),
                            width: 24,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ],
                      ),
                      BarChartGroupData(
                        x: 2,
                        barRods: [
                          BarChartRodData(
                            toY: 3,
                            gradient: LinearGradient(colors: [Colors.blue, Colors.lightBlueAccent]),
                            width: 24,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ],
                      ),
                      BarChartGroupData(
                        x: 3,
                        barRods: [
                          BarChartRodData(
                            toY: 2,
                            gradient: LinearGradient(colors: [Colors.purple, Colors.pinkAccent]),
                            width: 24,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ],
                      ),
                    ],
                    barTouchData: BarTouchData(
                      enabled: true,
                      touchTooltipData: BarTouchTooltipData(
                        // tooltipBgColor: Colors.black87,
                        getTooltipItem: (group, groupIndex, rod, rodIndex) {
                          final labels = ['Lighting', 'Equipment', 'Safety', 'Other'];
                          return BarTooltipItem(
                            '${labels[group.x]}: ${rod.toY.toInt()}',
                            TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24),
              // Search Bar
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search audits, assets, or locations',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dashboardCard(ThemeData theme, String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            SizedBox(height: 8),
            Text(value, style: theme.textTheme.titleLarge?.copyWith(color: color)),
            SizedBox(height: 4),
            Text(label, style: theme.textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}
