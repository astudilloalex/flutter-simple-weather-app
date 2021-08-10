import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:simple_weather/common/routes.dart';

class SettingsPopupMenu extends StatelessWidget {
  const SettingsPopupMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      onSelected: (value) {
        if (value == 0) {
          Navigator.of(context).pushNamed(Routes.settings);
        }
      },
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            value: 0,
            child: Text(AppLocalizations.of(context)!.settings),
          ),
        ];
      },
    );
  }
}
