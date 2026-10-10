# 0001 — Monorepo dengan Satu Go Module

- **Status:** Diterima
- **Tanggal:** 2026-10-10

## Konteks
Kilat terdiri dari beberapa service (gateway, order, product, worker, realtime, kilatkv) dan beberapa library bersama (`pkg/queue`, `pkg/ratelimit`, `pkg/observability`). Semua dikerjakan oleh satu orang di satu repository.

## Keputusan
Semua kode berada dalam **satu Go module** (`github.com/Voltatile/kilat`). Setiap service adalah satu package `main` di `services/<nama>`, dan di-build menjadi image Docker terpisah lewat satu `Dockerfile` generik (`--build-arg SERVICE=<nama>`).

## Konsekuensi
- ✅ Perubahan di `pkg/` langsung terpakai semua service tanpa versioning antar module.
- ✅ Satu `go.mod`, satu perintah `go test ./...` untuk semua.
- ❌ Semua service berbagi versi dependency yang sama.
- ❌ Image Docker setiap service ikut men-download dependency milik service lain saat build.

## Alternatif yang Dipertimbangkan
- **Satu module per service + `go.work`** — lebih mendekati repo terpisah, tetapi menambah overhead yang belum perlu di tahap awal. Bisa dipertimbangkan ulang kalau ada service yang perlu dirilis independen.
