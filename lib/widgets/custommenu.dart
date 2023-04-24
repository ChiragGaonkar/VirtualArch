import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import '/firebase/authentication.dart';
import '/screens/accounts/account_screen.dart';
import '/screens/display_screen.dart';
import '/screens/housemodels/exploremodels_screen.dart';
import '/screens/upload_work/upload_work.dart';
import '/widgets/customloadingspinner.dart';
import '../providers/drawer_nav_provider.dart';
import '../providers/user_data_provider.dart';
import '../screens/auth/home_screen.dart';

class CustomMenu extends StatefulWidget {
  const CustomMenu({super.key});

  @override
  State<CustomMenu> createState() => _CustomMenuState();
}

class _CustomMenuState extends State<CustomMenu> {
  //Code for retrieving data from firestore
  final User? user = Auth().currentUser;

  Future<void> signOut() async {
    await Auth().signOut();
  }

  //Code for retrieving data from firestore ends here

  Widget _buildListTile(
    String titleData,
    IconData iconData,
    bool isSelected,
  ) {
    final theme = Theme.of(context);

    return ListTile(
      leading: Icon(
        iconData,
        color: isSelected ? theme.primaryColor : theme.secondaryHeaderColor,
      ),
      title: Text(
        titleData,
        style: theme.textTheme.titleMedium!.copyWith(
          color: isSelected ? theme.primaryColor : theme.secondaryHeaderColor,
        ),
      ),
      tileColor:
          isSelected ? Colors.black.withOpacity(0.3) : Colors.transparent,
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var userData = Provider.of<UserDataProvide>(context, listen: false);
    var highLighter = Provider.of<DrawerNavProvider>(context, listen: false);
    var navigatorVar = Navigator.of(context);
    highLighter.changeHighLighter(ModalRoute.of(context)!.settings.name);
    return SizedBox(
      width: size.width * 0.6,
      child: Scaffold(
        backgroundColor:
            Theme.of(context).scaffoldBackgroundColor.withOpacity(1),
        body: SafeArea(
          child: SizedBox(
            height: size.height,
            child: Column(
              children: [
                const Center(
                  child: CircleAvatar(
                    radius: 65,
                    backgroundImage: AssetImage("assets/Female.png"),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                FutureBuilder(
                    future: userData.getData(),
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        String name = snapshot.data["architectName"];
                        // String name = "mithilesh0";
                        return Padding(
                          padding: const EdgeInsets.all(5),
                          child: Text(
                            name,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        );
                      } else {
                        return Center(
                          child: LoadingAnimationWidget.waveDots(
                            color: Theme.of(context).secondaryHeaderColor,
                            size: 20,
                          ),
                        );
                      }
                    }),
                const SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () {
                    //highLighter.highlightDrawerMenu(1);
                    Navigator.of(context).pop();
                    Navigator.of(context).pushNamed(DisplayScreen.routeName);
                  },
                  splashColor: Theme.of(context).primaryColor,
                  child: _buildListTile(
                    "My Uploads",
                    Icons.military_tech_outlined,
                    highLighter.isHome,
                  ),
                ),
                InkWell(
                  onTap: () {
                    //highLighter.highlightDrawerMenu(2);
                    Navigator.of(context).pop();
                    Navigator.of(context)
                        .pushNamed(ExploreModelsScreen.routeName);
                  },
                  splashColor: Theme.of(context).primaryColor,
                  child: _buildListTile(
                    "My Clients",
                    Icons.groups,
                    highLighter.isModels,
                  ),
                ),
                InkWell(
                  onTap: () {
                    //highLighter.highlightDrawerMenu(3);

                    Navigator.of(context).pop();
                    Navigator.of(context).pushNamed(UploadWorkScreen.routeName);
                  },
                  splashColor: Theme.of(context).primaryColor,
                  child: _buildListTile(
                    "Upload Work",
                    Icons.cloud_upload_outlined,
                    highLighter.isArchitects,
                  ),
                ),
                InkWell(
                  onTap: () {
                    //highLighter.highlightDrawerMenu(6);

                    Navigator.of(context).pop();
                    Navigator.of(context).pushNamed(AccountScreen.routeName,
                        arguments: {"": ""});
                  },
                  splashColor: Theme.of(context).primaryColor,
                  child: _buildListTile(
                    "My Account",
                    Icons.account_circle,
                    highLighter.isAccount,
                  ),
                ),
                const Spacer(),
                InkWell(
                  onTap: () async {
                    await Auth().signOut();
                    navigatorVar.pushNamed(HomeScreen.routeName);
                  },
                  splashColor: Theme.of(context).primaryColor,
                  child: Container(
                    color: Theme.of(context).primaryColor,
                    child: _buildListTile(
                      "Log out",
                      Icons.logout_rounded,
                      false,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
