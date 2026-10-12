# Database Design

## 1. Database Overview

The Task Manager backend uses **PostgreSQL 16** as its relational database. The database is named `task_manager` and runs inside a Docker container.

The `init.sql` file initializes the database tables.

The database contains three tables:

- **users:** Stores user information.
- **tasks:** Stores tasks created by users.
- **comments:** Stores comments added to tasks.

## 2. Users Table

The `users` table stores user details.

- `id`: Primary key that uniquely identifies each user.
- `name`: Stores the user's name.
- `email`: Stores the user's unique email address.
- `password_hash`: Stores the hashed password.
- `created_at`: Stores the account creation date and time.

**Constraints:** Name, email, and password hash are required. Email must be unique, and the creation timestamp defaults to the current time.

## 3. Tasks Table

The `tasks` table stores tasks created by users.

- `id`: Primary key that uniquely identifies each task.
- `title`: Stores the task title.
- `description`: Stores task details.
- `status`: Stores the task status; defaults to `PENDING`.
- `priority`: Stores task priority; defaults to `MEDIUM`.
- `due_date`: Stores the task deadline.
- `user_id`: Foreign key referencing `users.id`.
- `created_at`: Stores the task creation time.
- `updated_at`: Stores the last update time.

**Constraints:** Title, status, priority, and user ID are required. Each task belongs to one user. Deleting a user also deletes their tasks through `ON DELETE CASCADE`.

## 4. Comments Table

The `comments` table stores comments associated with tasks.

- `id`: Primary key that uniquely identifies each comment.
- `content`: Stores the comment text.
- `task_id`: Foreign key referencing `tasks.id`.
- `user_id`: Foreign key referencing `users.id`.
- `created_at`: Stores the comment creation time.

**Constraints:** Comment content, task ID, and user ID are required. Deleting a task or user deletes their associated comments through `ON DELETE CASCADE`.

## 5. Relationships

The database uses primary keys and foreign keys to connect its tables.

- **User–Task:** One user can have many tasks. Each task belongs to one user.
- **Task–Comment:** One task can have many comments. Each comment belongs to one task.
- **User–Comment:** One user can create many comments. Each comment belongs to one user.

**Foreign key relationships:**

- `tasks.user_id` → `users.id`
- `comments.task_id` → `tasks.id`
- `comments.user_id` → `users.id`

**Cascade Delete:** When a user is deleted, their tasks and comments are deleted. When a task is deleted, its comments are deleted. This prevents orphan records in the database.