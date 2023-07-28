import 'dart:convert';
import 'dart:io';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jitsi_meet_fix/jitsi_meet.dart';
import 'package:lottie/lottie.dart';
import 'package:virtualarch/screens/chats/chats_screen.dart';
import 'package:virtualarch/screens/error_screen.dart';
import 'package:virtualarch/widgets/customscreen.dart';
import '../../widgets/headerwithnavigation.dart';
import 'package:http/http.dart' as http;
import 'package:date_time_picker/date_time_picker.dart';
import 'package:intl/intl.dart';

class VideoCallHomeScreen extends StatefulWidget {
  const VideoCallHomeScreen({super.key});
  static const routeName = "/videocallscreen";
  @override
  State<VideoCallHomeScreen> createState() => _VideoCallHomeScreenState();
}

class _VideoCallHomeScreenState extends State<VideoCallHomeScreen> {
  final serverText = TextEditingController();
  final roomText = TextEditingController();
  final subjectText = TextEditingController(text: "Video Conference with Client");
  final nameText = TextEditingController();
  final emailText = TextEditingController(text: "fake@email.com");
  final iosAppBarRGBAColor = TextEditingController(text: "#0080FF80"); //transparent blue
  final dateTimeText = TextEditingController(text: DateTime.now().toString());
  String roomLink = "";
  bool? isAudioOnly = true;
  bool? isAudioMuted = true;
  bool? isVideoMuted = true;
  bool isInvited = false;
  bool isJoinMeetingClicked = false;

  @override
  void initState() {
    super.initState();
    JitsiMeet.addListener(
      JitsiMeetingListener(onConferenceWillJoin: _onConferenceWillJoin, onConferenceJoined: _onConferenceJoined, onConferenceTerminated: _onConferenceTerminated, onError: _onError),
    );
  }

  @override
  void dispose() {
    super.dispose();
    JitsiMeet.removeAllListeners();
  }

  @override
  Widget build(BuildContext context) {
    var scaffoldMessengerVar = ScaffoldMessenger.of(context);
    var size = MediaQuery.of(context).size;
    Map args = {};
    bool isErrorOccured = false;
    try {
      isErrorOccured = false;
      args = ModalRoute.of(context)!.settings.arguments as Map;
    } catch (e) {
      isErrorOccured = true;
    }
    nameText.text = isErrorOccured ? "Unknown Name" : args['architectsName'];
    roomText.text = isErrorOccured ? "Unknown RoomId" : args['chatsId'];
    roomLink = "https://meet.jit.si/${args['chatsId']}";
    iosAppBarRGBAColor.text = Theme.of(context).primaryColor.toString();
    return isErrorOccured
        ? const ErrorScreen(
            screenToBeRendered: ChatsScreen.routeName,
            renderScreenName: "Chats",
          )
        : Scaffold(
            body: MyCustomScreen(
              screenContent: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const HeaderWithNavigation(
                    heading: "Video Conference",
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
                            alignment: WrapAlignment.center,
                            // crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 20,
                            runSpacing: 10,
                            children: [
                              SizedBox(
                                width: 500,
                                child: meetConfig(
                                  args,
                                  size,
                                  scaffoldMessengerVar,
                                ),
                              ),
                              SizedBox(
                                width: 700,
                                child: Card(
                                  color: Theme.of(context).secondaryHeaderColor,
                                  child: Container(
                                    width: size.width * 0.60,
                                    height: size.height * 0.75,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: isJoinMeetingClicked ? const AssetImage("assets/launchRocket.gif") : const AssetImage("assets/videoIcon.gif"),
                                      ),
                                    ),
                                    child: JitsiMeetConferencing(
                                      extraJS: const [
                                        // extraJs setup example
                                        '<script>function echo(){console.log("echo!!!")};</script>',
                                        '<script src="https://code.jquery.com/jquery-3.5.1.slim.js" integrity="sha256-DrT5NfxfbHvMHux31Lkhxg42LY6of8TaYyK50jnxRnM=" crossorigin="anonymous"></script>'
                                      ],
                                    ),
                                  ),
                                ),
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

  Widget meetConfig(args, Size size, scaffoldMessengerVar) {
    return Column(
      children: [
        SizedBox(
          height: size.height * 0.5,
          child: Lottie.asset("assets/PhoneInHand.json"),
        ),
        const SizedBox(
          height: 10.0,
        ),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            children: [
              Text(
                "Schedule and Invite",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              DateTimePicker(
                type: DateTimePickerType.dateTimeSeparate,
                decoration: InputDecoration(
                  icon: const Icon(Icons.event),
                  iconColor: Theme.of(context).secondaryHeaderColor,
                ),
                dateMask: 'd MMM, yyyy',
                initialValue: DateTime.now().toString(),
                firstDate: DateTime.now(),
                lastDate: DateTime(2100),
                dateLabelText: 'Date',
                timeLabelText: "Hour",
                onChanged: (value) {
                  dateTimeText.text = value.toString();
                },
                validator: (val) {
                  return null;
                },
                onSaved: (val) {
                  dateTimeText.text = val.toString();
                },
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 14.0,
        ),
        SizedBox(
          height: 40.0,
          width: double.maxFinite,
          child: ElevatedButton(
            onPressed: () async {
              // Send email to client...
              setState(() {
                isInvited = true;
              });
              String formattedTime = DateFormat.yMEd().add_jm().format(DateTime.parse(dateTimeText.text));
              final response = await sendEmail(
                fromName: args['architectsName'],
                toName: args['clientsName'],
                toEmail: args['clientsEmail'],
                message: "Let's connect on $formattedTime using Jitsi Meet. Room Link: $roomLink",
              );
              // final response = 200;
              response == 200
                  ? scaffoldMessengerVar.showSnackBar(
                      SnackBar(
                        content: AwesomeSnackbarContent(
                          title: 'Hurray!',
                          message: "Invited ${args['clientsName']} on $formattedTime",
                          contentType: ContentType.success,
                        ),
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                      ),
                    )
                  : scaffoldMessengerVar.showSnackBar(
                      SnackBar(
                        content: AwesomeSnackbarContent(
                          title: 'Whoops',
                          message: "Unable to invite ${args['clientsName']}",
                          contentType: ContentType.failure,
                        ),
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                      ),
                    );
              setState(() {
                isInvited = false;
              });
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateColor.resolveWith(
                (states) => Theme.of(context).canvasColor,
              ),
            ),
            child: Text(
              isInvited ? "Inviting ${args['clientsName']}...." : "Invite ${args['clientsName']}",
              style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Theme.of(context).primaryColor),
            ),
          ),
        ),
        const SizedBox(
          height: 14.0,
        ),
        SizedBox(
          height: 40.0,
          width: double.maxFinite,
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                isJoinMeetingClicked = true;
              });
              _joinMeeting();
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateColor.resolveWith(
                (states) => Theme.of(context).canvasColor,
              ),
            ),
            child: Text(
              "Launch Meet",
              style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Theme.of(context).primaryColor),
            ),
          ),
        ),
      ],
    );
  }

