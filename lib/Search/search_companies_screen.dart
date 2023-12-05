import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ijob_clone_app/Widgets/all_companies_widget.dart';

import '../Widgets/botton_nav_bar.dart';
import '../Constants/colors.dart';
import '../Constants/text_styles.dart';

class AllWorkerScreen extends StatefulWidget {
  @override
  State<AllWorkerScreen> createState() => _AllWorkerScreenState();
}

class _AllWorkerScreenState extends State<AllWorkerScreen> {
  TextEditingController _searchQueryController = TextEditingController();
  String searchQuery = 'Search query';

  Widget _buildSearchField() {
    return TextField(
      controller: _searchQueryController,
      autocorrect: true,
      decoration: InputDecoration(hintText: 'Поиск по компаниям...', border: InputBorder.none, hintStyle: TextStyles.normalWhiteText15),
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
      bottomNavigationBar: BottomNavigator(
        selectedIndex: 1,
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: _buildSearchField(),
        actions: _buildActions(),
        centerTitle: true,
        backgroundColor: MyColors.brightGreen,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').where('name', isGreaterThanOrEqualTo: searchQuery).snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.data!.docs.isNotEmpty) {
              return Padding(
                padding: const EdgeInsets.only(top: 5),
                child: ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    return AllCompaniesWidget(
                      jobId: snapshot.data!.docs[index]['id'],
                      userName: snapshot.data!.docs[index]['name'],
                      phoneNumber: snapshot.data!.docs[index]['phoneNumber'],
                      userEmail: snapshot.data!.docs[index]['email'],
                      userImageUrl: snapshot.data!.docs[index]['userImage'],
                    );
                  },
                ),
              );
            }
            else {
              return Center(
                child: Text(
                  'Пока нет компаний',
                  style: TextStyles.normalGreenText,
                ),
              );
            }
          }
          return Center(
            child:  Text(''
                'Что-то пошо не так',  style: TextStyles.normalGreenText,),
          );
        },
      ),
    );
  }
}
