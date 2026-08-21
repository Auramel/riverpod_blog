SELECT
  id,
  login,
  full_name,
  birth_date,
  is_banned,
  is_deleted
FROM users_table
ORDER BY full_name;
