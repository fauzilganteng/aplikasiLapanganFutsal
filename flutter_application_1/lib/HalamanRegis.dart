import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/halamanutama.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class HalamanRegister extends StatefulWidget {
  const HalamanRegister({super.key});

  @override
  State<HalamanRegister> createState() => _HalamanRegisterState();
}

class _HalamanRegisterState extends State<HalamanRegister> {
  TextEditingController cUser = TextEditingController();
  TextEditingController cNama = TextEditingController();
  TextEditingController cNoHP = TextEditingController();
  TextEditingController cPass = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    Future<void> addUser() async {
      // Call the user's CollectionReference to add a new user
      return await users
          .add({
            'userName': cUser.text, // John Doe
            'nama': cNama.text, // Stokes and Sons
            'noHP': cNoHP.text,
            'pass': cPass.text // 42
          })
          .then((value) => log("User Added"))
          .catchError((error) => log("Failed to add user: $error"));
    }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: Colors.blue),
        child: Form(
            key: formKey,
            child: Center(
              child: Container(
                width: 300,
                child: Card(
                  elevation: 10,
                  shadowColor: Colors.red,
                  color: Color.fromARGB(255, 231, 236, 232),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: cUser,
                          decoration: InputDecoration(
                              labelText: 'User Name',
                              hintText: 'input  User Name',
                              border: OutlineInputBorder(
                                borderSide: BorderSide(width: 2),
                                borderRadius: BorderRadius.circular(10),
                              )),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'User Masih Kosong';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: cNama,
                          decoration: InputDecoration(
                              labelText: 'Nama Lengkap',
                              hintText: 'input  Nama Lengkap',
                              border: OutlineInputBorder(
                                borderSide: BorderSide(width: 2),
                                borderRadius: BorderRadius.circular(10),
                              )),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Nama Lengkap Masih Kosong';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: cNoHP,
                          decoration: InputDecoration(
                              labelText: 'NO HP',
                              hintText: 'Imput  NO HP',
                              border: OutlineInputBorder(
                                borderSide: BorderSide(width: 2),
                                borderRadius: BorderRadius.circular(10),
                              )),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'no HP Masih Kosong ';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          obscureText: true,
                          controller: cPass,
                          decoration: InputDecoration(
                              labelText: 'Password',
                              hintText: 'input password',
                              border: OutlineInputBorder(
                                borderSide: BorderSide(width: 2),
                                borderRadius: BorderRadius.circular(10),
                              )),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Password Masih Kosong';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                addUser();
                                cUser.clear();
                                cNama.clear();
                                cNoHP.clear();
                                cPass.clear();

                                // log('tc $cUser');
                              }

                              log("isi tc ${cUser.text}");
                            },
                            child: Text('REGISTRASI')),
                        SizedBox(
                          height: 10,
                          width: 10,
                        ),
                        Text("Sudah Punya akun"),
                        SizedBox(
                          height: 10,
                          width: 10,
                        ),
                        OutlinedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text("LOGIN"))
                      ],
                    ),
                  ),
                ),
              ),
            )),
      ),
    );
  }
}
