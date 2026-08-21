CREATE TABLE users_table (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  login TEXT NOT NULL UNIQUE,
  password TEXT NOT NULL,
  full_name TEXT NOT NULL,
  birth_date TEXT NOT NULL,
  is_banned INTEGER NOT NULL DEFAULT 0 CHECK (is_banned IN (0, 1)),
  is_deleted INTEGER NOT NULL DEFAULT 0 CHECK (is_deleted IN (0, 1))
);
