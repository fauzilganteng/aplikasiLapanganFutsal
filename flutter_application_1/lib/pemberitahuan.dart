import 'package:flutter/material.dart';

class Pemberitahuan extends StatefulWidget {
  const Pemberitahuan({super.key});

  @override
  State<Pemberitahuan> createState() => _PemberitahuanState();
}

class _PemberitahuanState extends State<Pemberitahuan> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text('pemberitahuan'),
          ],
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            width: 10,
            height: 10,
          ),
          Center(
            child: Text(
                'Datang Kelokasi Lapangan Sebelum 30menit Untuk Melakukan Pembayaran DP Jika Lewat Dari 30menit Maka Lapangan yang di Boking itu Batal'),
          ),
        ],
      ),
    );
  }
}
