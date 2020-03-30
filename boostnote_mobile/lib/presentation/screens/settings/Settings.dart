import 'package:boostnote_mobile/presentation/localization/app_localizations.dart';
import 'package:boostnote_mobile/presentation/navigation/NavigationService.dart';
import 'package:boostnote_mobile/presentation/theme/BoostnoteTheme.dart';
import 'package:boostnote_mobile/presentation/theme/ThemeNotifier.dart';
import 'package:boostnote_mobile/presentation/theme/ThemeService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Settings extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => SettingsState();

}

class SettingsState extends State<Settings> {

  NavigationService _newNavigationService;
  ThemeService _themeService;

  String _selectedThemeName;
  List<String> _themeNames;

  @override
  void initState(){
    super.initState();

    _newNavigationService = NavigationService();
    _themeService = ThemeService();

    _themeNames = BoostnoteTheme.themeNames;
    _themeService.getThemeName().then((themeName){
      setState(() {
        _selectedThemeName = themeName == null ? BoostnoteTheme.defaultThemeName : themeName;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      title: Text(AppLocalizations.of(context).translate('settings'), style: TextStyle(color: Theme.of(context).accentTextTheme.display1.color),),
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Theme.of(context).accentColor), 
        onPressed: () {
          Navigator.of(context).pop();
        }
      )
    );
  }

  Widget _buildBody() {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 20, right: 30),
                child: Text(
                  AppLocalizations.of(context).translate('theme'), 
                  style: TextStyle(fontSize: 18, color: Theme.of(context).textTheme.display1.color, fontWeight: FontWeight.bold)
                ),
              ),
              DropdownButton<String> (    
                value: _selectedThemeName, 
                underline: Container(), 
                style: TextStyle(fontSize: 18, color: Theme.of(context).textTheme.display1.color, fontWeight: FontWeight.bold),
                items: _themeNames.map<DropdownMenuItem<String>>((themeName) => DropdownMenuItem<String>(
                  value: themeName,
                  child: Text(themeName)
                )).toList(),
                onChanged: (themeName) {
                    setState(() {
                      _selectedThemeName = themeName;
                    });
                    _changeTheme(themeName);
                  }
              ),
          ],
        ),
      ],
    );
  }

  void _changeTheme(String themeName) {
    final ThemeNotifier themeNotifier = Provider.of<ThemeNotifier>(context);
    _themeService.changeTheme(themeName);
    themeNotifier.setTheme(BoostnoteTheme.getTheme(themeName));
  }

}