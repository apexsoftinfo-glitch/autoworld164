create table if not exists public.shared_users (
  id uuid primary key references auth.users(id) on delete cascade,
  first_name text
);

grant select, insert, update, delete on table public.shared_users to authenticated;
grant select, insert, update, delete on table public.shared_users to service_role;
grant select on table public.shared_users to anon;
