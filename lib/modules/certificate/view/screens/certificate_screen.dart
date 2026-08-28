/*
@Author - yehenSamarasinghe
@Date - 2026/08/29
*/
import 'package:flutter/material.dart';
class CertificateScreen extends StatelessWidget {
  const CertificateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Certificates')),
      body: const Center(child: Text('Certificates — post-MVP')),
    );
  }
}
