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
                padding: const EdgeInsets.symmetric(vertical: 1.0),
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

              // Garis di bawah tombol hasil
              const SizedBox(height: 16),
              const Divider(thickness: 2, color: Colors.black),
              const SizedBox(height: 16),

              // Field dengan Radio di sebelah kiri dan input readonly di sebelah kanan
              _buildRadioTextField(
                labelText: 'PPn',
                value: '10%',
                groupValue: selectedPPn,
                onChanged: (value) {
                  setState(() {
                    selectedPPn = value;
                  });
                },
              ),
              _buildRadioTextField(
                labelText: 'PPh21 Eselon III',
                value: '5%',
                groupValue: selectedPPh21Eselon3,
                onChanged: (value) {
                  setState(() {
                    selectedPPh21Eselon3 = value;
                  });
                },
              ),
              _buildRadioTextField(
                labelText: 'PPh21 Eselon IV',
                value: '15%',
                groupValue: selectedPPh21Eselon4,
                onChanged: (value) {
                  setState(() {
                    selectedPPh21Eselon4 = value;
                  });
                },
              ),
              _buildRadioTextField(
                labelText: 'PPh 22',
                value: '1.5%',
                groupValue: selectedPPh22,
                onChanged: (value) {
                  setState(() {
                    selectedPPh22 = value;
                  });
                },
              ),
              _buildRadioTextField(
                labelText: 'PPh 23',
                value: '',
                groupValue: selectedPPh23,
                onChanged: (value) {
                  setState(() {
                    selectedPPh23 = value;
                  });
                },
              ),
              _buildRadioTextField(
                labelText: 'PAJAK DAERAH',
                value: '',
                groupValue: selectedPajakDaerah,
                onChanged: (value) {
                  setState(() {
                    selectedPajakDaerah = value;
                  });
                },
              ),

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

  // Widget for radio button + text + read-only field
  Widget _buildRadioTextField({
    required String labelText,
    required String value,
    required dynamic groupValue,
    required Function(dynamic) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Radio button di sebelah kiri
          Radio(
            value: true,
            groupValue: groupValue,
            onChanged: onChanged,
          ),
          
          // Text label di tengah
          Text(
            labelText,
            style: TextStyle(fontSize: 16),
          ),
          
          // Expanded untuk memaksa TextField berada di sebelah kanan
          Expanded(
            child: Align(
              alignment: Alignment.centerRight, // Align TextField ke kanan
              child: Container(
                width: 300, // Set width untuk field read-only
                child: TextField(
                  readOnly: true,
                  decoration: InputDecoration(
                    hintText: value,
                    border: OutlineInputBorder(),
                    isDense: true, // Membuat field lebih compact
                  ),
                ),
              ),
            ),
          ),
        ],
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
