import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nunyaexam/app/appLocalization.dart';
import 'package:nunyaexam/app/routes.dart';
import 'package:nunyaexam/features/ads/interstitialAdCubit.dart';
import 'package:nunyaexam/features/profileManagement/cubits/userDetailsCubit.dart';
import 'package:nunyaexam/features/quiz/cubits/quizCategoryCubit.dart';
import 'package:nunyaexam/features/quiz/models/quizType.dart';
import 'package:nunyaexam/ui/widgets/bannerAdContainer.dart';

import 'package:nunyaexam/ui/widgets/circularProgressContainner.dart';
import 'package:nunyaexam/ui/widgets/customBackButton.dart';
import 'package:nunyaexam/ui/widgets/errorContainer.dart';
import 'package:nunyaexam/ui/widgets/pageBackgroundGradientContainer.dart';

import 'package:nunyaexam/utils/errorMessageKeys.dart';
import 'package:nunyaexam/utils/uiUtils.dart';

class CategoryScreen extends StatefulWidget {
  // Get the quiz Type
  final QuizTypes quizType;

  // Make sure the quiz type is required and exists
  CategoryScreen({required this.quizType});

  /// The function creates and returns an instance of the _CategoryScreen class.
  @override
  _CategoryScreen createState() => _CategoryScreen();

  static Route<dynamic> route(RouteSettings routeSettings) {
    Map arguments = routeSettings.arguments as Map;
    return CupertinoPageRoute(
        builder: (_) => CategoryScreen(
              quizType: arguments['quizType'] as QuizTypes,
            ));
  }
}

