import 'dart:io';

import 'package:doclense/screens/about.dart';
import 'package:doclense/constants/route_constants.dart';
import 'package:doclense/screens/home.dart';
import 'package:doclense/ui_components/image_view.dart';
import 'package:doclense/ui_components/multi_select_delete.dart';
import 'package:doclense/ui_components/pdf_conversion.dart';
import 'package:doclense/screens/pdf_preview_screen.dart';
import 'package:doclense/providers/image_list.dart';
import 'package:doclense/screens/settings/contact_developers.dart';
import 'package:doclense/screens/settings/settings.dart';
import 'package:doclense/screens/starred_documents.dart';
import 'package:flutter/material.dart';
// import 'package:folder_picker/folder_picker.dart';
import 'package:image_editor_plus/image_editor_plus.dart';

Route generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case RouteConstants.homeScreen:
      return pageBuilder(screen: Home());
    case RouteConstants.settingsScreen:
      return pageBuilder(screen: SettingsScreen());
    case RouteConstants.starredDocumentsScreen:
      return pageBuilder(screen: Starred());
    case RouteConstants.aboutAppScreen:
      return pageBuilder(screen: About());
    case RouteConstants.multiDelete:
      final args = settings.arguments as ImageList;
      return pageBuilder(screen: MultiDelete(args));

    case RouteConstants.imageView:
      final args = settings.arguments as Map;
      return pageBuilder(
        screen: Imageview(
          args['imageFile'] as File,
          args['imageList'] as ImageList,
        ),
      );
    case RouteConstants.contactDeveloperScreen:
      return pageBuilder(screen: ContactDeveloperScreen());
    case RouteConstants.photoFilterSelector:
      final args = settings.arguments as Map<String, Object>;
      return pageBuilder(
        screen: Builder(
          builder: (context) {
            final imageFile = File(args['fileName'] as String);
            return ImageEditor(
              image: imageFile.readAsBytesSync(),
              savePath: imageFile.path,
            );
          },
        ),
      );
    case RouteConstants.pdfConversionScreen:
      final args = settings.arguments as ImageList;
      return pageBuilder(screen: PDFConversion(args));
    case RouteConstants.pdfPreviewScreen:
      final args = settings.arguments as Map<String, Object>;
      return pageBuilder(
        screen: PdfPreviewScreen(
          path: args['path'] as String,
          name: args['name'] as String,
        ),
      );
    // case RouteConstants.folderPickerPage:
    //   final args = settings.arguments as Map;
    //   return pageBuilder(
    //     screen: FolderPickerPage(
    //       action:
    //           args['action'] as Future<void> Function(BuildContext, Directory),
    //       rootDirectory: args['rootDirectory'] as Directory,
    //     ),
    //   );
    default:
      return pageBuilder(
        screen: const Text(
          'Unknown Screen. Please restart the app.',
          textAlign: TextAlign.center,
        ),
      );
  }
}

PageRouteBuilder pageBuilder({required Widget screen}) {
  return PageRouteBuilder(
    pageBuilder: (c, a1, a2) => screen,
    transitionsBuilder:
        (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
  );
}
