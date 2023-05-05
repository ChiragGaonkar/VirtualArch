import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:provider/provider.dart';
import 'package:virtualarch/models/upload_model.dart';

import '../../providers/models_provider.dart';
import '../../widgets/customscreen.dart';
import '../../widgets/headerwithnavigation.dart';
import '../../widgets/housemodels/model_features.dart';

class ModelsDetailScreen extends StatelessWidget {
  const ModelsDetailScreen({super.key});
  static const routeName = '/ModelsDetail';

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    bool isDesktop = size.width >= 600;
    bool isMobile = size.width < 600;
    final modelData = ModalRoute.of(context)!.settings.arguments as Models3D;
    return Scaffold(
      body: MyCustomScreen(
        screenContent: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderWithNavigation(
              heading: modelData.modelName,
              screenToBeRendered: "None",
            ),
            SizedBox(
              height: size.height * 0.02,
            ),
            Expanded(
              child: SizedBox(
                height: size.height * 0.7,
                width: size.width,
                child: SingleChildScrollView(
                  child: SizedBox(
                    width: double.infinity,
                    child: Wrap(
                      alignment: WrapAlignment.start,
                      // crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 20,
                      runSpacing: 10,
                      children: [
                        // ClipRRect(
                        //   borderRadius: const BorderRadius.only(
                        //     bottomLeft: Radius.circular(30),
                        //     bottomRight: Radius.circular(30),
                        //   ),
                        //   child: Image.network(
                        //     modelData.modelImageURL,
                        //     fit: BoxFit.cover,
                        //   ),
                        // ),
                        Container(
                          height:
                              isMobile ? size.height * 0.5 : size.height * 0.8,
                          width: 600,
                          child: ModelViewer(
                            // backgroundColor: Theme.of(context).canvasColor,
                            src: modelData.model3dURL,
                            alt: "A 3d model of astronaut",
                            ar: true,
                            autoPlay: true,
                            autoRotate: true,
                            cameraControls: true,
                            loading: Loading.eager,
                            poster: modelData.modelImageURL,
                          ),
                        ),
                        SizedBox(
                          width: 500,
                          // color: Colors.green,
                          child: ModelFeatures(modelData: modelData),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}