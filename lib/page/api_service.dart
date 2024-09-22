import 'dart:convert';
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
      Buatlah sebuah proposal sponsorship yang komprehensif, profesional, dan menarik dalam Bahasa Indonesia untuk acara berikut. Proposal harus memiliki panjang sekitar 1500-2000 kata, mencakup semua aspek penting dari acara dan peluang sponsorship.

      Nama Acara: $eventName

      Ikuti struktur berikut dengan cermat, dan pastikan setiap bagian dielaborasi dengan baik:

      1. Halaman Sampul (tidak dihitung dalam jumlah kata):
         - Judul: "Proposal Sponsorship: [Nama Acara]"
         - Tanggal: [Tanggal Hari Ini]
         - Nama Organisasi Penyelenggara
         - Informasi Kontak

      2. Daftar Isi (tidak dihitung dalam jumlah kata):
         - Cantumkan semua bagian utama dengan nomor halaman

      3. Ringkasan Eksekutif (sekitar 200 kata):
         - Jelaskan secara singkat dan menarik tentang acara: $eventDescription
         - Uraikan mengapa acara ini unik dan mengapa sponsor harus terlibat
         - Sebutkan beberapa manfaat utama bagi sponsor

      4. Tentang Acara (sekitar 300 kata):
         - Deskripsi lengkap acara
         - Tujuan dan visi acara
         - Sejarah singkat (jika ada)
         - Tanggal, lokasi, dan durasi acara
         - Aktivitas atau program utama dalam acara

      5. Profil Audiens (sekitar 250 kata):
         - Informasi detail tentang audiens target: $audienceInfo
         - Analisis demografi yang mendalam: $demographics
         - Jelaskan bagaimana audiens ini relevan dan berharga bagi merek sponsor potensial
         - Sertakan data statistik atau hasil survei jika ada

      6. Peluang Pemasaran dan Visibilitas (sekitar 300 kata):
         - Daftar rinci media yang akan digunakan: $mediaList
         - Untuk setiap platform, jelaskan:
           * Bagaimana sponsor akan dipromosikan
           * Estimasi jangkauan dan exposure
           * Frekuensi penayangan/publikasi
         - Peluang branding di lokasi acara
         - Integrasi sponsor dalam materi promosi acara

      7. Dampak pada Merek Sponsor (sekitar 250 kata):
         - Analisis mendalam tentang potensi dampak pada merek sponsor: $brandImpact
         - Jelaskan bagaimana acara ini sejalan dengan nilai dan tujuan merek sponsor
         - Berikan contoh konkret bagaimana sponsor dapat meningkatkan citra mereknya

      8. Tujuan dan Manfaat Sponsorship (sekitar 250 kata):
         - Uraikan tujuan utama sponsorship: $sponsorPurpose
         - Jelaskan secara rinci bagaimana acara akan membantu mencapai tujuan tersebut: $eventHow
         - Daftar manfaat spesifik yang akan diperoleh sponsor, termasuk:
           * Peningkatan brand awareness
           * Peluang networking
           * Akses ke data audiens
           * Peluang penjualan langsung (jika relevan)

      9. Paket Sponsorship (sekitar 300 kata):
         - Rincian lengkap paket sponsorship yang ditawarkan: $subscriptionPackage
         - Untuk setiap tingkat sponsorship, jelaskan:
           * Harga
           * Hak dan keuntungan yang diperoleh
           * Visibilitas dan eksposur yang ditawarkan
           * Keuntungan eksklusif
         - Bandingkan nilai yang ditawarkan di setiap tingkat

      10. Rincian Tambahan (sekitar 200 kata):
          $proposalDetail
          - Tambahkan informasi penting lainnya yang belum tercakup

      11. Testimoni dan Endorsement (jika ada, sekitar 100 kata):
          - Kutipan dari sponsor atau peserta acara sebelumnya
          - Penghargaan atau pengakuan yang pernah diterima

      12. Tim Penyelenggara (sekitar 100 kata):
          - Profil singkat tim utama
          - Pengalaman dan keahlian relevan

      13. Ajakan Bertindak (sekitar 100 kata):
          - Buat ajakan yang kuat dan persuasif untuk sponsor bergabung
          - Jelaskan langkah-langkah konkret untuk berpartisipasi
          - Berikan tenggat waktu jika relevan

      14. Penutup (sekitar 150 kata):
          - Rangkum kembali poin-poin kunci proposal
          - Tekankan kembali nilai unik yang ditawarkan
          - Ucapkan terima kasih atas waktu dan pertimbangan mereka
          - Sertakan informasi kontak untuk tindak lanjut

      Instruksi Tambahan:
      - Gunakan bahasa Indonesia yang formal, profesional, namun tetap menarik dan persuasif.
      - Pastikan ada transisi yang halus antar bagian untuk menciptakan dokumen yang kohesif.
      - Gunakan data dan statistik (yang masuk akal) untuk mendukung klaim Anda.
      - Sesuaikan tone dan gaya bahasa dengan industri dan jenis acara yang diajukan.
      - Sertakan call-to-action yang jelas di seluruh dokumen.
      - Pastikan proposal memiliki struktur yang jelas dengan penggunaan heading dan subheading.

      Hasilkan proposal yang koheren, persuasif, dan profesional berdasarkan panduan di atas. Pastikan setiap bagian dielaborasi dengan baik dan relevan dengan informasi yang diberikan.
      ''';

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
