import 'package:flutter/material.dart';
import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';
import 'package:http/http.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';
import 'package:virtualarch/providers/userinfo_options_provider.dart';
import '../../firebase/authentication.dart';
import '../../widgets/auth/custombuttontonext.dart';
import '../../widgets/auth/customdecorationforinput.dart';
import '../../widgets/customloadingspinner.dart';
import '../../widgets/customscreen.dart';
import 'package:http/http.dart' as http;
import '../../widgets/header.dart';
import 'otp_screen.dart';

class UserInfoScreen extends StatefulWidget {
  const UserInfoScreen({super.key});
  static const routeName = "/userInfo";

  @override
  State<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  final formKey = GlobalKey<FormState>();
  final _nameKey = GlobalKey<FormFieldState<String>>();
  final _archTypeKey = GlobalKey<FormFieldState<String>>();
  final _regNumKey = GlobalKey<FormFieldState<String>>();
  final _expKey = GlobalKey<FormFieldState<String>>();
  final _companyNameKey = GlobalKey<FormFieldState<String>>();
  final _streetaddKey = GlobalKey<FormFieldState<String>>();
  final _cityKey = GlobalKey<FormFieldState<String>>();
  final _stateKey = GlobalKey<FormFieldState<String>>();
  final _zipcodeKey = GlobalKey<FormFieldState<String>>();
  final _countryKey = GlobalKey<FormFieldState<String>>();
  final _aboutMeKey = GlobalKey<FormFieldState<String>>();
  final _skillsKey = GlobalKey<FormFieldState<String>>();
  final _genderKey = GlobalKey<FormFieldState<String>>();

  final _nameTextController = TextEditingController();
  final _companyNameTextController = TextEditingController();
  final _archTypeTextController = [];
  final _experienceTextController = TextEditingController();
  final _regNumberTextController = TextEditingController();
  final _skillsTextController = TextEditingController();
  final _streetAddressTextController = TextEditingController();
  final _cityTextController = TextEditingController();
  final _stateTextController = TextEditingController();
  final _zipNumTextController = TextEditingController();
  final _countryTextController = TextEditingController();
  final _aboutMeTextController = TextEditingController();
  final _genderTextController = [];
  final List<String> _skills = [];

  int currentStep = 0;
  continueStep() {
    bool isLastStep = (currentStep == 2);
    if (isLastStep) {
      //Hides the keyboard.
      FocusScope.of(context).unfocus();

      //Start CircularProgressIndicator
      showDialog(
        context: context,
        builder: (context) {
          return const CustomLoadingSpinner();
        },
      );

      //Navigate to OTP Page

      // End CircularProgressIndicator
      Navigator.of(context).pop();
    } else {
      setState(() {
        currentStep += 1;
      });
    }

    // if (currentStep < 2) {
    //   //Check for the fields are valid in TextFormField.
    //   if (currentStep == 0 &&
    //       _nameKey.currentState!.validate() &&
    //       _archTypeKey.currentState!.validate() &&
    //       _regNumKey.currentState!.validate() &&
    //       _expKey.currentState!.validate() &&
    //       _genderKey.currentState!.validate()) {
    //     setState(() {
    //       currentStep = 1;
    //     });
    //   } else if (currentStep == 1 &&
    //       _companyNameKey.currentState!.validate() &&
    //       _streetaddKey.currentState!.validate() &&
    //       _cityKey.currentState!.validate() &&
    //       _stateKey.currentState!.validate() &&
    //       _zipcodeKey.currentState!.validate() &&
    //       _countryKey.currentState!.validate()) {
    //     setState(() {
    //       currentStep = 2;
    //     });
    //   }
    // } else {
    //   _aboutMeKey.currentState!.validate();
    //   _skillsKey.currentState!.validate();
    // }
  }

  cancelStep() {
    if (currentStep > 0) {
      setState(() {
        currentStep = currentStep - 1;
      });
    }
  }

