import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:kanji_for_n5_level_app/providers/account_details_state_provider.dart';
import 'package:kanji_for_n5_level_app/screens/main_screens/main_content.dart';

class PersonalInfo extends ConsumerWidget {
  PersonalInfo({super.key});

  final ImagePicker picker = ImagePicker();
  final String pathAssetUser = 'assets/images/user.png';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountDetailsData = ref.watch(personalInfoProvider);

    String formattedDate =
        DateFormat('yyyy-MM-dd').format(accountDetailsData.birthdayDate);

    logger.d(accountDetailsData.birthdayDate);

    final birthDayDate = 'Birthday date: $formattedDate';
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            InkWell(
              onTap: () async {
                try {
                  final XFile? photo =
                      await picker.pickImage(source: ImageSource.camera);
                  /*                       setState(() {
                            if (photo != null) {
                              pathProfileUser = photo.path;
                            }
                          }); */
                } on PlatformException catch (e) {
                  logger.e('Failed to pick image: $e');
                }
              },
              child: CircleAvatar(
                radius: 80,
                backgroundImage: accountDetailsData.pathProfileUser.isEmpty
                    ? AssetImage(pathAssetUser)
                    : FileImage(File(accountDetailsData.pathProfileUser))
                        as ImageProvider,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Form(
                  child: TextFormField(
                decoration: const InputDecoration(
                  label: Text('Full name'),
                  suffixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
              )),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(birthDayDate),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor:
                            Theme.of(context).colorScheme.onPrimary,
                      ),
                      onPressed: () async {
                        logger.d('called');
                        DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1950),
                            //DateTime.now() - not to allow to choose before today.
                            lastDate: DateTime(2100));

                        logger.d('calles');

                        if (pickedDate != null) {
                          ref
                              .read(personalInfoProvider.notifier)
                              .setBirthdayDate(pickedDate);
                          logger.d(pickedDate.year);
                          //pickedDate output format => 2021-03-10 00:00:00.000
                        } else {
                          logger.d('is null');
                        }
                      },
                      child: const Text('Pick date'))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
