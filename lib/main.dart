import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kalkulator Pajak',
      theme: ThemeData(
        primaryColor: const Color(0xFFD1291E),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isDpp = true;
  bool selectedPPn = false;
  bool selectedPPh21Eselon3 = false;
  bool selectedPPh21Eselon4 = false;
  bool selectedPPh22 = false;
  bool selectedPPh23 = false;
  bool selectedPajakDaerah = false;

  double nominal = 0;
  double nominalDpp = 0;
  double hasil = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/images/logo.png', // Path to your logo
              height: 40,
            ),
            const SizedBox(width: 10),
            const Text('Kalkulator Pajak'),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Field Input NOMINAL
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'NOMINAL',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      nominal = double.tryParse(value) ?? 0;
                    });
                  },
                ),
              ),
              const SizedBox(height: 16),

              // RadioButton DPP / TANPA DPP
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: RadioListTile<bool>(
                        title: const Text('DPP'),
                        value: true,
                        groupValue: isDpp,
                        onChanged: (value) {
                          setState(() {
                            isDpp = value!;
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<bool>(
                        title: const Text('TANPA DPP'),
                        value: false,
                        groupValue: isDpp,
                        onChanged: (value) {
                          setState(() {
                            isDpp = value!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),

              // Field Input NOMINAL DPP
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'NOMINAL DPP',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      nominalDpp = double.tryParse(value) ?? 0;
                    });
                  },
                ),
              ),
              const SizedBox(height: 16),

              // Tombol HASIL
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Center(
                  child: ElevatedButton(
                    onPressed: _hitungPajak,
                    child: const Text('HASIL'),
                  ),
                ),
              ),

              // Garis di bawah tombol hasil
              const SizedBox(height: 16),
              const Divider(thickness: 2, color: Colors.black),
              const SizedBox(height: 16),

              // Field PPn dengan radio list di samping kiri
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    Radio(
                      value: true,
                      groupValue: selectedPPn,
                      onChanged: (value) {
                        setState(() {
                          selectedPPn = value!;
                        });
                      },
                    ),
                    Expanded(
                      child: _buildReadOnlyField('PPn', '10%'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Field PPh21 Eselon III Kebawah dengan radio list di samping kiri
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    Radio(
                      value: true,
                      groupValue: selectedPPh21Eselon3,
                      onChanged: (value) {
                        setState(() {
                          selectedPPh21Eselon3 = value!;
                        });
                      },
                    ),
                    Expanded(
                      child: _buildReadOnlyField('PPh21 Eselon III Kebawah', '5%'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Field PPh21 Eselon IV dengan radio list di samping kiri
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    Radio(
                      value: true,
                      groupValue: selectedPPh21Eselon4,
                      onChanged: (value) {
                        setState(() {
                          selectedPPh21Eselon4 = value!;
                        });
                      },
                    ),
                    Expanded(
                      child: _buildReadOnlyField('PPh21 Eselon IV', '15%'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Field PPh 22 dengan radio list di samping kiri
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    Radio(
                      value: true,
                      groupValue: selectedPPh22,
                      onChanged: (value) {
                        setState(() {
                          selectedPPh22 = value!;
                        });
                      },
                    ),
                    Expanded(
                      child: _buildReadOnlyField('PPh 22', '2.5%'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Field PPh 23 dengan radio list di samping kiri (read-only)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    Radio(
                      value: true,
                      groupValue: selectedPPh23,
                      onChanged: (value) {
                        setState(() {
                          selectedPPh23 = value!;
                        });
                      },
                    ),
                    Expanded(
                      child: _buildReadOnlyField('PPh 23', ''),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Field PAJAK DAERAH dengan radio list di samping kiri (read-only)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    Radio(
                      value: true,
                      groupValue: selectedPajakDaerah,
                      onChanged: (value) {
                        setState(() {
                          selectedPajakDaerah = value!;
                        });
                      },
                    ),
                    Expanded(
                      child: _buildReadOnlyField('PAJAK DAERAH', ''),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Text bold "NILAI BERSIH SEMUA PERHITUNGAN"
              Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Center(
                child: const Text(
                  'NILAI BERSIH SEMUA PERHITUNGAN',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            
              // Field NILAI BERSIH (read-only)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: _buildReadOnlyField('NILAI BERSIH', ''),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget for read-only text fields
  Widget _buildReadOnlyField(String label, String value) {
    return TextFormField(
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        filled: true,
        fillColor: Colors.grey.shade200,
      ),
      initialValue: value,
    );
  }

  // Function to calculate taxes
  void _hitungPajak() {
    setState(() {
      hasil = nominal * 0.10; // Contoh sederhana menghitung PPn 10%
    });
  }
}
