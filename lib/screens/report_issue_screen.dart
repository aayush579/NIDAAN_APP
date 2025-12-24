import 'package:flutter/material.dart';

class ReportIssueScreen extends StatefulWidget {
  const ReportIssueScreen({super.key});

  @override
  _ReportIssueScreenState createState() => _ReportIssueScreenState();
}

class _ReportIssueScreenState extends State<ReportIssueScreen> {
  int _currentStep = 0;
  String? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Report an Issue [${_currentStep + 1} of 5]'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (_currentStep == 0) {
              Navigator.pop(context);
            } else {
              setState(() {
                _currentStep--;
              });
            }
          },
        ),
      ),
      body: Stepper(
        currentStep: _currentStep,
        onStepTapped: (step) => setState(() => _currentStep = step),
        onStepContinue: () {
          if (_currentStep < 4) {
            setState(() {
              _currentStep++;
            });
          } else {
            // Submit logic
            _showConfirmationDialog();
          }
        },
        onStepCancel: _currentStep == 0 ? null : () => setState(() => _currentStep--),
        controlsBuilder: (BuildContext context, ControlsDetails details) {
          return Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Row(
              children: <Widget>[
                if (_currentStep !=0)
                  TextButton(
                    onPressed: details.onStepCancel,
                    child: const Text('BACK'),
                  ),
                const Spacer(),
                ElevatedButton(
                  onPressed: details.onStepContinue,
                  child: Text(_currentStep < 4 ? 'NEXT' : 'SUBMIT'),
                ),
              ],
            ),
          );
        },
        steps: [
          Step(
            title: const Text('Select Category'),
            content: _buildCategorySelection(),
            isActive: _currentStep >= 0,
          ),
          Step(
            title: const Text('Add Photos'),
            content: _buildAddPhotos(),
            isActive: _currentStep >= 1,
          ),
          Step(
            title: const Text('Describe Issue'),
            content: _buildDescribeIssue(),
            isActive: _currentStep >= 2,
          ),
          Step(
            title: const Text('Confirm Location'),
            content: _buildConfirmLocation(),
            isActive: _currentStep >= 3,
          ),
          Step(
            title: const Text('Enter Your Details'),
            content: _buildEnterDetails(),
            isActive: _currentStep >= 4,
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Select a category', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          children: [
            _buildCategoryItem('Road Damage', Icons.construction, 'Road Damage'),
            _buildCategoryItem('Graffiti', Icons.format_paint, 'Graffiti'),
            _buildCategoryItem('Illegal Dumping', Icons.delete_sweep, 'Illegal Dumping'),
            _buildCategoryItem('Broken Street Light', Icons.lightbulb_outline, 'Broken Street Light'),
            _buildCategoryItem('Other', Icons.info_outline, 'Other'),
          ],
        )
      ],
    );
  }

  Widget _buildCategoryItem(String title, IconData icon, String category) {
    final bool isSelected = _selectedCategory == category;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategory = category;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue[50] : Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: isSelected ? Colors.blue : Colors.black54),
            const SizedBox(height: 8),
            Text(title, style: TextStyle(color: isSelected ? Colors.blue : Colors.black87, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildAddPhotos() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Visual proof helps us resolve the issue faster.', style: TextStyle(fontSize: 16)),
        const SizedBox(height: 24),
        ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.camera_alt),
          label: const Text('Take Photo'),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
          ),
        ),
        const SizedBox(height: 16),
        OutlinedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.photo_library),
          label: const Text('Choose from Gallery'),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
          ),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildPhotoPlaceholder(),
            _buildPhotoPlaceholder(),
            _buildPhotoPlaceholder(),
          ],
        )
      ],
    );
  }

  Widget _buildPhotoPlaceholder() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(Icons.add_a_photo, color: Colors.grey),
    );
  }


  Widget _buildDescribeIssue() {
    return Column(
      children: [
        const TextField(
          decoration: InputDecoration(
            hintText: 'Describe the issue... (e.g., Large pothole near the bus stop)',
            border: OutlineInputBorder(),
            suffixIcon: Icon(Icons.mic),
          ),
          maxLines: 4,
        ),
        const SizedBox(height: 20),
        RadioListTile(
          title: const Text("Use my current location"),
          value: "current",
          groupValue: "location",
          onChanged: (value) {},
        ),
        RadioListTile(
          title: const Text("Type address manually"),
          value: "manual",
          groupValue: "location",
          onChanged: (value) {},
        )
      ],
    );
  }

  Widget _buildConfirmLocation() {
    return Column(
      children: [
        const Text("We've automatically tagged your location using GPS."),
        const SizedBox(height: 16),
        Container(
          height: 200,
          color: Colors.grey[300],
          child: const Center(child: Text('[Map Placeholder]')), // Placeholder for a map widget
        ),
        const SizedBox(height: 16),
        const Text('Near Harmu Main Road, Ranchi, Jharkhand', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 24),
        ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.check),
          label: const Text('Yes, Correct'),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
          ),
        ),
        const SizedBox(height: 16),
        OutlinedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.edit_location),
          label: const Text('Edit Location'),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
          ),
        ),
      ],
    );
  }

  Widget _buildEnterDetails() {
    return Column(
      children: const [
        TextField(decoration: InputDecoration(labelText: 'Full Name*')),
        SizedBox(height: 8),
        TextField(decoration: InputDecoration(labelText: '10-digit mobile number*')),
        SizedBox(height: 8),
        TextField(decoration: InputDecoration(labelText: 'Pincode*')),
        SizedBox(height: 8),
        Row(
          children: [
            Expanded(child: TextField(decoration: InputDecoration(labelText: 'State*'))),
            SizedBox(width: 8),
            Expanded(child: TextField(decoration: InputDecoration(labelText: 'City*'))),
          ],
        ),
        SizedBox(height: 8),
        TextField(decoration: InputDecoration(labelText: 'Address (Area and Street)*')),
        SizedBox(height: 8),
        TextField(decoration: InputDecoration(labelText: 'Locality/Area*')),
        SizedBox(height: 8),
        TextField(decoration: InputDecoration(labelText: 'Landmark (Optional)')),
        SizedBox(height: 8),
        TextField(decoration: InputDecoration(labelText: 'Alternate Phone (Optional)')),

      ],
    );
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircleAvatar(
                radius: 30,
                backgroundColor: Colors.green,
                child: Icon(Icons.check, color: Colors.white, size: 40),
              ),
              const SizedBox(height: 20),
              const Text('Report Submitted!', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text('Thank you for helping make Ranchi better.', textAlign: TextAlign.center),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Column(
                  children: [
                    Text('Your Ticket ID'),
                    Text('JHR-2025-10842', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              const Text("You can track the status in 'My Reports'."),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                icon: const Icon(Icons.home),
                label: const Text('Go to Home'),
                onPressed: () {
                  Navigator.of(context).pop(); // Close dialog
                  Navigator.of(context).pop(); // Go back from report screen
                },
                style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
              ),
              const SizedBox(height: 8),
              TextButton.icon(
                icon: const Icon(Icons.receipt_long),
                label: const Text('View Ticket'),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  // Here you would navigate to the My Reports screen and filter for this ticket
                },
              )
            ],
          ),
        );
      },
    );
  }
}