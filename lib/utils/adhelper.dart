import 'dart:developer';
import 'dart:io';
import 'package:dtpocketfm/provider/sidedrawerprovider.dart';
import 'package:dtpocketfm/utils/color.dart';
import 'package:dtpocketfm/utils/sharedpre.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

class AdHelper {
  static int interstialcnt = 0;
  static int rewardcnt = 0;

  int maxFailedLoadAttempts = 3;
  static SharedPre sharePref = SharedPre();

  static String? banneradid;
  static String? banneradidios;
  static String? interstitaladid;
  static String? interstitaladidios;
  static String? rewardadid;
  static String? rewardadidios;

  static InterstitialAd? _interstitialAd;
  static int _numInterstitialLoadAttempts = 0;
  static int? maxInterstitialAdclick;

  static int _numRewardAttempts = 0;
  static int maxRewardAdclick = 0;

  static var bannerad = "";
  static var banneradIos = "";
  static var interstitalad = "";
  static var interstitalIos = "";
  static var rewardad = "";
  static var rewardadIos = "";

  static RewardedAd? _rewardedAd;

  static AdRequest request = const AdRequest(
    keywords: <String>['flutterio', 'beautiful apps'],
    contentUrl: 'https://flutter.io',
    nonPersonalizedAds: true,
  );

  static initialize() {
    MobileAds.instance.initialize();
  }

  static getAds(BuildContext context) async {
    final profileprovider =
        Provider.of<SidedrawerProvider>(context, listen: false);
    String? userid = await sharePref.read("userid");
    if (userid != null) {
      await profileprovider.getProfile(userid);
    }
    bannerad = await sharePref.read("banner_ad") ?? "";
    banneradIos = await sharePref.read("ios_banner_ad") ?? "";
    banneradid = await sharePref.read("banner_adid") ?? "";
    banneradidios = await sharePref.read("ios_banner_adid") ?? "";

    interstitalad = await sharePref.read("interstital_ad") ?? "";
    interstitalIos = await sharePref.read("ios_interstital_ad") ?? "";
    interstitaladid = await sharePref.read("interstital_adid") ?? "";
    interstitaladidios = await sharePref.read("interstital_adid") ?? "";

    rewardad = await sharePref.read("reward_ad") ?? "";
    rewardadIos = await sharePref.read("ios_reward_ad") ?? "";
    rewardadid = await sharePref.read("reward_adid") ?? "";
    rewardadidios = await sharePref.read("ios_reward_adid") ?? "";

    maxInterstitialAdclick =
        int.parse(await sharePref.read("interstital_adclick") ?? "0");
    maxRewardAdclick = int.parse(await sharePref.read("reward_adclick") ?? "0");

    log("maxInterstitialAdclick $maxInterstitialAdclick");
    log("Banner ads $banneradid");
  }

// Show Banner Ad Method Set in Any Page Build Method
  Widget bannerAd() {
    return Consumer<SidedrawerProvider>(
      builder: (context, profileprovider, child) {
        if (profileprovider.profileModel.status == 200 &&
            profileprovider.profileModel.result != null) {
          if ((profileprovider.profileModel.result?[0].isBuy.toString() ??
                  "") ==
              "0") {
            if ((bannerad == "1" && Platform.isAndroid) ||
                (banneradIos == "1" && Platform.isIOS)) {
              return Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 60,
                  color: transperent,
                  child:
                      AdWidget(ad: createBannerAd()..load(), key: UniqueKey()),
                ),
              );
            } else {
              return const SizedBox.shrink();
            }
          } else {
            return const SizedBox.shrink();
          }
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

// Banner Ad Show in Home Page
  static BannerAd createBannerAd() {
    BannerAd ad = BannerAd(
        size: AdSize.fullBanner,
        adUnitId: bannerAdUnitId,
        request: const AdRequest(),
        listener: BannerAdListener(
            onAdLoaded: (Ad ad) => debugPrint('Ad Loaded'),
            onAdClosed: (Ad ad) => debugPrint('Ad Closed'),
            onAdFailedToLoad: (Ad ad, LoadAdError error) {
              ad.dispose();
            },
            onAdOpened: (Ad ad) => debugPrint('Ad Open')));
    return ad;
  }

  static void createInterstitialAd() {
    InterstitialAd.load(
        adUnitId: interstitialAdUnitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            log('====> ads $ad');
            _interstitialAd = ad;
            _numInterstitialLoadAttempts = 0;
            ad.setImmersiveMode(true);
          },
          onAdFailedToLoad: (LoadAdError error) {
            log('InterstitialAd failed to load: $error');
          },
        ));
  }

// Click Button And Ad Show
  static interstitialAd(BuildContext context, VoidCallback callAction) {
    final profileprovider =
        // ignore: use_build_context_synchronously
        Provider.of<SidedrawerProvider>(context, listen: false);
    if ((profileprovider.profileModel.result?[0].isBuy.toString() ?? "") ==
        "0") {
      if ((interstitalad == "1" && Platform.isAndroid) ||
          (interstitalIos == "1" && Platform.isIOS)) {
        log("add");
        showInterstitialAd(() {
          callAction();
        });
      } else {
        log("action Device");
        callAction();
      }
    } else {
      log("action");
      callAction();
    }
  }

