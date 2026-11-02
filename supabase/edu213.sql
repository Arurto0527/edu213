-- ============================================================
-- EDU213 テスト対策アプリの記録（端末をまたいで引き継ぐため）
-- ・1行 = 1人ぶんの記録（間違えた問題・復習・正答数・記述・チェック）を JSON でまとめたもの
-- ・読み書きできるのは本人だけ
-- ・Roots と同じ Supabase プロジェクトを使う（ログインは Roots と同じメールのコード方式）
-- Supabase の SQL Editor に全部はりつけて Run する（何回実行してもよい）
-- ============================================================
create table if not exists public.edu213_state (
  user_id    uuid primary key references auth.users(id) on delete cascade,
  data       jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);

alter table public.edu213_state enable row level security;
revoke all on public.edu213_state from anon;
grant select, insert, update, delete on public.edu213_state to authenticated;

drop policy if exists edu213_state_own on public.edu213_state;
create policy edu213_state_own on public.edu213_state
  for all to authenticated
  using (user_id = auth.uid())
  with check (user_id = auth.uid());
