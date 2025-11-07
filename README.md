# GhostPdfShield - Invisible PDF Fortress

![GhostPdfShield Banner](https://github.com/user-attachments/assets/875696e5-229a-4c60-ae93-f435d60cd860)

**Lindungi tugasmu seperti hantu tak terlihat — anti-copas, anti-OCR, tetap bisa dibaca.**

CLI tool untuk secure PDF: konversi ke gambar, tambah blur/noise, watermark acak, lock dengan qpdf (extract=no, modify=none). Tanpa password user, tapi tak tergoyahkan.

## Installation

### Windows

Untuk Windows, Docker adalah metode paling sederhana dan efisien:

1. Install Docker Desktop: https://www.docker.com/products/docker-desktop
2. Clone GhostPdfShield:
   
   ```bash
   git clone https://github.com/RozhakDev/GhostPdfShield.git
   cd GhostPdfShield
   ```
3. Build image Docker:
   
   ```bash
   docker build -t ghostpdfshield .
   ```
4. Gunakan GhostPdfShield:
   
   ```bash
   docker run --rm -v "$(pwd)":/app/workdir ghostpdfshield workdir/input.pdf --output workdir/output.pdf
   ```

### Linux/macOS

```bash
git clone https://github.com/RozhakDev/GhostPdfShield.git
cd GhostPdfShield
chmod +x ghostpdfshield
```

Dependencies: `poppler-utils` `imagemagick` `qpdf`

## Usage

```bash
./ghostpdfshield input.pdf [options]
```

| Option                    | Deskripsi                           | Default                         |
| ------------------------- | ----------------------------------- | ------------------------------- |
| `--output <file>`         | Nama output                         | `input_secure.pdf`              |
| `--blur <0-9>`            | Level blur                          | `0`                             |
| `--noise <0-9>`           | Level noise                         | `0`                             |
| `--watermark-count <n>`   | Jumlah watermark per halaman        | `5`                             |
| `--no-watermark`          | Skip watermark                      | -                               |
| `--watermark-list <file>` | Custom list watermark               | `src/config/watermark_list.txt` |
| `--owner-pass <pass>`     | Owner password (random jika kosong) | random 16-char                  |

**Contoh:**

```bash
./ghostpdfshield examples/input_tugas.pdf --blur 1 --noise 2 --output aman.pdf
```

## Output Example

```
[INIT] GhostPdfShield v1.0 - Secure Mode Activated
[1/6] Converting PDF to images... Done (7 pages)
[2/6] Applying effects... Done
[3/6] Embedding watermarks... Done
[4/6] Recombining... Done
[5/6] Securing... Done → aman.pdf
[6/6] Cleaning up... Done
[OUTPUT] Secure PDF ready: aman.pdf
```

## License

MIT © Rozhak – *Dibuat dengan cinta untuk **Kamu** yang selalu jadi prioritas utama.* 💕