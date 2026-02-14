#!/bin/sh

echo "🔒 Encrypting SSH keys..."
# Zip folder .ssh (kecuali known_hosts/config biar bersih)
zip -r /tmp/ssh_raw.zip ~/.ssh -x "*.DS_Store"

# Buat folder backup jika belum ada
mkdir -p ~/backupssh

# Encrypt dengan OpenSSL (Bawaan Mac/Linux)
echo "🔑 Enter password for encryption:"
openssl enc -aes-256-cbc -salt -pbkdf2 -in /tmp/ssh_raw.zip -out ~/backupssh/ssh_backup.enc

# Hapus file mentah
rm /tmp/ssh_raw.zip

if [ -f ~/backupssh/ssh_backup.enc ]; then
  echo "✅ Backup created at ~/backupssh/ssh_backup.enc"
  echo "Sekarang kamu bisa push file ini ke repo private kamu."
else
  echo "❌ Encryption failed."
fi
