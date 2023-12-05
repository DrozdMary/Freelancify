import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ijob_clone_app/Widgets/botton_nav_bar.dart';
import 'package:ijob_clone_app/Constants/colors.dart';
import 'package:ijob_clone_app/Widgets/job_widget.dart';

import '../Widgets/costom_alert_dialog_categories.dart';
import '../Constants/text_styles.dart';
import '../Constants/persistent.dart';
import '../Search/search_job_screen.dart';

class JobScreen extends StatefulWidget {
  const JobScreen({super.key});

  @override
  State<JobScreen> createState() => _JobScreenState();
}

class _JobScreenState extends State<JobScreen> {
  String? jobCategoryFilter;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  _showCategoriesDialog({required Size size}) {
    DialogCotegories.showAlert(
        context: context,
        onTap: (index) {
          setState(() {
            jobCategoryFilter = Persistent.jobCategoryList[index];
          });
          Navigator.pop(context);
          print('jobCategoryList[index], ${Persistent.jobCategoryList[index]}');
        },
        onPressed: () {
          setState(() {
            jobCategoryFilter = null;
          });

          Navigator.canPop(context) ? Navigator.pop(context) : null;
        });
  }

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    Persistent persistentObject= Persistent();
    persistentObject.getMyData();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      bottomNavigationBar: BottomNavigator(
        selectedIndex: 0,
      ),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: MyColors.brightGreen,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(
            Icons.filter_list_rounded,
            color: MyColors.white,
          ),
          onPressed: () {
            _showCategoriesDialog(size: size);
          },
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  PageRouteBuilder(
                  pageBuilder: (_, __, ___) => SearchJobScreen(),
              transitionDuration: Duration(milliseconds: 20),
              transitionsBuilder: (_, a, __, c) => FadeTransition(opacity: a, child: c),
              ));

            },
            icon: Icon(Icons.search_outlined),
            color: MyColors.white,
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('Jobs')
            .where('jobCategory', isEqualTo: jobCategoryFilter)
            .where('recruitment', isEqualTo: true)
            .orderBy('createdAt', descending: false)
            .snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: MyColors.white,

              ),
            );
          } else if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.data?.docs.isEmpty == false)
            {
              return Padding(
                padding: const EdgeInsets.only(top: 5),
                child: ListView.builder(
                  itemCount: snapshot.data?.docs.length,
                  itemBuilder: (BuildContext context, int index) {

                    return JobWidget(
                      jobId: snapshot.data?.docs[index]['jobId'],
                      uploadedBy: snapshot.data?.docs[index]['uploadedBy'],
                      email: snapshot.data?.docs[index]['email'],
                      jobTitle: snapshot.data?.docs[index]['jobTitle'],
                      jobDescription: snapshot.data?.docs[index]['jobDescription'],
                      jobRequirements: snapshot.data?.docs[index]['jobRequirements'],
                      name: snapshot.data?.docs[index]['name'],
                      recruitment: snapshot.data?.docs[index]['recruitment'],
                      userImage: snapshot.data?.docs[index]['userImage'],
                      location: snapshot.data?.docs[index]['location'],
                    );
                  },
                ),
              );
            }
            else {

              return Center(
                child: Text(
                  'Пока нет вакансий',
                  style: TextStyles.normalGreenText,
                ),
              );
            }
          }
          return Center(
            child: Text(
              'Что-то пошло не так',
              style: TextStyles.boldText,
            ),
          );
        },
      ),
    );
  }
}