  static showInterstitialAd(VoidCallback callAction) {
    log('===>$_numInterstitialLoadAttempts');
    log('===>$maxInterstitialAdclick');
    if (_numInterstitialLoadAttempts == maxInterstitialAdclick) {
      _numInterstitialLoadAttempts = 0;
      if (_interstitialAd == null) {
        log('Warning: attempt to show interstitial before loaded.');

        return false;
      }
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (InterstitialAd ad) =>
            log('ad onAdShowedFullScreenContent.'),
        onAdDismissedFullScreenContent: (InterstitialAd ad) {
          log('$ad onAdDismissedFullScreenContent.');
          ad.dispose();
          createInterstitialAd();
        },
        onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
          log('$ad onAdFailedToShowFullScreenContent: $error');
          ad.dispose();

          createInterstitialAd();
        },
      );
      _interstitialAd!.show();
      _interstitialAd = null;
      return;
    }
    _numInterstitialLoadAttempts += 1;
    callAction();
  }

  static createRewardedAd() {
    RewardedAd.load(
        adUnitId: rewardedAdUnitId,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (RewardedAd ad) {
            debugPrint('$ad loaded.');
            _rewardedAd = ad;
            _numRewardAttempts = 0;
          },
          onAdFailedToLoad: (LoadAdError error) {
            debugPrint('RewardedAd failed to load: $error');
            _rewardedAd = null;
            _numRewardAttempts += 1;
            if (_numRewardAttempts <= maxRewardAdclick) {
              createRewardedAd();
            }
          },
        ));
  }

  static rewardedAd(BuildContext context, VoidCallback callAction) {
    final profileprovider =
        // ignore: use_build_context_synchronously
        Provider.of<SidedrawerProvider>(context, listen: false);
    if ((profileprovider.profileModel.result?[0].isBuy.toString() ?? "") ==
        "0") {
      if ((rewardad == "1" && Platform.isAndroid) ||
          (rewardadIos == "1" && Platform.isIOS)) {
        log("add");
        showRewardedAd(() {
          callAction();
        });
      } else {
        log("action Device");
        callAction();
      }
    } else {
      log("action");
      callAction();
    }
  }

  static showRewardedAd(VoidCallback callAction) {
    log('===>$_numRewardAttempts');
    log('===>$maxRewardAdclick');
    if (_numRewardAttempts == maxRewardAdclick) {
      if (_rewardedAd == null) {
        debugPrint('Warning: attempt to show rewarded before loaded.');
        return;
      }
      _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (RewardedAd ad) =>
            debugPrint('ad onAdShowedFullScreenContent.'),
        onAdDismissedFullScreenContent: (RewardedAd ad) {
          debugPrint('$ad onAdDismissedFullScreenContent.');
          ad.dispose();
          createRewardedAd();
        },
        onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
          debugPrint('$ad onAdFailedToShowFullScreenContent: $error');
          ad.dispose();
          createRewardedAd();
        },
      );

      _rewardedAd!.setImmersiveMode(true);
      _rewardedAd!.show(
          onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
        debugPrint(
            '$ad with reward $RewardItem(${reward.amount}, ${reward.type}');
      });
      _rewardedAd = null;
    }
    _numRewardAttempts += 1;
    callAction();
  }

  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return banneradid.toString();
    } else if (Platform.isIOS) {
      return banneradidios.toString();
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return interstitaladid.toString();
    } else if (Platform.isIOS) {
      return interstitaladidios.toString();
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      return rewardadid.toString();
    } else if (Platform.isIOS) {
      return rewardadidios.toString();
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }
}
