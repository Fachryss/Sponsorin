import 'dart:convert';
import 'dart:async';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _apiUrl =
      'https://api.ai21.com/studio/v1/j2-mid/complete';

  static Future<String> generateProposal({
    required String eventName,
    required String eventDescription,
    required String audienceInfo,
    required String mediaList,
    required String demographics,
    required String brandImpact,
    required String sponsorPurpose,
    required String eventHow,
    required String proposalDetail,
    required String subscriptionPackage,
  }) async {
    try {
      print('Memulai permintaan ke AI21 API...');

      await dotenv.load(fileName: ".env");
      final apiKey = dotenv.env['AI21_API_KEY'] ?? '';

      if (apiKey.isEmpty) {
        throw Exception('API key tidak ditemukan dalam file .env');
      }

      final prompt = '''
Buatlah sebuah proposal sponsorship yang komprehensif, profesional, dan menarik dalam Bahasa Indonesia untuk acara berikut. Proposal harus memiliki panjang sekitar 1500-2000 kata, mencakup semua aspek penting dari acara dan peluang sponsorship. Hasilkan proposal dalam format final tanpa komentar, instruksi tambahan, atau penjelasan proses.

Nama Acara: $eventName

Struktur proposal:

1. Halaman Sampul:
   - Judul: "Proposal Sponsorship: [Nama Acara]"
   - Tanggal: [Tanggal Hari Ini]
   - Nama Organisasi Penyelenggara
   - Informasi Kontak

2. Daftar Isi

3. Ringkasan Eksekutif (sekitar 200 kata):
   - Ringkasan singkat dan menarik tentang acara: $eventDescription
   - Keunikan acara dan alasan sponsor harus terlibat
   - Manfaat utama bagi sponsor

4. Tentang Acara (sekitar 300 kata):
   - Deskripsi lengkap acara
   - Tujuan dan visi acara
   - Sejarah singkat (jika ada)
   - Tanggal, lokasi, dan durasi acara
   - Aktivitas atau program utama

5. Profil Audiens (sekitar 250 kata):
   - Informasi detail tentang audiens target: $audienceInfo
   - Analisis demografi: $demographics
   - Relevansi audiens bagi merek sponsor potensial
   - Data statistik atau hasil survei (jika ada)

6. Peluang Pemasaran dan Visibilitas (sekitar 300 kata):
   - Daftar rinci media yang akan digunakan: $mediaList
   - Untuk setiap platform:
     * Metode promosi sponsor
     * Estimasi jangkauan dan exposure
     * Frekuensi penayangan/publikasi
   - Peluang branding di lokasi acara
   - Integrasi sponsor dalam materi promosi

7. Dampak pada Merek Sponsor (sekitar 250 kata):
   - Analisis potensi dampak pada merek sponsor: $brandImpact
   - Keselarasan acara dengan nilai dan tujuan merek sponsor
   - Contoh konkret peningkatan citra merek

8. Tujuan dan Manfaat Sponsorship (sekitar 250 kata):
   - Tujuan utama sponsorship: $sponsorPurpose
   - Cara acara membantu mencapai tujuan tersebut: $eventHow
   - Manfaat spesifik untuk sponsor:
     * Peningkatan brand awareness
     * Peluang networking
     * Akses ke data audiens
     * Peluang penjualan langsung (jika relevan)

9. Paket Sponsorship (sekitar 300 kata):
   - Rincian paket sponsorship: $subscriptionPackage
   - Untuk setiap tingkat sponsorship:
     * Harga
     * Hak dan keuntungan
     * Visibilitas dan eksposur
     * Keuntungan eksklusif
   - Perbandingan nilai antar tingkat

10. Rincian Tambahan (sekitar 200 kata):
    $proposalDetail

11. Testimoni dan Endorsement (jika ada, sekitar 100 kata)

12. Tim Penyelenggara (sekitar 100 kata):
    - Profil singkat tim utama
    - Pengalaman dan keahlian relevan

13. Ajakan Bertindak (sekitar 100 kata):
    - Ajakan persuasif untuk bergabung
    - Langkah-langkah konkret untuk berpartisipasi
    - Tenggat waktu (jika relevan)

14. Penutup (sekitar 150 kata):
    - Rangkuman poin-poin kunci
    - Penekanan nilai unik yang ditawarkan
    - Ucapan terima kasih
    - Informasi kontak untuk tindak lanjut

Panduan tambahan:
- Gunakan bahasa Indonesia formal, profesional, menarik, dan persuasif.
- Buat transisi halus antar bagian untuk dokumen yang kohesif.
- Gunakan data dan statistik yang masuk akal untuk mendukung klaim.
- Sesuaikan tone dan gaya bahasa dengan industri dan jenis acara.
- Sertakan call-to-action yang jelas di seluruh dokumen.
- Gunakan struktur yang jelas dengan heading dan subheading.

Hasilkan proposal final tanpa komentar tambahan atau penjelasan proses pembuatan.''';

      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      };

      final body = jsonEncode({
        "prompt": prompt,
        "numResults": 1,
        "maxTokens": 2048, // Ditingkatkan untuk proposal yang lebih panjang
        "temperature": 0.7,
        "topP": 0.9,
        "stopSequences": [
          "14. Penutup",
          "\\n\\n14."
        ] // Menghentikan generasi pada bagian penutup
      });

      print('API URL: $_apiUrl');
      print('Headers: ${jsonEncode(headers)}');
      print('Request Body: $body');

      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: headers,
        body: body,
      );

      print('Response status: ${response.statusCode}');
      print('Response headers: ${response.headers}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['completions'] is List && data['completions'].isNotEmpty) {
          return data['completions'][0]['data']['text'] ??
              'Tidak ada teks yang dihasilkan.';
        } else {
          throw Exception('Format respons tidak sesuai: $data');
        }
      } else {
        throw Exception(
            'Gagal generate proposal. Status Code: ${response.statusCode}, Body: ${response.body}');
      }
    } catch (e, stacktrace) {
      print('Error saat generate proposal: $e');
      print('Stack trace: $stacktrace');
      return 'Error: $e';
    }
  }
}



