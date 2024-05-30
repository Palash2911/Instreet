import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:instreet/models/userModel.dart';
import 'package:instreet/providers/authProvider.dart';
import 'package:instreet/providers/userProvider.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:provider/provider.dart';
import '../../../constants/constants.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  static var routeName = 'register-screen';

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _form = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _dateController = TextEditingController();

  String get name => _nameController.text;
  String get email => _emailController.text;
  String get date => _dateController.text;
  String phoneNo = '';

  String gender = "";
  String isoCode = 'IN';
  List<Gender> genders = [];
  var isLoading = false;

  bool isInit = false;

  @override
  void didChangeDependencies() {
    if (!isInit) {
      var auth = FirebaseAuth.instance;
      _nameController.text = "";
      _phoneController.text = auth.currentUser?.phoneNumber ?? '';
      if (_phoneController.text.isNotEmpty) {
        var number = PhoneNumber.fromCompleteNumber(
            completeNumber: _phoneController.text);
        _phoneController.text = number.number;
        isoCode = number.countryISOCode;
      }
      _emailController.text = auth.currentUser?.email ?? "";
      _dateController.text = "";
      genders.add(Gender("Male", Icons.male, false));
      genders.add(Gender("Female", Icons.female, false));
      genders.add(Gender("Others", Icons.transgender, false));
    }
    setState(() {
      isInit = true;
    });
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  Future register(BuildContext ctx) async {
    isLoading = true;
    var userProvider = Provider.of<UserProvider>(context, listen: false);
    var authId = Provider.of<Auth>(context, listen: false).token;
    final isValid = _form.currentState!.validate();
    if (isValid) {
      userProvider
          .registerUser(
        UserModel(
          uid: authId,
          uName: name,
          uEmail: email,
          phoneNo: phoneNo,
          dob: date,
          gender: gender,
          createdAt: DateTime.now(),
          isCreator: false,
        ),
      )
          .catchError((e) {
        Fluttertoast.showToast(
          msg: "Something went wrong!",
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 1,
          backgroundColor: kprimaryColor,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }).then((_) {
        Provider.of<Auth>(context, listen: false).autoLogin().then((value) {
          Fluttertoast.showToast(
            msg: "Successfully Registered !",
            toastLength: Toast.LENGTH_SHORT,
            timeInSecForIosWeb: 1,
            backgroundColor: kprimaryColor,
            textColor: Colors.white,
            fontSize: 16.0,
          );
          Navigator.of(ctx).pushReplacementNamed('bottom-nav');
        });
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tell us about you'),
      ),
      body: isLoading
          ? Container(
              height: MediaQuery.of(context).size.height,
              color: Colors.black.withOpacity(0.7),
              child: Center(
                child: Image.asset(
                  'assets/images/loader.gif',
                  width: 150,
                  height: 150,
                ),
              ),
            )
          : SingleChildScrollView(
              child: SafeArea(
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.8,
                  width: MediaQuery.of(context).size.width * 0.9,
                  padding: const EdgeInsets.only(left: 21),
                  child: Form(
                    key: _form,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextFormField(
                          controller: _nameController,
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                            hintText: "Name",
                            hintStyle: kTextPopR14,
                            icon: const Icon(Icons.person),
                            filled: true,
                            fillColor: Colors.transparent,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    width: 1, color: Colors.black)),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your name!';
                            }
                            return null;
                          },
                          textInputAction: TextInputAction.next,
                        ),
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            hintText: "Email",
                            hintStyle: kTextPopR14,
                            icon: const Icon(Icons.email),
                            filled: true,
                            fillColor: Colors.transparent,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    width: 1, color: Colors.black)),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter email!';
                            }
                            return null;
                          },
                          textInputAction: TextInputAction.next,
                        ),
                        IntlPhoneField(
                          controller: _phoneController,
                          decoration: InputDecoration(
                            labelText: 'Phone Number',
                            counterText: "",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              borderSide: const BorderSide(
                                  color: Colors.black, width: 1.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(
                                  color: Colors.black, width: 1.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(
                                  color: Colors.black, width: 1.0),
                            ),
                            icon: const Icon(Icons.phone),
                          ),
                          validator: (value) {
                            if (value!.number.isEmpty) {
                              return 'Please Enter Valid Number!';
                            }
                            return null;
                          },
                          initialCountryCode: isoCode,
                          onChanged: (phone) {
                            setState(() {
                              phoneNo = phone.completeNumber.toString();
                            });
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: TextFormField(
                            textInputAction: TextInputAction.next,
                            controller: _dateController,
                            decoration: InputDecoration(
                              hintText: "Date of Birth",
                              hintStyle: kTextPopR14,
                              icon: const Icon(Icons.calendar_today_rounded),
                              filled: true,
                              fillColor: Colors.transparent,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    width: 1, color: Colors.black),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Date Not Set !';
                              }
                              return null;
                            },
                            readOnly: true,
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime(2004, 1, 1),
                                  firstDate: DateTime(1950),
                                  lastDate: DateTime(2018));
                              if (pickedDate != null) {
                                String formattedDate =
                                    DateFormat.yMMMMd('en_US')
                                        .format(pickedDate);
                                setState(() {
                                  _dateController.text = formattedDate;
                                });
                              } else {}
                            },
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.male_rounded,
                              size: 32.0,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 12.0),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                border:
                                    Border.all(color: Colors.black, width: 1),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Row(
                                children: [
                                  const SizedBox(width: 27.0),
                                  SizedBox(
                                    height: 54,
                                    child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        shrinkWrap: true,
                                        itemCount: genders.length,
                                        itemBuilder: (context, index) {
                                          return InkWell(
                                            onTap: () {
                                              setState(() {
                                                genders.forEach((gender) =>
                                                    gender.isSelected = false);
                                                genders[index].isSelected =
                                                    true;
                                                gender = genders[index].name;
                                              });
                                            },
                                            child: Container(
                                              margin: const EdgeInsets.only(
                                                  right: 9),
                                              child: Chip(
                                                label: Text(
                                                  genders[index].name,
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: !genders[index]
                                                              .isSelected
                                                          ? kprimaryColor
                                                          : Colors.white),
                                                ),
                                                backgroundColor:
                                                    !genders[index].isSelected
                                                        ? Colors.white
                                                        : kprimaryColor,
                                              ),
                                            ),
                                          );
                                        }),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: () => register(context),
                          style: ElevatedButton.styleFrom(
                              fixedSize: const Size(300, 50),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              backgroundColor: kprimaryColor,
                              textStyle: const TextStyle(
                                fontSize: 18,
                              )),
                          child: const Text(
                            'Enter In-Street',
                            style: TextStyle(color: Colors.white),
                          ),
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

class Gender {
  String name;
  IconData icon;
  bool isSelected;

  Gender(this.name, this.icon, this.isSelected);
}
