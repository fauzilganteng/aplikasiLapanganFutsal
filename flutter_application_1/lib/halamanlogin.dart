import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/HalamanRegis.dart';
import 'package:flutter_application_1/halamanutama.dart';
import 'package:flutter_application_1/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DesainHalamanLogin extends StatefulWidget {
  const DesainHalamanLogin({super.key});

  @override
  State<DesainHalamanLogin> createState() => _DesainHalamanLoginState();
}

class _DesainHalamanLoginState extends State<DesainHalamanLogin> {
  TextEditingController cUser = TextEditingController();
  TextEditingController cPass = TextEditingController();
  final sessionLoginC = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final listSession = [
    'user',
    'admin',
  ];

  Future alertStatus() async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Status login'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: listSession
                  .map(
                    (e) => InkWell(
                      onTap: () {
                        sessionLoginC.text = e;
                        Navigator.pop(context);
                      },
                      child: Text(e),
                    ),
                  )
                  .toList(),
            ),
          );
        });
  }

  CollectionReference users = FirebaseFirestore.instance.collection('users');
  CollectionReference admin = FirebaseFirestore.instance.collection('admin');

  @override
  Widget build(BuildContext context) {
    Future login() async {
      final sp = await SharedPreferences.getInstance();
      try {
        if (formKey.currentState!.validate()) {
          QuerySnapshot<Object?> query;
          if (sessionLoginC.text == 'admin') {
            query = await admin
                .where('userName', isEqualTo: cUser.text)
                .where('pass', isEqualTo: cPass.text)
                .get();
          } else {
            query = await users
                .where('userName', isEqualTo: cUser.text)
                .where('pass', isEqualTo: cPass.text)
                .get();
          }
          if (query.size != 0) {
            //perintah untuk memanggil halaman baru
            print('ada');
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Homepage(),
              ),
            );
            final idLogin = query.docs.first.id;
            final dataLogin = query.docs.first.data() as Map<String, dynamic>;
            final sesi = sp.setString('sesi', sessionLoginC.text);
            final namaLogin = sp.setString('namaLogin', dataLogin['nama']);
            final nama = sp.getString('namaLogin');
            print(sesi);
            print(nama);
          } else {
            print('kosong');
            await showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('konfirmasi login'),
                    content: Text('User Atau Password Masih Salah'),
                    actions: [
                      ElevatedButton(
                          onPressed: () {
                            cUser.text = '';
                            cPass.text = '';
                            Navigator.of(context).pop();
                          },
                          child: Text('OK'))
                    ],
                  );
                });
          }
        }
      } catch (e) {
        print(e.toString());
      }
    }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(color: Colors.blue),
        child: Form(
            key: formKey,
            child: Center(
              child: SizedBox(
                width: 300,
                // height: 330,
                child: Card(
                  elevation: 10,
                  shadowColor: Colors.red,
                  color: const Color.fromARGB(255, 231, 236, 232),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          controller: cUser,
                          decoration: InputDecoration(
                              labelText: 'User Name',
                              hintText: 'input  User Name',
                              border: OutlineInputBorder(
                                borderSide: const BorderSide(width: 2),
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
                          obscureText: true,
                          controller: cPass,
                          decoration: InputDecoration(
                              labelText: 'Password',
                              hintText: 'input password',
                              border: OutlineInputBorder(
                                borderSide: const BorderSide(width: 2),
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
                        TextFormField(
                          onTap: alertStatus,
                          controller: sessionLoginC,
                          decoration: InputDecoration(
                            labelText: 'Status',
                            hintText: 'Pilih status login',
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(width: 2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Status Masih Kosong';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                          onPressed: login,
                          child: const Text('LOGIN'),
                        ),
                        const SizedBox(
                          height: 10,
                          width: 10,
                        ),
                        const Text("Belum Punya akun?"),
                        const SizedBox(
                          height: 10,
                          width: 10,
                        ),
                        OutlinedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const HalamanRegister(),
                                ));
                          },
                          child: const Text("REGISTRASI"),
                        ),
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
