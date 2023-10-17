import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/pemberitahuan.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Booking extends StatefulWidget {
  const Booking({super.key, required this.dataParamt});
  final QueryDocumentSnapshot<Object?>? dataParamt;

  @override
  State<Booking> createState() => _BookingState();
}

class _BookingState extends State<Booking> {
  DateTime date = DateTime.now();
  final namaC = TextEditingController();
  final tglC = TextEditingController();
  final jamMulaiC = TextEditingController();
  final jamBerakhirC = TextEditingController();
  final formKey = GlobalKey<FormState>();

  String dateFormat = 'dd MMMM yyyy';
  String dateTanggalFormat = 'dd/MM/yyyy';
  String idLap = '';
  String idBoking = '';
  String namaLap = '';
  String hargaLap = '';

  @override
  void initState() {
    // initData();
    if (widget.dataParamt != null) {
      idLap = widget.dataParamt!.id;
      idBoking = widget.dataParamt!.id;
      final data = widget.dataParamt!.data() as Map<String, dynamic>;
      // final dataNama = widget.dataParamt!.data() as Map<String, dynamic>;
      namaLap = data['namaLapangan'];
      hargaLap = data['harga'];
      // namaC.text = data['namaBoking'];
    }
    super.initState();
  }

  bool isBooking = false;
  List<Map<String, dynamic>> listLapTerboking = [];

