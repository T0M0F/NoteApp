import 'package:flutter/material.dart';

class DeviceWidthService {

  int breakpoint = 1200;
  BuildContext _context;

  DeviceWidthService(this._context);

  bool isTablet() => MediaQuery.of(this._context).size.width > this.breakpoint;

}