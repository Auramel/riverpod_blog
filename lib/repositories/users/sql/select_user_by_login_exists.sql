SELECT EXISTS (
  SELECT 1
  FROM users_table
  WHERE login = ?
) AS is_exists;
