import 'package:flutter/material.dart';
import 'package:flutter_491/pages/home_page.dart';
import 'package:flutter_491/pages/main_page.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:flutter_491/Campus Map/map.dart';
import 'package:flutter_491/pages/news_page.dart';
import 'package:flutter_491/components/post_item.dart';


//Jessica's contribution App's Tutorial
class TutorialManager {
  static get targets => null;

  static Function? _toggleOptionsCallback;

  // Call this method to initialize the manager with the callback
  static void init(Function toggleOptionsCallback) {
    _toggleOptionsCallback = toggleOptionsCallback;
  }

  // Use this method to run the callback from anywhere within TutorialManager
  static void callToggleOptions() {
    if (_toggleOptionsCallback != null) {
      _toggleOptionsCallback!();
    }
  }
  // This method now accepts targets directly
  static void showTutorial(BuildContext context, List<TargetFocus> targets) {
    TutorialCoachMark tutorialCoachMark = TutorialCoachMark(
      targets: targets,
      colorShadow: Colors.blue,
      textSkip: "SKIP",
      paddingFocus: 10,
      opacityShadow: 0.8,
      alignSkip: Alignment.bottomRight,
      onFinish: () => print('Tutorial finished'),
      onClickTarget: (target) {
         if (target.identify == "Options Toggle") {
            TutorialManager.callToggleOptions();
        }
      print('Target clicked: ${target.identify}');
      },
      onClickOverlay: (target) => print('Overlay clicked: ${target.identify}'),
      onSkip: () {
        print("Skip clicked");
        return true;
      },
    );

    tutorialCoachMark.show(context: context);
  }
  //Show tutorial for Main/Homepage
 static void showHomeMainPageTutorial(BuildContext context) {
    List<TargetFocus> targets = createTargetsForHomeMainPage();
    TutorialManager.showTutorial(context, targets);
  }
  //Show tutorial for Newsfeed page
static void showNewsfeedTutorial(BuildContext context, {Function? onReady}) {
    if (onReady != null) {
        onReady(() {
            List<TargetFocus> targets = createTargetsForNewsfeedPage();
            showTutorial(context, targets);
        });
    } else {
        List<TargetFocus> targets = createTargetsForNewsfeedPage();
        showTutorial(context, targets);
    }
}


