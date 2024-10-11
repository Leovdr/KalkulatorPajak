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
  String? selectedJenisPemotongan = 'PPh 21 Bulanan';
  String? selectedKodeObjekPajak;
  String? selectedPTKP;
  bool isGross = true;
  bool isTidakAda = false;
  double penghasilanBruto = 0;
  double dpp = 0;
  double pph21 = 0;

  final kodeObjekPajakList = ['Kode 1', 'Kode 2', 'Kode 3'];
  final ptkpList = ['PTKP A', 'PTKP B', 'PTKP C'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/images/logo.png', // Path gambar logo
              height: 40,
              width: 40,
            ),
            const SizedBox(width: 10), // Memberi jarak antara logo dan teks
            const Text('Kalkulator Pajak'), // Teks di sebelah kanan logo
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Divider(
                color: Colors.grey,
                thickness: 2,
              ),
              const SizedBox(height: 20), // Spasi antara garis dan teks PPh 21
              const Text(
                'PPh 21',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              // Dropdown untuk Jenis Pemotongan
              DropdownButtonFormField<String>(
                value: selectedJenisPemotongan,
                items: ['PPh 21 Bulanan', 'PPh 21 Tahunan']
                    .map((item) => DropdownMenuItem(
                          value: item,
                          child: Text(item),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedJenisPemotongan = value;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Jenis Pemotongan',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Dropdown untuk Kode Objek Pajak
              DropdownButtonFormField<String>(
                value: selectedKodeObjekPajak,
                items: kodeObjekPajakList
                    .map((item) => DropdownMenuItem(
                          value: item,
                          child: Text(item),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedKodeObjekPajak = value;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Kode Objek Pajak',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Skema Penghitungan
              const Text('Skema Penghitungan'),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<bool>(
                      title: const Text('Gross'),
                      value: true,
                      groupValue: isGross,
                      onChanged: (value) {
                        setState(() {
                          isGross = value!;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<bool>(
                      title: const Text('Gross Up'),
                      value: false,
                      groupValue: isGross,
                      onChanged: (value) {
                        setState(() {
                          isGross = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Switch untuk PPh Pasal 21
              SwitchListTile(
                title: const Text(
                    'Penghasilan yang telah dipotong PPh Pasal 21 pada masa pajak yang sama'),
                value: isTidakAda,
                onChanged: (value) {
                  setState(() {
                    isTidakAda = value;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Input untuk Penghasilan Bruto
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Penghasilan Bruto',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    penghasilanBruto = double.tryParse(value) ?? 0;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Dropdown untuk PTKP
              DropdownButtonFormField<String>(
                value: selectedPTKP,
                items: ptkpList
                    .map((item) => DropdownMenuItem(
                          value: item,
                          child: Text(item),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedPTKP = value;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'PTKP',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Tombol Hitung
              ElevatedButton(
                onPressed: _hitungPajak,
                child: const Text('Hitung'),
              ),
              const SizedBox(height: 16),

              // Hasil Penghitungan
              const Text(
                'PENGHITUNGAN PPh PASAL 21',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              // Output DPP, Tarif, PPh 21
              TextFormField(
                readOnly: true,
                initialValue: dpp.toStringAsFixed(2),
                decoration: const InputDecoration(
                  labelText: 'DPP',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                readOnly: true,
                initialValue: '${_getTarif()}%',
                decoration: const InputDecoration(
                  labelText: 'Tarif',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                readOnly: true,
                initialValue: pph21.toStringAsFixed(2),
                decoration: const InputDecoration(
                  labelText: 'PPh 21',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _hitungPajak() {
    setState(() {
      dpp = penghasilanBruto * 0.95; // 95% dari penghasilan bruto
      pph21 = dpp * _getTarif() / 100;
    });
  }

  double _getTarif() {
    if (dpp <= 50000000) {
      return 5;
    } else if (dpp <= 250000000) {
      return 15;
    } else if (dpp <= 500000000) {
      return 25;
    } else {
      return 30;
    }
  }
}
