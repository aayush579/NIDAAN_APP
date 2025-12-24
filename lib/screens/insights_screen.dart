import 'package:flutter/material.dart';

class InsightsScreen extends StatelessWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Insights'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.calendar_today))
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatsGrid(),
            const SizedBox(height: 24),
            _buildSectionTitle('Live Issue Density'),
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(child: Text('[Map Placeholder]')),
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('Category Performance'),
            _buildPerformanceCard(),
            const SizedBox(height: 24),
            _buildSectionTitle('Progress Reports'),
            _buildReportLink('Q2 2024 Citywide Report', 'Published on July 15, 2024'),
            _buildReportLink('Q1 2024 Citywide Report', 'Published on April 15, 2024'),
            const SizedBox(height: 24),
            _buildSectionTitle('Top Performing Wards'),
            _buildWardCard('Ward 5', 'Avg. Resolution Time: 2.8 days', Colors.amber),
            _buildWardCard('Ward 12', 'Avg. Resolution Time: 3.2 days', Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsGrid() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: [
        _buildStatCard('Total Issues', '12,345'),
        _buildStatCard('Resolved', '8,765'),
        _buildStatCard('Avg. Time', '3.5 days'),
        _buildStatCard('Satisfaction', '4.2/5'),
      ],
    );
  }

  Widget _buildStatCard(String title, String value) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title, style: const TextStyle(color: Colors.grey)),
            Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildPerformanceCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Last 30 Days'),
                Row(
                  children: const [
                    Icon(Icons.arrow_upward, color: Colors.green, size: 16),
                    Text('10%', style: TextStyle(color: Colors.green)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildPerformanceBar('Road Repair', 0.85),
            _buildPerformanceBar('Waste Management', 0.78),
            _buildPerformanceBar('Street Lighting', 0.92),
            _buildPerformanceBar('Water Issues', 0.60),
            _buildPerformanceBar('Public Safety', 0.75),
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceBar(String category, double value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text(category)),
          Expanded(
            flex: 3,
            child: LinearProgressIndicator(
              value: value,
              minHeight: 10,
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          const SizedBox(width: 8),
          Text('${(value * 100).toInt()}%'),
        ],
      ),
    );
  }

  Widget _buildReportLink(String title, String subtitle) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: const Icon(Icons.description, color: Colors.blue),
        title: Text(title),
        subtitle: Text(subtitle),
      ),
    );
  }


  Widget _buildWardCard(String name, String detail, Color iconColor) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: Icon(Icons.emoji_events, color: iconColor),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(detail),
      ),
    );
  }
}
