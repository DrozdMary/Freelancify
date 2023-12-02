import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ijob_clone_app/Constants/colors.dart';
import 'package:ijob_clone_app/Constants/show_dialog.dart';
import 'package:ijob_clone_app/Constants/text_styles.dart';

import '../Jobs/job_details_screen.dart';

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
  final FirebaseAuth _auth = FirebaseAuth.instance;

  _deleteDialog() {
    User? user = _auth.currentUser;
    final _uid = user!.uid;
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            actions: [
              TextButton(
                  onPressed: () async {
                    try {
                      if (widget.uploadedBy == _uid) {
                        await FirebaseFirestore.instance.collection('Jobs').doc(widget.jobId).delete();
                        await Fluttertoast.showToast(
                          msg: 'Вакансия была удалена',
                          toastLength: Toast.LENGTH_LONG,
                          backgroundColor: Colors.black,
                          fontSize: 18,
                        );
                        Navigator.canPop(context) ? Navigator.pop(context) : null;
                      } else {
                        GlobalMethod.showErrorDialog(error: 'У Вас нет прав для этого действия', ctx: ctx);
                      }
                    } catch (error) {
                      GlobalMethod.showErrorDialog(error: 'Невозможно удалить', ctx: ctx);
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.delete_outline,
                        color: Colors.red,
                      ),
                      Text(
                        'Удалить',
                        style: TextStyle(color: Colors.red),
                      )
                    ],
                  )),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 8,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: ListTile(
        onTap: () {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => JobDetailsScreen(
                        uploadedBy: widget.uploadedBy,
                        jobID: widget.jobId,
                      )));
        },
        onLongPress: () {
          _deleteDialog();
        },
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        leading: Container(
          padding: EdgeInsets.only(right: 12),
          decoration: const BoxDecoration(
            border: Border(
              right: BorderSide(width: 2, color: Color(0xFFC6E9E5)),

            ),
          ),
          child: Image.network((widget.userImage)),
        ),
        title: Text(
          widget.jobTitle,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyles.boldText,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              widget.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyles.normalGreenText14,
            ),
            const SizedBox(
              height: 4,
            ),
            Text(
              widget.jobDescription,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyles.normText13,
            ),
            const SizedBox(
              height: 8,
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
