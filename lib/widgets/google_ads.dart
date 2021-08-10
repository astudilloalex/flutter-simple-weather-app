import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:simple_weather/common/constants.dart';

class CustomBannerAd extends StatefulWidget {
  final AdSize? size;

  const CustomBannerAd({
    Key? key,
    this.size,
  }) : super(key: key);

  @override
  _CustomBannerAdState createState() => _CustomBannerAdState();
}

class _CustomBannerAdState extends State<CustomBannerAd> {
  BannerAd? _bannerAd;
  bool _loadingBanner = false;

  @override
  void dispose() {
    super.dispose();
    _bannerAd?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        if (!_loadingBanner) {
          _loadingBanner = true;
          _load(context);
        }
        return SizedBox(
          width: _bannerAd!.size.width.toDouble(),
          height: _bannerAd!.size.height.toDouble(),
          child: AdWidget(ad: _bannerAd!),
        );
      },
    );
  }

  // Initialize banner ad.
  Future<void> _load(BuildContext context) async {
    final AnchoredAdaptiveBannerAdSize? size = widget.size == null
        ? await AdSize.getAnchoredAdaptiveBannerAdSize(
            Orientation.portrait,
            MediaQuery.of(context).size.width.truncate(),
          )
        : null;
    if (widget.size == null && size == null) return;
    final BannerAd bannerAd = BannerAd(
      size: widget.size ?? size!,
      adUnitId: Ads.bannerAd,
      listener: BannerAdListener(
        onAdClosed: (ad) {},
        onAdFailedToLoad: (ad, error) async {
          await ad.dispose();
        },
        onAdLoaded: (ad) {
          setState(() {
            _bannerAd = ad as BannerAd?;
          });
        },
        onAdOpened: (ad) {},
      ),
      request: const AdRequest(),
    );
    return bannerAd.load();
  }
}
