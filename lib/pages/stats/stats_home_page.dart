import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class StatsHomePage extends StatefulWidget {
  const StatsHomePage({super.key});

  @override
  State<StatsHomePage> createState() => _StatsHomePageState();
}

class _StatsHomePageState extends State<StatsHomePage> {
  final List<bool> _isExpanded = [false, false, false];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: commonAppBar(),
        body: ListView(
          padding: const EdgeInsets.symmetric(vertical: 20),
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Statistics',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            _buildExpandableCard(
              index: 0,
              title: 'Daily Stats',
              child: _buildDailyStatsChart(),
            ),
            _buildExpandableCard(
              index: 1,
              title: 'Weekly Stats',
              child: _buildWeeklyStatsChart(),
            ),
            _buildExpandableCard(
              index: 2,
              title: 'Dish Ratings',
              child: _buildDishRatingsChart(),
            ),
          ],
        ),
      ),
    );
  }

  AppBar commonAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      title: const Text(
        'Nutri-mealo',
        style: TextStyle(
          color: Color(0xff16C47F),
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildExpandableCard({
    required int index,
    required String title,
    required Widget child,
  }) {
    final isOpen = _isExpanded[index];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Colors.black54),
        ),
        color: Colors.grey.shade200,
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  for (int i = 0; i < _isExpanded.length; i++) {
                    _isExpanded[i] = i == index ? !_isExpanded[i] : false;
                  }
                });
              },
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.bar_chart),
                    title: Text(
                      title,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    trailing: AnimatedRotation(
                      turns: isOpen ? 0.5 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: const Icon(Icons.keyboard_arrow_down_outlined),
                    ),
                  ),
                  if (isOpen)
                    Container(
                      height: 1,
                      width: double.infinity,
                      color: Colors.black38,
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                ],
              ),
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: ClipRect(
                child:
                    isOpen
                        ? Padding(
                          padding: const EdgeInsets.only(
                            top: 12,
                          ), // << spacing before chart
                          child: child,
                        )
                        : const SizedBox.shrink(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyStatsChart() {
    final List<double> dailyData = [30, 55, 42, 75, 63, 28, 47];
    final weekNumber =
        DateTime.now().difference(DateTime(DateTime.now().year, 1, 1)).inDays ~/
            7 +
        1;
    const barColor = Color(0xff16C47F);
    const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, top: 6),
          child: Text(
            "Week $weekNumber",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(height: 20),
        AspectRatio(
          aspectRatio: 1.5,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: BarChart(
              BarChartData(
                barTouchData: BarTouchData(enabled: true),
                alignment: BarChartAlignment.spaceAround,
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget:
                          (value, meta) => Text(
                            value.toInt().toString(),
                            style: const TextStyle(fontSize: 12),
                          ),
                      reservedSize: 28,
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget:
                          (value, meta) => Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              weekdays[value.toInt()],
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                    ),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                gridData: FlGridData(show: true),
                barGroups: List.generate(dailyData.length, (index) {
                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: dailyData[index],
                        color: barColor,
                        width: 18,
                        borderRadius: BorderRadius.zero,
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: Row(
            children: [
              Container(width: 12, height: 12, color: barColor),
              const SizedBox(width: 8),
              const Text(
                "Protein intake (grams)",
                style: TextStyle(fontSize: 13),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWeeklyStatsChart() {
    final List<double> weeklyData = [210, 195, 240, 180];
    final currentWeek =
        DateTime.now().difference(DateTime(DateTime.now().year, 1, 1)).inDays ~/
            7 +
        1;
    final List<String> labels = List.generate(
      4,
      (i) => 'Week${currentWeek - 3 + i}',
    );
    const barColor = Color(0xff16C47F);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AspectRatio(
          aspectRatio: 1.5,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: BarChart(
              BarChartData(
                barTouchData: BarTouchData(enabled: true),
                alignment: BarChartAlignment.spaceAround,
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget:
                          (value, meta) => Text(
                            value.toInt().toString(),
                            style: const TextStyle(fontSize: 12),
                          ),
                      reservedSize: 28,
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget:
                          (value, meta) => Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              labels[value.toInt()],
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                    ),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                gridData: FlGridData(show: true),
                barGroups: List.generate(weeklyData.length, (index) {
                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: weeklyData[index],
                        color: barColor,
                        width: 18,
                        borderRadius: BorderRadius.zero,
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: Row(
            children: [
              Container(width: 12, height: 12, color: barColor),
              const SizedBox(width: 8),
              const Text(
                "Protein intake (grams)",
                style: TextStyle(fontSize: 13),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDishRatingsChart() {
    const liked = 50.0;
    const disliked = 20.0;
    const notTried = 30.0;

    const likedColor = Color(0xff16C47F);
    const dislikedColor = Colors.redAccent;
    const notTriedColor = Colors.grey;

    return Column(
      children: [
        AspectRatio(
          aspectRatio: 2,
          child: PieChart(
            PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: 40,
              sections: [
                PieChartSectionData(
                  value: liked,
                  color: likedColor,
                  title: '${liked.toInt()}%',
                  titleStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                PieChartSectionData(
                  value: disliked,
                  color: dislikedColor,
                  title: '${disliked.toInt()}%',
                  titleStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                PieChartSectionData(
                  value: notTried,
                  color: notTriedColor,
                  title: '${notTried.toInt()}%',
                  titleStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 16,
          children: [
            _buildLegendButton("Liked", likedColor),
            _buildLegendButton("Disliked", dislikedColor),
            _buildLegendButton("Haven't Tried", notTriedColor),
          ],
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildLegendButton(String label, Color color) {
    return TextButton.icon(
      onPressed: () {},
      icon: Container(
        width: 12,
        height: 12,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
      label: Text(label, style: const TextStyle(color: Colors.black87)),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        foregroundColor: Colors.black,
      ),
    );
  }
}
