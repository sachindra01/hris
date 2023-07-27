import 'package:url_launcher/url_launcher.dart';

routeUrl(type, url) async {
  final Uri launchUri = Uri(
    scheme: type,
    path: url
  );
  await launchUrl(launchUri);
}