import 'package:flutter/material.dart';

class DeviceChecker {

  int breakpoint = 1200;
  BuildContext _context;

  DeviceChecker(this._context);

  bool isTablet() => MediaQuery.of(this._context).size.width > this.breakpoint;

}