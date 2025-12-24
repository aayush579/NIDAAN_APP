import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Welcome,', style: TextStyle(fontSize: 16)),
            Text('Alex M.', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
        ],
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileCard(),
            const SizedBox(height: 24),
            _buildOfficialAnnouncementCard(),
            const SizedBox(height: 24),
            _buildSectionHeader('Recent Activity'),
            const SizedBox(height: 8),
            _buildRecentActivityItem('Pothole on Elm Street', 'Resolved', Icons.check_circle, Colors.green),
            _buildRecentActivityItem('Graffiti on Oak Avenue', 'Reported', Icons.radio_button_unchecked, Colors.grey),
            const SizedBox(height: 24),
            _buildSectionHeader('Issues Near You'),
            const SizedBox(height: 8),
            _buildNearbyIssueItem('Damaged Sidewalk', '200m away', Icons.warning_amber_rounded, Colors.orange),
            _buildNearbyIssueItem('Blocked Drain', '500m away', Icons.opacity, Colors.blue),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 30,
              backgroundColor: Colors.grey,
              child: Icon(Icons.person, size: 30, color: Colors.white),
            ),
            const SizedBox(width: 16),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Alex Morgan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text('Springfield, IL', style: TextStyle(color: Colors.grey)),
              ],
            ),
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text('Your Impact', style: TextStyle(color: Colors.grey)),
                const Text('Level 2: Community Helper', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text('15 Reports', style: TextStyle(color: Colors.grey[600])),
                    const SizedBox(width: 16),
                    Text('5 Resolved', style: TextStyle(color: Colors.green[600], fontWeight: FontWeight.bold)),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildOfficialAnnouncementCard() {
    return Card(
      color: Colors.blue[50],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Official Announcement', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                  const SizedBox(height: 8),
                  const Text('Annual city-wide cleanup event this Saturday. Volunteers needed!'),
                  TextButton(
                    onPressed: () {},
                    child: const Text('View More'),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.campaign, color: Colors.blue),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        TextButton(onPressed: () {}, child: const Text('View All')),
      ],
    );
  }

  Widget _buildRecentActivityItem(String title, String status, IconData icon, Color color) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(title),
        subtitle: Text(status, style: TextStyle(color: color)),
      ),
    );
  }

  Widget _buildNearbyIssueItem(String title, String distance, IconData icon, Color color) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.1),
          child: Icon(icon, color: color),
        ),
        title: Text(title),
        subtitle: Text(distance),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}
