import 'dart:convert';
import 'dart:async';
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:google_generative_ai/google_generative_ai.dart';

class ApiService {
  static const String _jambaApiUrl =
      'https://api.ai21.com/studio/v1/chat/completions';

  static Future<String> generateProposal({
    required String model,
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
      if (model.startsWith('jamba')) {
        return await _generateWithJamba(
          model: model,
          eventName: eventName,
          eventDescription: eventDescription,
          audienceInfo: audienceInfo,
          mediaList: mediaList,
          demographics: demographics,
          brandImpact: brandImpact,
          sponsorPurpose: sponsorPurpose,
          eventHow: eventHow,
          proposalDetail: proposalDetail,
          subscriptionPackage: subscriptionPackage,
        );
      } else if (model.startsWith('gemini')) {
        return await _generateWithGemini(
          model: model,
          prompt: _buildPrompt(
            eventName: eventName,
            eventDescription: eventDescription,
            audienceInfo: audienceInfo,
            mediaList: mediaList,
            demographics: demographics,
            brandImpact: brandImpact,
            sponsorPurpose: sponsorPurpose,
            eventHow: eventHow,
            proposalDetail: proposalDetail,
            subscriptionPackage: subscriptionPackage,
          ),
        );
      } else {
        throw Exception('Model tidak dikenali: $model');
      }
    } catch (e, stacktrace) {
      print('Error saat generate proposal: $e');
      print('Stack trace: $stacktrace');
      return 'Error: $e';
    }
  }

  static Future<String> _generateWithJamba({
    required String model,
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
    final apiKey = 'lmCls71dZH3ads0aVL9jwp5wXg5a0QIU';
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $apiKey',
    };

    final body = jsonEncode({
      'model': model,
      'messages': [
        {
          'role': 'system',
          'content': 'Anda adalah asisten AI yang ahli dalam membuat proposal sponsorship yang detail dan profesional.'
        },
        {'role': 'user', 'content': _buildPrompt(
          eventName: eventName,
          eventDescription: eventDescription,
          audienceInfo: audienceInfo,
          mediaList: mediaList,
          demographics: demographics,
          brandImpact: brandImpact,
          sponsorPurpose: sponsorPurpose,
          eventHow: eventHow,
          proposalDetail: proposalDetail,
          subscriptionPackage: subscriptionPackage,
        )}
      ],
      'temperature': 0.7,
      'max_tokens': 3000,
      'top_p': 1,
      'frequency_penalty': 0,
      'presence_penalty': 0,
    });

    final response = await http.post(
      Uri.parse(_jambaApiUrl),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['choices'][0]['message']['content'] ?? 'Tidak ada teks yang dihasilkan.';
    } else {
      throw Exception('Gagal generate proposal. Status Code: ${response.statusCode}, Body: ${response.body}');
    }
  }

  static Future<String> _generateWithGemini({
    required String model,
    required String prompt,
  }) async {
    final apiKey = 'AIzaSyCKJF4KYzvkc1zf0cRUj1dYUBN5lu_9vZA';
    if (apiKey == null) {
      throw Exception('No \$GEMINI_API_KEY environment variable. APIKEY: $apiKey');
    }
  
    final generativeModel = GenerativeModel(
      model: model,
      apiKey: apiKey,
      generationConfig: GenerationConfig(
        temperature: 1,
        topK: 40,
        topP: 0.95,
        maxOutputTokens: 8192,
        responseMimeType: 'text/plain',
      ),
    );
  
    final chat = generativeModel.startChat(history: []);
    final content = Content.text(prompt);
    final response = await chat.sendMessage(content);
  
    return response.text ?? '';
  }

  static String _buildPrompt({
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
  }) {
    return '''
# Template Prompt untuk AI-Generated Sponsorship Proposal

Buatlah sebuah proposal sponsorship yang komprehensif, profesional, dan menarik dalam Bahasa Indonesia untuk acara berikut. Proposal harus memiliki panjang sekitar 2000-2500 kata, mencakup semua aspek penting dari acara dan peluang sponsorship, dengan fokus khusus pada kesesuaian dengan strategi dan tujuan bisnis sponsor. Hasilkan proposal dalam format final tanpa komentar, instruksi tambahan, atau penjelasan proses.

## Informasi Acara:
- Nama Acara: $eventName
- Deskripsi Acara: $eventDescription
- Informasi Audiens: $audienceInfo
- Media: $mediaList
- Demografi: $demographics
- Dampak Brand: $brandImpact
- Tujuan Sponsor: $sponsorPurpose
- Bagaimana Acara: $eventHow
- Detail Proposal: $proposalDetail
- Paket Berlangganan: $subscriptionPackage

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
   - Analisis mendalam tentang tujuan bisnis [Nama Perusahaan]: $sponsorPurpose
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

13. Testimoni dan Endorsement (jika ada, sekitar 150 kata):
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
- Hasilkan proposal final tanpa komentar tambahan atau penjelasan proses pembuatan.''';
  }
}
