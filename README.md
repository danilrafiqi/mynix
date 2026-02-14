# 🚀 Home Manager Multi-Platform Setup Guide

Panduan ini ditujukan untuk setup laptop baru (Mac, Linux, atau Windows WSL) dari nol agar environment development kamu langsung siap pakai dan identik di semua perangkat.

---

## 🛠 Tahap 0: Persiapan (Prerequisites)

Sebelum mulai, pastikan **Nix** sudah terinstall di laptop baru kamu.

### Install Nix (Multi-user)
Jalankan perintah ini di terminal:
```bash
sh <(curl -L https://nixos.org/nix/install) --daemon
```
*Setelah selesai, tutup dan buka kembali terminal kamu.*

---

## 🔑 Tahap 1: Migrasi SSH Key (SANGAT PENTING)

Agar kamu bisa langsung `push/pull` ke GitHub/GitLab tanpa login ulang, kamu harus memindahkan kunci SSH dari laptop lama ke laptop baru.

1.  **Di Laptop Lama**: Copy folder `~/.ssh` (isi file `id_ed25519` dan `id_ed25519.pub`) ke flashdisk atau cloud yang aman.
2.  **Di Laptop Baru**:
    -   Buat folder ssh: `mkdir -p ~/.ssh`
    -   Paste file kunci kamu ke dalam folder tersebut.
    -   Atur permission (Wajib):
        ```bash
        chmod 700 ~/.ssh
        chmod 600 ~/.ssh/id_ed25519
        chmod 644 ~/.ssh/id_ed25519.pub
        ```

---

## 📂 Tahap 2: Copy Konfigurasi

Copy folder `home-manager` ini dari laptop lama ke lokasi yang sama di laptop baru:
`~/.config/home-manager/`

---

## 🚀 Tahap 3: Aktivasi Home Manager

Sekarang, kita akan memasang Home Manager dan mengaktifkan konfigurasi kamu.

### 1. Inisialisasi Home Manager (Pertama Kali)
```bash
nix run home-manager/master -- init --flake ~/.config/home-manager
```

### 2. Pilih Output Sesuai Laptop Kamu
Jalankan perintah yang sesuai di bawah ini:

#### A. Jika ini MacBook (Apple Silicon)
```bash
home-manager switch --flake .#mdanilrafiqi -b backup
```

#### B. Jika ini Laptop Linux (Native)
```bash
home-manager switch --flake .#mdanilrafiqi-linux -b backup
```

#### C. Jika ini Windows (WSL2)
```bash
home-manager switch --flake .#mdanilrafiqi-wsl -b backup
```

---

## 💡 Apa yang Otomatis Terpasang?

| Fitur | Deskripsi |
| :--- | :--- |
| **Git Identity** | Nama `M Danil Rafiqi` & Email sudah otomatis tersetup. |
| **SSH Config** | Otomatis mengenali GitHub/GitLab menggunakan key kamu. |
| **Shell (ZSH)** | Oh-My-Zsh, Theme, Plugins (git, docker, npm) terinstall. |
| **CLI Tools** | `eza` (ls icon), `bat` (cat berwarna), `htop`, `ripgrep`, dll. |
| **Alias** | `hm` (untuk update config), `ll`, `ls`, `cat` semua sudah di-map. |
| **GUI Apps** | Versi Mac/Linux akan menginstall Chrome, Zoom, VSCode secara otomatis. |

---

## 🔍 Troubleshooting

- **"command not found: nix"**: Jalankan `source ~/.zshrc` atau buka terminal baru.
- **"clobbered error"**: Pastikan kamu selalu menyertakan flag `-b backup` saat menjalankan `home-manager switch`.
- **Ganti Nama/Email Git**: Ubah di file [home.nix](file:///Users/mdanilrafiqi/.config/home-manager/home.nix) di bagian `programs.git`.

---
*Happy Coding!* 🚀

## Backup
Jika terjadi kesalahan, konfigurasi lama tersimpan di `~/backupnix`.