// import 'dart:convert';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:http/http.dart' as http;

// class ApiService {
//   static const String _apiUrl = 'https://api.llama-api.com/chat/completions'; // Ganti dengan URL Llama2 Anda

//   static Future<String> generateProposal({
//     required String eventName,
//     required String eventDescription,
//     required String audienceInfo,
//     required String mediaList,
//     required String demographics,
//     required String brandImpact,
//     required String sponsorPurpose,
//     required String eventHow,
//     required String proposalDetail,
//     required String subscriptionPackage,
//   }) async {
//     try {
//       print('Mengirim permintaan ke API Llama2...');

//       final prompt = '''
//       Buat proposal sponsorship acara dengan informasi berikut:
//       Nama Acara: $eventName
//       Deskripsi: $eventDescription
//       Informasi Audiens: $audienceInfo
//       Media yang Digunakan: $mediaList
//       Demografi Audiens: $demographics
//       Dampak pada Brand: $brandImpact
//       Tujuan Sponsor: $sponsorPurpose
//       Cara Acara Membantu Sponsor: $eventHow
//       Rincian Proposal: $proposalDetail
//       Paket Sponsorship: $subscriptionPackage
//       ''';

//       final response = await http.post(
//         Uri.parse(_apiUrl),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer LA-a41e61133f5f46d795dbeab450f82ba0bcc216f88a03408a9c47d56136b700c5', // Ganti dengan kunci API Llama2
//         },
//         body: jsonEncode({
//           "input": prompt,
//           "parameters": {
//             "max_length": 300,
//             "num_return_sequences": 1,
//             "temperature": 0.9,
//             "top_p": 0.95,
//           },
//         }),
//       );

//       print('Response status: ${response.statusCode}');
//       print('Response body: ${response.body}');

