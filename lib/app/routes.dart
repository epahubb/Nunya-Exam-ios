import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:nunyaexam/ui/screens/CaptureImageScreen.dart';
import 'package:nunyaexam/ui/screens/aboutAppScreen.dart';
import 'package:nunyaexam/ui/screens/appSettingsScreen.dart';
import 'package:nunyaexam/ui/screens/auth/otpScreen.dart';
import 'package:nunyaexam/ui/screens/auth/signInScreen.dart';
import 'package:nunyaexam/ui/screens/auth/signUpScreen.dart';
import 'package:nunyaexam/ui/screens/badgesScreen.dart';
import 'package:nunyaexam/ui/screens/battle/battleRoomFindOpponentScreen.dart';
import 'package:nunyaexam/ui/screens/bookmarkScreen.dart';
import 'package:nunyaexam/ui/screens/coinHistoryScreen.dart';
import 'package:nunyaexam/ui/screens/coinStoreScreen.dart';
import 'package:nunyaexam/ui/screens/exam/examScreen.dart';
import 'package:nunyaexam/ui/screens/exam/examsScreen.dart';
import 'package:nunyaexam/ui/screens/home/homeScreen.dart';
import 'package:nunyaexam/ui/screens/introSliderScreen.dart';
import 'package:nunyaexam/ui/screens/leaderBoardScreen.dart';
import 'package:nunyaexam/ui/screens/notificationScreen.dart';
import 'package:nunyaexam/ui/screens/profile/profileScreen.dart';
import 'package:nunyaexam/ui/screens/battle/battleRoomQuizScreen.dart';

import 'package:nunyaexam/ui/screens/quiz/bookmarkQuizScreen.dart';
import 'package:nunyaexam/ui/screens/quiz/categoryScreen.dart';
import 'package:nunyaexam/ui/screens/quiz/contestLeaderboardScreen.dart';
import 'package:nunyaexam/ui/screens/quiz/contestScreen.dart';
import 'package:nunyaexam/ui/screens/quiz/funAndLearnScreen.dart';
import 'package:nunyaexam/ui/screens/quiz/funAndLearnTitleScreen.dart';
import 'package:nunyaexam/ui/screens/quiz/guessTheWordQuizScreen.dart';
import 'package:nunyaexam/ui/screens/battle/multiUserBattleRoomQuizScreen.dart';
import 'package:nunyaexam/ui/screens/battle/multiUserBattleRoomResultScreen.dart';
import 'package:nunyaexam/ui/screens/quiz/levelsScreen.dart';
import 'package:nunyaexam/ui/screens/quiz/reviewAnswersScreen.dart';
import 'package:nunyaexam/ui/screens/quiz/selfChallengeQuestionsScreen.dart';
import 'package:nunyaexam/ui/screens/quiz/selfChallengeScreen.dart';

import 'package:nunyaexam/ui/screens/quiz/subCategoryAndLevelScreen.dart';
import 'package:nunyaexam/ui/screens/quiz/quizScreen.dart';
import 'package:nunyaexam/ui/screens/quiz/resultScreen.dart';
import 'package:nunyaexam/ui/screens/quiz/subCategoryScreen.dart';

import 'package:nunyaexam/ui/screens/referAndEarnScreen.dart';
import 'package:nunyaexam/ui/screens/rewards/rewardsScreen.dart';
import 'package:nunyaexam/ui/screens/profile/selectProfilePictureScreen.dart';

import 'package:nunyaexam/ui/screens/splashScreen.dart';
import 'package:nunyaexam/ui/screens/statisticsScreen.dart';
import 'package:nunyaexam/ui/screens/tournament/tournamentDetailsScreen.dart';
import 'package:nunyaexam/ui/screens/tournament/tournamentScreen.dart';
import 'package:nunyaexam/ui/screens/wallet/walletScreen.dart';

class Routes {
  static const home = "/";
  static const login = "login";
  static const splash = 'splash';
  static const signUp = "signUp";
  static const introSlider = "introSlider";
  static const selectProfile = "selectProfile";
  static const quiz = "/quiz";
  static const subcategoryAndLevel = "/subcategoryAndLevel";
  static const subCategory = "/subCategory";

  static const referAndEarn = "/referAndEarn";
  static const notification = "/notification";
  static const bookmark = "/bookmark";
  static const bookmarkQuiz = "/bookmarkQuiz";
  static const coinStore = "/coinStore";
  static const rewards = "/rewards";
  static const result = "/result";
  static const selectRoom = "/selectRoom";
  static const category = "/category";
  static const profile = "/profile";
  static const editProfile = "/editProfile";
  static const leaderBoard = "/leaderBoard";
  static const reviewAnswers = "/reviewAnswers";
  static const selfChallenge = "/selfChallenge";
  static const selfChallengeQuestions = "/selfChallengeQuestions";
  static const battleRoomQuiz = "/battleRoomQuiz";
  static const battleRoomFindOpponent = "/battleRoomFindOpponent";

