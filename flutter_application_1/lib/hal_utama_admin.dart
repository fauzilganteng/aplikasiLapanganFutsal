import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/halamanBoking.dart';
import 'package:flutter_application_1/halamanlogin.dart';
import 'package:google_fonts/google_fonts.dart';

class HalamanUtamaAdmin extends StatefulWidget {
  const HalamanUtamaAdmin({Key? key}) : super(key: key);

  @override
  State<HalamanUtamaAdmin> createState() => _HomePageState();
}

void toPage({required BuildContext ctx, required Widget page}) {
  Navigator.push(ctx, MaterialPageRoute(builder: (context) => page));
}

class _HomePageState extends State<HalamanUtamaAdmin> {
  final Stream<QuerySnapshot> booking =
      FirebaseFirestore.instance.collection('boking').snapshots();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Container(
              alignment: Alignment.topLeft,
              height: 45,
              width: 45,
              decoration: BoxDecoration(
                image: const DecorationImage(
                    image: NetworkImage(
                        "https://tse1.mm.bing.net/th?id=OIP.6OCaE_oCzFkm7972WOPdOAHaD_&pid=Api&P=0&h=180")),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                    color: Colors.white, style: BorderStyle.solid, width: 2),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              "Halo , Selamat Datang !",
              style: GoogleFonts.montserrat(color: Colors.white),
            ),
          ],
        ),
        actions: [
          Row(
            children: [
              Center(
                child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  const DesainHalamanLogin()));
                    },
                    child: const Icon(Icons.output)),
              ),
              const SizedBox(
                width: 10,
              )
            ],
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Text('list Boking'),
          StreamBuilder<QuerySnapshot>(
            stream: booking,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Text('Something went wrong');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Text("Loading");
              }
              return Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    String boking = '';
                    bool isBooking = false;
                    final data = snapshot.data!.docs[index];
                    final datald = data.id;
                    final dataMap = data.data() as Map;
                    final jamMulai =
                        dataMap['jamBoking']['jamMulai'] as Timestamp;
                    final jamSelesai =
                        dataMap['jamBoking']['jamSelesai'] as Timestamp;
                    final menitM = jamMulai.toDate().minute;
                    final menitS = jamSelesai.toDate().minute;
                    final jamM = jamMulai.toDate().hour;
                    final jamS = jamSelesai.toDate().hour;
                    final day = jamSelesai.toDate().day;
                    final month = jamSelesai.toDate().month;
                    final year = jamSelesai.toDate().year;
                    print(jamMulai.toString() + 'data Jam Mulai');
                    if (jamMulai.toDate().isBefore(DateTime.now()) &&
                        jamSelesai.toDate().isAfter(DateTime.now())) {
                      print('berjalan');
                      boking = 'berjalan';
                      isBooking = true;
                    } else if (jamSelesai.toDate().isAfter(DateTime.now())) {
                      print('di boking');
                      boking = 'di boking';
                    } else if (jamMulai.toDate().isBefore(DateTime.now())) {
                      print('telah selesai');
                      boking = 'telah selesai';
                    }
                    //  else {
                    //   boking = 'Belum terbooking';
                    //   print('Belum terbooking');
                    // }

                    return Card(
                      color: const Color.fromARGB(255, 156, 155, 152),
                      child: InkWell(
                        onTap: () {
                          // toPage(
                          //   ctx: context,
                          //   page: Booking(
                          //     dataParamt: data,
                          //   ),
                          // );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Text(dataMap['namaLapangan']),
                                Text(dataMap['namaPenyewa']),
                              ],
                            ),
                            Column(
                              children: [
                                Text(boking),
                                Text(
                                  '$jamM:$menitM s/d'
                                  '$jamS:$menitS\n'
                                  'Tanggal: $day/$month/$year',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class PenyewaanLapangan extends StatelessWidget {
  final String imagePath;

  const PenyewaanLapangan({
    super.key,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        height: 240,
        child: Stack(
          children: [
            Card(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              elevation: 10,
              child: Column(
                children: [
                  SizedBox(
                      width: double.infinity,
                      height: 150,
                      child: Image(image: NetworkImage(imagePath))),
                  Positioned(
                    bottom: 0,
                    left: 10,
                    child: SizedBox(
                      height: 70,
                      child: Column(
                        children: [
                          Text(
                            'Lapangan masih kosong',
                            style: GoogleFonts.montserrat(
                                fontSize: 17, fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
