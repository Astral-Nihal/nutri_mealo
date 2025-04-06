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
        const SizedBox(width: 15),
        // Circular close button
        _circularIconButton(
          icon: Icons.arrow_back,
          onTap: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const ProfileHomePage()),
            );
          },
        ),
        SizedBox(width: 120),
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

  Widget _circularIconButton({
    required IconData icon,
    required VoidCallback? onTap,
    double iconSize = 24,
    bool disabled = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Material(
        color: disabled ? Colors.grey[300] : Colors.grey[200],
        shape: const CircleBorder(),
        elevation: 0, // No shadow as you requested earlier
        child: InkWell(
          onTap: disabled ? null : onTap,
          customBorder: const CircleBorder(),
          splashColor: Colors.grey.withOpacity(0.3),
          child: Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black54),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: iconSize,
              color: disabled ? Colors.grey : Colors.black,
            ),
          ),
        ),
      ),
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
