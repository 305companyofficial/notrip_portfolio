import 'dart:io';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

Future<int> checkIfLocationPermissionGranted() async{
  Map<Permission, PermissionStatus> statuses = await [Permission.locationAlways,
  ].request();
  int permitstateidx = 0;
  statuses.forEach((permission, permissionStatus) {
    print('$permission permissionStatus는 $permissionStatus');
    if ( permissionStatus.isDenied) permitstateidx =  1;
    if ( permissionStatus.isPermanentlyDenied) permitstateidx = 2;
  });
  print('permission check -> '+ permitstateidx.toString());
  return permitstateidx;
}