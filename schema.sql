-- Run this once in Supabase: Dashboard -> SQL Editor -> New query -> paste -> Run

create table if not exists config (
  id int primary key default 1,
  data jsonb not null
);

create table if not exists foods (
  id text primary key,
  name text not null,
  unit text not null,
  is_x boolean default false,
  is_meal boolean default false,
  cal numeric default 0,
  protein numeric default 0,
  carb numeric default 0,
  fat numeric default 0,
  fibre numeric default 0,
  sugar numeric default 0,
  salt numeric default 0,
  batch_date text,
  batch_weight numeric,
  raw_weight numeric
);

create table if not exists logs (
  id text primary key,
  date text not null,
  slot text not null,
  person text not null,
  food_name text,
  grams numeric default 0,
  cal numeric default 0,
  protein numeric default 0,
  carb numeric default 0,
  fat numeric default 0,
  fibre numeric default 0,
  sugar numeric default 0,
  salt numeric default 0
);

alter table config enable row level security;
alter table foods enable row level security;
alter table logs enable row level security;

-- Public policies: this app has no login, both people share the same anon key.
-- Anyone with the anon key (i.e. anyone with the deployed app URL) can read/write.
drop policy if exists "public read config" on config;
drop policy if exists "public write config" on config;
drop policy if exists "public update config" on config;
create policy "public read config" on config for select using (true);
create policy "public write config" on config for insert with check (true);
create policy "public update config" on config for update using (true);

drop policy if exists "public read foods" on foods;
drop policy if exists "public write foods" on foods;
drop policy if exists "public update foods" on foods;
drop policy if exists "public delete foods" on foods;
create policy "public read foods" on foods for select using (true);
create policy "public write foods" on foods for insert with check (true);
create policy "public update foods" on foods for update using (true);
create policy "public delete foods" on foods for delete using (true);

drop policy if exists "public read logs" on logs;
drop policy if exists "public write logs" on logs;
drop policy if exists "public update logs" on logs;
drop policy if exists "public delete logs" on logs;
create policy "public read logs" on logs for select using (true);
create policy "public write logs" on logs for insert with check (true);
create policy "public update logs" on logs for update using (true);
create policy "public delete logs" on logs for delete using (true);

insert into config (id, data) values (1, '{}'::jsonb) on conflict (id) do nothing;
