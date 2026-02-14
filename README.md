# 🚀 Home Manager Multi-Platform Setup Guide

Panduan ini adalah **"Kitab Lengkap"** untuk setup laptop baru (Mac, Linux, atau Windows WSL) dari nol agar environment development kamu langsung siap pakai dan identik di semua perangkat.

---

## 🛠 Tahap 0: Install Nix & Enable Flakes

### 1. Install Nix (Multi-user)
Jalankan perintah ini di terminal (Mac/Linux/WSL):
```bash
sh <(curl -L https://nixos.org/nix/install) --daemon
```
*Tutup dan buka kembali terminal setelah selesai.*

### 2. Enable Flakes (Wajib)
Agar konfigurasi ini bisa jalan, kamu harus mengaktifkan fitur "Flakes":
```bash
mkdir -p ~/.config/nix
echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
```

---

## 📂 Tahap 1: Download Konfigurasi Ini

Karena di laptop baru kamu belum punya SSH Key, kita gunakan HTTPS dulu atau copy manual.

### Opsi A: Git Clone via HTTPS
Kamu perlu login dengan GitHub username & password (atau Personal Access Token).
```bash
git clone https://github.com/danilrafiqi/mynix.git ~/.config/home-manager
```

### Opsi B: Copy Manual (Flashdisk)
Copy folder `home-manager` dari laptop lama ke `~/.config/home-manager/` di laptop baru.

---

---

## 🚀 Tahap 2: Aktivasi Home Manager

Sekarang environment kamu siap diaktifkan!

### 1. Inisialisasi & Apply (Sekubus)
Karena kamu sudah clone repo ini, kamu TIDAK PERLU menjalankan `home-manager init`. Langsung jalankan perintah ini untuk mengapply konfigurasi pertama kali:

#### 🍎 MacBook (Apple Silicon)
```bash
nix run home-manager/master -- switch --flake ~/.config/home-manager#mdanilrafiqi -b backup
```

#### 🐧 Linux Native (Ubuntu/Fedora)
```bash
nix run home-manager/master -- switch --flake ~/.config/home-manager#mdanilrafiqi-linux -b backup
```

#### 🪟 Windows (WSL2)
```bash
nix run home-manager/master -- switch --flake ~/.config/home-manager#norastudio -b backup
```

### 2. Install & Switch
### 2. Update Config Berikutnya
Setelah command di atas sukses dan home-manager sudah terinstall di path, untuk update selanjutnya cukup gunakan command yang lebih pendek:

```bash
home-manager switch --flake ~/.config/home-manager
```
*(Otomatis mendeteksi hostname yang sesuai)*

---

## 🔑 Tahap 3: Restore SSH Key

Agar kamu bisa akses repo private lain tanpa password, kita restore kunci SSH kamu.
Karena `home-manager` sudah terinstall, script `restore-ssh` sudah tersedia di terminal kamu.

1.  **Siapkan File Backup**: Pastikan file `ssh_backup.enc` ada di folder `~/backupssh/`.
    ```bash
    mkdir -p ~/backupssh
    # Copy file ssh_backup.enc ke folder ini
    ```
2.  **Jalankan Restore**:
    ```bash
    restore-ssh
    ```
    *Masukkan password enkripsi saat diminta.*

---

## ✅ Selesai! Apa yang harus dicek?

1.  **Shell**: Jika terminal kamu belum berubah jadi ZSH (tema RobbyRussell), coba restart terminal atau jalankan `zsh`.
2.  **Git**: Coba `git status` di folder manapun, harusnya sudah pakai nama & email kamu.
3.  **SSH**: Coba `ssh -T git@github.com`, harusnya sukses ("Hi mdanilrafiqi!").

---

## 💡 Fitur Otomatis
| Fitur | Deskripsi |
| :--- | :--- |
| **Backup SSH** | Ketik `backup-ssh` untuk mengenkripsi kunci SSH kapan saja. |
| **Restore SSH** | Ketik `restore-ssh` di laptop lain untuk mengembalikan kunci. |
| **Apps** | Chrome, VSCode, Zoom otomatis terinstall (kecuali di WSL). |

---

## 🔍 Troubleshooting

- **"command not found: nix"**: Jalankan `source ~/.zshrc` atau reinstall Nix.
- **"clobbered error"**: Selalu pakai flag `-b backup`.
- **"permission denied"**: Coba `chmod +x` pada script yang mau dijalankan.
