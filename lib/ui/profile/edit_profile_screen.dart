import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // [GANTI] Pakai Supabase

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _nameController = TextEditingController();
  
  // [GANTI] Inisialisasi Supabase Client
  final _supabase = Supabase.instance.client;
  
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    // [GANTI] Cara ambil data user di Supabase
    final user = _supabase.auth.currentUser;
    // Ambil nama dari 'user_metadata' dengan key 'full_name'
    _nameController.text = user?.userMetadata?['full_name'] ?? "";
  }

  Future<void> _updateProfile() async {
    setState(() => isLoading = true);
    try {
      // [GANTI] Cara update data user di Supabase
      // Kita update 'user_metadata' bagian 'full_name'
      await _supabase.auth.updateUser(
        UserAttributes(
          data: {'full_name': _nameController.text.trim()},
        ),
      );
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profil berhasil diperbarui!")),
        );
        Navigator.pop(context); // Kembali ke halaman profile
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal update: $e")),
        );
      }
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Profile")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: "Nama Lengkap",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: isLoading ? null : _updateProfile,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                child: isLoading 
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      "Simpan Perubahan", 
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}