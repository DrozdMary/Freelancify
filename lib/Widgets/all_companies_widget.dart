import 'package:flutter/material.dart';
import 'package:ijob_clone_app/Search/profile_screen.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../Constants/colors.dart';
import '../Constants/text_styles.dart';

class AllCompaniesWidget extends StatefulWidget {
  final String jobId;
  final String userName;
  final String phoneNumber;
  final String userEmail;
  final String userImageUrl;

  const AllCompaniesWidget({
    required this.jobId,
    required this.userName,
    required this.phoneNumber,
    required this.userEmail,
    required this.userImageUrl,
  });

  @override
  State<AllCompaniesWidget> createState() => _AllCompaniesWidgetState();
}

class _AllCompaniesWidgetState extends State<AllCompaniesWidget> {


 void _mailTo() async {
   final Uri params = Uri(
     scheme: 'mailto',
     path: widget.userEmail,
     query: 'subject=Вакансия на Freelancify&body = Здравствуйте, расскажите, пожалуйста, поподробнее об открытой вакансии',
   );
   final url = params.toString();
   launchUrlString(url);
 }


  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      color: MyColors.white,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: ListTile(
        onTap: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (_, __, ___) => ProfileScreen(userId: widget.jobId),
              transitionDuration: Duration(milliseconds: 100),
              transitionsBuilder: (_, a, __, c) => FadeTransition(opacity: a, child: c),
            ),
          );
        },
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        leading: Container(
          padding: EdgeInsets.only(right: 12),
          decoration: BoxDecoration(
            border: Border(
              right: BorderSide(width: 2, color: Color(0xFFC6E9E5)),
            )
          ),
          child: CircleAvatar(
            backgroundColor: MyColors.lightGreen,
            radius: 20,
              child: Image.network(widget.userImageUrl == null
                  ? 'https://sun9-39.userapi.com/impg/ZXuuLOZ8-c61rNlS-Xgwa1AL43JR7i13NJ8MYQ/ufBlqgJcvLY.jpg?size=420x420&quality=96&sign=f527b52a6dd16f0d8f843d3ef37a4e06&type=album'
              : widget.userImageUrl
              ),
          ),
        ),
        title: Text(
          widget.userName,
          maxLines: 2,
            overflow: TextOverflow.ellipsis,
          style: TextStyles.boldText,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
                'Просмотреть профиль',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
          style: TextStyles.normalGreenText14,),
          ],
        ),
        trailing: CircleAvatar(
          backgroundColor: MyColors.darkBlue,
          radius: 22,
          child: CircleAvatar(
            radius: 22,
            backgroundColor: MyColors.darkBlue1,
            child: IconButton(
              icon: Icon(
                Icons.mail_outlined,
                size: 25,
                  color: MyColors.darkBlue,
              ),
              onPressed: (){
                _mailTo();
              },
            ),
          ),
        ),
      ),
    );
  }
}
