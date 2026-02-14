# Multi-Platform Home Manager Configuration

Repositori ini berisi konfigurasi Home Manager yang didesain agar bisa digunakan di berbagai sistem operasi (macOS, Native Linux, dan Windows WSL) dengan konfigurasi yang konsisten.

## Struktur Utama
- `flake.nix`: Mengelola output untuk berbagai sistem dan arsitektur.
- `home.nix`: Berisi logika instalasi paket dan konfigurasi shell (ZSH) yang otomatis mendeteksi platform.

## Cara Penggunaan

Gunakan flag yang sesuai dengan perangkat kamu saat menjalankan `home-manager switch`. 

> [!TIP]
> Jika muncul error **"Existing file ... would be clobbered"**, tambahkan flag `-b backup` untuk membackup file lama secara otomatis.

### 1. Apple Silicon Mac
```bash
home-manager switch --flake .#mdanilrafiqi -b backup
```
- **Paket**: Terminal Tools + GUI Apps (Chrome, VSCode, ITerm2, dll).
- **Home Dir**: `/Users/mdanilrafiqi`

### 2. Native Linux (Laptop Laptop/PC)
```bash
home-manager switch --flake .#mdanilrafiqi-linux -b backup
```
- **Paket**: Terminal Tools + GUI Apps (Chrome, VSCode, dll).
- **Home Dir**: `/home/mdanilrafiqi`

### 3. Windows (WSL2)
```bash
home-manager switch --flake .#mdanilrafiqi-wsl -b backup
```
- **Paket**: Cuma Terminal Tools (Ringan).
- **Hardware**: Disarankan pakai versi Windows native untuk Zoom/Postman agar Webcam/Mic stabil.
- **Home Dir**: `/home/mdanilrafiqi`

---

## Tips & Troubleshooting

### Error: "Existing file ... would be clobbered"
Nix tidak akan menimpa file konfigurasi yang sudah ada (seperti `.zshrc` bawaan Mac) secara paksa. Gunakan flag `-b backup` untuk memberitahu Home Manager agar memindahkan file asli ke nama baru (misal: `.zshrc.backup`) sebelum memasang versinya sendiri.

### Error: "command not found: nix"
Jika perintah `nix` tidak dikenali setelah update macOS, jalankan:
```bash
source ~/.zshrc
```
Ini karena konfigurasi Nix di dalam `.zshrc` perlu dimuat ulang.

---

## Logika Deteksi Otomatis
Konfigurasi (`home.nix`) menggunakan variabel `isWSL` dan pengecekan arsitektur untuk:
1. Menentukan lokasi `homeDirectory`.
2. Memilih apakah aplikasi GUI perlu diinstall lewat Nix atau tidak.
3. Mengaktifkan plugin ZSH spesifik platform (misal: plugin `macos`).

## Backup
Jika terjadi kesalahan, konfigurasi lama tersimpan di `~/backupnix`.
