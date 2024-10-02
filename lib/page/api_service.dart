import 'dart:convert';
import 'dart:async';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _apiUrl =
      'https://api.ai21.com/studio/v1/chat/completions'; // Ganti dengan URL API Jamba yang benar

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
      print('Memulai permintaan ke Jamba API...');

      // await dotenv.load(fileName: ".env");
      final apiKey = 'lmCls71dZH3ads0aVL9jwp5wXg5a0QIU';

      if (apiKey.isEmpty) {
        throw Exception('API key tidak ditemukan dalam file .env');
      }

      String eventDateLocation = '5 - 7 Oktober 2022, SMK Telkom Malang';
      String expectedAttendees = '1000 - 1500 orang';

      String companyName = 'PT Good Day Beverages Indonesia';
      String companyDescription =
          'PT Good Day Beverages Indonesia adalah perusahaan FMCG yang berfokus pada produksi dan distribusi berbagai varian minuman kopi siap minum (RTD) di Indonesia.';
      String industryType =
          'FMCG (Fast-Moving Consumer Goods), Makanan dan Minuman';
      String companyTargetMarket =
          'Target pasar kami adalah generasi milenial dan Gen Z berusia antara 18-35 tahun yang menginginkan minuman kopi dengan rasa yang inovatif dan mudah diakses.';
      String companyBusinessGoals =
          'Tujuan jangka pendek kami adalah meningkatkan pangsa pasar sebesar 15% di segmen minuman kopi siap saji dalam satu tahun.';
      String companyValuesMission =
          'Nilai inti perusahaan kami adalah kreativitas, keunikan, dan kedekatan dengan konsumen.';
      String companyContact =
          'Email: info@goodday.com Telepon: +62 21 1234 5678 Alamat: Jl. Kopi No. 9, Jakarta, Indonesia';

      final prompt = '''
      # Template Prompt untuk AI-Generated Sponsorship Proposal

Buatlah sebuah proposal sponsorship yang komprehensif, profesional, dan menarik dalam Bahasa Indonesia untuk acara berikut. Proposal harus memiliki panjang sekitar 2000-2500 kata, mencakup semua aspek penting dari acara dan peluang sponsorship, dengan fokus khusus pada kesesuaian dengan strategi dan tujuan bisnis sponsor. Hasilkan proposal dalam format final tanpa komentar, instruksi tambahan, atau penjelasan proses.

## Informasi Acara:
- Nama Acara: $eventName
- Deskripsi Acara: $eventDescription
- Tanggal dan Lokasi: $eventDateLocation
- Jumlah Peserta yang Diharapkan: $expectedAttendees

## Informasi Perusahaan Target:
- Nama Perusahaan: $companyName
- Deskripsi Perusahaan: $companyDescription
- Jenis Industri: $industryType
- Target Pasar Perusahaan: $companyTargetMarket
- Tujuan Bisnis Perusahaan: $companyBusinessGoals
- Nilai dan Misi Perusahaan: $companyValuesMission
- Kontak Perusahaan: $companyContact

## Struktur proposal:

1. Halaman Sampul:
   - Judul: "Proposal Sponsorship: [Nama Acara] untuk [Nama Perusahaan]"
   - Tanggal: [Tanggal Hari Ini]
   - Nama Organisasi Penyelenggara
   - Informasi Kontak

2. Daftar Isi

3. Ringkasan Eksekutif (sekitar 250 kata):
   - Ringkasan singkat dan menarik tentang acara
   - Keunikan acara dan relevansinya dengan [Nama Perusahaan]
   - Manfaat utama bagi sponsor, disesuaikan dengan tujuan bisnis [Nama Perusahaan]
   - Highlight kesesuaian strategis antara acara dan perusahaan

4. Profil Acara dan Kesesuaian dengan Strategi Sponsor (sekitar 400 kata):
   - Deskripsi lengkap acara
   - Tujuan dan visi acara
   - Sejarah singkat (jika ada)
   - Tanggal, lokasi, dan durasi acara
   - Aktivitas atau program utama
   - Analisis mendalam tentang bagaimana acara ini sejalan dengan:
     * Strategi pemasaran [Nama Perusahaan]
     * Tujuan jangka panjang [Nama Perusahaan]
     * Nilai-nilai dan misi [Nama Perusahaan]

5. Profil dan Data Audiens (sekitar 350 kata):
   - Informasi detail tentang audiens target: $audienceInfo
   - Analisis demografi mendalam: $demographics
     * Usia, jenis kelamin, pekerjaan, pendapatan
     * Minat dan preferensi
     * Perilaku konsumen
   - Relevansi audiens bagi [Nama Perusahaan]
   - Data statistik atau hasil survei (jika ada)
   - Perbandingan antara audiens acara dan target pasar [Nama Perusahaan]

6. Jangkauan Media dan Potensi Exposure (sekitar 350 kata):
   - Daftar rinci media yang akan digunakan: $mediaList
   - Untuk setiap platform:
     * Metode promosi sponsor
     * Estimasi jangkauan dan exposure (gunakan data konkret)
     * Frekuensi penayangan/publikasi
   - Peluang branding di lokasi acara
   - Integrasi sponsor dalam materi promosi
   - Analisis tentang bagaimana exposure ini mendukung tujuan bisnis [Nama Perusahaan]

7. Dampak dan Potensi Acara (sekitar 300 kata):
   - Analisis potensi dampak pada merek sponsor: $brandImpact
   - Proyeksi peningkatan brand awareness untuk [Nama Perusahaan]
   - Estimasi ROI berdasarkan investasi sponsorship
   - Potensi leads atau konversi penjualan
   - Dampak jangka panjang pada positioning [Nama Perusahaan] di industri

8. Kesesuaian dengan Tujuan Bisnis Sponsor (sekitar 350 kata):
   - Analisis mendalam tentang tujuan bisnis [Nama Perusahaan]: $companyBusinessGoals
   - Penjelasan rinci bagaimana acara membantu mencapai tujuan tersebut: $eventHow
   - Strategi spesifik yang akan diimplementasikan untuk mencapai tujuan bisnis sponsor
   - Metrik dan KPI yang akan digunakan untuk mengukur kesuksesan

9. Manfaat Sponsorship (sekitar 300 kata):
   - Manfaat spesifik untuk [Nama Perusahaan]:
     * Peningkatan brand awareness (dengan estimasi persentase atau angka)
     * Peluang networking dengan stakeholder kunci
     * Akses ke data audiens yang berharga
     * Peluang penjualan langsung (jika relevan)
     * Customer engagement opportunities
   - Penjelasan bagaimana setiap manfaat mendukung strategi dan tujuan [Nama Perusahaan]

10. Paket Sponsorship (sekitar 350 kata):
    - Rincian paket sponsorship: $subscriptionPackage
    - Untuk setiap tingkat sponsorship:
      * Harga
      * Hak dan keuntungan detail
      * Visibilitas dan eksposur spesifik
      * Keuntungan eksklusif
    - Perbandingan nilai antar tingkat
    - Penjelasan bagaimana setiap paket disesuaikan dengan kebutuhan [Nama Perusahaan]

11. Rincian Tambahan (sekitar 200 kata):
    $proposalDetail
    - Informasi logistik acara
    - Rencana kontingensi (jika relevan)
    - Asuransi dan pertimbangan hukum

12. Tim Penyelenggara (sekitar 150 kata):
    - Profil singkat tim utama
    - Pengalaman dan keahlian relevan
    - Track record kesuksesan acara sebelumnya

13. Testimoni dan Endorsement (jika ada, sekitar 150 kata)
    - Testimoni dari sponsor sebelumnya
    - Endorsement dari tokoh industri atau influencer

14. Struktur Proposal dan Evaluasi (sekitar 200 kata):
    - Penjelasan singkat tentang struktur proposal
    - Metode evaluasi kesuksesan sponsorship
    - Timeline pelaporan dan feedback

15. Ajakan Bertindak (sekitar 150 kata):
    - Ajakan persuasif untuk bergabung, disesuaikan dengan [Nama Perusahaan]
    - Langkah-langkah konkret untuk berpartisipasi
    - Tenggat waktu (jika relevan)
    - Penawaran untuk diskusi lebih lanjut atau presentasi

16. Penutup (sekitar 150 kata):
    - Rangkuman poin-poin kunci
    - Penekanan nilai unik yang ditawarkan kepada [Nama Perusahaan]
    - Ucapan terima kasih
    - Informasi kontak untuk tindak lanjut

Panduan tambahan:
- Gunakan bahasa Indonesia formal, profesional, menarik, dan persuasif.
- Buat transisi halus antar bagian untuk dokumen yang kohesif.
- Gunakan data dan statistik konkret untuk mendukung setiap klaim.
- Sesuaikan tone dan gaya bahasa dengan industri [Nama Perusahaan].
- Sertakan call-to-action yang jelas dan relevan di seluruh dokumen.
- Gunakan struktur yang jelas dengan heading dan subheading.
- Pastikan setiap bagian menunjukkan pemahaman mendalam tentang [Nama Perusahaan] dan kebutuhannya.
- Fokus pada mendemonstrasikan nilai dan ROI yang jelas bagi [Nama Perusahaan].

Hasilkan proposal final tanpa komentar tambahan atau penjelasan proses pembuatan.

''';

      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      };

      final body = jsonEncode({
        'model': 'jamba-1.5-large', // Ganti dengan nama model Jamba yang benar
        'messages': [
          {
            'role': 'system',
            'content':
                'Anda adalah asisten AI yang ahli dalam membuat proposal sponsorship yang detail dan profesional.'
          },
          {'role': 'user', 'content': prompt}
        ],
        'temperature': 0.7,
        'max_tokens': 3000,
        'top_p': 1,
        'frequency_penalty': 0,
        'presence_penalty': 0,
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
        if (data['choices'] is List && data['choices'].isNotEmpty) {
          return data['choices'][0]['message']['content'] ??
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
// import 'dart:async';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:http/http.dart' as http;

// class ApiService {
//   static const String _apiUrl =
//       'https://api.ai21.com/studio/v1/j2-ultra/complete';

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
//       print('Memulai permintaan ke AI21 API...');

//       await dotenv.load(fileName: ".env");
//       final apiKey = dotenv.env['AI21_API_KEY'] ?? '';

//       if (apiKey.isEmpty) {
//         throw Exception('API key tidak ditemukan dalam file .env');
//       }

//       // Data placeholder untuk proposal

//       String eventDateLocation = '5 - 7 Oktober 2022, SMK Telkom Malang';
//       String expectedAttendees = '1000 - 1500 orang';

//       String companyName = 'PT Good Day Beverages Indonesia';
//       String companyDescription =
//           'PT Good Day Beverages Indonesia adalah perusahaan FMCG yang berfokus pada produksi dan distribusi berbagai varian minuman kopi siap minum (RTD) di Indonesia. Dikenal dengan tagline "Kopinya Anak Muda", Good Day menawarkan pengalaman kopi yang praktis dan penuh gaya, dengan beragam rasa yang kreatif dan inovatif. Kami ingin menghadirkan kopi yang menyenangkan dan sesuai dengan selera generasi muda. Visi kami adalah menjadi pemimpin di kategori minuman kopi siap saji di Asia Tenggara, dengan menyediakan produk berkualitas tinggi yang terjangkau dan mudah diakses. Misi kami adalah menciptakan momen santai dengan secangkir kopi yang penuh keunikan, memperkuat hubungan antara merek dan konsumen di setiap kesempatan.';
//       String industryType =
//           'FMCG (Fast-Moving Consumer Goods), Makanan dan Minuman';
//       String companyTargetMarket =
//           'Target pasar kami adalah generasi milenial dan Gen Z berusia antara 18-35 tahun yang menginginkan minuman kopi dengan rasa yang inovatif dan mudah diakses. Kami menargetkan individu yang aktif, dinamis, dan gemar mencoba hal-hal baru. Produk Good Day juga menyasar konsumen yang mencari opsi minuman ringan yang terjangkau, mudah ditemukan di berbagai gerai, dan dapat dinikmati kapan saja.';
//       String companyBusinessGoals =
//           'Tujuan jangka pendek kami adalah meningkatkan pangsa pasar sebesar 15% di segmen minuman kopi siap saji dalam satu tahun. Jangka panjangnya, kami bertujuan untuk memperluas jangkauan pasar ke negara-negara tetangga di Asia Tenggara, sekaligus memperkenalkan varian-varian rasa baru yang sesuai dengan preferensi pasar lokal. KPI yang diutamakan adalah peningkatan penjualan, perluasan distribusi, dan peningkatan engagement digital.';
//       String companyValuesMission =
//           'Nilai inti perusahaan kami adalah kreativitas, keunikan, dan kedekatan dengan konsumen. Kami ingin terus berinovasi dalam menciptakan produk yang menggugah rasa, sekaligus menjaga standar kualitas dan integritas dalam setiap produk yang kami luncurkan. Misi kami adalah menghadirkan lebih dari sekadar kopi—kami ingin menciptakan momen yang menyenangkan, memberikan inspirasi, dan membuat setiap tegukan menjadi pengalaman yang berkesan.';
//       String companyContact =
//           'Email: info@goodday.com Telepon: +62 21 1234 5678 Alamat: Jl. Kopi No. 9, Jakarta, Indonesia';

//       final prompt = '''
// # Template Prompt untuk AI-Generated Sponsorship Proposal

// Buatlah sebuah proposal sponsorship yang komprehensif, profesional, dan menarik dalam Bahasa Indonesia untuk acara berikut. Proposal harus memiliki panjang sekitar 2000-2500 kata, mencakup semua aspek penting dari acara dan peluang sponsorship, dengan fokus khusus pada kesesuaian dengan strategi dan tujuan bisnis sponsor. Hasilkan proposal dalam format final tanpa komentar, instruksi tambahan, atau penjelasan proses.

// ## Informasi Acara:
// - Nama Acara: $eventName
// - Deskripsi Acara: $eventDescription
// - Tanggal dan Lokasi: $eventDateLocation
// - Jumlah Peserta yang Diharapkan: $expectedAttendees

// ## Informasi Perusahaan Target:
// - Nama Perusahaan: $companyName
// - Deskripsi Perusahaan: $companyDescription
// - Jenis Industri: $industryType
// - Target Pasar Perusahaan: $companyTargetMarket
// - Tujuan Bisnis Perusahaan: $companyBusinessGoals
// - Nilai dan Misi Perusahaan: $companyValuesMission
// - Kontak Perusahaan: $companyContact

// ## Struktur proposal:

// 1. Halaman Sampul:
//    - Judul: "Proposal Sponsorship: [Nama Acara] untuk [Nama Perusahaan]"
//    - Tanggal: [Tanggal Hari Ini]
//    - Nama Organisasi Penyelenggara
//    - Informasi Kontak

// 2. Daftar Isi

// 3. Ringkasan Eksekutif (sekitar 250 kata):
//    - Ringkasan singkat dan menarik tentang acara
//    - Keunikan acara dan relevansinya dengan [Nama Perusahaan]
//    - Manfaat utama bagi sponsor, disesuaikan dengan tujuan bisnis [Nama Perusahaan]
//    - Highlight kesesuaian strategis antara acara dan perusahaan

// 4. Profil Acara dan Kesesuaian dengan Strategi Sponsor (sekitar 400 kata):
//    - Deskripsi lengkap acara
//    - Tujuan dan visi acara
//    - Sejarah singkat (jika ada)
//    - Tanggal, lokasi, dan durasi acara
//    - Aktivitas atau program utama
//    - Analisis mendalam tentang bagaimana acara ini sejalan dengan:
//      * Strategi pemasaran [Nama Perusahaan]
//      * Tujuan jangka panjang [Nama Perusahaan]
//      * Nilai-nilai dan misi [Nama Perusahaan]

// 5. Profil dan Data Audiens (sekitar 350 kata):
//    - Informasi detail tentang audiens target: $audienceInfo
//    - Analisis demografi mendalam: $demographics
//      * Usia, jenis kelamin, pekerjaan, pendapatan
//      * Minat dan preferensi
//      * Perilaku konsumen
//    - Relevansi audiens bagi [Nama Perusahaan]
//    - Data statistik atau hasil survei (jika ada)
//    - Perbandingan antara audiens acara dan target pasar [Nama Perusahaan]

// 6. Jangkauan Media dan Potensi Exposure (sekitar 350 kata):
//    - Daftar rinci media yang akan digunakan: $mediaList
//    - Untuk setiap platform:
//      * Metode promosi sponsor
//      * Estimasi jangkauan dan exposure (gunakan data konkret)
//      * Frekuensi penayangan/publikasi
//    - Peluang branding di lokasi acara
//    - Integrasi sponsor dalam materi promosi
//    - Analisis tentang bagaimana exposure ini mendukung tujuan bisnis [Nama Perusahaan]

// 7. Dampak dan Potensi Acara (sekitar 300 kata):
//    - Analisis potensi dampak pada merek sponsor: $brandImpact
//    - Proyeksi peningkatan brand awareness untuk [Nama Perusahaan]
//    - Estimasi ROI berdasarkan investasi sponsorship
//    - Potensi leads atau konversi penjualan
//    - Dampak jangka panjang pada positioning [Nama Perusahaan] di industri

// 8. Kesesuaian dengan Tujuan Bisnis Sponsor (sekitar 350 kata):
//    - Analisis mendalam tentang tujuan bisnis [Nama Perusahaan]: $companyBusinessGoals
//    - Penjelasan rinci bagaimana acara membantu mencapai tujuan tersebut: $eventHow
//    - Strategi spesifik yang akan diimplementasikan untuk mencapai tujuan bisnis sponsor
//    - Metrik dan KPI yang akan digunakan untuk mengukur kesuksesan

// 9. Manfaat Sponsorship (sekitar 300 kata):
//    - Manfaat spesifik untuk [Nama Perusahaan]:
//      * Peningkatan brand awareness (dengan estimasi persentase atau angka)
//      * Peluang networking dengan stakeholder kunci
//      * Akses ke data audiens yang berharga
//      * Peluang penjualan langsung (jika relevan)
//      * Customer engagement opportunities
//    - Penjelasan bagaimana setiap manfaat mendukung strategi dan tujuan [Nama Perusahaan]

// 10. Paket Sponsorship (sekitar 350 kata):
//     - Rincian paket sponsorship: $subscriptionPackage
//     - Untuk setiap tingkat sponsorship:
//       * Harga
//       * Hak dan keuntungan detail
//       * Visibilitas dan eksposur spesifik
//       * Keuntungan eksklusif
//     - Perbandingan nilai antar tingkat
//     - Penjelasan bagaimana setiap paket disesuaikan dengan kebutuhan [Nama Perusahaan]

// 11. Rincian Tambahan (sekitar 200 kata):
//     $proposalDetail
//     - Informasi logistik acara
//     - Rencana kontingensi (jika relevan)
//     - Asuransi dan pertimbangan hukum

// 12. Tim Penyelenggara (sekitar 150 kata):
//     - Profil singkat tim utama
//     - Pengalaman dan keahlian relevan
//     - Track record kesuksesan acara sebelumnya

// 13. Testimoni dan Endorsement (jika ada, sekitar 150 kata)
//     - Testimoni dari sponsor sebelumnya
//     - Endorsement dari tokoh industri atau influencer

// 14. Struktur Proposal dan Evaluasi (sekitar 200 kata):
//     - Penjelasan singkat tentang struktur proposal
//     - Metode evaluasi kesuksesan sponsorship
//     - Timeline pelaporan dan feedback

// 15. Ajakan Bertindak (sekitar 150 kata):
//     - Ajakan persuasif untuk bergabung, disesuaikan dengan [Nama Perusahaan]
//     - Langkah-langkah konkret untuk berpartisipasi
//     - Tenggat waktu (jika relevan)
//     - Penawaran untuk diskusi lebih lanjut atau presentasi

// 16. Penutup (sekitar 150 kata):
//     - Rangkuman poin-poin kunci
//     - Penekanan nilai unik yang ditawarkan kepada [Nama Perusahaan]
//     - Ucapan terima kasih
//     - Informasi kontak untuk tindak lanjut

// Panduan tambahan:
// - Gunakan bahasa Indonesia formal, profesional, menarik, dan persuasif.
// - Buat transisi halus antar bagian untuk dokumen yang kohesif.
// - Gunakan data dan statistik konkret untuk mendukung setiap klaim.
// - Sesuaikan tone dan gaya bahasa dengan industri [Nama Perusahaan].
// - Sertakan call-to-action yang jelas dan relevan di seluruh dokumen.
// - Gunakan struktur yang jelas dengan heading dan subheading.
// - Pastikan setiap bagian menunjukkan pemahaman mendalam tentang [Nama Perusahaan] dan kebutuhannya.
// - Fokus pada mendemonstrasikan nilai dan ROI yang jelas bagi [Nama Perusahaan].

// Hasilkan proposal final tanpa komentar tambahan atau penjelasan proses pembuatan.''';

//       final headers = {
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer $apiKey',
//       };

//       final body = jsonEncode({
//         'model': 'j2-jumbo-instruct',
//         "prompt": prompt,
//         'numResults': 1,
//         'maxTokens': 4096,
//         'temperature': 0.4,
//         'topP': 1.0,
//         'stopSequences': [
//           "14. Penutup",
//           "\\n\\n14."
//         ],
//         'countPenalty': {
//           'scale': 0,
//           'applyToNumbers': false,
//           'applyToPunctuations': false,
//           'applyToStopwords': false,
//           'applyToWhitespaces': false,
//           'applyToEmojis': false
//         },
//         'frequencyPenalty': {
//           'scale': 0,
//           'applyToNumbers': false,
//           'applyToPunctuations': false,
//           'applyToStopwords': false,
//           'applyToWhitespaces': false,
//           'applyToEmojis': false
//         },
//         'presencePenalty': {
//           'scale': 0,
//           'applyToNumbers': false,
//           'applyToPunctuations': false,
//           'applyToStopwords': false,
//           'applyToWhitespaces': false,
//           'applyToEmojis': false
//         },
//         'systemPrompt':
//             'Anda membuat proposal pengajuan sponsorship detail, lengkap dan final',
            
//         // "numResults": 1,
//         // "maxTokens": 2048, // Ditingkatkan untuk proposal yang lebih panjang
//         // "temperature": 0.7,
//         // "topP": 0.9,
//         // "stopSequences": [
//         //   "14. Penutup",
//         //   "\\n\\n14."
//         // ] // Menghentikan generasi pada bagian penutup
//       });

//       print('API URL: $_apiUrl');
//       print('Headers: ${jsonEncode(headers)}');
//       print('Request Body: $body');

//       final response = await http.post(
//         Uri.parse(_apiUrl),
//         headers: headers,
//         body: body,
//       );

//       print('Response status: ${response.statusCode}');
//       print('Response headers: ${response.headers}');
//       print('Response body: ${response.body}');

//       if (response.statusCode == 200) {
//         var data = jsonDecode(response.body);
//         if (data['completions'] is List && data['completions'].isNotEmpty) {
//           return data['completions'][0]['data']['text'] ??
//               'Tidak ada teks yang dihasilkan.';
//         } else {
//           throw Exception('Format respons tidak sesuai: $data');
//         }
//       } else {
//         throw Exception(
//             'Gagal generate proposal. Status Code: ${response.statusCode}, Body: ${response.body}');
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
