import 'package:civic_issue_reporter/services/auth_service.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService _auth = AuthService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildProfileHeader(),
            const SizedBox(height: 20),
            _buildSection('My Account'),
            _buildProfileOption(Icons.person_outline, 'Personal Information'),
            _buildProfileOption(Icons.location_on_outlined, 'My Addresses'),
            _buildProfileOption(Icons.lock_outline, 'Change Password'),
            _buildProfileOption(Icons.language, 'Language', trailing: 'English'),
            _buildProfileOption(Icons.notifications_outlined, 'Notification Settings'),
            const Divider(),
            _buildSection('App Settings'),
            _buildProfileOption(Icons.data_usage, 'Data Usage'),
            _buildProfileOption(Icons.send_to_mobile, 'Auto-Submit Reports'),
            const Divider(),
            _buildSection('Support'),
            _buildProfileOption(Icons.help_outline, 'Help & FAQ'),
            _buildProfileOption(Icons.support_agent, 'Contact Support'),
            _buildProfileOption(Icons.star_outline, 'Rate This App'),
            _buildProfileOption(Icons.info_outline, 'How It Works'),
            const Divider(),
            _buildSection('About'),
            _buildProfileOption(Icons.description_outlined, 'Terms of Service'),
            _buildProfileOption(Icons.privacy_tip_outlined, 'Privacy Policy'),
            _buildProfileOption(Icons.system_update_alt, 'App Version', trailing: '1.2.3'),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextButton(
                onPressed: () async {
                  await _auth.signOut();
                },
                child: const Text('Logout', style: TextStyle(color: Colors.red)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: const [
        CircleAvatar(
          radius: 50,
          //backgroundImage: NetworkImage('...'), // Placeholder
          backgroundColor: Colors.grey,
        ),
        SizedBox(height: 10),
        Text('Ethan Carter', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        Text('San Francisco, CA', style: TextStyle(color: Colors.grey)),
      ],
    );
  }

  Widget _buildSection(String title){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Align(
          alignment: Alignment.centerLeft,
          child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
    );
  }


  Widget _buildProfileOption(IconData icon, String title, {String? trailing}) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: trailing != null ? Text(trailing, style: const TextStyle(color: Colors.grey)) : const Icon(Icons.chevron_right, color: Colors.grey,),
      onTap: () {},
    );
  }
}
