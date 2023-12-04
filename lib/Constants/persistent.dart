
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'global_variables.dart';

class Persistent {
  static List<String> jobCategoryList = [
    'Архитектура и Конструирование',
    'Медицина',
    'Образование, наука',
    'Маркетинг, реклама, PR',
    'Бизнес',
    'Информационные технологии',
    'Подбор персонала',
    'Маркетинг, реклама, PR',
    'Дизайн, творчество',
    'Обслуживание',
    'Производство',
    'Строительство',
    'Финансы и учет',
    'Гостинично-ресторанный бизнес',
    'Туризм',
    'Администрация, руководство',
    'Продажи, закупки',
    'Культура, музыка, шоу-бизнес',
    'Телекоммуникации и связь',
    'СМИ, издательство, полиграфия',
    'Другое'
  ];

  void getMyData() async {
    final DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get();

    name = userDoc.get('name');
    userImage = userDoc.get('userImage');
    location = userDoc.get('location');


  }
}
