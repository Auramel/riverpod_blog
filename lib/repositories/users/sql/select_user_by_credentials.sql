SELECT
  id,
  login,
  full_name,
  birth_date,
  is_banned,
  is_deleted
FROM users_table
WHERE login = ?
  AND password = ?
  AND is_deleted = 0
LIMIT 1;
