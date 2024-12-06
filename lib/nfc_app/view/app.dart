import 'package:exp_tracker/common/app_text_style.dart';
import 'package:exp_tracker/common/ui_helpers.dart';
import 'package:exp_tracker/nfc_app/repository/repository.dart';
import 'package:exp_tracker/nfc_app/view/common/form_row.dart';
import 'package:exp_tracker/nfc_app/view/connected_friends.dart';
import 'package:exp_tracker/nfc_app/view/ndef_write.dart';
import 'package:exp_tracker/nfc_app/view/tag_read.dart';
import 'package:flutter/material.dart';
import 'package:exp_tracker/common/app_colors.dart';
import 'package:provider/provider.dart';
import '../provider/read_data_provider.dart';

class App extends StatelessWidget {
  const App({super.key});
  static Future<Widget> withDependency() async {
    final repo = await Repository.createInstance();
    return MultiProvider(
      providers: [
        Provider<Repository>.value(
          value: repo,
        ),
      ],
      child: const App(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: primaryColor, // Set the primary color globally
        primarySwatch: Colors.green, // Define a swatch for lighter variants
        scaffoldBackgroundColor: backgroundColor,
        appBarTheme: const AppBarTheme(
          backgroundColor: primaryColor,
          titleTextStyle: TextStyle(color: whiteColor, fontSize: 20),
        ),
        buttonTheme: const ButtonThemeData(
          buttonColor: primaryColor, // Default button color
          textTheme: ButtonTextTheme.primary, // Button text color
        ),
      ),
      home: _Home(),
    );
  }
}

class _Home extends StatefulWidget {
  @override
  State<_Home> createState() => _HomeState();
}

class _HomeState extends State<_Home> {
  void _showUserEmpty(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        action: SnackBarAction(
          label: 'OK',
          onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
        ),
        content: const Text('You have\'t connected to any users yet!'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkGreyColor.withOpacity(.5),
      body: Container(
        // decoration: BoxDecoration(gradient: bgdGradiant),
        padding: const EdgeInsets.symmetric(horizontal: smallSize),
        child: Column(
          children: [
            verticalSpaceLarge,
            Row(
              children: [
                horizontalSpaceSmall,
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: const DefaultTextStyle(
                    style: AppTextStyle.h3Normal,
                    child: IconTheme(
                      data: IconThemeData(color: whiteColor, size: mediumSize),
                      child: Icon(Icons.chevron_left),
                    ),
                  ),
                ),
                horizontalSpaceMedium,
                const Text(
                  'Connect to NFC Cards',
                  style: AppTextStyle.h3Normal,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            verticalSpaceMedium,
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: smallSize),
              child: Text(
                'You can write to your NFC card and share your profile with your friends, family, or colleagues.',
                style: AppTextStyle.h3Normal,
                textAlign: TextAlign.justify,
              ),
            ),
            verticalSpaceMedium,
            FormRow(
              title: const Text('Read NFC Card'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TagReadPage.withDependency(),
                  )),
            ),
            verticalSpaceSmall,
            FormRow(
              title: const Text('Write to NFC Card'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NdefWritePage.withDependency(),
                ),
              ),
            ),
            // verticalSpaceSmall,
            // FormRow(
            //   title: const Text('Connected Friends'),
            //   trailing: const Icon(Icons.chevron_right),
            //   onTap: () {
            //     final sharedTags = ReadDataProvider().userInstance.allSharedTag;
            //     if (sharedTags.isEmpty) {
            //       _showUserEmpty(context);
            //       return;
            //     }
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) => ConnectedUsers(
            //           connectedUsersData: sharedTags,
            //         ),
            //       ),
            //     );
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}
