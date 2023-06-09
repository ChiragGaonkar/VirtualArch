import 'package:flutter/material.dart';
import 'package:virtualarch/screens/upload_work/upload_info.dart';
import '../screens/accounts/account_screen.dart';
import '../screens/chats/chats_screen.dart';
import '../screens/housemodels/exploremodels_screen.dart';
import '../screens/upload_work/upload_work.dart';

class DrawerNavProvider with ChangeNotifier {
  bool isHome = true;
  bool isModels = false;
  bool isArchitects = false;
  bool isFavorites = false;
  bool isChats = false;
  bool isAccount = false;

  void changeHighLighter(String? route) {
    switch (route) {
      case ExploreModelsScreen.routeName:
        highlightDrawerMenu(1);
        break;
      case ChatsScreen.routeName:
        highlightDrawerMenu(2);
        break;
      case UploadProjInfo.routeName:
        highlightDrawerMenu(3);
        break;
      case AccountScreen.routeName:
        highlightDrawerMenu(4);
        break;
      default:
        print("error ${route}");
    }
  }

  void highlightDrawerMenu(int loc) {
    switch (loc) {
      case 1:
        isHome = true;
        isModels = false;
        isArchitects = false;
        isFavorites = false;
        isChats = false;
        isAccount = false;
        break;

      case 2:
        isHome = false;
        isModels = true;
        isArchitects = false;
        isFavorites = false;
        isChats = false;
        isAccount = false;
        break;

      case 3:
        isHome = false;
        isModels = false;
        isArchitects = true;
        isFavorites = false;
        isChats = false;
        isAccount = false;
        break;

      case 4:
        isHome = false;
        isModels = false;
        isArchitects = false;
        isFavorites = true;
        isChats = false;
        isAccount = false;
        break;

      case 5:
        isHome = false;
        isModels = false;
        isArchitects = false;
        isFavorites = false;
        isChats = true;
        isAccount = false;
        break;

      case 6:
        isHome = false;
        isModels = false;
        isArchitects = false;
        isFavorites = false;
        isChats = false;
        isAccount = true;
        break;
    }
  }
}
