# 11 Months of Us — Thiệp Mời Hẹn Hò 24/11/2026 (Mai Sơn & Ngọc Hà)

Trang thiệp mời hẹn hò kỷ niệm 11 tháng kèm lịch trình 8 điểm Quận 1, đồng bộ xác nhận tham dự (RSVP) trực tuyến, tải nhiều ảnh lên Album chung và triển khai tự động trên **GitHub Pages**.

---

## Tính năng nổi bật

1. **Xác nhận tham dự (RSVP) đồng bộ trực tuyến**
   - Khi Ngọc Hà nhập lời nhắn và bấm **"Em đồng ý đi hẹn!"**, nội dung kèm ngày giờ xác nhận sẽ được lưu ngay lên **Supabase**.
   - **Mai Sơn** mở link web trên bất kỳ thiết bị nào (hoặc mở mục **"Góc Mai Sơn"** / truy cập đường dẫn có thêm `?view=maison`) sẽ thấy ngay trạng thái đồng ý, lời nhắn mới nhất và toàn bộ lịch sử lời nhắn — cập nhật **Realtime** không cần tải lại trang.
2. **Album Ảnh Kỷ Niệm Chung & Khung Check-in**
   - **Tải nhiều ảnh cùng lúc**: Chọn nhiều ảnh từ điện thoại/máy tính, tự động nén tối ưu tốc độ tải, gắn địa điểm trong lịch trình, nhập caption và tải hàng loạt lên Album chung.
   - **Khung Check-in phong cách tạp chí**: Ghép khung *Polaroid*, *Tạp Chí*, *Kỷ Niệm 11 Tháng*, xuất file PNG chất lượng cao (`1080x1350`) hoặc lưu thẳng vào Album chung.
   - **Thư viện Album & Lightbox**: Lọc ảnh theo địa điểm, bấm vào ảnh để xem toàn màn hình (hỗ trợ vuốt trên điện thoại và phím mũi tên trên máy tính), tải ảnh về hoặc xóa ảnh.
3. **Đồng bộ tiến độ Check-in 8 điểm hẹn**
   - Đánh dấu hoàn thành từng điểm trên lịch trình và đồng bộ trực tiếp giữa hai máy.
4. **Dựng sẵn trên GitHub Pages**
   - Đã cấu hình sẵn GitHub Actions workflow tại `.github/workflows/deploy-pages.yml` để tự động triển khai mỗi khi `git push` lên nhánh `main`.

---

## Bước 1: Cấu hình lưu trữ trực tuyến Supabase (Miễn phí, 2 phút)

> Không cần thẻ tín dụng. Free tier gồm PostgreSQL database + 1GB lưu trữ ảnh (~2.500 ảnh đã tối ưu).

1. Truy cập [https://supabase.com](https://supabase.com) và đăng nhập (có thể đăng nhập nhanh bằng tài khoản GitHub).
2. Bấm **New project** → Đặt tên (VD: `one-year-date`) → Chọn khu vực gần Việt Nam (**Singapore**) → Bấm **Create new project**.
3. Sau khi project khởi tạo xong, vào menu **SQL Editor** ở thanh bên trái → bấm **New query**.
4. Mở file `supabase-setup.sql` trong dự án này, copy **toàn bộ nội dung**, dán vào SQL Editor và bấm **Run** (chờ hiện `Success`).
5. Vào **Project Settings** (biểu tượng bánh răng) → chọn **API** (hoặc **Data API** / **API Keys**):
   - Copy **Project URL** (dạng `https://xxxxx.supabase.co`).
   - Copy **anon public** key (dạng `eyJ...` hoặc `sb_publishable_...`).
6. Mở file `config.js` trong dự án và dán 2 giá trị vào:
   ```js
   window.APP_CONFIG = {
     SUPABASE_URL: 'https://xxxxx.supabase.co',
     SUPABASE_ANON_KEY: 'eyJ...',
     STORAGE_BUCKET: 'anniversary-album'
   };
   ```

---

## Bước 2: Đẩy lên GitHub & Bật GitHub Pages

1. Mở terminal tại thư mục `D:\oneYear` và đẩy code lên GitHub:
   ```bash
   git add .
   git commit -m "Add Supabase RSVP sync, multi-photo album, and GitHub Pages deploy"
   git push origin main
   ```
2. Vào repository trên GitHub: `https://github.com/maison1996ptit/oneYear`
3. Chọn **Settings** → mục **Pages** (thanh bên trái):
   - Ở phần **Build and deployment** → **Source**, chọn **GitHub Actions**.
4. Vào tab **Actions** trên GitHub để xem workflow **Deploy to GitHub Pages** chạy xong (khoảng 30 giây).
5. Trang web của bạn sẽ hoạt động tại:
   - Link gửi Ngọc Hà: `https://maison1996ptit.github.io/oneYear/`
   - Link mở nhanh **Góc Mai Sơn** (xem lịch sử xác nhận & ảnh): `https://maison1996ptit.github.io/oneYear/?view=maison`

---

## Cấu trúc thư mục

- `index.html` — Toàn bộ giao diện & logic ứng dụng web
- `config.js` — Nơi điền `SUPABASE_URL` và `SUPABASE_ANON_KEY`
- `supabase-setup.sql` — Script SQL tạo bảng dữ liệu, Storage Bucket & Realtime cho Supabase
- `.github/workflows/deploy-pages.yml` — Tự động deploy lên GitHub Pages khi push nhánh `main`
- `.nojekyll` — Đảm bảo GitHub Pages phục vụ file tĩnh trực tiếp