  _onAudioOnlyChanged(bool? value) {
    setState(() {
      isAudioOnly = value;
    });
  }

  _onAudioMutedChanged(bool? value) {
    setState(() {
      isAudioMuted = value;
    });
  }

  _onVideoMutedChanged(bool? value) {
    setState(() {
      isVideoMuted = value;
    });
  }

  _joinMeeting() async {
    String? serverUrl = serverText.text.trim().isEmpty ? null : serverText.text;

    // Enable or disable any feature flag here
    // If feature flag are not provided, default values will be used
    // Full list of feature flags (and defaults) available in the README
    Map<FeatureFlagEnum, bool> featureFlags = {
      FeatureFlagEnum.WELCOME_PAGE_ENABLED: false,
    };
    if (!kIsWeb) {
      // Here is an example, disabling features for each platform
      if (Platform.isAndroid) {
        // Disable ConnectionService usage on Android to avoid issues (see README)
        featureFlags[FeatureFlagEnum.CALL_INTEGRATION_ENABLED] = false;
      } else if (Platform.isIOS) {
        // Disable PIP on iOS as it looks weird
        featureFlags[FeatureFlagEnum.PIP_ENABLED] = false;
      }
    }
    // Define meetings options here
    var options = JitsiMeetingOptions(room: roomText.text)
      ..serverURL = serverUrl
      ..subject = subjectText.text
      ..userDisplayName = nameText.text
      ..userEmail = emailText.text
      ..iosAppBarRGBAColor = iosAppBarRGBAColor.text
      ..audioOnly = isAudioOnly
      ..audioMuted = isAudioMuted
      ..videoMuted = isVideoMuted
      ..featureFlags.addAll(featureFlags)
      ..webOptions = {
        "roomName": roomText.text,
        "width": "100%",
        "height": "100%",
        "enableWelcomePage": false,
        "chromeExtensionBanner": null,
        "userInfo": {"displayName": nameText.text}
      };

    debugPrint("JitsiMeetingOptions: $options");
    await JitsiMeet.joinMeeting(
      options,
      listener: JitsiMeetingListener(
          onConferenceWillJoin: (message) {
            debugPrint("${options.room} will join with message: $message");
          },
          onConferenceJoined: (message) {
            debugPrint("${options.room} joined with message: $message");
          },
          onConferenceTerminated: (message) {
            setState(() {
              isJoinMeetingClicked = false;
            });
            debugPrint("${options.room} terminated with message: $message");
          },
          genericListeners: [
            JitsiGenericListener(
                eventName: 'readyToClose',
                callback: (dynamic message) {
                  debugPrint("readyToClose callback");
                }),
          ]),
    );
  }

  Future sendEmail({
    required String fromName,
    required String toName,
    required String toEmail,
    required String message,
  }) async {
    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
    const serviceId = 'service_eywybwf';
    const templateId = 'template_76giubj';
    const userId = 'Lw4TOd4fvd60QUhWf';
    final response = await http.post(url,
        headers: {'Content-Type': 'application/json'}, //This line makes sure it works for all platforms.
        body: json.encode({
          'service_id': serviceId,
          'template_id': templateId,
          'user_id': userId,
          'template_params': {'from_name': fromName, 'to_name': toName, 'reply_to': toEmail, 'message': message}
        }));
    return response.statusCode;
  }

  void _onConferenceWillJoin(message) {
    debugPrint("_onConferenceWillJoin broadcasted with message: $message");
  }

  void _onConferenceJoined(message) {
    debugPrint("_onConferenceJoined broadcasted with message: $message");
  }

  void _onConferenceTerminated(message) {
    debugPrint("_onConferenceTerminated broadcasted with message: $message");
  }

  _onError(error) {
    debugPrint("_onError broadcasted: $error");
  }
}
