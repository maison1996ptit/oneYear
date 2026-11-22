/**
 * CẤU HÌNH ĐỒNG BỘ TRỰC TUYẾN (SUPABASE)
 * ---------------------------------------------------------
 * Để lời xác nhận RSVP của Ngọc Hà và Album ảnh được lưu trực tuyến
 * (cả hai máy đều xem được trên GitHub Pages), hãy điền 2 thông số
 * từ dự án Supabase miễn phí của bạn vào bên dưới:
 *
 * 1. Vào https://supabase.com -> New Project (miễn phí, không cần thẻ)
 * 2. Vào SQL Editor -> dán & chạy toàn bộ nội dung file `supabase-setup.sql`
 * 3. Vào Project Settings -> API:
 *    - Copy "Project URL" dán vào SUPABASE_URL
 *    - Copy "anon public" key dán vào SUPABASE_ANON_KEY
 * 4. Lưu file này và đẩy (git push) lên GitHub!
 *
 * Lưu ý: Nếu để trống, trang web vẫn chạy bình thường ở chế độ
 * lưu tạm trên trình duyệt (Local Mode).
 */
window.APP_CONFIG = {
  SUPABASE_URL: '',
  SUPABASE_ANON_KEY: '',
  STORAGE_BUCKET: 'anniversary-album'
};
