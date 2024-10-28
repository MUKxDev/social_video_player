import 'package:flutter/material.dart';
import 'package:jaar_player/service/injection.dart';
import 'package:jaar_player/service/navigation_service.dart';

BuildContext get context =>
    getIt<NavigationService>().navigationKey.currentContext!;
