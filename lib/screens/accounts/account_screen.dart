import 'package:flutter/material.dart';
import 'package:googleapis/compute/v1.dart';
import 'package:provider/provider.dart';
import 'package:virtualarch/screens/housemodels/exploremodels_screen.dart';
import '../../providers/user_data_provider.dart';
import '../../widgets/accounts/customdecorationforaccountinput.dart';
import '../../widgets/customloadingspinner.dart';
import '../../widgets/custommenu.dart';
import '../../widgets/customscreen.dart';
import '../../widgets/headerwithmenu.dart';
import '../error_screen.dart';
import 'edit_profile_screen.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});
  static const routeName = '/account';

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen>
    with WidgetsBindingObserver {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneNoController = TextEditingController();
  var prefeb;
  String name = "";
  Map<String, dynamic> next_page_data = {};

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
  }

  Widget _buildTheNavigation(String heading, Future<Object?> navigator) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          heading,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        IconButton(
          onPressed: () => navigator,
          icon: const Icon(
            Icons.arrow_forward_ios,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildTextFormField(
    TextEditingController inputText,
    String infoText,
  ) {
    return TextFormField(
      minLines: 1,
      maxLines: 4,
      controller: inputText,
      readOnly: true,
      decoration: customDecorationForAccountInput(
        context,
        infoText,
        Theme.of(context).textTheme.headlineSmall,
      ),
    );
  }

  void add_data(AsyncSnapshot<dynamic> data) {
    next_page_data["name"] = data.data["architectName"];
    next_page_data["type"] = data.data["architectType"];
    next_page_data["regNum"] = data.data["architectRegisterNum"];
    next_page_data["exp"] = data.data["architectExperience"];
    next_page_data["address"] = data.data["architectOfficeLocation"];
    next_page_data["aboutMe"] = data.data["aboutMe"];
    next_page_data["skills"] = data.data["skills"];
    next_page_data["image"] = data.data["architectImageUrl"];
    next_page_data["email"] = data.data["architectEmail"];
    print("\nabout me\n");
    print(data.data["skills"]);
  }

  @override
  Widget build(BuildContext context) {
    bool isErrorOccured = false;
    try {
      final reload = ModalRoute.of(context)!.settings.arguments as Map;
      if (reload["reload"] == true) {
        setState(() {});
      }
      isErrorOccured = false;
    } catch (e) {
      isErrorOccured = true;
    }

    var size = MediaQuery.of(context).size;
    var user_data = Provider.of<UserDataProvide>(context, listen: false);
    return isErrorOccured
        ? const ErrorScreen(
            screenToBeRendered: ExploreModelsScreen.routeName,
            renderScreenName: "Home Page")
        : Scaffold(
            key: scaffoldKey,
            endDrawer: const CustomMenu(),
            body: MyCustomScreen(
              customColor: Theme.of(context).primaryColor,
              screenContent: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  HeaderWithMenu(
                    header: "My Account",
                    scaffoldKey: scaffoldKey,
                  ),
                  SizedBox(
                    height: size.height * 0.04,
                  ),
                  const CircleAvatar(
                    backgroundImage: AssetImage("assets/Female.png"),
                    radius: 80,
                  ),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  FutureBuilder(
                      future: user_data.getData(),
                      builder: (context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          name = snapshot.data["architectName"];
                          String email = "email";
                          var tempAddr =
                              snapshot.data["architectOfficeLocation"];
                          _addressController.text =
                              tempAddr["companyStreetAddress"] +
                                  " " +
                                  tempAddr["city"] +
                                  " " +
                                  tempAddr["state"] +
                                  " " +
                                  tempAddr["zipCode"];
                          add_data(snapshot);
                          //print(" adress ${_addressController.text}");
                          //_phoneNoController.text = snapshot.data["phoneNumber"];
                          return Column(
                            children: [
                              Text(
                                name,
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                              ),
                              Text(
                                email,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              SizedBox(
                                height: size.height * 0.02,
                              ),
                              _buildTextFormField(
                                  _addressController, "Address"),
                              SizedBox(
                                height: size.height * 0.02,
                              ),
                              // _buildTextFormField(_phoneNoController, "Phone Number"),
                              SizedBox(
                                height: size.height * 0.04,
                              ),
                            ],
                          );
                        } else {
                          return CustomLoadingSpinner();
                        }
                      }),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     Text(
                  //       "My Orders",
                  //       style: Theme.of(context).textTheme.titleLarge,
                  //     ),
                  //     IconButton(
                  //       onPressed: () => Navigator.of(context)
                  //           .pushNamed(ExploreModelsScreen.routeName),
                  //       icon: const Icon(
                  //         Icons.arrow_forward_ios,
                  //         color: Colors.white,
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Edit Profile",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pushNamed(
                            EditProfileScreen.routeName,
                            arguments: next_page_data),
                        icon: const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  // _buildTheNavigation(
                  //     "Edit Profile",
                  //     Navigator.of(context)
                  //         .pushNamed(EditProfileScreen.routeName, arguments: {
                  //       "name": name,
                  //       "phoneNumber": _phoneNoController.text,
                  //       "address": _addressController.text
                  //     })),
                ],
              ),
            ),
          );
  }
}
