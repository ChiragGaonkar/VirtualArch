import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:virtualarch/screens/error_screen.dart';

import '../../firebase/firebase_storage.dart';
import '../../providers/user_data_provider.dart';
import '../../widgets/accounts/customdecorationforaccountinput.dart';
import '../../widgets/auth/customdecorationforinput.dart';
import '../../widgets/customscreen.dart';
import '../../widgets/headerwithnavigation.dart';
import '../housemodels/exploremodels_screen.dart';
import 'account_screen.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});
  static const routeName = '/editProfile';

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _typeController = TextEditingController();
  final _cityController = TextEditingController();
  final _companyNameController = TextEditingController();
  final _streetController = TextEditingController();
  final _countryController = TextEditingController();
  final _stateController = TextEditingController();
  final _zipcodeController = TextEditingController();
  final _registerationController = TextEditingController();
  final _experienceController = TextEditingController();
  final _aboutmeController = TextEditingController();
  final _skillsController = TextEditingController();
  final _imageController = TextEditingController();

  final _skillsKey = GlobalKey<FormFieldState<String>>();
  List<dynamic> _skills = [];

  var prefeb;
  bool init = false;

  @override
  void initState() {
    super.initState();
  }

  Widget _buildTextFormField(
    TextEditingController myController,
    TextInputType textType,
    String inputTextlabel,
    bool read,
    String? Function(String?) validator,
  ) {
    return TextFormField(
      controller: myController,
      minLines: 1,
      maxLines: 2,
      keyboardType: textType,
      readOnly: read,
      decoration: customDecorationForAccountInput(
        context,
        inputTextlabel,
        Theme.of(context).textTheme.titleMedium,
      ),
      validator: validator,
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var scaffoldMessengerVar = ScaffoldMessenger.of(context);
    var user_data = Provider.of<UserDataProvide>(context, listen: false);
    bool isErrorOccured = false;
    try {
      final userData = ModalRoute.of(context)!.settings.arguments as Map;
      if (!init) {
        /*
        next_page_data["name"] = data.data["architectName"];
        next_page_data["type"] = data.data["architectType"];
        next_page_data["regNum"] = data.data["architectRegisterNum"];
        next_page_data["exp"] = data.data["architectExperience"];
        next_page_data["address"] = data.data["architectOfficeLocation"];
        next_page_data["aboutMe"] = data.data["aboutMe"];
        next_page_data["skills"] = data.data["skills"];
        next_page_data["image"] = data.data["architectImageUrl"];
        next_page_data["email"] = data.data["architectEmail"];
        */
        _nameController.text = userData["name"].toString();
        _emailTextController.text = userData["email"].toString();
        _typeController.text = userData["type"].toString();
        _registerationController.text = userData["regNum"].toString();
        _experienceController.text = userData["exp"].toString();
        _cityController.text = userData["address"]["city"].toString();
        _companyNameController.text = userData["address"]["companyName"].toString();
        _streetController.text = userData["address"]["companyStreetAddress"].toString();
        _countryController.text = userData["address"]["country"].toString();
        _stateController.text = userData["address"]["state"].toString();
        _zipcodeController.text = userData["address"]["zipCode"].toString();
        _aboutmeController.text = userData["aboutMe"].toString();
        _imageController.text = userData["image"].toString();
        _skillsController.text = "";
        _skills = userData["skills"] as List<dynamic>;
        init = true;
      }
      isErrorOccured = false;
    } catch (e) {
      isErrorOccured = true;
    }

    return isErrorOccured
        ? const ErrorScreen(screenToBeRendered: ExploreModelsScreen.routeName, renderScreenName: "Home Page")
        : Scaffold(
            // resizeToAvoidBottomInset: true,
            body: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: MyCustomScreen(
                customColor: Theme.of(context).primaryColor,
                screenContent: Column(
                  children: [
                    const HeaderWithNavigation(
                      heading: "Edit Profile",
                      screenToBeRendered: "", // change afterwards
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Form(
                          key: formKey,
                          child: Column(
                            children: [
                              SizedBox(
                                height: size.height * 0.04,
                              ),
                              GestureDetector(
                                onTap: () async {
                                  await FirebaseStorage.uploadDP();
                                  // setState(() {});
                                },
                                child: CircleAvatar(
                                  backgroundImage: NetworkImage(_imageController.text),
                                  radius: 80,
                                ),
                              ),
                              SizedBox(
                                height: size.height * 0.02,
                              ),
                              //TextFormField
                              _buildTextFormField(
                                _emailTextController,
                                TextInputType.name,
                                "Email",
                                true,
                                (value) {
                                  return null;
                                },
                              ),
                              SizedBox(
                                height: size.height * 0.02,
                              ),
                              //TextFormField
                              _buildTextFormField(
                                _registerationController,
                                TextInputType.name,
                                "Registeration Number",
                                true,
                                (value) {
                                  return null;
                                },
                              ),
                              SizedBox(
                                height: size.height * 0.02,
                              ),
                              //TextFormField
                              _buildTextFormField(
                                _nameController,
                                TextInputType.name,
                                "Name",
                                false,
                                (value) {
                                  if (value != null && value.isEmpty) {
                                    return "Please enter your name";
                                  }
                                  if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value!)) {
                                    return 'Please enter alphabets only(spaces allowed)';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(
                                height: size.height * 0.02,
                              ),
                              //TextFormField
                              _buildTextFormField(
                                _aboutmeController,
                                TextInputType.name,
                                "About Me",
                                false,
                                (value) {
                                  if (value != null && value.isEmpty) {
                                    return "Please enter about yourself";
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(
                                height: size.height * 0.02,
                              ),
                              //TextFormField
                              _buildTextFormField(
                                _typeController,
                                TextInputType.multiline,
                                "Architect Type",
                                true,
                                (value) {
                                  return null;
                                },
                              ),
                              SizedBox(
                                height: size.height * 0.02,
                              ),
                              //TextFormField
                              _buildTextFormField(
                                _experienceController,
                                TextInputType.number,
                                "Experience",
                                false,
                                (value) {
                                  if (value != null && value.isEmpty) {
                                    return 'Please enter Experience in years (e.g.- 10)';
                                  }
                                  if (!RegExp(r'^\d+$').hasMatch(value!)) {
                                    return 'Experience must be a positive number (e.g.- 10)';
                                  }
                                  return null; // Return null if the input is valid
                                },
                              ),
                              SizedBox(
                                height: size.height * 0.02,
                              ),
                              //TextFormField
                              _buildTextFormField(
                                _cityController,
                                TextInputType.name,
                                "City",
                                false,
                                (value) {
                                  if (value != null && value.isEmpty) {
                                    return 'Please enter your city';
                                  }
                                  if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value!)) {
                                    return 'Please enter alphabets only(spaces allowed)';
                                  }
                                  return null; // Return null if the input is valid
                                  // Additional validation logic for project name if needed
                                },
                              ),
                              SizedBox(
                                height: size.height * 0.02,
                              ),
                              //TextFormField
                              _buildTextFormField(
                                _companyNameController,
                                TextInputType.name,
                                "Company Name",
                                false,
                                (value) {
                                  if (value != null && value.isEmpty) {
                                    return 'Please enter your company name';
                                  }
                                  if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value!)) {
                                    return 'Please enter alphabets only(spaces allowed)';
                                  }
                                  return null; // Return null if the input is valid
                                  // Additional validation logic for project name if needed
                                },
                              ),
                              SizedBox(
                                height: size.height * 0.02,
                              ),
                              //TextFormField
                              _buildTextFormField(
                                _streetController,
                                TextInputType.name,
                                "Street",
                                false,
                                (value) {
                                  if (value != null && value.isEmpty) {
                                    return "Please enter your street";
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(
                                height: size.height * 0.02,
                              ),
                              //TextFormField
                              _buildTextFormField(
                                _countryController,
                                TextInputType.name,
                                "Country",
                                false,
                                (value) {
                                  if (value != null && value.isEmpty) {
                                    return 'Please enter your country';
                                  }
                                  if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value!)) {
                                    return 'Please enter alphabets only(spaces allowed)';
                                  }
                                  return null; // Return null if the input is valid
                                  // Additional validation logic for project name if needed
                                },
                              ),
                              SizedBox(
                                height: size.height * 0.02,
                              ),
                              //TextFormField
                              _buildTextFormField(
                                _stateController,
                                TextInputType.name,
                                "State",
                                false,
                                (value) {
                                  if (value != null && value.isEmpty) {
                                    return 'Please enter your state';
                                  }
                                  if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value!)) {
                                    return 'Please enter alphabets only(spaces allowed)';
                                  }
                                  return null; // Return null if the input is valid
                                  // Additional validation logic for project name if needed
                                },
                              ),
                              SizedBox(
                                height: size.height * 0.02,
                              ),
                              //TextFormField
                              _buildTextFormField(
                                _zipcodeController,
                                TextInputType.number,
                                "Zip Code",
                                false,
                                (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter your zip/postal code';
                                  }
                                  if (value.length != 6) {
                                    return 'Zip/Postal code must be a 6-digit number';
                                  }
                                  if (!value.contains(RegExp(r'^[0-9]+$'))) {
                                    return 'Zip/Postal code must contain only 6 digits';
                                  }
                                  // Additional validation logic for project name if needed
                                  return null; // Return null if the input is valid
                                },
                              ),
                              // SizedBox(
                              //   height: size.height * 0.02,
                              // ),
                              // //TextFormField
                              // _buildTextFormField(
                              //   _imageController,
                              //   TextInputType.name,
                              //   "Image Url",
                              //   false,
                              //   (value) {
                              //     if (value != null && value.isEmpty) {
                              //       return "Please enter an Image Url";
                              //     }
                              //     return null;
                              //   },
                              // ),
                              SizedBox(
                                height: size.height * 0.02,
                              ),
                              Container(
                                width: 500,
                                margin: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: _skills.isNotEmpty ? Theme.of(context).canvasColor : Colors.transparent,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextFormField(
                                      key: _skillsKey,
                                      controller: _skillsController,
                                      keyboardType: TextInputType.number,
                                      maxLength: 15,
                                      decoration: customDecorationForInput(
                                        context,
                                        "Add Skills",
                                        Icons.add_moderator_outlined,
                                      ),
                                      validator: (about) {
                                        if (_skills.isEmpty) {
                                          return "Please add atleast 1 skill";
                                        } else {
                                          return null;
                                        }
                                      },
                                      onFieldSubmitted: (value) {
                                        _skillsKey.currentState!.validate();
                                        setState(() {
                                          if (!_skills.contains(value)) {
                                            _skills.add(value);
                                          }
                                          _skillsController.text = "";
                                        });
                                      },
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 4),
                                      child: Text(
                                        "Type and hit enter to add & click on skill to delete",
                                        style: Theme.of(context).textTheme.labelSmall!.copyWith(
                                              color: Theme.of(context).primaryColor,
                                            ),
                                      ),
                                    ),
                                    if (_skills.isNotEmpty)
                                      ResponsiveGridList(
                                        minItemWidth: 150,
                                        shrinkWrap: true,
                                        children: List.generate(
                                          _skills.length,
                                          (index) => Container(
                                            margin: const EdgeInsets.all(4),
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(15),
                                              color: Theme.of(context).primaryColor,
                                            ),
                                            child: InkWell(
                                              onTap: () {
                                                setState(() {
                                                  _skills.remove(_skills[index]);
                                                });
                                              },
                                              child: Center(
                                                child: Text(
                                                  _skills[index],
                                                  style: Theme.of(context).textTheme.titleSmall,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: size.height * 0.04,
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(0, 0, 0, size.height * 0.07),
                                child: ElevatedButton(
                                  onPressed: () {
                                    final isValid = formKey.currentState!.validate();
                                    if (!isValid) return;
                                    FocusScope.of(context).unfocus();

                                    Map<String, dynamic> data = {
                                      "name": _nameController.text,
                                      "exp": _experienceController.text,
                                      "city": _cityController.text,
                                      "company": _companyNameController.text,
                                      "street": _streetController.text,
                                      "country": _countryController.text,
                                      "state": _stateController.text,
                                      "zip": _zipcodeController.text,
                                      "aboutMe": _aboutmeController.text,
                                      "image": _imageController.text,
                                      "skills": _skills
                                    };
                                    // print(_nameController.text);
                                    // print(_emailTextController.text);
                                    // print(_phoneNoController.text);
                                    // print(_addressController.text);
                                    user_data.updateData(data);
                                    Navigator.pushNamed(context, AccountScreen.routeName, arguments: {"reload": true});
                                  },
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: Size(
                                      size.width * 0.8,
                                      size.height * 0.06,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                  child: Text(
                                    "Save",
                                    style: Theme.of(context).textTheme.titleMedium,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
