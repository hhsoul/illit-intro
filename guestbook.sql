-- 아일릿 소개 사이트의 응원 방명록 테이블
-- Supabase 대시보드의 SQL Editor에서 한 번 실행하세요.

create table if not exists public.guestbook (
  id bigint generated always as identity primary key,
  nickname text not null check (char_length(btrim(nickname)) between 1 and 20),
  message text not null check (char_length(btrim(message)) between 1 and 200),
  created_at timestamptz not null default now()
);

alter table public.guestbook enable row level security;

-- 방문자는 읽기와 새 글 쓰기만 할 수 있습니다. 수정과 삭제는 할 수 없습니다.
revoke all on table public.guestbook from anon, authenticated;
grant select on table public.guestbook to anon, authenticated;
grant insert (nickname, message) on table public.guestbook to anon, authenticated;

drop policy if exists "guestbook_read" on public.guestbook;
create policy "guestbook_read"
  on public.guestbook for select
  to anon, authenticated
  using (true);

drop policy if exists "guestbook_write" on public.guestbook;
create policy "guestbook_write"
  on public.guestbook for insert
  to anon, authenticated
  with check (true);
