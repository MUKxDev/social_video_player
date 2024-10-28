import 'package:jaar_player/app/app.dart';
import 'package:jaar_player/bootstrap.dart';
import 'package:jaar_player/service/injection.dart';

void main() {
  configureInjection();
  bootstrap(() => const App());
}