// Category Screen
class _CategoryScreen extends State<CategoryScreen> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    // ADS
    // Future.delayed(Duration.zero, () {
    //   context.read<InterstitialAdCubit>().showAd(context);
    // });

    // GET QUIZ CATEGORY
    context.read<QuizCategoryCubit>().getQuizCategory(
          languageId: UiUtils.getCurrentQuestionLanguageId(context),
          type: UiUtils.getCategoryTypeNumberFromQuizType(widget.quizType),
          userId: context.read<UserDetailsCubit>().getUserId(),
        );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          PageBackgroundGradientContainer(),
          Column(children: <Widget>[
            Expanded(flex: 2, child: back()),
            Expanded(flex: 15, child: showCategory()),
          ]),
          Align(
            alignment: Alignment.bottomCenter,
            // child: BannerAdContainer(),
          ),
        ],
      ),
    );
  }

  Widget back() {
    return Padding(
      padding: const EdgeInsetsDirectional.only(top: 30, start: 20, end: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomBackButton(
            iconColor: Theme.of(context).primaryColor,
          )
        ],
      ),
    );
  }

  Widget showCategory() {
    return BlocConsumer<QuizCategoryCubit, QuizCategoryState>(
        bloc: context.read<QuizCategoryCubit>(),
        listener: (context, state) {
          if (state is QuizCategoryFailure) {
            if (state.errorMessage == unauthorizedAccessCode) {
              UiUtils.showAlreadyLoggedInDialog(context: context);
            }
          }
        },
        builder: (context, state) {
          if (state is QuizCategoryProgress || state is QuizCategoryInitial) {
            return Center(
              child: CircularProgressContainer(
                useWhiteLoader: false,
              ),
            );
          }
          if (state is QuizCategoryFailure) {
            return ErrorContainer(
              showBackButton: false,
              errorMessageColor: Theme.of(context).primaryColor,
              showErrorImage: true,
              errorMessage: AppLocalization.of(context)!.getTranslatedValues(
                convertErrorCodeToLanguageKey(state.errorMessage),
              ),
              onTapRetry: () {
                context.read<QuizCategoryCubit>().getQuizCategory(
                      languageId: UiUtils.getCurrentQuestionLanguageId(context),
                      type: UiUtils.getCategoryTypeNumberFromQuizType(
                          widget.quizType),
                      userId: context.read<UserDetailsCubit>().getUserId(),
                    );
              },
            );
          }
          final categoryList = (state as QuizCategorySuccess).categories;
          return ListView.builder(
            padding: EdgeInsets.only(
              bottom: 50,
            ),
            controller: scrollController,
            // scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: categoryList.length,
            physics: AlwaysScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  if (widget.quizType == QuizTypes.quizZone) {
                    //noOf means how many subcategory it has
                    //if subcategory is 0 then check for level
                    print(categoryList[index]);
                    if (categoryList[index].noOf == "0") {
                      //means this category does not have level
                      if (categoryList[index].maxLevel == "0") {
                        //direct move to quiz screen pass level as 0
                        Navigator.of(context)
                            .pushNamed(Routes.quiz, arguments: {
                          "numberOfPlayer": 1,
                          "quizType": QuizTypes.quizZone,
                          "categoryId": categoryList[index].id,
                          "subcategoryId": "",
                          "level": "0",
                          "subcategoryMaxLevel": "0",
                          "unlockedLevel": 0,
                          "contestId": "",
                          "comprehensionId": "",
                          "quizName": "Quiz Zone"
                        });
                      } else {
                        //navigate to level screen
                        Navigator.of(context)
                            .pushNamed(Routes.levels, arguments: {
                          "maxLevel": categoryList[index].maxLevel,
                          "categoryId": categoryList[index].id,
                        });
                      }
                    } else {
                      Navigator.of(context).pushNamed(
                          Routes.subcategoryAndLevel,
                          arguments: categoryList[index].id);
                    }
                  } else if (widget.quizType == QuizTypes.audioQuestions) {
                    //noOf means how many subcategory it has

                    if (categoryList[index].noOf == "0") {
                      //
                      Navigator.of(context).pushNamed(Routes.quiz, arguments: {
                        "numberOfPlayer": 1,
                        "quizType": QuizTypes.audioQuestions,
                        "categoryId": categoryList[index].id,
                        "isPlayed": categoryList[index].isPlayed,
                      });
                    } else {
                      //
                      Navigator.of(context)
                          .pushNamed(Routes.subCategory, arguments: {
                        "categoryId": categoryList[index].id,
                        "quizType": widget.quizType,
                      });
                    }
                  } else if (widget.quizType == QuizTypes.guessTheWord) {
                    //if therse is noo subcategory then get questions by category
                    if (categoryList[index].noOf == "0") {
                      Navigator.of(context)
                          .pushNamed(Routes.guessTheWord, arguments: {
                        "type": "category",
                        "typeId": categoryList[index].id,
                        "isPlayed": categoryList[index].isPlayed,
                      });
                    } else {
                      Navigator.of(context)
                          .pushNamed(Routes.subCategory, arguments: {
                        "categoryId": categoryList[index].id,
                        "quizType": widget.quizType,
                      });
                    }
                  } else if (widget.quizType == QuizTypes.funAndLearn) {
                    //if therse is no subcategory then get questions by category
                    if (categoryList[index].noOf == "0") {
                      Navigator.of(context)
                          .pushNamed(Routes.funAndLearnTitle, arguments: {
                        "type": "category",
                        "typeId": categoryList[index].id,
                      });
                    } else {
                      Navigator.of(context)
                          .pushNamed(Routes.subCategory, arguments: {
                        "categoryId": categoryList[index].id,
                        "quizType": widget.quizType,
                      });
                    }
                  } else if (widget.quizType == QuizTypes.mathMania) {
                    //if therse is noo subcategory then get questions by category
                    if (categoryList[index].noOf == "0") {
                      Navigator.of(context).pushNamed(Routes.quiz, arguments: {
                        "numberOfPlayer": 1,
                        "quizType": QuizTypes.mathMania,
                        "categoryId": categoryList[index].id,
                        "isPlayed": categoryList[index].isPlayed,
                      });
                    } else {
                      Navigator.of(context)
                          .pushNamed(Routes.subCategory, arguments: {
                        "categoryId": categoryList[index].id,
                        "quizType": widget.quizType,
                      });
                    }
                  } else if (widget.quizType == QuizTypes.bece) {
                    //if there is noo subcategory then get questions by category
                    if (categoryList[index].noOf == "0") {
                      Navigator.of(context).pushNamed(Routes.quiz, arguments: {
                        "numberOfPlayer": 1,
                        "quizType": QuizTypes.bece,
                        "categoryId": categoryList[index].id,
                        "isPlayed": categoryList[index].isPlayed,
                      });
                    } else {
                      Navigator.of(context)
                          .pushNamed(Routes.subCategory, arguments: {
                        "categoryId": categoryList[index].id,
                        "quizType": widget.quizType,
                      });
                    }
                  }
                  // WASSCE
                  else if (widget.quizType == QuizTypes.wassce) {
                    //if there is noo subcategory then get questions by category
                    if (categoryList[index].noOf == "0") {
                      Navigator.of(context).pushNamed(Routes.quiz, arguments: {
                        "numberOfPlayer": 1,
                        "quizType": QuizTypes.wassce,
                        "categoryId": categoryList[index].id,
                        "isPlayed": categoryList[index].isPlayed,
                      });
                    } else {
                      Navigator.of(context)
                          .pushNamed(Routes.subCategory, arguments: {
                        "categoryId": categoryList[index].id,
                        "quizType": widget.quizType,
                      });
                    }
                  }
                  // CAMBRIDGE O LEVEL
                  else if (widget.quizType == QuizTypes.cambridgeOLevel) {
                    //if there is noo subcategory then get questions by category
                    if (categoryList[index].noOf == "0") {
                      Navigator.of(context).pushNamed(Routes.quiz, arguments: {
                        "numberOfPlayer": 1,
                        "quizType": QuizTypes.cambridgeOLevel,
                        "categoryId": categoryList[index].id,
                        "isPlayed": categoryList[index].isPlayed,
                      });
                    } else {
                      Navigator.of(context)
                          .pushNamed(Routes.subCategory, arguments: {
                        "categoryId": categoryList[index].id,
                        "quizType": widget.quizType,
                      });
                    }
                  }
                  // CAMBRIDGE A LEVEL
                  else if (widget.quizType == QuizTypes.cambridgeALevel) {
                    //if there is noo subcategory then get questions by category
                    if (categoryList[index].noOf == "0") {
                      Navigator.of(context).pushNamed(Routes.quiz, arguments: {
                        "numberOfPlayer": 1,
                        "quizType": QuizTypes.cambridgeALevel,
                        "categoryId": categoryList[index].id,
                        "isPlayed": categoryList[index].isPlayed,
                      });
                    } else {
                      Navigator.of(context)
                          .pushNamed(Routes.subCategory, arguments: {
                        "categoryId": categoryList[index].id,
                        "quizType": widget.quizType,
                      });
                    }
                  }
                  // TOFEL
                  else if (widget.quizType == QuizTypes.tofel) {
                    //if there is noo subcategory then get questions by category
                    if (categoryList[index].noOf == "0") {
                      Navigator.of(context).pushNamed(Routes.quiz, arguments: {
                        "numberOfPlayer": 1,
                        "quizType": QuizTypes.tofel,
                        "categoryId": categoryList[index].id,
                        "isPlayed": categoryList[index].isPlayed,
                      });
                    } else {
                      Navigator.of(context)
                          .pushNamed(Routes.subCategory, arguments: {
                        "categoryId": categoryList[index].id,
                        "quizType": widget.quizType,
                      });
                    }
                  }

                  // TOFEL
                  else if (widget.quizType == QuizTypes.sat) {
                    //if there is noo subcategory then get questions by category
                    if (categoryList[index].noOf == "0") {
                      Navigator.of(context).pushNamed(Routes.quiz, arguments: {
                        "numberOfPlayer": 1,
                        "quizType": QuizTypes.sat,
                        "categoryId": categoryList[index].id,
                        "isPlayed": categoryList[index].isPlayed,
                      });
                    } else {
                      Navigator.of(context)
                          .pushNamed(Routes.subCategory, arguments: {
                        "categoryId": categoryList[index].id,
                        "quizType": widget.quizType,
                      });
                    }
                  }
                },
                child: Container(
                    height: 90,
                    alignment: Alignment.center,
                    margin: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: Theme.of(context).primaryColor),
                    child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: CachedNetworkImage(
                              placeholder: (context, _) => SizedBox(),
                              imageUrl: categoryList[index].image!,
                              errorWidget: (context, imageUrl, _) => Image(
                                  image: AssetImage(UiUtils.getImagePath(
                                      "ic_launcher.png")))),
                        ),
                        trailing: Icon(
                          Icons.navigate_next_outlined,
                          size: 40,
                          color: Theme.of(context).backgroundColor,
                        ),
                        title: Text(
                          categoryList[index].categoryName!,
                          style: TextStyle(
                            color: Theme.of(context).backgroundColor,
                          ),
                        ),
                        subtitle: widget.quizType == QuizTypes.quizZone
                            ? Text(
                                "Question: " + categoryList[index].noOfQqe!,
                                style: TextStyle(
                                    color: Theme.of(context).canvasColor),
                              )
                            : SizedBox())),
              );
            },
          );
        });
  }
}
