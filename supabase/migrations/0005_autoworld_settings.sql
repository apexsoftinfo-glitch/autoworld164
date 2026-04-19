-- Migration: autoworld_settings table and realtime
create table if not exists public.autoworld_settings (
  id uuid primary key references auth.users(id) on delete cascade,
  garage_name text,
  currency text default 'usd',
  language text default 'pl',
  garage_background text default 'assets/images/warm_garage.png',
  updated_at timestamp with time zone default now()
);

alter table public.autoworld_settings enable row level security;

-- Policies
drop policy if exists "Users can view their own settings" on public.autoworld_settings;
create policy "Users can view their own settings"
  on public.autoworld_settings for select
  using (auth.uid() = id);

drop policy if exists "Users can update their own settings" on public.autoworld_settings;
create policy "Users can update their own settings"
  on public.autoworld_settings for update
  using (auth.uid() = id);

drop policy if exists "Users can insert their own settings" on public.autoworld_settings;
create policy "Users can insert their own settings"
  on public.autoworld_settings for insert
  with check (auth.uid() = id);

-- Realtime
do $$
begin
  if exists (
    select 1
    from pg_publication
    where pubname = 'supabase_realtime'
  ) and not exists (
    select 1
    from pg_publication_tables
    where pubname = 'supabase_realtime'
      and schemaname = 'public'
      and tablename = 'autoworld_settings'
  ) then
    alter publication supabase_realtime add table public.autoworld_settings;
  end if;
end;
$$;
