-- =====================================================================
-- THIẾT LẬP DATABASE & STORAGE CHO THIỆP MỜI 11 MONTHS OF US (SUPABASE)
-- Hướng dẫn: Copy toàn bộ nội dung file này -> dán vào Supabase SQL Editor -> bấm RUN
-- =====================================================================

-- 1. Bảng lưu xác nhận tham dự (RSVP) & lời nhắn của Ngọc Hà
create table if not exists public.rsvp_responses (
  id uuid primary key default gen_random_uuid(),
  guest_name text not null default 'Ngọc Hà',
  confirmed boolean not null default true,
  message text not null default '',
  user_agent text default '',
  created_at timestamptz not null default now()
);

-- 2. Bảng lưu Album ảnh kỷ niệm chung
create table if not exists public.album_photos (
  id uuid primary key default gen_random_uuid(),
  image_url text not null,
  storage_path text not null default '',
  location text not null default 'Khoảnh khắc chung 24/11',
  caption text not null default '',
  frame text not null default 'none',
  uploaded_by text not null default 'Mai Sơn & Ngọc Hà',
  created_at timestamptz not null default now()
);

-- 3. Bảng lưu tiến độ check-in 8 điểm hẹn
create table if not exists public.itinerary_checkins (
  stop_id text primary key,
  checked boolean not null default false,
  updated_at timestamptz not null default now()
);

-- 4. Bật Row Level Security (RLS) và cấp quyền đọc/ghi công khai cho ứng dụng
alter table public.rsvp_responses enable row level security;
alter table public.album_photos enable row level security;
alter table public.itinerary_checkins enable row level security;

drop policy if exists "Allow public read rsvp" on public.rsvp_responses;
create policy "Allow public read rsvp"
  on public.rsvp_responses for select to anon, authenticated
  using (true);

drop policy if exists "Allow public insert rsvp" on public.rsvp_responses;
create policy "Allow public insert rsvp"
  on public.rsvp_responses for insert to anon, authenticated
  with check (true);

drop policy if exists "Allow public delete rsvp" on public.rsvp_responses;
create policy "Allow public delete rsvp"
  on public.rsvp_responses for delete to anon, authenticated
  using (true);

drop policy if exists "Allow public read album" on public.album_photos;
create policy "Allow public read album"
  on public.album_photos for select to anon, authenticated
  using (true);

drop policy if exists "Allow public insert album" on public.album_photos;
create policy "Allow public insert album"
  on public.album_photos for insert to anon, authenticated
  with check (true);

drop policy if exists "Allow public delete album" on public.album_photos;
create policy "Allow public delete album"
  on public.album_photos for delete to anon, authenticated
  using (true);

drop policy if exists "Allow public read checkins" on public.itinerary_checkins;
create policy "Allow public read checkins"
  on public.itinerary_checkins for select to anon, authenticated
  using (true);

drop policy if exists "Allow public upsert checkins" on public.itinerary_checkins;
create policy "Allow public upsert checkins"
  on public.itinerary_checkins for insert to anon, authenticated
  with check (true);

drop policy if exists "Allow public update checkins" on public.itinerary_checkins;
create policy "Allow public update checkins"
  on public.itinerary_checkins for update to anon, authenticated
  using (true) with check (true);

-- 5. Tạo Storage Bucket công khai để lưu ảnh Album (1GB miễn phí)
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values (
  'anniversary-album',
  'anniversary-album',
  true,
  10485760,
  array['image/jpeg', 'image/png', 'image/webp', 'image/gif']
)
on conflict (id) do update
set public = true,
    file_size_limit = 10485760,
    allowed_mime_types = array['image/jpeg', 'image/png', 'image/webp', 'image/gif'];

-- Cấp quyền đọc / tải lên / xóa ảnh trong bucket anniversary-album
drop policy if exists "Public read album storage" on storage.objects;
create policy "Public read album storage"
  on storage.objects for select to anon, authenticated
  using (bucket_id = 'anniversary-album');

drop policy if exists "Public upload album storage" on storage.objects;
create policy "Public upload album storage"
  on storage.objects for insert to anon, authenticated
  with check (bucket_id = 'anniversary-album');

drop policy if exists "Public delete album storage" on storage.objects;
create policy "Public delete album storage"
  on storage.objects for delete to anon, authenticated
  using (bucket_id = 'anniversary-album');

-- 6. Bật Realtime để 2 máy cập nhật ngay lập tức không cần tải lại trang
do $$
begin
  if not exists (
    select 1 from pg_publication_tables
    where pubname = 'supabase_realtime' and schemaname = 'public' and tablename = 'rsvp_responses'
  ) then
    alter publication supabase_realtime add table public.rsvp_responses;
  end if;

  if not exists (
    select 1 from pg_publication_tables
    where pubname = 'supabase_realtime' and schemaname = 'public' and tablename = 'album_photos'
  ) then
    alter publication supabase_realtime add table public.album_photos;
  end if;

  if not exists (
    select 1 from pg_publication_tables
    where pubname = 'supabase_realtime' and schemaname = 'public' and tablename = 'itinerary_checkins'
  ) then
    alter publication supabase_realtime add table public.itinerary_checkins;
  end if;
end $$;