//       if (response.statusCode == 200) {
//         var data = jsonDecode(response.body);
//         if (data is Map && data.containsKey('output')) {
//           // Ganti 'output' dengan nama field yang benar sesuai respons Llama2
//           return data['output'] ?? 'Tidak ada teks yang dihasilkan.';
//         } else {
//           throw Exception('Format respons tidak sesuai: $data');
//         }
//       } else {
//         throw Exception('Gagal generate proposal. Status Code: ${response.statusCode}, Body: ${response.body}');
//       }
//     } catch (e, stacktrace) {
//       print('Error saat generate proposal: $e');
//       print('Stack trace: $stacktrace');
//       return 'Error: $e';
//     }
//   }
// }





// import 'dart:convert';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:http/http.dart' as http;

// class ApiService {
//   static String get _apiKey => dotenv.env['API_KEY']!;
//   static const String _apiUrl = 'https://api.openai.com/v1/completions';

//   // Fungsi untuk generate proposal dengan menggunakan GPT API
//   static Future<String> generateProposal({
//     required String eventName,
//     required String eventDescription,
//     required String audienceInfo,
//     required String mediaList,
//     required String demographics,
//     required String brandImpact,
//     required String sponsorPurpose,
//     required String eventHow,
//     required String proposalDetail,
//     required String subscriptionPackage,
//   }) async {
//     try {
//       // Debug log untuk input yang dikirim
//       print('Mengirim permintaan ke API GPT...');
//       print('Nama Acara: $eventName');
//       print('Deskripsi: $eventDescription');
//       print('Informasi Audiens: $audienceInfo');
//       print('Media: $mediaList');
//       print('Demografi: $demographics');
//       print('Dampak: $brandImpact');
//       print('Tujuan Sponsor: $sponsorPurpose');
//       print('Cara Membantu Sponsor: $eventHow');
//       print('Detail Proposal: $proposalDetail');
//       print('Paket Sponsorship: $subscriptionPackage');

//       // Panggil API dengan retry menggunakan exponential backoff
//       return await _retryWithBackoff(() async {
//         final response = await http.post(
//           Uri.parse(_apiUrl),
//           headers: {
//             'Content-Type': 'application/json',
//             'Authorization': 'Bearer $_apiKey',
//           },
//           body: jsonEncode({
//             "model": "gpt-3.5-turbo",
//             "prompt": '''
//             Buat proposal sponsorship acara dengan informasi berikut:
//             Nama Acara: $eventName
//             Deskripsi: $eventDescription
//             Informasi Audiens: $audienceInfo
//             Media yang Digunakan: $mediaList
//             Demografi Audiens: $demographics
//             Dampak pada Brand: $brandImpact
//             Tujuan Sponsor: $sponsorPurpose
//             Cara Acara Membantu Sponsor: $eventHow
//             Rincian Proposal: $proposalDetail
//             Paket Sponsorship: $subscriptionPackage
//             ''',
//             "max_tokens": 1000,  // Mengurangi max_tokens untuk menghindari error
//           }),
//         );

//         print('Response status: ${response.statusCode}');
//         print('Response body: ${response.body}');

//         if (response.statusCode == 200) {
//           var data = jsonDecode(response.body);
//           return data['choices'][0]['text'];
//         } else {
//           throw Exception('Failed to generate proposal. Status Code: ${response.statusCode}');
//         }
//       });
//     } catch (e, stacktrace) {
//       print('Error saat generate proposal: $e');
//       print('Stack trace: $stacktrace');
//       return 'Error: $e';
//     }
//   }

//   // Fungsi untuk retry dengan exponential backoff
//   static Future<String> _retryWithBackoff(
//       Future<String> Function() apiRequest,
//       {int maxAttempts = 5, int initialDelay = 2}) async {
//     for (int attempt = 0; attempt < maxAttempts; attempt++) {
//       try {
//         return await apiRequest();
//       } catch (e) {
//         if (attempt < maxAttempts - 1) {
//           // Jika gagal, tunggu sesuai exponential backoff
//           int delayInSeconds = initialDelay * (attempt + 1);
//           print('Gagal, mencoba lagi dalam $delayInSeconds detik...');
//           await Future.delayed(Duration(seconds: delayInSeconds));
//         } else {
//           // Jika sudah mencapai jumlah percobaan maksimal
//           throw Exception('Gagal setelah $maxAttempts percobaan');
//         }
//       }
//     }
//     throw Exception('Gagal melakukan request API');
//   }
// }
