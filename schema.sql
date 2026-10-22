-- À coller dans Supabase > SQL Editor > Run
create table posts(
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null default auth.uid() references auth.users on delete cascade,
  author text not null, type text not null, title text not null, descr text,
  created_at timestamptz default now());
create table votes(
  post_id uuid references posts on delete cascade,
  user_id uuid default auth.uid() references auth.users on delete cascade,
  primary key(post_id,user_id));
alter table posts enable row level security;
alter table votes enable row level security;
create policy "lire posts" on posts for select using (true);
create policy "creer post" on posts for insert to authenticated with check (auth.uid()=user_id);
create policy "supprimer son post" on posts for delete to authenticated using (auth.uid()=user_id);
create policy "lire votes" on votes for select using (true);
create policy "voter" on votes for insert to authenticated with check (auth.uid()=user_id);
