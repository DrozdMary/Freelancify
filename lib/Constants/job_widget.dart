import 'package:flutter/material.dart';
import 'package:ijob_clone_app/Constants/colors.dart';
import 'package:ijob_clone_app/Constants/text_styles.dart';

class JobWidget extends StatefulWidget {
  final String jobId;
  final String uploadedBy;
  final String email;
  final String jobTitle;
  final String jobDescription;
  final String jobRequirements;
  final String name;
  final bool recruitment;
  final String userImage;
  final String location;

  const JobWidget({
    required this.jobId,
    required this.uploadedBy,
    required this.email,
    required this.jobTitle,
    required this.jobDescription,
    required this.jobRequirements,
    required this.name,
    required this.recruitment,
    required this.userImage,
    required this.location,
  });

  @override
  State<JobWidget> createState() => _JobWidgetState();
}

class _JobWidgetState extends State<JobWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.purple,
      elevation: 8,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: ListTile(
        onTap: () {},
        onLongPress: () {},
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        leading: Container(
          padding: EdgeInsets.only(right: 12),
          decoration: const BoxDecoration(
            border: Border(
              right: BorderSide(width: 1),
            ),
          ),
          child: Image.network((widget.userImage)),
        ),
        title: Text(
          widget.jobTitle,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyles.editText,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              widget.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyles.editText.copyWith(fontSize: 13),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              widget.jobDescription,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: TextStyles.editText.copyWith(fontSize: 15),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              widget.jobRequirements,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: TextStyles.editText.copyWith(fontSize: 15),
            ),
          ],
        ),
        trailing: Icon(
          Icons.keyboard_arrow_right_rounded,
          size: 30,
          color: MyColors.darkBlue,
        ),
      ),
    );
  }
}
