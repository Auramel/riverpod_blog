# River Blog

Пет-проект на Flutter для экспериментов с Riverpod, Event Bus, SQLite и offline-first архитектурой.

## Консоль базы данных

Команды запускаются из корня проекта. Для их работы утилита `sqlite3` должна быть доступна в `PATH`.

### Миграции

Применить все новые миграции:

```bash
dart run db:migrate
```

Посмотреть состояние миграций:

```bash
dart run db:status
```

Удалить базу, заново применить все миграции и запустить сидеры:

```bash
dart run db:fresh
```

Команда запросит подтверждение. Чтобы пропустить подтверждение:

```bash
dart run db:fresh --force
```

Создать новый SQL-файл миграции:

```bash
dart run db:make_migration create_posts_table
```

Файл будет создан в `lib/database/migrations/` с очередным числовым префиксом.

### Сидеры

Запустить все сидеры:

```bash
dart run db:seed
```

Создать новый SQL-файл сидера:

```bash
dart run db:make_seeder posts
```

Файл будет создан в `lib/database/seeders/`.

### Путь к базе

Показать путь к используемому файлу SQLite:

```bash
dart run db:path
```

Любой команде можно явно передать другой файл базы:

```bash
dart run db:migrate --database=/path/to/database.sqlite
```

Также путь можно задать через переменную окружения:

```bash
RIVER_BLOG_DATABASE_PATH=/path/to/database.sqlite dart run db:migrate
```

Приоритет выбора пути:

1. Аргумент `--database`.
2. Переменная окружения `RIVER_BLOG_DATABASE_PATH`.
3. Стандартный путь базы приложения на macOS.

### Справка

Список всех команд можно вывести так:

```bash
dart run db:migrate --help
```
