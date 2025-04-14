import 'package:flutter/material.dart';
import 'package:nutri_mealo/pages/profile/delete_account_page.dart';
import 'package:nutri_mealo/pages/profile/profile_home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsHomePage extends StatefulWidget {
  const SettingsHomePage({super.key});

  @override
  State<SettingsHomePage> createState() => _SettingsHomePageState();
}

class _SettingsHomePageState extends State<SettingsHomePage> {
  bool isDarkMode = false;
  bool isNotificationsOn = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isDarkMode = prefs.getBool('darkMode') ?? false;
      isNotificationsOn = prefs.getBool('notificationsOn') ?? true;
    });
  }

  Future<void> _saveDarkMode(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', value);
  }

  Future<void> _saveNotifications(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notificationsOn', value);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: commonAppBar(),
        body: ListView(
          children: [
            const SizedBox(height: 30),
            topBarField(context),
            const SizedBox(height: 50),
            bunchOfFields(context),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Padding bunchOfFields(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(16),
          color: Colors.grey.shade100,
        ),
        child: Column(
          children: [
            settingsOptionTile(
              icon: Icons.dark_mode,
              title: "Dark Mode",
              trailing: Switch(
                value: isDarkMode,
                onChanged: (value) {
                  setState(() {
                    isDarkMode = value;
                  });
                  _saveDarkMode(value);
                },
              ),
            ),

            Divider(height: 1, color: Colors.grey.shade400),
            settingsOptionTile(
              icon: Icons.notifications,
              title: "Notifications",
              trailing: Switch(
                value: isNotificationsOn,
                onChanged: (value) {
                  setState(() {
                    isNotificationsOn = value;
                  });
                  _saveNotifications(value);
                },
              ),
            ),

            Divider(height: 1, color: Colors.grey.shade400),
            settingsOptionTile(
              icon: Icons.delete_forever,
              title: "Delete Account",
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => DeleteAccountPage()),
                );
              },
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

  Row topBarField(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 180),
        // Title centered
        Center(
          child: Text(
            'Settings',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),

        // Space to balance right side
        const SizedBox(width: 48),
      ],
    );
  }

  Widget settingsOptionTile({
    required IconData icon,
    required String title,
    required Widget trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.black, size: 30),
      title: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
      ),
      trailing: trailing,
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      minVerticalPadding: 16,
    );
  }
}
