import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'package:virtualarch/firebase/firebase_uploads.dart';
import 'package:virtualarch/screens/housemodels/exploremodels_screen.dart';
import 'package:virtualarch/screens/upload_work/upload_work.dart';
import 'package:virtualarch/widgets/headerwithmenu.dart';
import 'package:virtualarch/widgets/upload_work/upload_image.dart';
import '../../firebase/authentication.dart';
import '../../firebase/firebase_storage.dart';
import '../../providers/feature_options_provider.dart';
import '../../widgets/auth/customdecorationforinput.dart';
import '../../widgets/customloadingspinner.dart';
import '../../widgets/custommenu.dart';
import '../../widgets/customscreen.dart';

class UploadProjInfo extends StatefulWidget {
  const UploadProjInfo({super.key});
  static const routeName = "/uploadWork";

  @override
  State<UploadProjInfo> createState() => _UploadProjInfoState();
}

class _UploadProjInfoState extends State<UploadProjInfo> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  int currentStep = 0;

  //Controllers
  //General
  final _modelNameController = TextEditingController();
  final _modelPriceController = TextEditingController();
  final _modelEstimatedBuildPriceController = TextEditingController();

  //Exterior
  final List _modelColorSchemeController = [];
  final _modelFloorsController = TextEditingController();
  final _modelTotalSquareFootageController = TextEditingController();
  final List _modelRoofStyleController = [];

  //Interior
  final _modelNumberOfCommonRoomsController = TextEditingController();
  final _modelNumberOfBedroomsController = TextEditingController();
  final _modelNumberOfBathsController = TextEditingController();
  final _modelCeilingHeightController = TextEditingController();
  final List _modelFlooringOfRoomsController = [];
  final List _modelLightingOfRoomsController = [];

  //Kitchen & Bathrooms
  final List _modelKitchenCountertopsController = [];
  final List _modelKitchenCabinetryController = [];
  final List _modelFlooringOfKitchenController = [];
  final List _modelBathroomVanityController = [];

  //Outdoor Space
  bool _modelYardController = false;
  bool _modelDeckController = false;
  bool _modelPatioController = false;
  bool _modelPoolController = false;
  bool _modelParkingsController = false;

  //Technology and smart features
  final List _modelTechnologyAndSmartFeaturesController = [];

  //Important urls
  String _model3dURLController = "";
  String _modelImageURLController = "";

  continueStep() async {
    bool isLastStep = (currentStep == 6);
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

      final User? user = Auth().currentUser;

      _modelImageURLController = await FirebaseStorage.uploadSampleImage();
      _model3dURLController = await FirebaseStorage.upload3DModel();

      Map<String, dynamic> projectInfo = {
        'modelImageURL': _modelImageURLController,
        'model3dURL': _model3dURLController,
        'modelName': _modelNameController.text,
        'modelPrice': _modelPriceController.text,
        'modelEstimatedBuildPrice': _modelEstimatedBuildPriceController.text,
        'modelArchitectname': "Temporary Name",
        'modelArchitectID': user!.uid,
        'modelColorScheme': _modelColorSchemeController,
        'modelFloors': _modelFloorsController.text,
        'modelTotalSquareFootage': _modelTotalSquareFootageController.text,
        'modelRoofStyle': _modelRoofStyleController,
        'modelNumberOfCommonRooms': _modelNumberOfCommonRoomsController.text,
        'modelNumberOfBedrooms': _modelNumberOfBedroomsController.text,
        'modelNumberOfBaths': _modelNumberOfBathsController.text,
        'modelFlooringOfRooms': _modelFlooringOfRoomsController,
        'modelLightingOfRooms': _modelLightingOfRoomsController,
        'modelCeilingHeight': _modelCeilingHeightController.text,
        'modelKitchenCountertops': _modelKitchenCountertopsController,
        'modelKitchenCabinetry': _modelKitchenCabinetryController,
        'modelFlooringOfKitchen': _modelFlooringOfKitchenController,
        'modelBathroomVanity': _modelBathroomVanityController,
        'modelYard': _modelYardController,
        'modelDeck': _modelDeckController,
        'modelPatio': _modelPatioController,
        'modelParkings': _modelParkingsController,
        'modelPool': _modelPoolController,
        'modelTechnologyAndSmartFeatures':
            _modelTechnologyAndSmartFeaturesController,
      };

      Map<String, dynamic> projectData =
          await FirebaseUploads().createProject(projectInfo: projectInfo);
      if (projectData['noErrors']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: AwesomeSnackbarContent(
              title: 'Hurray!',
              message: "Project was successfully created.",
              contentType: ContentType.success,
            ),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: AwesomeSnackbarContent(
              title: 'Oh snap!',
              message: "Unable to create Project.",
              contentType: ContentType.failure,
            ),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
        );
      }

      // End CircularProgressIndicator
      Navigator.of(context).pop();

      // Navigator.of(context).pushNamed(
      //   UploadDesignScreen.routeName,
      //   arguments: projectData['projectId'],
      // );

      Navigator.of(context).pushNamed(ExploreModelsScreen.routeName);
    } else {
      setState(() {
        currentStep += 1;
      });
    }
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

  Widget multiSelectBuilder(
    String inputTitle,
    IconData inputIcon,
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

  Widget textInputBuilder(
    String inputTitle,
    IconData inputIcon,
    TextEditingController inputs,
  ) {
    return Container(
      width: 500,
      margin: const EdgeInsets.all(10),
      child: TextFormField(
        // key: _nameKey,
        controller: inputs,
        decoration: customDecorationForInput(
          context,
          inputTitle,
          inputIcon,
        ),
        // validator: (name) {
        //   if (name != null && name.isEmpty) {
        //     return "Enter a valid ${inputTitle}";
        //   } else {
        //     return null;
        //   }
        // },
      ),
    );
  }

  Widget switchButtonBuilder(
    String inputTitle,
    Function(bool) onChnaged,
  ) {
    return Container(
      width: 200,
      margin: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          LiteRollingSwitch(
            width: 100,
            textOn: 'Yes',
            textOff: 'No',
            colorOn: Theme.of(context).primaryColor,
            colorOff: Theme.of(context).canvasColor,
            iconOn: Icons.done,
            iconOff: Icons.not_interested_outlined,
            animationDuration: const Duration(milliseconds: 300),
            onTap: () => null,
            onDoubleTap: () => null,
            onChanged: onChnaged,
            onSwipe: () => null,
          ),
          const SizedBox(height: 10),
          Text(
            inputTitle,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      key: scaffoldKey,
      endDrawer: const CustomMenu(),
      body: MyCustomScreen(
        screenContent: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderWithMenu(
              header: "Upload Project Info",
              scaffoldKey: scaffoldKey,
            ),
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
                        onStepTapped: (step) => setState(() {
                          currentStep = step;
                        }),
                        steps: [
                          Step(
                            isActive: currentStep >= 0,
                            title: Text(
                              "General Details",
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            content: Column(
                              children: [
                                SizedBox(
                                  width: double.infinity,
                                  child: Wrap(
                                    alignment: WrapAlignment.start,
                                    children: [
                                      textInputBuilder(
                                        "Enter Project Name",
                                        Icons.catching_pokemon,
                                        _modelNameController,
                                      ),
                                      textInputBuilder(
                                        "Enter Price",
                                        Icons.catching_pokemon,
                                        _modelPriceController,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  child: Wrap(
                                    alignment: WrapAlignment.start,
                                    children: [
                                      textInputBuilder(
                                        "Enter Estimated Construction Price",
                                        Icons.catching_pokemon,
                                        _modelEstimatedBuildPriceController,
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Step(
                            isActive: currentStep >= 1,
                            title: Text(
                              "Exterior",
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            content: Column(
                              children: [
                                SizedBox(
                                  width: double.infinity,
                                  child: Wrap(
                                    alignment: WrapAlignment.start,
                                    children: [
                                      textInputBuilder(
                                        "Number of Floors",
                                        Icons.catching_pokemon_rounded,
                                        _modelFloorsController,
                                      ),
                                      textInputBuilder(
                                        "Total Area in sqft",
                                        Icons.catching_pokemon,
                                        _modelTotalSquareFootageController,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  child: Wrap(
                                    alignment: WrapAlignment.start,
                                    children: [
                                      //ColorScheme
                                      multiSelectBuilder(
                                        "Choose Colorscheme",
                                        Icons.color_lens,
                                        colorSchemeList,
                                        _modelColorSchemeController,
                                      ),
                                      multiSelectBuilder(
                                        "Choose Roof Style",
                                        Icons.roofing_rounded,
                                        roofStyleList,
                                        _modelRoofStyleController,
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Step(
                            isActive: currentStep >= 2,
                            title: Text(
                              "Interior",
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            content: Column(
                              children: [
                                SizedBox(
                                  width: double.infinity,
                                  child: Wrap(
                                    alignment: WrapAlignment.start,
                                    children: [
                                      textInputBuilder(
                                        "Number of Common Rooms",
                                        Icons.catching_pokemon,
                                        _modelNumberOfCommonRoomsController,
                                      ),
                                      textInputBuilder(
                                        "Number of Bedrooms",
                                        Icons.catching_pokemon,
                                        _modelNumberOfBedroomsController,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  child: Wrap(
                                    alignment: WrapAlignment.start,
                                    children: [
                                      textInputBuilder(
                                        "Number of Bathrooms",
                                        Icons.catching_pokemon,
                                        _modelNumberOfBathsController,
                                      ),
                                      textInputBuilder(
                                        "Ceiling Height",
                                        Icons.catching_pokemon,
                                        _modelCeilingHeightController,
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
                                        "Flooring of rooms",
                                        Icons.catching_pokemon,
                                        flooring,
                                        _modelFlooringOfRoomsController,
                                      ),
                                      multiSelectBuilder(
                                        "Lighting of rooms",
                                        Icons.catching_pokemon,
                                        lightingOfFloors,
                                        _modelLightingOfRoomsController,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Step(
                            isActive: currentStep >= 3,
                            title: Text(
                              "Kitchen & Bathrooms",
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            content: Column(
                              children: [
                                SizedBox(
                                  width: double.infinity,
                                  child: Wrap(
                                    alignment: WrapAlignment.start,
                                    children: [
                                      multiSelectBuilder(
                                        "Choose Kitchen Countertops",
                                        Icons.catching_pokemon,
                                        kitchenCountertops,
                                        _modelKitchenCountertopsController,
                                      ),
                                      multiSelectBuilder(
                                        "Choose Kitchen Cabinetry",
                                        Icons.catching_pokemon,
                                        kitchenCountertops,
                                        _modelKitchenCabinetryController,
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  child: Wrap(
                                    alignment: WrapAlignment.start,
                                    children: [
                                      multiSelectBuilder(
                                        "Choose Kitchen Flooring",
                                        Icons.catching_pokemon,
                                        flooring,
                                        _modelFlooringOfKitchenController,
                                      ),
                                      multiSelectBuilder(
                                        "Choose Bathroom Vanity",
                                        Icons.catching_pokemon,
                                        bathroomVanity,
                                        _modelBathroomVanityController,
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Step(
                            isActive: currentStep >= 4,
                            title: Text(
                              "Outdoors",
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            content: Column(
                              children: [
                                SizedBox(
                                  width: double.infinity,
                                  child: Wrap(
                                    alignment: WrapAlignment.start,
                                    children: [
                                      switchButtonBuilder(
                                        "Yard",
                                        (bool state) {
                                          setState(() {
                                            _modelYardController = state;
                                          });
                                        },
                                      ),
                                      switchButtonBuilder(
                                        "Patio",
                                        (bool state) {
                                          setState(() {
                                            _modelPatioController = state;
                                          });
                                        },
                                      ),
                                      switchButtonBuilder(
                                        "Swimming Pool",
                                        (bool state) {
                                          setState(() {
                                            _modelPoolController = state;
                                          });
                                        },
                                      ),
                                      switchButtonBuilder(
                                        "Deck",
                                        (bool state) {
                                          setState(() {
                                            _modelDeckController = state;
                                          });
                                        },
                                      ),
                                      switchButtonBuilder(
                                        "Parkings",
                                        (bool state) {
                                          setState(() {
                                            _modelParkingsController = state;
                                          });
                                        },
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Step(
                            isActive: currentStep >= 5,
                            title: Text(
                              "Technology & Energy Efficiency",
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            content: Column(
                              children: [
                                SizedBox(
                                  width: double.infinity,
                                  child: Wrap(
                                    alignment: WrapAlignment.start,
                                    children: [
                                      multiSelectBuilder(
                                        "Technology & Energy Efficient tools",
                                        Icons.catching_pokemon,
                                        technologyList,
                                        _modelTechnologyAndSmartFeaturesController,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Step(
                            isActive: currentStep >= 5,
                            title: Text(
                              "Upload 3d Models and Image",
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            content: Column(
                              children: [
                                SizedBox(
                                  width: double.infinity,
                                  child: Wrap(
                                    alignment: WrapAlignment.start,
                                    children: [
                                      UploadImage(
                                          imgName: "3D model",
                                          onPressed: () async {
                                            await FirebaseStorage
                                                .select3DModel();
                                          },
                                          index: -1),
                                      UploadImage(
                                          imgName: "Sample Image",
                                          onPressed: () async {
                                            await FirebaseStorage
                                                .selectSampleFile();
                                          },
                                          index: -1),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
