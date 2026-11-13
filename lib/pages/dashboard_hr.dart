import 'package:flutter/material.dart';

class DashboardHR extends StatelessWidget {
  final VoidCallback onToggleTheme;

  const DashboardHR({super.key, required this.onToggleTheme});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth >= 600;
        return _buildDashboard(context, isTablet);
      },
    );
  }

  Widget _buildDashboard(BuildContext context, bool isTablet) {
    final colors = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.network(
                'https://picsum.photos/seed/logo/40/40',
                width: 32,
                height: 32,
                errorBuilder: (_, _, _) => const Icon(Icons.business, size: 32),
              ),
            ),
            const SizedBox(width: 8),
            const Flexible(
              child: Text('PT Maju Bersama', overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
        actions: [
          // Tugas 1: tombol toggle dark mode
          IconButton(
            tooltip: isDark ? 'Mode terang' : 'Mode gelap',
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: onToggleTheme,
          ),
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () {},
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
          const CircleAvatar(
            radius: 16,
            backgroundImage: NetworkImage(
              'https://picsum.photos/seed/user/50/50',
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Banner sapaan (Tugas 2: kontras aman di light & dark) ──
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      colors: [
                        colors.primaryContainer,
                        colors.tertiaryContainer,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
                Positioned(
                  left: 20,
                  top: 20,
                  bottom: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Selamat Pagi, Admin!',
                        style: TextStyle(
                          color: colors.onPrimaryContainer,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Senin, 7 Oktober 2024',
                        style: TextStyle(
                          color: colors.onPrimaryContainer.withValues(
                            alpha: 0.75,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  right: 20,
                  top: 20,
                  bottom: 20,
                  child: Icon(
                    Icons.waving_hand,
                    color: colors.onPrimaryContainer.withValues(alpha: 0.5),
                    size: 64,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // ── Grid statistik ──
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: isTablet ? 4 : 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: isTablet ? 1.4 : 1.3,
              children: [
                _kartuStat('248', 'Karyawan', Icons.people, colors.primary),
                _kartuStat(
                  '95%',
                  'Hadir',
                  Icons.check_circle,
                  colors.secondary,
                ),
                _kartuStat('12', 'Cuti', Icons.beach_access, colors.tertiary),
                _kartuStat('3', 'Rekrut', Icons.person_add, colors.error),
              ],
            ),
            const SizedBox(height: 20),

            // ── Tugas 3: Bar chart kehadiran per divisi ──
            Text(
              'Kehadiran per Divisi',
              style: Theme.of(context).textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _barChartKehadiran(colors),
            const SizedBox(height: 20),

            // ── Judul seksi aktivitas ──
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    'Aktivitas Terkini',
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                TextButton(onPressed: () {}, child: const Text('Lihat Semua')),
              ],
            ),

            // ── Kartu aktivitas ──
            ...List.generate(
              _aktivitas.length,
              (i) => _kartuAktivitas(_aktivitas[i]),
            ),
            const SizedBox(height: 12),

            // ── Tugas 4: dua kartu berdampingan (tablet) / vertikal (HP) ──
            if (isTablet)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _kartuInfo('Terbaru Absen', const [
                      'Citra Dewi - 08:02',
                      'Doni Pratama - 08:10',
                      'Fitri Handayani - 08:15',
                    ]),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _kartuInfo('Terbaru Cuti', const [
                      'Budi Santoso - 3 hari',
                      'Gita Lestari - 1 hari',
                      'Hadi Kurniawan - 5 hari',
                    ]),
                  ),
                ],
              )
            else
              Column(
                children: [
                  _kartuInfo('Terbaru Absen', const [
                    'Citra Dewi - 08:02',
                    'Doni Pratama - 08:10',
                    'Fitri Handayani - 08:15',
                  ]),
                  const SizedBox(height: 12),
                  _kartuInfo('Terbaru Cuti', const [
                    'Budi Santoso - 3 hari',
                    'Gita Lestari - 1 hari',
                    'Hadi Kurniawan - 5 hari',
                  ]),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _kartuStat(String nilai, String label, IconData icon, Color warna) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: warna.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: warna.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: warna, size: 28),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                nilai,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: warna,
                ),
              ),
              Text(
                label,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static const _divisi = [
    (nama: 'Engineering', persen: 92),
    (nama: 'Sales', persen: 85),
    (nama: 'HR', persen: 97),
    (nama: 'Finance', persen: 90),
  ];

  Widget _barChartKehadiran(ColorScheme colors) {
    return Card(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: _divisi.map((d) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  children: [
                    SizedBox(
                      width: 90,
                      child: Text(d.nama, overflow: TextOverflow.ellipsis),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            flex: d.persen,
                            child: Container(
                              height: 14,
                              decoration: BoxDecoration(
                                color: colors.primary,
                                borderRadius: BorderRadius.circular(7),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 100 - d.persen,
                            child: const SizedBox(),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 40,
                      child: Text(
                        '${d.persen}%',
                        textAlign: TextAlign.right,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _kartuInfo(String judul, List<String> isi) {
    return Card(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                judul,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              ...isi.map(
                (e) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  child: Text(e),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static const _aktivitas = [
    (
      nama: 'Budi Santoso',
      aksi: 'Mengajukan cuti',
      waktu: '09:14',
      icon: Icons.beach_access,
      warna: Colors.orange,
    ),
    (
      nama: 'Citra Dewi',
      aksi: 'Check-in absensi',
      waktu: '08:02',
      icon: Icons.check_circle,
      warna: Colors.green,
    ),
    (
      nama: 'Eko Wahyudi',
      aksi: 'Upload kontrak baru',
      waktu: '07:45',
      icon: Icons.description,
      warna: Colors.blue,
    ),
  ];

  Widget _kartuAktivitas(
    ({
      String nama,
      String aksi,
      String waktu,
      IconData icon,
      MaterialColor warna,
    })
    d,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: d.warna.withValues(alpha: 0.15),
          child: Icon(d.icon, color: d.warna, size: 20),
        ),
        title: Text(
          d.nama,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(d.aksi),
        trailing: Text(
          d.waktu,
          style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
        ),
      ),
    );
  }
}