  //Show tutorial for Map page
 static void showMapTutorial(BuildContext context) {
    List<TargetFocus> targets = createTargetsForMapPage();
    TutorialManager.showTutorial(context, targets);
  }
  //Show tutorial for Chatbot page
 static void showChatbotTutorial(BuildContext context) {
    List<TargetFocus> targets = createTargetsForChatbotPage();
    TutorialManager.showTutorial(context, targets);
  }
 //Show tutorial for Profile page
 static void showProfileTutorial(BuildContext context) {
    List<TargetFocus> targets = createTargetsForProfilePage();
    TutorialManager.showTutorial(context, targets);
  }
}

  //Targets for Homepage with main
 List<TargetFocus> createTargetsForHomeMainPage() {
    return [
      // NewsFeed target
    TargetFocus(
      identify: "News Feed",
      keyTarget: newsFeedKey,
      contents: [
        TargetContent(
          align: ContentAlign.top,
          builder: (context, controller) {
            return const Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: Text(
                "This is where you can find the latest news updates.",
                style: TextStyle(
                color: Colors.white, 
                fontSize: 30,
                fontWeight: FontWeight.bold, // Making text bold
              ),
              ),
            );
          },
        ),
      ],
    ),

  // Map target
    TargetFocus(
      identify: "Map",
      keyTarget: mapKey,
      contents: [
        TargetContent(
          align: ContentAlign.top,
          builder: (context, controller) {
            return const Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: Text(
                "Access the map to find locations around the campus.",
                style: TextStyle(
                color: Colors.white, 
                fontSize: 30,
                fontWeight: FontWeight.bold, // Making text bold
              ),
              ),
            );
          },
        ),
      ],
    ),

  // Home target
    TargetFocus(
      identify: "Home",
      keyTarget: homeKey,
      contents: [
        TargetContent(
          align: ContentAlign.top,
          builder: (context, controller) {
            return const Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: Text(
                "This is your home dashboard.",
                style: TextStyle(
                color: Colors.white, 
                fontSize: 30,
                fontWeight: FontWeight.bold, 
              ),
            ),
            );
          },
        ),
      ],
    ),

  // Chatbot target
    TargetFocus(
      identify: "Chatbot",
      keyTarget: chatbotKey,
      contents: [
        TargetContent(
          align: ContentAlign.top,
          builder: (context, controller) {
            return const Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: Text(
                "Interact with our AI chatbot for help and information.",
                style: TextStyle(
                color: Colors.white, 
                fontSize: 30,
                fontWeight: FontWeight.bold, 
              ),
            ),
            );
          },
        ),
      ],
    ),

  // User Profile target
    TargetFocus(
      identify: "User Profile",
      keyTarget: userKey,
      contents: [
        TargetContent(
          align: ContentAlign.top,
          builder: (context, controller) {
            return const Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: Text(
                "Manage your profile and account settings here. Need a tutorial refresher, you can find our interative tutorials here as well.",
                style: TextStyle(
                color: Colors.white, 
                fontSize: 30,
                fontWeight: FontWeight.bold, 
              ),
            ),
            );
          },
        ),
      ],
    ),
    TargetFocus(
        identify: "Agenda",
        keyTarget: agendaKey,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return const Padding(
                padding: EdgeInsets.only(bottom: 10.0),
                child: Text(
                  "Here's where you can view your agenda",
                  style: TextStyle(
                color: Colors.white, 
                fontSize: 30,
                fontWeight: FontWeight.bold, 
              ),
            ),
            );
            },
          ),
        ],
      ),
      TargetFocus(
        identify: "Goal",
        keyTarget: goalKey,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return const Padding(
                padding: EdgeInsets.only(bottom: 10.0),
                child: Text(
                  "Set and view your goals here",
                  style: TextStyle(
                color: Colors.white, 
                fontSize: 30,
                fontWeight: FontWeight.bold, 
              ),
            ),
            );
            },
          ),
        ],
      ),
      // Storage Icon target
    TargetFocus(
      identify: "Storage",
      keyTarget: storageKey,
      contents: [
        TargetContent(
          align: ContentAlign.bottom,
          builder: (context, controller) {
            return const Padding(
              padding: EdgeInsets.only(bottom: 10.0),
              child: Text(
                "Keep track and download your files and documents in Storage",
                style: TextStyle(
                color: Colors.white, 
                fontSize: 30,
                fontWeight: FontWeight.bold, 
              ),
            ),
            );
          },
        ),
      ],
    ),

    // Calendar Icon target
    TargetFocus(
      identify: "Calendar",
      keyTarget: calendarKey,
      contents: [
        TargetContent(
          align: ContentAlign.bottom,
          builder: (context, controller) {
            return const Padding(
              padding: EdgeInsets.only(bottom: 10.0),
              child: Text(
                "View and manage your schedule in the Calendar",
                style: TextStyle(
                color: Colors.white, 
                fontSize: 30,
                fontWeight: FontWeight.bold, 
              ),
            ),
            );
          },
        ),
      ],
    ),// ... other targets ...
    ];
  }
  
 List<TargetFocus> createTargetsForNewsfeedPage() {
  return [
    TargetFocus(
      identify: "Notification Bell",
      keyTarget: bellIconKey,  // Ensure these keys are defined and assigned to the correct widgets elsewhere in your code
      contents: [
        TargetContent(
          align: ContentAlign.bottom,
          builder: (context, controller) {
            return const Padding(
              padding: EdgeInsets.only(bottom: 10.0),
              child: Text(
                "View your notifications here.",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          },
        ),
      ],
    ),
    TargetFocus(
      identify: "Bookmark Icon",
      keyTarget: firstBookmarkIconKey,
      contents: [
        TargetContent(
          align: ContentAlign.bottom,
          builder: (context, controller) {
            return const Padding(
              padding: EdgeInsets.only(bottom: 10.0),
              child: Text(
                "Bookmark posts for later viewing.",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          },
        ),
      ],
    ),
    TargetFocus(
      identify: "Share Icon",
      keyTarget: firstShareIconKey,
      contents: [
        TargetContent(
          align: ContentAlign.top,
          builder: (context, controller) {
            return const Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: Text(
                "Share this post with friends.",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          },
        ),
      ],
    ),
    TargetFocus(
      identify: "Options Menu",
      keyTarget: firstOptionsMenuKey,
      contents: [
        TargetContent(
          align: ContentAlign.bottom,
          builder: (context, controller) {
            return const Padding(
              padding: EdgeInsets.only(bottom: 10.0),
              child: Text(
                "Access more options like reporting.",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          },
        ),
      ],
    ),
    // Add more TargetFocus configurations for other elements if needed
  ];
}

  


List<TargetFocus> createTargetsForProfilePage() {
  return [];
}

List<TargetFocus> createTargetsForMapPage() {
  return [
    TargetFocus(
      identify: "Search Bar",
      keyTarget: searchBarKey,
      contents: [
        TargetContent(
          align: ContentAlign.bottom,
          builder: (context, controller) {
            return const Padding(
              padding: EdgeInsets.only(bottom: 10.0),
              child: Text(
                "Use this to search places on the map.",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          },
        ),
      ],
    ),
    TargetFocus(
      identify: "Options Toggle",
      keyTarget: optionsToggleKey,
      contents: [
        TargetContent(
          align: ContentAlign.bottom,
          builder: (context, controller) {
            return const Padding(
              padding: EdgeInsets.only(bottom: 10.0),
              child: Text(
                "Tap here to toggle map options",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          },
        ),
      ],
    ),
    TargetFocus(
      identify: "Campus Button",
      keyTarget: campusButtonKey,
      contents: [
        TargetContent(
          align: ContentAlign.bottom,
          builder: (context, controller) {
            return const Padding(
              padding: EdgeInsets.only(bottom: 10.0),
              child: Text(
                "Click here to take you back to CSULB campus on the map.",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          },
        ),
      ],
    ),
    TargetFocus(
      identify: "Current Location Button",
      keyTarget: currentLocationButtonKey,
      contents: [
        TargetContent(
          align: ContentAlign.bottom,
          builder: (context, controller) {
            return const Padding(
              padding: EdgeInsets.only(bottom: 10.0),
              child: Text(
                "Click here to find your current location on the map.",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          },
        ),
      ],
    ),
    TargetFocus(
      identify: "Distance Button",
      keyTarget: directionButtonKey,
      contents: [
        TargetContent(
          align: ContentAlign.bottom,
          builder: (context, controller) {
            return const Padding(
              padding: EdgeInsets.only(bottom: 10.0),
              child: Text(
                "Click here to calculate the distance to your desired destination.",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          },
        ),
      ],
    ),
    // ... Add more targets as needed ...
  ];
}
List<TargetFocus> createTargetsForChatbotPage() {
  return [];
}

