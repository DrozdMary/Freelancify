import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ijob_clone_app/Constants/show_dialog.dart';
import 'package:ijob_clone_app/Jobs/jobs_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../Constants/colors.dart';
import '../Constants/text_styles.dart';

class JobDetailsScreen extends StatefulWidget {
  final String uploadedBy;
  final String jobID;

  JobDetailsScreen({
    required this.uploadedBy,
    required this.jobID,
  });

  @override
  State<JobDetailsScreen> createState() => _JobDetailsScreenState();
}

class _JobDetailsScreenState extends State<JobDetailsScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isCommenting = false;

  final TextEditingController _commentController = TextEditingController();

  String? authorName;
  String? userImageUrl;
  String? jobCategory;
  String? jobDescription;
  String? jobRequirements;
  String? jobTitle;
  bool? recruitment;
  Timestamp? postedDateTimeStamp;
  Timestamp? deadlineDateTimeStamp;
  String? postedDate;
  String? deadlineDate;
  String? locationCompany = '';
  String? emailCompany = '';
  int applicants = 0;
  bool isDeadlineAvailable = false;

  void getJobData() async {
    final DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(widget.uploadedBy).get();

    if (userDoc == null) {
      return;
    } else {
      setState(() {
        authorName = userDoc.get('name');
        userImageUrl = userDoc.get('userImage');
      });
    }
    final DocumentSnapshot jobDatabase = await FirebaseFirestore.instance.collection('Jobs').doc(widget.jobID).get();
    if (jobDatabase == null) {
      return;
    } else {
      setState(() {
        jobTitle = jobDatabase.get('jobTitle');
        jobDescription = jobDatabase.get('jobDescription');
        jobRequirements = jobDatabase.get('jobRequirements');
        recruitment = jobDatabase.get('recruitment');
        emailCompany = jobDatabase.get('email');
        locationCompany = jobDatabase.get('location');
        applicants = jobDatabase.get('applicants');
        postedDateTimeStamp = jobDatabase.get('createdAt');
        deadlineDateTimeStamp = jobDatabase.get('deadlineDateTimeStamp');
        deadlineDate = jobDatabase.get('deadlineDate');
        var postDate = postedDateTimeStamp!.toDate();
        postedDate = '${postDate.day}.${postDate.month}.${postDate.year}';
      });
      var date = deadlineDateTimeStamp!.toDate();
      isDeadlineAvailable = date.isAfter(DateTime.now());
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getJobData();
  }

  Widget dividerWidget() {
    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        Divider(
          thickness: 3,
          color: MyColors.lightGreen,
        ),
        SizedBox(
          height: 10,
        )
      ],
    );
  }

  applyForJob() {
    final Uri params = Uri(
      scheme: 'mailto',
      path: emailCompany,
      query:
          'subject=Отклик на вакансию $jobTitle &body= Здравствуйте, меня заинтересовала Ваша вакансия в приложении Freeldncify. Прошу ознакомиться с моим резюме.',
    );
    final url = params.toString();
    launchUrlString(url);
    addNewApplicant();
  }

  void addNewApplicant() async {
    var docRef = FirebaseFirestore.instance.collection('Jobs').doc(widget.jobID);
    docRef.update({
      'applicants': applicants = 1,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          jobTitle == null ? '' : jobTitle!,
        ),
        centerTitle: true,
        backgroundColor: MyColors.brightGreen,
        leading: IconButton(
          icon: Icon(
            Icons.close_rounded,
            color: MyColors.darkBlue,
          ),
          onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => JobScreen()));
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: 4,
                right: 4,
              ),
              child: Card(
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(4),
                        child: Text(
                          jobTitle == null ? '' : jobTitle!,
                          maxLines: 5,
                          style: TextStyles.boldText22,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 3,
                                color: MyColors.brightGreen,
                              ),
                              shape: BoxShape.rectangle,
                              image: DecorationImage(
                                image: NetworkImage(
                                  userImageUrl == null
                                      ? ' https://png.pngtree.com/png-vector/20190225/ourlarge/pngtree-vector-avatar-icon-png-image_702369.jpg'
                                      : userImageUrl!,
                                ),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  authorName == null ? '' : authorName!,
                                  style: TextStyles.boldText.copyWith(fontSize: 15),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  locationCompany == null ? 'Неизвестно ' : locationCompany!,
                                  style: TextStyles.normText,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      dividerWidget(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.supervisor_account_outlined,
                            color: MyColors.darkBlue,
                            size: 20,
                          ),
                          SizedBox(
                            width: 6,
                          ),
                          Text(
                            'Отклики: ${applicants.toString()}',
                            style: TextStyles.normText,
                          ),
                        ],
                      ),
                      dividerWidget(),
                      Text(
                        'Описание работы',
                        style: TextStyles.boldText,
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        jobDescription == null ? '' : jobDescription!,
                        textAlign: TextAlign.center,
                        style: TextStyles.normText,
                      ),
                      dividerWidget(),
                      Text(
                        'Требования',
                        style: TextStyles.boldText,
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      jobRequirements != null
                          ? RichText(
                              text: TextSpan(
                                style: TextStyles.normText13,
                                children: jobRequirements!.split(';').map((requirement) => TextSpan(text: '   • $requirement\n')).toList(),
                              ),
                            )
                          : Text(
                              'Нет информации о требованиях',
                              style: TextStyles.normText,
                            ),
                    ],
                  ),
                ),
              ),
            ),
            FirebaseAuth.instance.currentUser!.uid != widget.uploadedBy
                ? SizedBox()
                : Padding(
                    padding: EdgeInsets.only(
                      left: 4,
                      right: 4,
                    ),
                    child: Card(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                                child: Text(
                              'Актуальность',
                              style: TextStyles.boldText,
                            )),
                            SizedBox(
                              height: 5,
                            ),
                            Center(
                                child: Text(
                              '''Данный блок виден только вам! \nЕсли данная вакансия уже не актуальна, можете ее архивировать, нажав на кнопку "Архивировать вакансию"\n''',
                              style: TextStyles.normText10,
                              textAlign: TextAlign.center,
                            )),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 115,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: recruitment == true ? MyColors.emeraldGreen : MyColors.white,
                                    border: Border.all(color: MyColors.emeraldGreen, width: 2),
                                  ),
                                  child: TextButton(
                                    onPressed: () {
                                      User? user = _auth.currentUser;
                                      final _uid = user!.uid;
                                      if (_uid == widget.uploadedBy) {
                                        try {
                                          FirebaseFirestore.instance.collection('Jobs').doc(widget.jobID).update({'recruitment': true});
                                        } catch (error) {
                                          GlobalMethod.showErrorDialog(error: 'Дейстиве не может быть выполнено. Попробуйте позже', ctx: context);
                                        }
                                      } else {
                                        GlobalMethod.showErrorDialog(error: "У Вас недостаточно прав для этого действия", ctx: context);
                                      }
                                      getJobData();
                                    },
                                    child: Text(
                                      'Показывать вакансию',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: recruitment == true ? MyColors.white : MyColors.emeraldGreen,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 40,
                                ),
                                Container(
                                  width: 120,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: recruitment == false ? MyColors.emeraldGreen : MyColors.white,
                                      border: Border.all(color: MyColors.emeraldGreen, width: 2)),
                                  child: TextButton(
                                    onPressed: () {
                                      User? user = _auth.currentUser;
                                      final _uid = user!.uid;
                                      if (_uid == widget.uploadedBy) {
                                        try {
                                          FirebaseFirestore.instance.collection('Jobs').doc(widget.jobID).update({'recruitment': false});
                                        } catch (error) {
                                          GlobalMethod.showErrorDialog(error: 'Дейстивие не может быть выполнено. Попробуйте позже', ctx: context);
                                        }
                                      } else {
                                        GlobalMethod.showErrorDialog(error: "У Вас недостаточно прав для этого действия ", ctx: context);
                                      }
                                      getJobData();
                                    },
                                    child: Text(
                                      'Архивировать вакансию',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: recruitment == false ? MyColors.white : MyColors.emeraldGreen,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
            Padding(
              padding: EdgeInsets.only(
                left: 4,
                right: 4,
              ),
              child: Card(
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      isDeadlineAvailable
                          ? Center(
                              child: Column(
                                children: [
                                  Text(
                                    ' Вакансия еще актуальна',
                                    style: TextStyles.boldGreenText18,
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Text(
                                    ' Если данная вакансия Вас заинтересовла, отправьте работадатю Ваше резюме',
                                    style: TextStyles.normText13,
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            )
                          : Center(
                              child: Text(
                                'Срок актуальности вакансии истек',
                                style: TextStyles.boldRedText18,
                                textAlign: TextAlign.center,
                              ),
                            ),
                      SizedBox(
                        height: 6,
                      ),
                      Center(
                        child: MaterialButton(
                          minWidth: 160,
                          onPressed: () {
                            applyForJob();
                          },
                          color: MyColors.emeraldGreen,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Text(
                                  'Откликнуться',
                                  style: TextStyles.normalWhiteText,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      dividerWidget(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Загружена:',
                            style: TextStyles.normText,
                          ),
                          Text(
                            postedDate == null ? "" : postedDate!,
                            style: TextStyles.normText,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Срок актуальности вакансии: ',
                            style: TextStyles.normText,
                          ),
                          Text(
                            deadlineDate == null ? " " : deadlineDate!,
                            style: TextStyles.normText,
                          ),
                        ],
                      ),
                      dividerWidget(),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: 4,
                right: 4,
              ),
              child: Card(
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AnimatedSwitcher(
                        duration: Duration(milliseconds: 500),
                        child: _isCommenting
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Flexible(
                                    flex: 3,
                                    child: TextField(
                                      controller: _commentController,
                                      style: TextStyles.normText,
                                      maxLength: 300,
                                      keyboardType: TextInputType.text,
                                      maxLines: 7,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(16.0),
                                        ),
                                        filled: true,
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: MyColors.lightGreen, width: 0),
                                          borderRadius: BorderRadius.circular(16.0),
                                        ),
                                        fillColor: MyColors.lightGreen,
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: MyColors.emeraldGreen, width: 2),
                                          borderRadius: BorderRadius.circular(16.0),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: MyColors.red, width: 2),
                                          borderRadius: BorderRadius.circular(16.0),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 8),
                                          child: MaterialButton(
                                            minWidth: 160,
                                            onPressed: () {},
                                            color: MyColors.emeraldGreen,
                                            elevation: 0,
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Column(
                                                children: [
                                                  Text(
                                                    'Отправить',
                                                    style: TextStyles.normalWhiteText,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        MaterialButton(
                                          minWidth: 160,
                                          onPressed: () {},
                                          color: MyColors.emeraldGreen,
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              children: [
                                                Text(
                                                  'Удалить',
                                                  style: TextStyles.normalWhiteText,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    onPressed: () {},
                                    icon: Icon(Icons.add_comment, color: MyColors.emeraldGreen, size: 40),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  IconButton(
                                    onPressed: () {},
                                    icon: Icon(Icons.arrow_drop_down_circle, color: MyColors.emeraldGreen, size: 40),
                                  ),
                                ],
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
