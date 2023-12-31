import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:nunyaexam/app/appLocalization.dart';
import 'package:nunyaexam/features/coinHistory/coinHistoryCubit.dart';
import 'package:nunyaexam/features/coinHistory/coinHistoryRepository.dart';
import 'package:nunyaexam/features/coinHistory/models/coinHistory.dart';
import 'package:nunyaexam/features/profileManagement/cubits/userDetailsCubit.dart';
import 'package:nunyaexam/ui/styles/colors.dart';
import 'package:nunyaexam/ui/widgets/circularProgressContainner.dart';
import 'package:nunyaexam/ui/widgets/errorContainer.dart';
import 'package:nunyaexam/ui/widgets/pageBackgroundGradientContainer.dart';
import 'package:nunyaexam/ui/widgets/roundedAppbar.dart';
import 'package:nunyaexam/utils/errorMessageKeys.dart';
import 'package:nunyaexam/utils/stringLabels.dart';
import 'package:nunyaexam/utils/uiUtils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CoinHistoryScreen extends StatefulWidget {
  CoinHistoryScreen({Key? key}) : super(key: key);

  @override
  _CoinHistoryScreenState createState() => _CoinHistoryScreenState();

  static Route<dynamic> route(RouteSettings routeSettings) {
    return CupertinoPageRoute(
        builder: (_) => BlocProvider<CoinHistoryCubit>(
            create: (_) => CoinHistoryCubit(CoinHistoryRepository()),
            child: CoinHistoryScreen()));
  }
}

class _CoinHistoryScreenState extends State<CoinHistoryScreen> {
  late ScrollController _coinHistoryScrollController = ScrollController()
    ..addListener(hasMoreCoinHistoryScrollListener);

  void getCoinHistory() {
    Future.delayed(Duration.zero, () {
      context
          .read<CoinHistoryCubit>()
          .getCoinHistory(userId: context.read<UserDetailsCubit>().getUserId());
    });
  }

  @override
  void initState() {
    getCoinHistory();
    super.initState();
  }

  @override
  void dispose() {
    _coinHistoryScrollController
        .removeListener(hasMoreCoinHistoryScrollListener);
    _coinHistoryScrollController.dispose();
    super.dispose();
  }

  void hasMoreCoinHistoryScrollListener() {
    if (_coinHistoryScrollController.position.maxScrollExtent ==
        _coinHistoryScrollController.offset) {
      print("At the end of the list");
      if (context.read<CoinHistoryCubit>().hasMoreCoinHistory()) {
        //
        context.read<CoinHistoryCubit>().getMoreCoinHistory(
            userId: context.read<UserDetailsCubit>().getUserId());
      } else {
        print("No more coin history");
      }
    }
  }

  Widget _buildCoinHistoryContainer({
    required CoinHistory coinHistory,
    required int index,
    required int totalCurrentCoinHistory,
    required bool hasMoreCoinHistoryFetchError,
    required bool hasMore,
  }) {
    if (index == totalCurrentCoinHistory - 1) {
      //check if hasMore
      if (hasMore) {
        if (hasMoreCoinHistoryFetchError) {
          return Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
              child: IconButton(
                  onPressed: () {
                    context.read<CoinHistoryCubit>().getMoreCoinHistory(
                        userId: context.read<UserDetailsCubit>().getUserId());
                  },
                  icon: Icon(
                    Icons.error,
                    color: Theme.of(context).primaryColor,
                  )),
            ),
          );
        } else {
          return Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
              child: CircularProgressContainer(
                useWhiteLoader: false,
                heightAndWidth: 40,
              ),
            ),
          );
        }
      }
    }
    return GestureDetector(
      onTap: () {
        print(coinHistory.type);
      },
      child: Container(
        child: Row(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * (0.69),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppLocalization.of(context)!
                            .getTranslatedValues(coinHistory.type) ??
                        coinHistory.type,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Theme.of(context).backgroundColor,
                        fontSize: 16.5),
                  ),
                  SizedBox(
                    height: 2.5,
                  ),
                  Text(
                    coinHistory.date,
                    style: TextStyle(color: Theme.of(context).backgroundColor),
                  ),
                ],
              ),
            ),
            Spacer(),
            LayoutBuilder(builder: (context, boxConstraints) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.center,
                    height: boxConstraints.maxHeight * (0.6),
                    width: MediaQuery.of(context).size.width * (0.125),
                    decoration: BoxDecoration(
                        color: Theme.of(context).backgroundColor,
                        borderRadius: BorderRadius.circular(5)),
                    child: Text(
                      coinHistory.status == "0"
                          ? "+${UiUtils.formatNumber(int.parse(coinHistory.points))}"
                          : UiUtils.formatNumber(int.parse(coinHistory.points)),
                      style: TextStyle(
                          color: coinHistory.status == "1"
                              ? hurryUpTimerColor
                              : addCoinColor,
                          fontSize: 17.0),
                    ),
                  ),
                ],
              );
            })
          ],
        ),
        padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(10.0)),
        height: MediaQuery.of(context).size.height * (0.1),
        margin: EdgeInsets.symmetric(vertical: 10.0),
      ),
    );
  }

  Widget _buildCoinHistory() {
    return BlocConsumer<CoinHistoryCubit, CoinHistoryState>(
      listener: (context, state) {
        if (state is CoinHistoryFetchFailure) {
          if (state.errorMessage == unauthorizedAccessCode) {
            UiUtils.showAlreadyLoggedInDialog(context: context);
          }
        }
      },
      bloc: context.read<CoinHistoryCubit>(),
      builder: (context, state) {
        if (state is CoinHistoryFetchInProgress ||
            state is CoinHistoryInitial) {
          //
          return Center(
            child: CircularProgressContainer(
              useWhiteLoader: false,
            ),
          );
        }
        if (state is CoinHistoryFetchFailure) {
          return Center(
            child: ErrorContainer(
                errorMessageColor: Theme.of(context).primaryColor,
                errorMessage: AppLocalization.of(context)!.getTranslatedValues(
                    convertErrorCodeToLanguageKey(state.errorMessage)),
                onTapRetry: () {
                  getCoinHistory();
                },
                showErrorImage: true),
          );
        }
        return ListView.builder(
            controller: _coinHistoryScrollController,
            padding: EdgeInsets.only(
              bottom: 30.0,
              left: MediaQuery.of(context).size.width * (0.05),
              right: MediaQuery.of(context).size.width * (0.05),
              top: MediaQuery.of(context).size.height *
                      UiUtils.appBarHeightPercentage +
                  15,
            ),
            itemCount: (state as CoinHistoryFetchSuccess).coinHistory.length,
            itemBuilder: (context, index) {
              return _buildCoinHistoryContainer(
                coinHistory: state.coinHistory[index],
                hasMore: state.hasMore,
                hasMoreCoinHistoryFetchError: state.hasMoreFetchError,
                index: index,
                totalCurrentCoinHistory: state.coinHistory.length,
              );
            });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageBackgroundGradientContainer(),
          Align(
            alignment: Alignment.topCenter,
            child: _buildCoinHistory(),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: RoundedAppbar(
                appBarColor: Theme.of(context).backgroundColor,
                appTextAndIconColor: Theme.of(context).primaryColor,
                title: AppLocalization.of(context)!
                    .getTranslatedValues(coinHistoryKey)!),
          )
        ],
      ),
    );
  }
}
