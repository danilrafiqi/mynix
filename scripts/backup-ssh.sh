#!/bin/sh

echo "🔒 Encrypting SSH keys..."
# Compress folder .ssh (exclude known_hosts/config.backup) using tar
tar -czvf /tmp/ssh_raw.tar.gz -C "$HOME" .ssh --exclude=".ssh/known_hosts" --exclude=".ssh/config.backup" --exclude=".ssh/.DS_Store"

# Buat folder backup jika belum ada
mkdir -p ~/backupssh

# Encrypt dengan OpenSSL
echo "🔑 Enter password for encryption:"
openssl enc -aes-256-cbc -salt -pbkdf2 -in /tmp/ssh_raw.tar.gz -out ~/backupssh/ssh_backup.enc

# Hapus file mentah
rm /tmp/ssh_raw.tar.gz

if [ -f ~/backupssh/ssh_backup.enc ]; then
  echo "✅ Backup created at ~/backupssh/ssh_backup.enc"
  echo "Sekarang kamu bisa push file ini ke repo private kamu."
else
  echo "❌ Encryption failed."
fi
