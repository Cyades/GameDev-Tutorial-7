# 🎮 Game Development Tutorial 7
**Nama:** Malvin Scafi  
**NPM:** 2306152430  
**Kelas:** Game Development

## Tutorial 7

### Mechanics yang Diimplementasikan

### 1 Pick up item + inventory system

Tujuan: Player dapat mengambil objek di level dan menyimpannya ke inventory.

Implementasi:
- Sistem interaksi tetap menggunakan RayCast3D dari kamera player.
- Class dasar interaksi diperluas agar bisa menerima interactor (player) saat fungsi interact dipanggil.
- Ditambahkan item baru yang bisa di-pickup (`pickup_item.tscn`) dengan script `PickupItem.gd`.
- Saat player menekan tombol interact ke arah item, item memanggil fungsi `add_item_to_inventory()` pada player.
- Data inventory disimpan sebagai Dictionary pada player dengan format `item_id -> jumlah`.
- Item yang sudah diambil akan dihapus dari level (`queue_free`) agar tidak bisa diambil berulang.

### 2 Sprinting + crouching

Tujuan: Player punya tiga mode gerak: normal, sprint, dan crouch.

Implementasi:
- Kecepatan normal tetap dari variabel `speed`.
- Sprint memakai `sprint_multiplier`.
- Crouch memakai `crouch_multiplier`.
- Input sprint: action `sprint` atau tombol Shift.
- Input crouch: action `crouch` atau tombol Ctrl.
- Saat crouch, tinggi kepala kamera diturunkan secara smooth.
- Collision capsule juga dipendekkan secara smooth agar terasa seperti jongkok.


### Input Mapping

- Sprint = SHIFT
- Crouch = CTRL
- Pickup = E