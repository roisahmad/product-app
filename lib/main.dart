import 'package:flutter/material.dart';
import 'package:product_app/viewmodels/barang_viewmodel.dart';
import 'package:product_app/viewmodels/kategori_barang_viewmodel.dart';
import 'package:product_app/views/barang_list_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => BarangViewModel()),
        ChangeNotifierProvider(create: (context) => KategoriBarangViewModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: BarangListScreen(),
      ),
    );
  }
}
