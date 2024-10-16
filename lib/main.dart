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
                    onPressed: _hitungPajaak,
                    child: const Text('HASIL'),
                  ),
                ),
              ),

              // Field Input NOMINAL DPP
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                  readOnly: true,
                  controller: TextEditingController(
                      text: "${nominalDpp.toStringAsFixed(2)}"),
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
                value: selectedPPn ? hitungPPn(nominal).toStringAsFixed(2) : '',
                groupValue: selectedPPn,
                onChanged: (value) {
                  if (!isDpp) {
                    setState(() {
                      selectedPPn = value;
                    });
                  }
                },
              ),
              _buildRadioTextField(
                labelText: 'PPh21 Eselon III',
                value: selectedPPh21Eselon3
                    ? hitungPPh21Eselon3(nominal).toStringAsFixed(2)
                    : '',
                groupValue: selectedPPh21Eselon3,
                onChanged: (value) {
                  if (!isDpp) {
                    setState(() {
                      selectedPPh21Eselon3 = value;
                    });
                  }
                },
              ),
              _buildRadioTextField(
                labelText: 'PPh21 Eselon IV',
                value: selectedPPh21Eselon4
                    ? hitungPPh21Eselon4(nominal).toStringAsFixed(2)
                    : '',
                groupValue: selectedPPh21Eselon4,
                onChanged: (value) {
                  if (!isDpp) {
                    setState(() {
                      selectedPPh21Eselon4 = value;
                    });
                  }
                },
              ),
              _buildRadioTextField(
                labelText: 'PPh 22',
                value: selectedPPh22
                    ? hitungPPh22(nominal).toStringAsFixed(2)
                    : '',
                groupValue: selectedPPh22,
                onChanged: (value) {
                  if (!isDpp) {
                    setState(() {
                      selectedPPh22 = value;
                    });
                  }
                },
              ),
              _buildRadioTextField(
                labelText: 'PPh 23',
                value: selectedPPh23
                    ? hitungPPh23(nominal).toStringAsFixed(2)
                    : '',
                groupValue: selectedPPh23,
                onChanged: (value) {
                  if (!isDpp) {
                    setState(() {
                      selectedPPh23 = value;
                    });
                  }
                },
              ),
              _buildRadioTextField(
                labelText: 'PAJAK DAERAH',
                value: selectedPajakDaerah
                    ? hitungPajakDaerah(nominal).toStringAsFixed(2)
                    : '',
                groupValue: selectedPajakDaerah,
                onChanged: (value) {
                  if (!isDpp) {
                    setState(() {
                      selectedPajakDaerah = value;
                    });
                  }
                },
              ),

              // Text bold "NILAI BERSIH SEMUA PERHITUNGAN"
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Center(
                  child: Text(
                    'NILAI BERSIH SEMUA PERHITUNGAN',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              // Field NILAI BERSIH (read-only)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: _buildReadOnlyField(
                    'NILAI BERSIH', hasil.toStringAsFixed(2)),
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
            toggleable: true,
          ),

          // Text label di tengah
          Text(
            labelText,
            style: const TextStyle(fontSize: 16),
          ),

          // Expanded untuk memaksa TextField berada di sebelah kanan
          Expanded(
            child: Align(
              alignment: Alignment.centerRight, // Align TextField ke kanan
              child: SizedBox(
                width: 300, // Set width untuk field read-only
                child: TextField(
                  readOnly: true,
                  decoration: InputDecoration(
                    hintText: value,
                    border: const OutlineInputBorder(),
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

  void _hitungPajaak() {
    setState(() {
      // Periksa apakah DPP dipilih
      if (isDpp) {
        setState(() {
          selectedPPn = hasil > 0;
          _hitungPajaak();
        });
        nominalDpp = (100 / 111) * nominal;
        hasil = (11 / 111) * nominal; // PPN dihitung berdasarkan nilai nominal
      } else {
        nominalDpp = 0;
        hasil = 0; // Reset hasil

        // Hitung pajak berdasarkan radio button yang dipilih
        if (selectedPPn) {
          hasil += hitungPPn(nominal);
        }
        if (selectedPPh21Eselon3) {
          hasil += hitungPPh21Eselon3(nominal);
        }
        if (selectedPPh21Eselon4) {
          hasil += hitungPPh21Eselon4(nominal);
        }
        if (selectedPPh22) {
          hasil += hitungPPh22(nominal);
        }
        if (selectedPPh23) {
          hasil += hitungPPh23(nominal);
        }
        if (selectedPajakDaerah) {
          hasil += hitungPajakDaerah(nominal);
        }

        // Deselect all radio buttons
        selectedPPn = false;
        selectedPPh21Eselon3 = false;
        selectedPPh21Eselon4 = false;
        selectedPPh22 = false;
        selectedPPh23 = false;
        selectedPajakDaerah = false;
      }
    });
  }

  // Fungsi untuk menghitung PPN dengan nilai 10%
  double hitungPPn(double nominal) {
    return nominal * 0.10;
  }

  // Fungsi untuk menghitung PPh21 Eselon 3 dengan nilai 5%
  double hitungPPh21Eselon3(double nominal) {
    return nominal * 0.05;
  }

  // Fungsi untuk menghitung PPh21 Eselon 4 dengan nilai 15%
  double hitungPPh21Eselon4(double nominal) {
    return nominal * 0.15;
  }

  // Fungsi untuk menghitung PPh 22 dengan nilai 1.5%
  double hitungPPh22(double nominal) {
    return nominal * 0.015;
  }

  // Fungsi untuk menghitung PPh 23 dengan nilai 2%
  double hitungPPh23(double nominal) {
    return nominal * 0.02;
  }

  // Fungsi untuk menghitung Pajak Daerah dengan nilai 1%
  double hitungPajakDaerah(double nominal) {
    return nominal * 0.01;
  }
}
