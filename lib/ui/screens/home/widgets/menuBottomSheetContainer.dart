import 'dart:io';

import 'package:flutter/material.dart' hide ModalBottomSheetRoute;

import 'package:nunyaexam/app/routes.dart';
import 'package:nunyaexam/features/systemConfig/cubits/systemConfigCubit.dart';
import 'package:nunyaexam/ui/screens/home/widgets/languageBottomSheetContainer.dart';
import 'package:nunyaexam/ui/screens/profile/widgets/themeDialog.dart';
import 'package:nunyaexam/ui/widgets/menuTile.dart';
import 'package:nunyaexam/utils/constants.dart';
import 'package:nunyaexam/utils/stringLabels.dart';
import 'package:nunyaexam/utils/uiUtils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:launch_review/launch_review.dart';
import 'package:share_plus/share_plus.dart';

class MenuBottomSheetContainer extends StatelessWidget {
  const MenuBottomSheetContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
          gradient: UiUtils.buildLinerGradient([
            Theme.of(context).scaffoldBackgroundColor,
            Theme.of(context).canvasColor
          ], Alignment.topCenter, Alignment.bottomCenter)),
      child: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            //
            SizedBox(
              height: MediaQuery.of(context).size.height * (0.025),
            ),

            // WALLET MENU ITEM
            // context.read<SystemConfigCubit>().isPaymentRequestEnable()
            //     ? MenuTile(
            //         isSvgIcon: true,
            //         onTap: () {
            //           Navigator.of(context).pop();
            //           Navigator.of(context).pushNamed(Routes.wallet);
            //         },
            //         title: walletKey,
            //         leadingIcon: "wallet.svg",
            //       )
            //     : SizedBox(),

            // MenuTile(
            //   isSvgIcon: true,
            //   onTap: () {
            //     Navigator.of(context).pop();
            //     Navigator.of(context).pushNamed(Routes.coinHistory);
            //   },
            //   title: coinHistoryKey,
            //   leadingIcon: "coinhistory.svg",
            // ),

            // context.read<SystemConfigCubit>().isInAppPurchaseEnable()
            //     ? MenuTile(
            //         isSvgIcon: true,
            //         onTap: () {
            //           Navigator.of(context).pop();
            //           Navigator.of(context).pushNamed(Routes.coinStore);
            //         },
            //         title: coinStoreKey,
            //         leadingIcon: "coin_store.svg",
            //       )
            //     : SizedBox(),

            MenuTile(
              isSvgIcon: true,
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed(Routes.badges);
              },
              title: badgesKey,
              leadingIcon: "badges.svg",
            ),

            // MenuTile(
            //   isSvgIcon: true,
            //   onTap: () {
            //     Navigator.of(context).pop();
            //     Navigator.of(context).pushNamed(Routes.rewards);
            //   },
            //   title: rewardsLbl,
            //   leadingIcon: "rewards.svg",
            // ),

            context.read<SystemConfigCubit>().getLanguageMode() == "1"
                ? MenuTile(
                    isSvgIcon: true,
                    onTap: () {
                      Navigator.of(context).pop();
                      showDialog(
                          context: context,
                          builder: (_) => LanguageDailogContainer());
                    },
                    title: languageKey,
                    leadingIcon: "language_icon.svg",
                  )
                : SizedBox(),

            MenuTile(
              isSvgIcon: true,
              onTap: () {
                Navigator.of(context).pop();
                showDialog(context: context, builder: (_) => ThemeDialog());
              },
              title: themeKey,
              leadingIcon: "theme.svg", //theme icon
            ),

            MenuTile(
              isSvgIcon: true,
              onTap: () {
                Navigator.of(context).pop();

                Navigator.of(context).pushNamed(Routes.statistics);
                //
              },
              title: statisticsLabelKey,
              leadingIcon: "statistics.svg", //theme icon
            ),

            MenuTile(
              isSvgIcon: true,
              onTap: () {
                Navigator.of(context).pop();

                Navigator.of(context).pushNamed(Routes.notification);
                //
              },
              title: "notificationLbl",
              leadingIcon: "notification.svg", //theme icon
            ),

            MenuTile(
              isSvgIcon: true,
              onTap: () {
                Navigator.of(context).pop();

                Navigator.of(context).pushNamed(Routes.profile);
              },
              title: accountKey,
              leadingIcon: "account.svg", //theme icon
            ),

            MenuTile(
              isSvgIcon: true,
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context)
                    .pushNamed(Routes.appSettings, arguments: howToPlayLbl);
              },
              title: howToPlayLbl,
              leadingIcon: "howtoplay_icon.svg", //theme icon
            ),

            MenuTile(
              isSvgIcon: true,
              onTap: () {
                Navigator.of(context).pop();

                Navigator.of(context).pushNamed(Routes.aboutApp);
              },
              title: aboutQuizAppKey,
              leadingIcon: "about_us.svg", //theme icon
            ),

            MenuTile(
              isSvgIcon: true,
              onTap: () {
                Navigator.of(context).pop();
                LaunchReview.launch(
                  androidAppId: packageName,
                  iOSAppId: "585027354",
                );
              },
              title: "rateUsLbl",
              leadingIcon: "rateus_icon.svg", //theme icon
            ),

            MenuTile(
              isSvgIcon: true,
              onTap: () {
                Navigator.of(context).pop();
                try {
                  if (Platform.isAndroid) {
                    Share.share(context.read<SystemConfigCubit>().getAppUrl() +
                        "\n" +
                        context
                            .read<SystemConfigCubit>()
                            .getSystemDetails()
                            .shareappText);
                  } else {
                    Share.share(context.read<SystemConfigCubit>().getAppUrl() +
                        "\n" +
                        context
                            .read<SystemConfigCubit>()
                            .getSystemDetails()
                            .shareappText);
                  }
                } catch (e) {
                  UiUtils.setSnackbar(e.toString(), context, false);
                }
              },
              title: "shareAppLbl",
              leadingIcon: "share_app.svg", //theme icon
            ),

            SizedBox(
              height: MediaQuery.of(context).size.height * (0.025),
            ),
          ],
        ),
      ),
    );
  }
}
