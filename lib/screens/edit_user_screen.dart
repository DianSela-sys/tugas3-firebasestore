import 'package:appjumat/model/user_model.dart';
import 'package:appjumat/repositories/firestore_repository.dart';
import 'package:flutter/material.dart';

class EditUserScreen extends StatefulWidget {
  final User user;
  EditUserScreen({required this.user});

  @override
  _EditUserScreenState createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> {
  final FirestoreRepository _firestoreRepository = FirestoreRepository();
  late TextEditingController _nameController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _emailController = TextEditingController(text: widget.user.email);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100], // Warna background biru muda
      appBar: AppBar(
        title: Text(
          'Edit Pengguna',
          style: TextStyle(color: Colors.white), // Warna teks putih
        ),
        backgroundColor: Colors.blue, // Warna AppBar biru
        iconTheme: IconThemeData(color: Colors.white), // Warna ikon putih
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 5, // Menambahkan efek bayangan pada card
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white, // Warna putih untuk kontras dengan background biru
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _nameController,
                    style: TextStyle(color: Colors.black), // Warna teks input hitam
                    decoration: InputDecoration(
                      labelText: 'Nama',
                      labelStyle: TextStyle(color: Colors.blue), // Warna label biru
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person, color: Colors.blue),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: _emailController,
                    style: TextStyle(color: Colors.black), // Warna teks input hitam
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(color: Colors.blue), // Warna label biru
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email, color: Colors.blue),
                    ),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      String name = _nameController.text.trim();
                      String email = _emailController.text.trim();
                      if (name.isEmpty || email.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Nama dan email tidak boleh kosong')),
                        );
                        return;
                      }
                      try {
                        await _firestoreRepository.updateUser(widget.user.id, {
                          'name': name,
                          'email': email,
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Data berhasil diperbarui!')),
                        );
                        Navigator.pop(context);
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Gagal memperbarui data: $e')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue, // Warna tombol biru
                      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Simpan Perubahan',
                      style: TextStyle(color: Colors.white), // Warna teks putih
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
