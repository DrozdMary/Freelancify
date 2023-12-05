import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ijob_clone_app/Constants/job_widget.dart';
import 'package:ijob_clone_app/Constants/text_styles.dart';

import '../Constants/colors.dart';
import '../Jobs/jobs_screen.dart';

class SearchJobScreen extends StatefulWidget {
  const SearchJobScreen({super.key});

  @override
  State<SearchJobScreen> createState() => _SearchJobScreen();
}

class _SearchJobScreen extends State<SearchJobScreen> {
  TextEditingController _searchQueryController = TextEditingController();
  String searchQuery = 'Search query';

  Widget _buildSearchField() {
    return TextField(
      controller: _searchQueryController,
      autocorrect: true,
      decoration: InputDecoration(hintText: 'Поиск по вакансиям...', border: InputBorder.none, hintStyle: TextStyles.normalWhiteText15),
      style: TextStyles.normalWhiteText,
      onChanged: (query) => updateSearchQuery(query),
    );
  }

  List<Widget> _buildActions() {
    return <Widget>[
      IconButton(
          onPressed: () {
            _clearSearchQuery();
          },
          icon: Icon(
            Icons.clear,
            color: Colors.white,
          ))
    ];
  }

  void _clearSearchQuery() {
    setState(() {
      _searchQueryController.clear();
      updateSearchQuery('');
    });
  }

  void updateSearchQuery(String newQuery) {
    setState(() {
      searchQuery = newQuery;
      print(searchQuery);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: MyColors.brightGreen,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_outlined,
            color: MyColors.white,
          ),
          onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => JobScreen()));
          },
        ),
        title: _buildSearchField(),
        actions: _buildActions(),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection("Jobs").where('jobTitle', isGreaterThanOrEqualTo: searchQuery).where(
            'recruitment', isEqualTo: true).snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: Colors.white,),);
          }
          else if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.data?.docs.isNotEmpty == true) {
              return ListView.builder(
                  itemCount: snapshot.data?.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    return JobWidget(
                        uploadedBy: snapshot.data?.docs[index]['uploadedBy'],
                        email: snapshot.data?.docs[index]['email'],
                        jobTitle: snapshot.data?.docs[index]['jobTitle'],
                        jobDescription: snapshot.data?.docs[index]['jobDescription'],
                        jobId: snapshot.data?.docs[index]['jobId'],
                        jobRequirements: snapshot.data?.docs[index]['jobRequirements'],
                        name: snapshot.data?.docs[index]['name'],
                        recruitment: snapshot.data?.docs[index]['recruitment'],
                        userImage: snapshot.data?.docs[index]['userImage'],
                        location: snapshot.data?.docs[index]['location'],);
                  },
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
            child: Text('Что-то пошло не так', style: TextStyles.normalGreenText,),
          );
        },
      ),
    );
  }
}
