-- 자기소개 페이지의 연락처 폼 테이블
-- Supabase 대시보드의 SQL Editor에서 한 번 실행하세요.
-- 방문자는 메시지를 보내기만 할 수 있고, 다른 사람의 메시지는 읽을 수 없습니다.
-- 받은 메시지는 대시보드의 Table Editor > contact_messages 에서 확인하세요.

create table if not exists public.contact_messages (
  id bigint generated always as identity primary key,
  name text not null check (char_length(btrim(name)) between 1 and 30),
  contact text check (contact is null or char_length(contact) <= 100),
  message text not null check (char_length(btrim(message)) between 1 and 1000),
  created_at timestamptz not null default now()
);

alter table public.contact_messages enable row level security;

revoke all on table public.contact_messages from anon, authenticated;
grant insert (name, contact, message) on table public.contact_messages to anon, authenticated;

drop policy if exists "contact_send" on public.contact_messages;
create policy "contact_send"
  on public.contact_messages for insert
  to anon, authenticated
  with check (true);