  static const logOut = "/logOut";
  static const trueFalse = "/trueFalse";
  static const multiUserBattleRoomQuiz = "/multiUserBattleRoomQuiz";
  static const multiUserBattleRoomQuizResult = "/multiUserBattleRoomQuizResult";

  static const contest = "/contest";
  static const contestLeaderboard = "/contestLeaderboard";
  static const funAndLearnTitle = "/funAndLearnTitle";
  static const funAndLearn = "funAndLearn";
  static const guessTheWord = "/guessTheWord";
  static const appSettings = "/appSettings";
  static const levels = "/levels";
  static const aboutApp = "/aboutApp";
  static const badges = "/badges";
  static const exams = "/exams";
  static const exam = "/exam";
  static const tournament = "/tournament";
  static const tournamentDetails = "/tournamentDetails";
  static const otpScreen = "/otpScreen";
  static const statistics = "/statistics";
  static const coinHistory = "/coinHistory";
  static const wallet = "/wallet";
  static const captureImage = "/captureImage";

  static String currentRoute = splash;

  static Route<dynamic> onGenerateRouted(RouteSettings routeSettings) {
    //to track current route
    //this will only track pushed route on top of previous route
    currentRoute = routeSettings.name ?? "";
    print("Current Route is $currentRoute");
    switch (routeSettings.name) {
      case splash:
        return CupertinoPageRoute(builder: (context) => SplashScreen());
      case home:
        return HomeScreen.route(routeSettings);
      case introSlider:
        return CupertinoPageRoute(builder: (context) => IntroSliderScreen());
      case login:
        return CupertinoPageRoute(builder: (context) => SignInScreen());
      case signUp:
        return CupertinoPageRoute(builder: (context) => SignUpScreen());
      case otpScreen:
        return OtpScreen.route(routeSettings);
      case subcategoryAndLevel:
        return SubCategoryAndLevelScreen.route(routeSettings);
      case selectProfile:
        return SelectProfilePictureScreen.route(routeSettings);
      case quiz:
        return QuizScreen.route(routeSettings);
      case wallet:
        return WalletScreen.route(routeSettings);
      case captureImage:
        return CupertinoPageRoute<String?>(
            builder: (context) => CaptureImageScreen());
      case coinStore:
        return CoinStoreScreen.route(routeSettings);
      case rewards:
        return RewardsScreen.route(routeSettings);
      case referAndEarn:
        return CupertinoPageRoute(builder: (_) => ReferAndEarnScreen());
      case result:
        return ResultScreen.route(routeSettings);
      case profile:
        return ProfileScreen.route(routeSettings);
      case reviewAnswers:
        return ReviewAnswersScreen.route(routeSettings);
      case selfChallenge:
        return SelfChallengeScreen.route(routeSettings);
      case selfChallengeQuestions:
        return SelfChallengeQuestionsScreen.route(routeSettings);
      case category:
        return CategoryScreen.route(routeSettings);
      case leaderBoard:
        return LeaderBoardScreen.route(routeSettings);
      case bookmark:
        return CupertinoPageRoute(builder: (context) => BookmarkScreen());
      case bookmarkQuiz:
        return BookmarkQuizScreen.route(routeSettings);
      case battleRoomQuiz:
        return BattleRoomQuizScreen.route(routeSettings);
      case notification:
        return NotificationScreen.route(routeSettings);
      case funAndLearnTitle:
        return FunAndLearnTitleScreen.route(routeSettings);
      case funAndLearn:
        return FunAndLearnScreen.route(routeSettings);
      case multiUserBattleRoomQuiz:
        return MultiUserBattleRoomQuizScreen.route(routeSettings);
      case contest:
        return ContestScreen.route(routeSettings);
      case guessTheWord:
        return GuessTheWordQuizScreen.route(routeSettings);

      case multiUserBattleRoomQuizResult:
        return MultiUserBattleRoomResultScreen.route(routeSettings);

      case contestLeaderboard:
        return ContestLeaderBoardScreen.route(routeSettings);

      case battleRoomFindOpponent:
        return BattleRoomFindOpponentScreen.route(routeSettings);

      case appSettings:
        return AppSettingsScreen.route(routeSettings);

      case levels:
        return LevelsScreen.route(routeSettings);

      case coinHistory:
        return CoinHistoryScreen.route(routeSettings);

      case aboutApp:
        return CupertinoPageRoute(builder: (context) => AboutAppScreen());

      case subCategory:
        return SubCategoryScreen.route(routeSettings);
      case badges:
        return BadgesScreen.route(routeSettings);

      case exams:
        return ExamsScreen.route(routeSettings);

      case exam:
        return ExamScreen.route(routeSettings);

      case tournament:
        return TournamentScreen.route(routeSettings);

      case tournamentDetails:
        return TournamentDetailsScreen.route(routeSettings);

      case statistics:
        return StatisticsScreen.route(routeSettings);

      default:
        return CupertinoPageRoute(builder: (context) => Scaffold());
    }
  }
}
