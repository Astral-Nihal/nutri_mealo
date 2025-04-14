import 'package:flutter/material.dart';
import 'package:nutri_mealo/pages/profile/edit_profile/edit_profile_page1.dart';
import 'package:nutri_mealo/pages/profile/pressed_logout_card_page.dart';
import 'package:nutri_mealo/pages/profile/settings_home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileHomePage extends StatefulWidget {
  const ProfileHomePage({super.key});

  @override
  State<ProfileHomePage> createState() => _ProfileHomePageState();
}

class _ProfileHomePageState extends State<ProfileHomePage> {
  String _selectedAvatar = '';

  @override
  void initState() {
    super.initState();
    _loadAvatar();
  }

  void _loadAvatar() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedAvatar =
          prefs.getString('selectedAvatar') ?? 'assets/avatars/avatar1.png';
    });
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
            const SizedBox(height: 30),
            avatarField(context),
            const SizedBox(height: 100),
            editProfileField(),
            const SizedBox(height: 20),
            settingsField(),
            const SizedBox(height: 20),
            logoutField(),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Widget logoutField() {
    return profileCard(
      icon: Icons.logout,
      title: 'Logout',
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => PressedLogoutCardPage()),
        );
      },
    );
  }

  Widget settingsField() {
    return profileCard(
      icon: Icons.settings_outlined,
      title: 'Settings',
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => SettingsHomePage()),
        );
      },
    );
  }

  Widget editProfileField() {
    return profileCard(
      icon: Icons.edit_outlined,
      title: 'Edit Profile',
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => EditProfilePage1()),
        );
      },
    );
  }

  Widget profileCard({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(16),
            color: Colors.white,
          ),
          child: Row(
            children: [
              Icon(icon, size: 28, color: Colors.black87),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                size: 18,
                color: Colors.black45,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Center avatarField(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {
          _showAvatarSelectionDialog(context);
        },
        child: CircleAvatar(
          radius: 100,
          backgroundColor: Colors.white,
          backgroundImage:
              _selectedAvatar.isNotEmpty
                  ? AssetImage(_selectedAvatar)
                  : const AssetImage('assets/avatars/avatar1.png'),
        ),
      ),
    );
  }

  void _showAvatarSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Select Avatar'),
          content: SizedBox(
            width: double.maxFinite,
            child: GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              children: List.generate(6, (index) {
                String path = 'assets/avatars/avatar${index + 1}.png';
                return GestureDetector(
                  onTap: () async {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setString('selectedAvatar', path);
                    setState(() {
                      _selectedAvatar = path;
                    });
                    Navigator.of(context).pop();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage(path),
                    ),
                  ),
                );
              }),
            ),
          ),
        );
      },
    );
  }

  Row topBarField(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 15),
        // Circular close button
        // _circularIconButton(
        //   icon: Icons.close,
        //   onTap: () {
        //     Navigator.of(context).pushReplacement(
        //       MaterialPageRoute(builder: (_) => const MainNavigation()),
        //     );
        //   },
        // ),
        SizedBox(width: 170),
        // Title centered
        Center(
          child: Text(
            'Profile',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),

        // Space to balance right side
        const SizedBox(width: 48),
      ],
    );
  }

  // Widget _circularIconButton({
  //   required IconData icon,
  //   required VoidCallback? onTap,
  //   double iconSize = 24,
  //   bool disabled = false,
  // }) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 4.0),
  //     child: Material(
  //       color: disabled ? Colors.grey[300] : Colors.grey[200],
  //       shape: const CircleBorder(),
  //       elevation: 0, // No shadow as you requested earlier
  //       child: InkWell(
  //         onTap: disabled ? null : onTap,
  //         customBorder: const CircleBorder(),
  //         splashColor: Colors.grey.withOpacity(0.3),
  //         child: Container(
  //           padding: const EdgeInsets.all(12.0),
  //           decoration: BoxDecoration(
  //             border: Border.all(color: Colors.black54),
  //             shape: BoxShape.circle,
  //           ),
  //           child: Icon(
  //             icon,
  //             size: iconSize,
  //             color: disabled ? Colors.grey : Colors.black,
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

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
}
