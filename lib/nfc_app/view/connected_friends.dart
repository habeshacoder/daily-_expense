import 'package:flutter/material.dart';
import '../../common/app_colors.dart';
import '../../common/app_text_style.dart';
import '../../common/ui_helpers.dart';
import '../model/connected_friends_model.dart';

class ConnectedUsers extends StatelessWidget {
  const ConnectedUsers({
    super.key,
    required this.connectedUsersData, // Mark as required
  });

  final List<TagModel>? connectedUsersData; // Use 'final' for immutability

  void _showDetailOFConnectedUser(
      BuildContext context, TagModel connectedUser) {
    showModalBottomSheet(
      backgroundColor: mediumGrey,
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Personal information of ${connectedUser.title}',
                  style: AppTextStyle.h4Normal,
                ),
                ...List.generate(
                  connectedUser.tagInformation!.length,
                  (index) => ListTile(
                    title: Text(
                      connectedUser.tagInformation![index],
                      style: AppTextStyle.h4Normal,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Handle case where connectedUsersData is null
    if (connectedUsersData == null || connectedUsersData!.isEmpty) {
      return const Center(child: Text('No connected users available.'));
    }

    return Scaffold(
      backgroundColor: darkGreyColor,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: smallSize),
        // decoration: BoxDecoration(gradient: bgdGradiant),
        child: SingleChildScrollView(
          child: Column(
            children: [
              verticalSpaceLarge,
              Row(
                children: [
                  horizontalSpaceSmall,
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: const DefaultTextStyle(
                      style: AppTextStyle.h4Normal,
                      child: IconTheme(
                        data:
                            IconThemeData(color: whiteColor, size: mediumSize),
                        child: Icon(Icons.chevron_left),
                      ),
                    ),
                  ),
                  horizontalSpaceMedium,
                  const Text(
                    'All Friends',
                    style: AppTextStyle.h4Normal,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              ...List.generate(
                connectedUsersData!.length,
                (index) => InkWell(
                  onTap: () => _showDetailOFConnectedUser(
                    context,
                    connectedUsersData![index],
                  ),
                  child: ListTile(
                    title: Text(
                      '${connectedUsersData![index].title}',
                      style: AppTextStyle.h3Normal,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
