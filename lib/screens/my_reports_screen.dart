import 'package:flutter/material.dart';

class MyReportsScreen extends StatefulWidget {
  const MyReportsScreen({super.key});

  @override
  _MyReportsScreenState createState() => _MyReportsScreenState();
}

class _MyReportsScreenState extends State<MyReportsScreen> {
  String _selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Reports'),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          IconButton(icon: const Icon(Icons.filter_list), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          _buildHeader(),
          _buildFilterChips(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(8.0),
              children: [
                _buildReportCard(
                    'Large Pothole on Main St',
                    '#834-572',
                    '07/22/2024',
                    '123 Main St, Anytown, USA',
                    'Pending',
                    Colors.orange),
                _buildReportCard(
                    'Graffiti on Park Bench',
                    '#834-571',
                    '07/20/2024',
                    'Central Park, Anytown, USA',
                    'Assigned',
                    Colors.blue),
                _buildReportCard(
                    'Streetlight Outage on Elm St',
                    '#834-569',
                    '07/15/2024',
                    '456 Elm St, Anytown, USA',
                    'Resolved',
                    Colors.green),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Total Reports: 25'),
          const SizedBox(height: 8),
          const Row(
            children: [
              Text('15 Resolved, 10 Pending', style: TextStyle(color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: 15 / 25,
            backgroundColor: Colors.grey[300],
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildFilterChip('All'),
          _buildFilterChip('Pending'),
          _buildFilterChip('In Progress'),
          _buildFilterChip('Resolved'),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    bool isSelected = _selectedFilter == label;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (bool selected) {
        setState(() {
          if (selected) {
            _selectedFilter = label;
          }
        });
      },
      selectedColor: Colors.blue[100],
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildReportCard(String title, String id, String date, String address,
      String status, Color statusColor) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const Icon(Icons.more_vert),
              ],
            ),
            Text('ID: $id'),
            Text('Submitted: $date'),
            Text(address, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 10),
            Row(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  color: Colors.grey[300],
                  // Replace with actual image
                  child: const Icon(Icons.image, color: Colors.grey),
                ),
                const SizedBox(width: 10),
                Container(
                  width: 80,
                  height: 80,
                  color: Colors.grey[300],
                  child: const Icon(Icons.image, color: Colors.grey),
                ),
                const Spacer(),
                Chip(
                  label: Text(status),
                  backgroundColor: statusColor.withOpacity(0.2),
                  labelStyle: TextStyle(color: statusColor),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}