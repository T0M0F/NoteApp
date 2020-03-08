import 'package:boostnote_mobile/business_logic/service/ThemeService.dart';
import 'package:boostnote_mobile/data/entity/BoostnoteEntity.dart';
import 'package:boostnote_mobile/presentation/BoostnoteTheme.dart';
import 'package:boostnote_mobile/presentation/NewNavigationService.dart';
import 'package:boostnote_mobile/presentation/ThemeNotifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Settings extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => SettingsState();

}

class SettingsState extends State<Settings> {

  NewNavigationService _newNavigationService;
  ThemeService _themeService;

  String _selectedThemeName;
  List<String> _themeNames;

  @override
  void initState(){
    super.initState();

    _newNavigationService = NewNavigationService();
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
      title: Text('Settings'),
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Theme.of(context).accentColor), 
        onPressed: () {
          _newNavigationService.navigateBack(context);
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
                  'Theme', 
                  style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold)
                ),
              ),
              DropdownButton<String> (    //TODO FolderEntity
                      value: _selectedThemeName, 
                      underline: Container(), 
                      style: TextStyle(fontSize: 18, color: Colors.black54, fontWeight: FontWeight.bold),
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
        Row(
          children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 20, right: 30),
                child: Text(
                  'Language', 
                  style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold)
                ),
              ),
              Text(
                'Englisch', 
                style: TextStyle(fontSize: 18, color: Colors.black54, fontWeight: FontWeight.bold)
              ),
          ],
        )
      ],
    );
  }

  void _changeTheme(String themeName) {
    final ThemeNotifier themeNotifier = Provider.of<ThemeNotifier>(context);
    _themeService.changeTheme(themeName);
    themeNotifier.setTheme(BoostnoteTheme.getTheme(themeName));
  }

}