  Future initData({
    required Timestamp mulai,
    required Timestamp selesai,
    required String namaLap,
  }) async {
    final booking = await FirebaseFirestore.instance.collection('boking').get();
    if (booking.size != 0) {
      for (int i = 0; i < booking.docs.length; i++) {
        final dataBooking = booking.docs[i].data() as Map<String, dynamic>;
        final jamMulai = dataBooking['jamBoking']['jamMulai'] as Timestamp;
        final jamSelesai = dataBooking['jamBoking']['jamSelesai'] as Timestamp;

        print(jamMulai.toString() + 'data Jam Mulai');
        print(jamMulai.toString() + 'data Jam Mulai');
        final boolMulai = jamMulai.toDate().hour == mulai.toDate().hour &&
            jamMulai.toDate().day == mulai.toDate().day;

        final boolSelesai = jamSelesai.toDate().hour == selesai.toDate().hour &&
            jamSelesai.toDate().day == selesai.toDate().day;
        print('$boolMulai' + ' bool mulai');
        print('$boolSelesai' + ' bool selesai');

        if (boolMulai && dataBooking['namaLapangan'] == namaLap) {
          print('berjalan');
          isBooking = true;
        } else if (boolSelesai && dataBooking['namaLapangan'] == namaLap) {
          print('di boking');
          isBooking = true;
        } else {
          print('telah selesai');
        }
        print(isBooking);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Future addDataLapangan() async {
      final Map<String, dynamic> data = {
        'namaBoking': namaC.text,
        // 'jamBoking': jadwalB.text,
      };
      final dataLapangan =
          FirebaseFirestore.instance.collection('lapangan').add(data);
      await dataLapangan;
      namaC.clear();
      // jadwalB.clear();
    }

    Future addDataBoking() async {
      final Map<String, dynamic> data = {
        'namaPenyewa': namaC.text,
        // 'jamBoking': jadwalB.text,
      };
      final dataBoking =
          FirebaseFirestore.instance.collection('boking').add(data);
      await dataBoking;
      namaC.clear();
      // jadwalB.clear();
    }

    Future updateDataLapangan() async {
      if (formKey.currentState!.validate()) {
        TimeOfDay jamMulai = TimeOfDay(
          hour: int.parse(jamMulaiC.text.split(':')[0]),
          minute: int.parse(jamMulaiC.text.split(':')[1]),
        );
        print(jamMulai.toString() + 'jamMulai');

        TimeOfDay jamBerakhir = TimeOfDay(
          hour: int.parse(jamBerakhirC.text.split(':')[0]),
          minute: int.parse(jamBerakhirC.text.split(':')[1]),
        );
        print(jamBerakhir.toString() + 'jamBerakhir');
        DateFormat inputFormat = DateFormat("dd MMMM yyyy", "id_ID");
        DateTime tanggal = inputFormat.parse(tglC.text);
        DateTime tglMulai = DateTime(
          tanggal.year,
          tanggal.month,
          tanggal.day,
          jamMulai.hour,
          jamMulai.minute,
        );
        DateTime tglBerakhir = DateTime(
          tanggal.year,
          tanggal.month,
          tanggal.day,
          jamBerakhir.hour,
          jamBerakhir.minute,
        );
        Timestamp tsTglMulai = Timestamp.fromDate(tglMulai);
        Timestamp tsTglBerakhir = Timestamp.fromDate(tglBerakhir);
        print(tglMulai.toString() + 'tglMulai');
        print(tglBerakhir.toString() + 'tglBerakhir');
        final data = {
          'jamBoking': {
            'jamMulai': tsTglMulai,
            'jamSelesai': tsTglBerakhir,
          },
          'namaBoking': namaC.text,
          'namal': namaLap,
        };
        // final dataNama = {'namaBoking': namaC};
        final dataLapangan =
            FirebaseFirestore.instance.collection('lapangan').add(data);
        print(idLap);
        print(data);
        await dataLapangan;
        namaC.clear();
        jamMulaiC.clear();
        jamBerakhirC.clear();
        tglC.clear();
      }
    }

    Future updateDataBoking() async {
      final sp = await SharedPreferences.getInstance();
      if (formKey.currentState!.validate()) {
        TimeOfDay jamMulai = TimeOfDay(
          hour: int.parse(jamMulaiC.text.split(':')[0]),
          minute: int.parse(jamMulaiC.text.split(':')[1]),
        );
        print(jamMulai.toString() + 'jamMulai');

        TimeOfDay jamBerakhir = TimeOfDay(
          hour: int.parse(jamBerakhirC.text.split(':')[0]),
          minute: int.parse(jamBerakhirC.text.split(':')[1]),
        );
        print(jamBerakhir.toString() + 'jamBerakhir');
        DateFormat inputFormat = DateFormat("dd MMMM yyyy", "id_ID");
        DateTime tanggal = inputFormat.parse(tglC.text);
        DateTime tglMulai = DateTime(
          tanggal.year,
          tanggal.month,
          tanggal.day,
          jamMulai.hour,
          jamMulai.minute,
        );
        DateTime tglBerakhir = DateTime(
          tanggal.year,
          tanggal.month,
          tanggal.day,
          jamBerakhir.hour,
          jamBerakhir.minute,
        );
        final nama = sp.getString('namaLogin');
        Timestamp tsTglMulai = Timestamp.fromDate(tglMulai);
        Timestamp tsTglBerakhir = Timestamp.fromDate(tglBerakhir);
        // print(tglMulai.toString() + 'tglMulai');
        // print(tglBerakhir.toString() + 'tglBerakhir');
        initData(
          mulai: tsTglMulai,
          selesai: tsTglBerakhir,
          namaLap: namaLap,
        );
        final data = {
          'jamBoking': {
            'jamMulai': tsTglMulai,
            'jamSelesai': tsTglBerakhir,
          },
          'namaPenyewa': nama,
          'namaLapangan': namaLap,
        };

        // if (isBooking == true) {
        print(isBooking);
        final dataBoking =
            FirebaseFirestore.instance.collection('boking').add(data);
        Navigator.pop(context);
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Info Berhasil di Booking'),
            content: const Text(
                'datang ke lapangan yang sudah di boking sebelum 2 Jam\ untuk melakukan pembayaran DP. Jika lewat dari 2 jam maka di nyatakan batal untuk di boking '),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'Cancel'),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, 'OK'),
                child: const Text('OK'),
              ),
            ],
          ),
        );
        // } else {
        //   print(isBooking);
        // }

        // print(idBoking);
        // print(data);
        // await dataBoking;
        // namaC.clear();
        jamMulaiC.clear();
        jamBerakhirC.clear();
        tglC.clear();
      }
    }

    Future<TimeOfDay?> selectTime(
      BuildContext context,
      TimeOfDay initialDate,
    ) async {
      final TimeOfDay? picked = await showTimePicker(
        context: context,
        helpText: "Pilih Waktu",
        cancelText: "BATAL",
        confirmText: "OKE",
        hourLabelText: "Jam",
        minuteLabelText: "Menit",
        initialTime: initialDate,
      );
      if (picked != null && picked != initialDate) {
        return picked;
      }
      return null;
    }

    Future<String> getTime(
      BuildContext context,
    ) async {
      final data = await selectTime(context, TimeOfDay.now());
      if (data != null) {
        final hour = data.hour.toString().padLeft(2, '0');
        final minute = data.minute.toString().padLeft(2, '0');
        final formattedTime = "$hour : $minute";
        return formattedTime;
      }

      return "";
    }

    Future<DateTime?> selectDate(
      BuildContext context,
      DateTime initialDate,
    ) async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: DateTime.now(),
        lastDate: DateTime(2100),
      );
      if (picked != null) {
        return picked;
      }
      return null;
    }

    Future<String> getDate(BuildContext context,
        [bool isTanggal = false]) async {
      final data = await selectDate(context, DateTime.now());
      if (data != null) {
        final dateFormatter = DateFormat(dateFormat, "id_ID");
        final dateTanggalFormatter = DateFormat(dateTanggalFormat, "id_ID");
        final formattedDate = isTanggal
            ? dateTanggalFormatter.format(data)
            : dateFormatter.format(data);
        return formattedDate;
      }
      return "";
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('From input'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                // NetworkImage(
                //     'https://cdn.idntimes.com/content-images/community/2020/09/lapangan-futsal-94db8dd85c516f7bffe3836900ae1e6e_600x400.jpg'),
                // SizedBox(
                //   width: 800,
                //   child: Image.network(
                //       "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQrY4smZvOt89ZphE6sHKtuauXlo59C6_uyMtiK5Ne0MBChZN3AXAtWELq6brqsqvSc2LY&usqp=CAU"),
                // ),
                Image.network(
                  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQrY4smZvOt89ZphE6sHKtuauXlo59C6_uyMtiK5Ne0MBChZN3AXAtWELq6brqsqvSc2LY&usqp=CAU",
                  width: 300,
                ),
                Text(namaLap),
                // TextFormField(
                //     controller: namaC,
                //     decoration: const InputDecoration(
                //       labelText: 'Nama Penyewa',
                //     )),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                    onTap: () async {
                      jamMulaiC.text = await getTime(context);
                    },
                    controller: jamMulaiC,
                    decoration: const InputDecoration(
                      labelText: 'Jam Masuk',
                    )),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                    onTap: () async {
                      jamBerakhirC.text = await getTime(context);
                    },
                    controller: jamBerakhirC,
                    decoration: const InputDecoration(
                      labelText: 'Jam Selesai',
                    )),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                    onTap: () async {
                      tglC.text = await getDate(context);
                    },
                    controller: tglC,
                    decoration: const InputDecoration(
                      labelText: 'tanggal',
                    )),
                const SizedBox(
                  height: 20,
                ),
                Text('Harga lapangan perjam : $hargaLap'),

                // 12.sW,
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: SizedBox(
                    width: 12,
                    child: Divider(
                      thickness: 2,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    // updateDataLapangan();
                    updateDataBoking();
                  },
                  child: const Text('Boking Lapangan '),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
