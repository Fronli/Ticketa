# Ticketa

Ticketa adalah aplikasi web pemesanan tiket event yang terinspirasi dari platform seperti Ticket.com. Aplikasi ini menyediakan katalog event, pembelian tiket, simulasi pembayaran, serta pengelolaan event berbasis Role-Based Access Control (RBAC).

Selain menghasilkan tiket digital secara otomatis setelah pembayaran berhasil, Ticketa juga menyediakan QR code scanner untuk memvalidasi dan melakukan check-in peserta event.

> Catatan: fitur pembayaran pada proyek ini hanya simulasi untuk kebutuhan pembelajaran dan pengembangan. Tidak ada transaksi uang sungguhan.

## Fitur Utama

- Registrasi dan login menggunakan email/password.
- Login menggunakan Google OAuth.
- Browsing dan pencarian event.
- Detail event dengan pilihan tipe tiket dan kuota.
- Pembuatan order dan alur checkout.
- Simulasi pembayaran dengan status order dan payment.
- Ticket generation otomatis berdasarkan jumlah tiket yang dibeli.
- QR code untuk setiap tiket digital.
- Halaman daftar tiket milik pengguna.
- Pengajuan dan pengelolaan Event Organizer (EO).
- Pembuatan event, pengaturan harga, tipe tiket, dan kuota.
- Dashboard EO untuk memantau penjualan dan event.
- Scanner QR/reference ID untuk validasi tiket dan check-in peserta.
- Dashboard admin untuk menyetujui pengajuan EO, mengelola akun, melihat event, transaksi, dan menonaktifkan event.

## Role dan Hak Akses

Ticketa menggunakan tiga role utama:

| Role | Tanggung jawab |
| --- | --- |
| `USER` | Melihat event, membeli tiket, menyelesaikan simulasi pembayaran, dan melihat tiket pribadi. |
| `EO` | Membuat dan mengelola event, memantau penjualan, serta memvalidasi dan melakukan check-in tiket. |
| `ADMIN` | Mengelola pengguna dan EO, memproses pengajuan EO, memantau event/transaksi, dan menonaktifkan event. |

Akses endpoint dilindungi dengan JWT authentication dan middleware role authorization.

## Alur Pembelian Tiket

1. Pengguna memilih event dan tipe tiket.
2. Pengguna menentukan jumlah tiket dan membuat order.
3. Pengguna menyelesaikan pembayaran simulasi.
4. Sistem menandai order sebagai `PAID` dan payment sebagai `PAID`.
5. Sistem mengurangi kuota tiket.
6. Sistem membuat tiket digital beserta kode unik dan QR code.
7. EO dapat memindai QR code atau memasukkan kode tiket untuk melihat status dan melakukan check-in.

Status tiket yang digunakan adalah `VALID`, `USED`, dan `CANCELLED`.

## Teknologi

### Backend

- Node.js dan TypeScript
- Express 5
- Prisma ORM
- PostgreSQL
- JWT dan bcrypt
- Google OAuth
- Multer untuk upload poster event
- QRCode untuk membuat QR code tiket
- Jest untuk unit test

### Frontend

- HTML
- CSS
- Vanilla JavaScript
- `jsQR` untuk membaca QR code pada halaman scanner

## Struktur Proyek

```text
.
├── backend/
│   ├── prisma/             # Prisma schema dan migration
│   ├── src/
│   │   ├── controllers/    # Logika request dan response
│   │   ├── middleware/     # JWT, RBAC, dan upload middleware
│   │   ├── routes/         # Route auth, event, EO, dan admin
│   │   ├── services/       # Service authentication
│   │   └── server.ts       # Entry point Express
│   └── testing/            # Unit test dan load test
├── frontend/               # Halaman HTML, CSS, dan JavaScript
├── docker-compose.yml      # Service aplikasi dan PostgreSQL
└── Dockerfile
```

## Menjalankan dengan Docker

Pastikan Docker dan Docker Compose sudah terpasang, lalu siapkan file environment di `backend/.env`.

Contoh konfigurasi minimal:

```env
PORT=3000
DATABASE_URL="postgresql://fronli:fronli@db:5432/ticketa?schema=public"
JWT_SECRET="ganti-dengan-secret-yang-aman"
GOOGLE_CLIENT_ID="client-id-google-opsional"
```

Jalankan aplikasi:

```bash
docker compose up --build
```

Buka aplikasi melalui [http://localhost:3000](http://localhost:3000).

## Menjalankan Secara Lokal

### 1. Siapkan PostgreSQL

Buat database PostgreSQL bernama `ticketa`, lalu sesuaikan `DATABASE_URL` pada `backend/.env`.

```env
PORT=3000
DATABASE_URL="postgresql://username:password@localhost:5432/ticketa?schema=public"
JWT_SECRET="ganti-dengan-secret-yang-aman"
GOOGLE_CLIENT_ID="client-id-google-opsional"
```

### 2. Install dependency backend

```bash
cd backend
npm install
npx prisma generate
npx prisma migrate dev
```

### 3. Jalankan server development

```bash
npm run dev
```

Server berjalan di [http://localhost:3000](http://localhost:3000).

## Perintah Backend

Jalankan dari folder `backend`:

```bash
npm run dev      # Menjalankan server dalam mode development
npm run build    # Generate Prisma Client dan compile TypeScript
npm start        # Menjalankan hasil build dari folder dist
npm test         # Menjalankan unit test
```

## Endpoint Utama

| Area | Endpoint | Keterangan |
| --- | --- | --- |
| Auth | `POST /auth/signup` | Registrasi pengguna |
| Auth | `POST /auth/login` | Login email/password |
| Auth | `POST /auth/google` | Login Google |
| Event | `GET /event/getEvents` | Mendapatkan daftar event |
| Event | `GET /event/getEventById/:id` | Mendapatkan detail event |
| Order | `POST /event/order/createOrder` | Membuat order |
| Payment | `POST /event/order/completePayment` | Menyelesaikan pembayaran simulasi |
| Ticket | `GET /event/myticket` | Mendapatkan tiket pengguna |
| EO | `POST /eo/createEvent` | Membuat event |
| EO | `GET /eo/ticket/:qrcode` | Memvalidasi tiket |
| EO | `PATCH /eo/ticket/:qrcode/checkin` | Check-in tiket |
| Admin | `GET /admin/dashboard/transactions` | Melihat transaksi |

Endpoint yang bersifat privat membutuhkan header:

```http
Authorization: Bearer <jwt-token>
```

## Pengujian

Unit test tersedia untuk service authentication, controller event/EO/admin, serta middleware authentication dan role authorization.

```bash
cd backend
npm test
```

Load test tersedia di `backend/testing/k6/load-test.js` dan dapat dijalankan menggunakan k6.

## Status Proyek

Ticketa merupakan proyek pembelajaran/full-stack application yang berfokus pada implementasi alur ticketing, RBAC, simulasi pembayaran, ticket generation, dan ticket check-in.
