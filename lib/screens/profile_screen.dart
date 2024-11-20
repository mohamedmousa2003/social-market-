import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';
import 'package:social_market/models/user_model.dart';
import 'package:social_market/provider/user_provider.dart';
import 'package:social_market/screens/auth/login_screen.dart';
import 'package:social_market/screens/inner_screens/loading_manager.dart';
import 'package:social_market/screens/inner_screens/viewed_recently.dart';
import 'package:social_market/screens/inner_screens/wishlits.dart';
import 'package:social_market/services/assets_manager.dart';
import 'package:social_market/services/my_app_methods.dart';
import 'package:social_market/widgets/app_name.text.dart';
import 'package:social_market/widgets/subtitle_text.dart';
import 'package:social_market/widgets/title_text.dart';
import '../provider/them_provider.dart';
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with AutomaticKeepAliveClientMixin {
  User? user = FirebaseAuth.instance.currentUser;
  bool _isLoading = true;
  UserModel? userModel;

  Future<void> fetchUserInfo() async {
    if (user == null) {
      setState(() {
        _isLoading = false;
      });
      return;
    }
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      userModel = await userProvider.fetchUserInfo();
    } catch (error) {
      await MyAppMethods.showErrorOrWarningDialog(
          context: context,
          subtitle: "An error occurred: $error",
          fct: () {}
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    fetchUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);  // Ensure state persistence
    final themeProvider = Provider.of<ThemeProvider>(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        leading: Image.asset(AssetsMamager.shoppingCart),
        title: const AppNameTextWidget(fontSize: 30),
      ),
      body: LoadingManager(
        isLoading: _isLoading,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (user == null)
              const Padding(
                padding: EdgeInsets.all(20.0),
                child: TitleTextWidget(label: "Please login to have ultimate access"),
              ),

            if (userModel != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    Container(
                      height: 70,
                      width: 70,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).cardColor,
                        border: Border.all(color: Colors.blueGrey, width: 2.5),
                        image: DecorationImage(
                          image: NetworkImage(userModel!.userImage),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    const SizedBox(width: 7),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TitleTextWidget(label: userModel!.userName),
                        SubtitleTextWidget(label: userModel!.userEmail),
                      ],
                    ),
                  ],
                ),
              ),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 24),
              child: TitleTextWidget(label: 'General'),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  
                  CustomListTile(
                    imagePath: AssetsMamager.wishlist_svg,
                    text: "Wishlist",
                    function: () => Navigator.pushNamed(context, WishlistScreen.routName),
                  ),
                  CustomListTile(
                    imagePath: AssetsMamager.recent,
                    text: "Viewed Recently",
                    function: () => Navigator.pushNamed(context, ViewedRecentlyScreen.routName),
                  ),
                  
                  const Divider(thickness: 1),
                  const TitleTextWidget(label: "Settings"),
                  SwitchListTile(
                    secondary: Image.asset(AssetsMamager.theme, height: 30),
                    title: Text(themeProvider.getIsDarkTheme ? "Dark Mode" : "Light Mode"),
                    value: themeProvider.getIsDarkTheme,
                    onChanged: (value) => themeProvider.setDarkTheme(themeValue: value),
                  ),
                  const Divider(thickness: 1),
                  Center(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      onPressed: () async {
                        if (user == null) {
                          await Navigator.pushNamed(context, LoginScreen.routName);
                        } else {
                          MyAppMethods.showErrorOrWarningDialog(
                            context: context,
                            fct: () async {
                              await FirebaseAuth.instance.signOut();
                              if (!mounted) return;
                              await Navigator.pushNamed(context, LoginScreen.routName);
                            },
                            subtitle: user == null ? "Login" : "Logout",
                            isError: true,
                          );
                        }
                      },
                      icon: Icon(user == null ? IconlyBold.login : IconlyBold.logout, color: Colors.white),
                      label: Text(user == null ? "Login" : "Logout", style: const TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class CustomListTile extends StatelessWidget {
  const CustomListTile({super.key, required this.imagePath, required this.text, required this.function});

  final String imagePath, text;
  final Function function;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => function(),
      leading: Image.asset(imagePath, height: 30),
      title: SubtitleTextWidget(label: text),
      trailing: const Icon(IconlyBold.arrowRight2),
    );
  }
}
