import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:virtualarch/firebase/firebase_storage.dart';
import 'package:virtualarch/models/architects_model.dart';

class FireDatabase {
  Future<void> createUser({
    required String architectId,
    required Map architectData,
  }) async {
    try {
      final docArchitect = FirebaseFirestore.instance.collection("architects").doc(architectId);
      final architect = ArchitectModel(
        architectID: architectId,
        architectName: architectData['architectName'],
        architectType: architectData['architectType'],
        architectRegisterNum: architectData['architectRegisterNum'],
        architectExperience: architectData['architectExperience'],
        architectOfficeLocation: {
          'companyName': architectData['architectCompanyName'],
          'companyStreetAddress': architectData['architectStreetAddress'],
          'city': architectData['architectCity'],
          'state': architectData['architectState'],
          'zipCode': architectData['architectZipCode'],
          'country': architectData['architectCountry'],
        },
        aboutMe: architectData['architectAboutMe'],
        skills: architectData['architectSkills'],
        architectImageUrl: architectData['architectGender'] == "Male" ? "assets/Male.png" : "assets/Female.png",
        architectEmail: architectData['email'],
      );
      final json = architect.toJson();
      await docArchitect.set(json);
    } on FirebaseException catch (e) {
      print("Error ${e}");
    }
  }

  static Future<void> addModelUrl(String url, String key, String projectId) async {
    // final userId = FirebaseAuth.instance.currentUser!.uid;
    // print("field ${key} url ${url}");
    // DocumentSnapshot ds =
    //     await FirebaseFirestore.instance.collection('models').doc(userId).get();
    // print("exist or not ${ds.exists}");
    // if (ds.exists) {
    // var map = {
    //   "house1": {
    //     "2d_images": FieldValue.arrayUnion([url])
    //   }
    // };
    // await FirebaseFirestore.instance.collection('models').doc(userId).update({
    //   "house1": {
    //     "2d_images": FieldValue.array([url])
    //   }
    // }).then((value) {
    //   print("updated");
    // });
    // } else {
    // var map = {
    //   "house1": {key: url}
    // };

    await FirebaseFirestore.instance.collection('models').doc(projectId).set({key: url}, SetOptions(merge: true));
    // }
  }

  static Future<String> getDPLink() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    var modelData = await FirebaseFirestore.instance.collection('architects').doc(userId).get();
    try {
      return modelData["architectImageUrl"];
    } catch (e) {
      return "";
    }
  }

  static Future<void> updateDP(String url) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance.collection('architects').doc(userId).set({"architectImageUrl": url}, SetOptions(merge: true));
  }

  static Future<void> deleteModel(String id) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    var modelData = await FirebaseFirestore.instance.collection('models').doc(id).get();
    List<dynamic> models = [];
    models.add(modelData["model3dBirdsView"]);
    models.add(modelData["model3dURL"]);
    models.add(modelData["modelImageURL"]);
    var mapImage = modelData["modelOtherDesignLinks"];
    mapImage.forEach((tag, e) => models.add(e.toString()));
    await FirebaseStorage.deleteModel(models);
    await FirebaseFirestore.instance.collection('models').doc(id).delete();
    await FirebaseFirestore.instance.collection('architects').doc(userId).set({
      "architectProjectsId": FieldValue.arrayRemove([id])
    }, SetOptions(merge: true));
  }

  static Future<void> addToken() async {
    late FirebaseMessaging messaging;
    const vapidKey = "BJQERLPD7uSf2P9aotC9k3Y6nj5hT07hMuoovz2MzRadJ_UPwG3B2hayB8x2K0CeVTGyXdgV3_yRUlejTYanjP4";
    try {
      final userId = FirebaseAuth.instance.currentUser!.uid;
      messaging = FirebaseMessaging.instance;
      // final settings = await messaging.requestPermission(
      //   alert: true,
      //   announcement: false,
      //   badge: true,
      //   carPlay: false,
      //   criticalAlert: false,
      //   provisional: false,
      //   sound: true,
      // );
      var tokens = await messaging.getToken(
        vapidKey: vapidKey,
      );
      print("token $tokens");
      await FirebaseFirestore.instance.collection('architects').doc(userId).get().then((value) async {
        var list = value["token"] as List<dynamic>;
        if (list.contains(tokens.toString())) {
          return;
        }
        await FirebaseFirestore.instance.collection('architects').doc(userId).set({
          "token": FieldValue.arrayUnion([tokens])
        }, SetOptions(merge: true));
      });
    } catch (e) {
      print(e);
    }
  }

  static Future<bool> checkReg(String reg) async {
    reg = reg.trim();
    String id = reg.replaceAll('/', '-');
    var modelData = await FirebaseFirestore.instance.collection('verifiedArch').doc(id).get();
    // try {
    //   print(modelData["name"]);
    // } catch (e) {
    //   print("Doest exist");
    // }
    print(reg);
    print("$id  ${modelData.exists}");
    return modelData.exists;
  }

  static Future<bool> checkName(String reg, String name) async {
    try {
      String id = reg.replaceAll('/', '-');
      var modelData = await FirebaseFirestore.instance.collection('verifiedArch').doc(id).get();
      var temp = modelData["name"];
      return temp == name ? true : false;
    } catch (e) {
      return false;
    }
  }
}
