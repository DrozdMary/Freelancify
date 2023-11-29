import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ijob_clone_app/Constants/show_dialog.dart';
import 'package:ijob_clone_app/Constants/text_styles.dart';
import 'package:ijob_clone_app/Persistent/persistent.dart';
import 'package:uuid/uuid.dart';
import '../Constants/botton_nav_bar.dart';
import '../Constants/colors.dart';
import '../Constants/costom_alert_dialog_categories.dart';
import '../Constants/global_variables.dart';

class UploadJobNow extends StatefulWidget {
  @override
  State<UploadJobNow> createState() => _UploadJobNowState();
}

class _UploadJobNowState extends State<UploadJobNow> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _jobCategoryController = TextEditingController(text: 'Выберите категорию работы');
  final TextEditingController _jobTitleController = TextEditingController();
  final TextEditingController _jobDescriptionController = TextEditingController();
  final TextEditingController _jobRequirementsController = TextEditingController();
  final TextEditingController _deadlineDateController = TextEditingController(text: 'Срок актуальности работы');

  DateTime? picked;
  Timestamp? deadlineDateTimeStamp;

  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _jobCategoryController.dispose();
    _jobTitleController.dispose();
    _jobDescriptionController.dispose();
    _deadlineDateController.dispose();
  }

  int _calculateMaxLines(String valueKey) {
    if (valueKey == 'JobDescription' || valueKey == 'JobRequirements') {
      return 3;
    } else {
      return 1;
    }
  }

  Widget _textTitles({required String label}) {
    return Padding(
      padding: EdgeInsets.all(5),
      child: Text(
        label,
        style: TextStyles.normText.copyWith(fontSize: 20),
      ),
    );
  }

  Widget _textFormFields({
    required String valueKey,
    required TextEditingController controller,
    required bool enabled,
    required Function fct,
    required int maxLength,
  }) {
    return Padding(
      padding: EdgeInsets.all(5),
      child: InkWell(
        onTap: () {
          fct();
        },
        child: TextFormField(
            validator: (value) {
              if (value!.isEmpty) {
                return "Неправильные данные";
              }
              return null;
            },
            controller: controller,
            enabled: enabled,
            key: ValueKey(valueKey),
            style: TextStyles.normalGreenText,
            maxLines: _calculateMaxLines(valueKey),
            maxLength: maxLength,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              filled: true,
              fillColor: MyColors.lightGreen,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyColors.lightGreen, width: 0),
                borderRadius: BorderRadius.circular(16.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyColors.emeraldGreen, width: 2),
                borderRadius: BorderRadius.circular(16.0),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyColors.red, width: 2),
                borderRadius: BorderRadius.circular(16.0),
              ),
            )),
      ),
    );
  }

  _showTaskCategoriesDialog({required Size size}) {
    DialogCotegories.showAlert(
        context: context,
        onTap: (index) {
          setState(() {
            _jobCategoryController.text = Persistent.jobCategoryList[index];
          });
          Navigator.canPop(context) ? Navigator.pop(context) : null;
        },
        onPressed: () {
          setState(() {
            print('Нужна помощь');
          });
          Navigator.canPop(context) ? Navigator.pop(context) : null;
        });
  }

  void _pickDateDialog() async {
    picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(
        const Duration(days: 0),
      ),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _deadlineDateController.text = '${picked!.day}.${picked!.month}.${picked!.year}';
        deadlineDateTimeStamp = Timestamp.fromMicrosecondsSinceEpoch(picked!.microsecondsSinceEpoch);
      });
    }
  }

  void _uploadTask() async {
    final jobId = Uuid().v4();
    User? user = FirebaseAuth.instance.currentUser;
    final _uid = user!.uid;
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      if (_deadlineDateController.text == 'Срок выполнения работы:' || _jobCategoryController.text == 'Выберите категорию работы') {
        GlobalMethod.showErrorDialog(error: 'Пожалуйста заполните все поля', ctx: context);
        return;
      }
      setState(() {
        _isLoading = true;
      });
      try {
        await FirebaseFirestore.instance.collection('Jobs').doc(jobId).set({
          'jobId': jobId,
          'uploadedBy': _uid,
          'email': user.email,
          'jobTitle': _jobTitleController.text,
          'jobCategory': _jobCategoryController.text,
          'jobDescription': _jobDescriptionController.text,
          'jobRequirements': _jobRequirementsController.text,
          'deadlineDate': _deadlineDateController.text,
          'deadlineDateTimeStamp': deadlineDateTimeStamp,
          'jobComments': [],
          'recruitment': true,
          'createdAt': Timestamp.now(),
          'name': name,
          'userImage': userImage,
          'location': location,
          'applicants': 0,
        });
        await Fluttertoast.showToast(
          msg: 'Вакансия была опубликована',
          toastLength: Toast.LENGTH_LONG,
          fontSize: 18,
        );
        _jobTitleController.clear();
        _jobDescriptionController.clear();
        _jobRequirementsController.clear();
        setState(() {
          _jobCategoryController.text = 'Выберите категорию работы';
          _deadlineDateController.text = 'Выберите срок выполнения';
        });
      } catch (error) {
        {
          setState(() {
            _isLoading = false;
          });
          GlobalMethod.showErrorDialog(error: error.toString(), ctx: context);
        }
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      print('Валидация не пройдена');
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      bottomNavigationBar: BottomNavigator(
        selectedIndex: 02,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 20, right: 7, left: 7, bottom: 2),
          child: Card(
            color: MyColors.white,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 5,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.all(5),
                      child: Text('Создание новой вакансии', style: TextStyles.boldText.copyWith(fontSize: 25)),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Divider(
                    color: MyColors.lightGreen,
                    thickness: 3,
                  ),
                  Center(
                    child: Padding(
                      padding: EdgeInsets.only(left: 5, right: 5, top: 5),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _textTitles(label: 'Категория работы:'),
                            _textFormFields(
                              valueKey: 'JobCategory',
                              controller: _jobCategoryController,
                              enabled: false,
                              fct: () {
                                _showTaskCategoriesDialog(size: size);
                              },
                              maxLength: 100,
                            ),
                            _textTitles(label: 'Название вакансии:'),
                            _textFormFields(
                              valueKey: 'JobTitle',
                              controller: _jobTitleController,
                              enabled: true,
                              fct: () {},
                              maxLength: 100,
                            ),
                            _textTitles(label: 'Описание работы:'),
                            _textFormFields(
                              valueKey: 'JobDescription',
                              controller: _jobDescriptionController,
                              enabled: true,
                              fct: () {},
                              maxLength: 600,
                            ),
                            _textTitles(label: 'Требования к кондидату:'),
                            _textFormFields(
                              valueKey: 'JobRequirements',
                              controller: _jobRequirementsController,
                              enabled: true,
                              fct: () {},
                              maxLength: 600,
                            ),
                            _textTitles(label: 'Срок актуальности вакансии:'),
                            _textFormFields(
                              valueKey: 'Deadline',
                              controller: _deadlineDateController,
                              enabled: false,
                              fct: () {
                                _pickDateDialog();
                              },
                              maxLength: 100,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: _isLoading
                        ? CircularProgressIndicator(
                            color: MyColors.emeraldGreen,
                          )
                        : MaterialButton(
                            onPressed: () {
                              _uploadTask();
                            },
                            color: MyColors.darkBlue,
                            elevation: 8,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 14),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Опубликовать',
                                    style: TextStyles.bigButtonText.copyWith(fontSize: 22),
                                  ),
                                  SizedBox(
                                    width: 9,
                                  ),
                                  Icon(
                                    Icons.upload_outlined,
                                    color: MyColors.white,
                                  ),
                                ],
                              ),
                            ),
                          ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
