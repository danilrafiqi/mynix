#!/bin/sh

# Cek folder ~/backupssh
if [ ! -f ~/backupssh/ssh_backup.enc ]; then
  echo "❌ File ~/backupssh/ssh_backup.enc tidak ditemukan!"
  echo "Pastikan kamu sudah menaruh file backup di folder ~/backupssh"
  exit 1
fi

echo "🔓 Decrypting SSH keys..."
echo "🔑 Enter password for decryption:"
openssl enc -d -aes-256-cbc -salt -pbkdf2 -in ~/backupssh/ssh_backup.enc -out /tmp/ssh_restored.tar.gz

if [ $? -ne 0 ]; then
  echo "❌ Decryption failed! Password might be wrong."
  exit 1
fi

# Extract ke home directory (tar otomatis overwrite jika tidak ada opsi keep-newer-files, which is fine for restore)
tar -xzvf /tmp/ssh_restored.tar.gz -C "$HOME"

# Set permission yang benar (PENTING)
chmod 700 ~/.ssh
chmod 600 ~/.ssh/id_ed25519 2>/dev/null || true
chmod 644 ~/.ssh/id_ed25519.pub 2>/dev/null || true

# Bersihkan
rm /tmp/ssh_restored.tar.gz

echo "✅ SSH keys restored successfully!"
