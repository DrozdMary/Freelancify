import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../Widgets/botton_nav_bar.dart';
import '../Constants/colors.dart';
import '../Widgets/divider_widget.dart';
import '../Widgets/show_dialog.dart';
import '../Constants/text_styles.dart';

class ProfileScreen extends StatefulWidget {
  final String userId;

  ProfileScreen({required this.userId});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;

  String? name;
  String email = '';
  String location = '';
  String phoneNumber = '';
  String information = '';
  String imageUrl = '';
  String joinedAt = '';
  bool _isSameUser = false;

  void getUserData() async {
    try {
      _isLoading = true;
      final DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(widget.userId).get();
      if (userDoc == null) {
        return;
      } else {
        setState(() {
          name = userDoc.get('name');
          email = userDoc.get('email');
          location = userDoc.get('location');
          phoneNumber = userDoc.get('phoneNumber');
          imageUrl = userDoc.get('userImage');
          information=userDoc.get('information');
          Timestamp joinedAtTimestamp = userDoc.get('createdAt');
          var joinedDate = joinedAtTimestamp.toDate();

          joinedAt = '${joinedDate.day}.${joinedDate.month}.${joinedDate.year}';
        });
        User? user = _auth.currentUser;
        final _uid = user!.uid;
        setState(() {
          _isSameUser = _uid == widget.userId;
        });
      }
    } catch (error) {
    } finally {
      _isLoading = false;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
  }

  void _logout() async {
    await GlobalMethod.showLogoutDialog(
      ctx: context,
    );
  }

  Widget userInfo({required IconData icon, required String content}) {
    return Row(
      children: [
        Icon(
          icon,
          color: MyColors.emeraldGreen,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            content,
            style: TextStyles.normText.copyWith(fontSize: 17),
          ),
        )
      ],
    );
  }

  Widget _contactBy({required Color color, required Color backColor, required Function fct, required IconData icon}) {
    return CircleAvatar(
      backgroundColor: color,
      radius: 25,
      child: CircleAvatar(
        radius: 23,
        backgroundColor: backColor,
        child: IconButton(
          icon: Icon(
            icon,
            color: color,
          ),
          onPressed: () {
            fct();
          },
        ),
      ),
    );
  }

  void _openWhatsAppChat() async {
    var url = 'http://wa.me/$phoneNumber?text=HelloWord';
    launchUrlString(url);
  }

  void _mailTo() async {
    final Uri params = Uri(
      scheme: 'mailto',
      path: email,
      query: 'subject=Write subject here, Please&body = Здравствуйте, расскажите, пожалуйста, поподробнее об открытой вакансии',
    );
    final url = params.toString();
    launchUrlString(url);
  }

  void _callPhoneNumber() async {
    var url = 'tel://$phoneNumber';
    launchUrlString(url);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      bottomNavigationBar: BottomNavigator(
        selectedIndex: 3,
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: MyColors.emeraldGreen,
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(top: 15,),
                child: Stack(
                  children: [
                    Card(
                      color: Colors.white,
                      margin: EdgeInsets.all(30),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 100,
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Text(
                                  name == null ? 'Имя пользвателя' : name!,
                                  style: TextStyles.boldText.copyWith(fontSize: 25),
                                ),
                              ),
                            ),
                            SizedBox(height: 10,),
                            Text(
                              information == null ? '' : information!,
                              textAlign: TextAlign.center,
                              style: TextStyles.normText,
                            ),

                            DividerWidget(),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Center(
                                child: Text(
                                  'Контакты:',
                                  style: TextStyles.boldGreenText18.copyWith(fontSize: 22),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 20, bottom: 9),
                              child: userInfo(icon: Icons.email_outlined, content: email),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 20, bottom: 9),
                              child: userInfo(icon: Icons.phone, content: phoneNumber),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: userInfo(icon: Icons.location_on_outlined, content: location),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            _isSameUser
                                ? SizedBox()
                                : Column(
                                    children: [
                                      DividerWidget(),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          _contactBy(
                                              backColor: MyColors.q11,
                                              color: MyColors.q1,
                                              fct: () {
                                                _openWhatsAppChat();
                                              },
                                              icon: FontAwesome.whatsapp),
                                          SizedBox(
                                            width: 40,
                                          ),
                                          _contactBy(
                                              backColor: MyColors.q22,
                                              color: MyColors.q2,
                                              fct: () {
                                                _mailTo();
                                              },
                                              icon: Icons.mail_outline_outlined),
                                          SizedBox(
                                            width: 40,
                                          ),
                                          _contactBy(
                                              backColor: MyColors.q33,
                                              color: MyColors.q3,
                                              fct: () {
                                                _callPhoneNumber();
                                              },
                                              icon: Icons.phone),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                    ],
                                  ),
                            !_isSameUser
                                ? SizedBox()
                                : Center(
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: DividerWidget(),
                                        ),
                                        MaterialButton(
                                          height: 55,
                                          onPressed: () {
                                            _logout();
                                          },
                                          color: MyColors.red,
                                          elevation: 5,
                                          //устанавливает высоту тени кнопки
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                          child: _isLoading
                                              ? Center(
                                                  child: Container(
                                                    child: const CircularProgressIndicator(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                )
                                              : Padding(
                                                  padding: const EdgeInsets.symmetric(
                                                    vertical: 12,
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Text('Выход из аккаунта  ', style: TextStyles.bigButtonText.copyWith(fontSize: 20)),
                                                      Icon(
                                                        Icons.logout_outlined,
                                                        color: Colors.white,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                        ),
                                        SizedBox(height: 20,)
                                      ],
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: size.width * 0.3,
                          height: size.width * 0.3,
                          decoration: BoxDecoration(
                              color: MyColors.lightGreen,
                              shape: BoxShape.circle,
                              border: Border.all(
                                width: 8,
                                color: Theme.of(context).scaffoldBackgroundColor,
                              ),
                              image: DecorationImage(
                                image: NetworkImage(
                                  imageUrl == null
                                      ? 'https://sun9-39.userapi.com/impg/ZXuuLOZ8-c61rNlS-Xgwa1AL43JR7i13NJ8MYQ/ufBlqgJcvLY.jpg?size=420x420&quality=96&sign=f527b52a6dd16f0d8f843d3ef37a4e06&type=album'
                                      : imageUrl,
                                ),
                                fit: BoxFit.fill,
                              )),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