  Widget controlsBuilder(context, details) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: SizedBox(
        width: double.infinity,
        child: Wrap(
          alignment: WrapAlignment.start,
          children: [
            ElevatedButton(
              onPressed: details.onStepContinue,
              child: const Text('Continue'),
            ),
            const SizedBox(
              width: 10,
            ),
            OutlinedButton(
              onPressed: details.onStepCancel,
              child: const Text('Back'),
            )
          ],
        ),
      ),
    );
  }

  Widget inputTextField(inputKey, inputController, inputLabel, inputIcon) {
    return Container(
      width: 500,
      margin: const EdgeInsets.all(10),
      child: TextFormField(
        key: inputKey,
        controller: inputController,
        decoration: customDecorationForInput(
          context,
          inputLabel,
          inputIcon,
        ),
        // validator: (name) {
        //   if (name != null && name.isEmpty) {
        //     return "Enter a valid name";
        //   } else {
        //     return null;
        //   }
        // },
      ),
    );
  }

  Widget multiSelectBuilder(
    String inputTitle,
    IconData inputIcon,
    Key inputKey,
    List<MultiSelectCard> inputOptions,
    List selections,
  ) {
    return Container(
      width: 500,
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Theme.of(context).canvasColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                inputIcon,
                color: Theme.of(context).secondaryHeaderColor,
              ),
              const SizedBox(width: 5),
              Text(
                inputTitle,
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ],
          ),
          const SizedBox(height: 5),
          MultiSelectContainer(
            key: inputKey,
            singleSelectedItem: true,
            itemsPadding: const EdgeInsets.all(5),
            itemsDecoration: MultiSelectDecorations(
              decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).canvasColor),
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              selectedDecoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).canvasColor),
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            textStyles: MultiSelectTextStyles(
              textStyle: TextStyle(color: Theme.of(context).primaryColor),
            ),
            items: inputOptions,
            onChange: (allSelectedItems, selectedItem) {
              selections.clear();
              selections.addAll(allSelectedItems);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    var scaffoldMessengerVar = ScaffoldMessenger.of(context);
    var navigatorVar = Navigator.of(context);

    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: MyCustomScreen(
          // customColor: Colors.blue,
          screenContent: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Header(heading: "Personal Info"),
              Expanded(
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        Stepper(
                          currentStep: currentStep,
                          onStepContinue: continueStep,
                          onStepCancel: cancelStep,
                          controlsBuilder: controlsBuilder,
                          steps: [
                            Step(
                              isActive: currentStep >= 0,
                              title: Text(
                                "Personal Information",
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              content: Column(
                                children: [
                                  SizedBox(
                                    width: double.infinity,
                                    child: Wrap(
                                      alignment: WrapAlignment.start,
                                      children: [
                                        Container(
                                          width: 500,
                                          margin: const EdgeInsets.all(10),
                                          child: TextFormField(
                                            enabled: false,
                                            decoration:
                                                customDecorationForInput(
                                              context,
                                              args['email'],
                                              Icons.email_rounded,
                                            ),
                                          ),
                                        ),
                                        //Name
                                        inputTextField(
                                          _nameKey,
                                          _nameTextController,
                                          "Enter your Name",
                                          Icons.person,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: double.infinity,
                                    child: Wrap(
                                      alignment: WrapAlignment.start,
                                      children: [
                                        inputTextField(
                                          _regNumKey,
                                          _regNumberTextController,
                                          "Enter Register Number",
                                          Icons.verified_outlined,
                                        ),
                                        inputTextField(
                                          _expKey,
                                          _experienceTextController,
                                          "Enter Experience in Years",
                                          Icons.real_estate_agent_rounded,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: double.infinity,
                                    child: Wrap(
                                      alignment: WrapAlignment.start,
                                      children: [
                                        multiSelectBuilder(
                                          "Enter Gender",
                                          Icons.man_4_rounded,
                                          _genderKey,
                                          architectGenderList,
                                          _genderTextController,
                                        ),
                                        multiSelectBuilder(
                                          "Enter Architect Type",
                                          Icons.account_tree_rounded,
                                          _archTypeKey,
                                          architectTypeList,
                                          _archTypeTextController,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Step(
                              isActive: currentStep >= 1,
                              title: Text(
                                "Office Information",
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              content: Column(
                                children: [
                                  SizedBox(
                                    width: double.infinity,
                                    child: Wrap(
                                      alignment: WrapAlignment.start,
                                      children: [
                                        inputTextField(
                                          _companyNameKey,
                                          _companyNameTextController,
                                          "Enter Company Name",
                                          Icons.share_location_sharp,
                                        ),
                                        inputTextField(
                                          _streetaddKey,
                                          _streetAddressTextController,
                                          "Enter Office Street Address",
                                          Icons.share_location_sharp,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: double.infinity,
                                    child: Wrap(
                                      alignment: WrapAlignment.start,
                                      children: [
                                        inputTextField(
                                          _cityKey,
                                          _cityTextController,
                                          "Enter City",
                                          Icons.share_location_sharp,
                                        ),
                                        inputTextField(
                                          _stateKey,
                                          _stateTextController,
                                          "Enter State",
                                          Icons.share_location_sharp,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: double.infinity,
                                    child: Wrap(
                                      alignment: WrapAlignment.start,
                                      children: [
                                        inputTextField(
                                          _zipcodeKey,
                                          _zipNumTextController,
                                          "Enter Zip/Postal Code",
                                          Icons.share_location_sharp,
                                        ),
                                        inputTextField(
                                          _countryKey,
                                          _countryTextController,
                                          "Enter Country",
                                          Icons.share_location_sharp,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Step(
                              isActive: currentStep >= 2,
                              title: Text(
                                'More about yourself',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              content: Column(
                                children: [
                                  SizedBox(
                                    width: double.infinity,
                                    child: Wrap(
                                      alignment: WrapAlignment.start,
                                      children: [
                                        Container(
                                          width: 500,
                                          margin: const EdgeInsets.all(10),
                                          child: TextFormField(
                                            key: _aboutMeKey,
                                            controller: _aboutMeTextController,
                                            maxLength: 900,
                                            keyboardType: TextInputType.number,
                                            decoration:
                                                customDecorationForInput(
                                              context,
                                              "Tell us something about yourself",
                                              Icons.catching_pokemon,
                                            ),
                                            minLines: 1,
                                            maxLines: 10,
                                            validator: (about) {
                                              if (about != null &&
                                                  about.isEmpty) {
                                                return "Please add some content";
                                              } else {
                                                return null;
                                              }
                                            },
                                          ),
                                        ),
                                        Container(
                                          width: 500,
                                          margin: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            color: _skills.isNotEmpty
                                                ? Theme.of(context).canvasColor
                                                : Colors.transparent,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              TextFormField(
                                                key: _skillsKey,
                                                controller:
                                                    _skillsTextController,
                                                keyboardType:
                                                    TextInputType.number,
                                                maxLength: 15,
                                                decoration:
                                                    customDecorationForInput(
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
                                                  _skillsKey.currentState!
                                                      .validate();
                                                  setState(() {
                                                    if (!_skills
                                                        .contains(value)) {
                                                      _skills.add(value);
                                                    }
                                                    _skillsTextController.text =
                                                        "";
                                                  });
                                                },
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 4),
                                                child: Text(
                                                  "Type and hit enter to add & click on skill to delete",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .labelSmall!
                                                      .copyWith(
                                                        color: Theme.of(context)
                                                            .primaryColor,
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
                                                      margin:
                                                          const EdgeInsets.all(
                                                              4),
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                      ),
                                                      child: InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            _skills.remove(
                                                                _skills[index]);
                                                          });
                                                        },
                                                        child: Center(
                                                          child: Text(
                                                            _skills[index],
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .titleSmall,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: size.width * 0.02,
                        ),
                        NextButtonClass(
                          text: "Proceed to Verify",
                          onPressed: () async {
                            //Check for the fields are valid in TextFormField.
                            final isValid = formKey.currentState!.validate();
                            if (!isValid) return;

                            await Auth().createUserWithEmailAndPassword(
                              email: args['email'],
                              password: args['password'],
                            );

                            navigatorVar.pushNamed(
                              OTPScreen.routeName,
                              arguments: {
                                'email': args['email'],
                                'password': args['password'],
                                'architectName': _nameTextController.text,
                                'architectType': _archTypeTextController[0],
                                'architectRegisterNum':
                                    _regNumberTextController.text,
                                'architectExperience':
                                    _experienceTextController.text,
                                'architectGender': _genderTextController[0],
                                'architectCompanyName':
                                    _companyNameTextController.text,
                                'architectStreetAddress':
                                    _streetAddressTextController.text,
                                'architectCity': _cityTextController.text,
                                'architectState': _stateTextController.text,
                                'architectZipCode': _zipNumTextController.text,
                                'architectCountry': _countryTextController.text,
                                'architectAboutMe': _aboutMeTextController.text,
                                'architectSkills': _skills,
                              },
                            );
                          },
                        ),
                        SizedBox(
                          height: size.height * 0.05,
                        ),
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
