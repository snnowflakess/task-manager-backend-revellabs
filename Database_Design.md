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


## Database Indexing Strategy

### Purpose of Indexing

Indexes improve query performance by helping PostgreSQL locate records efficiently. They are especially useful for frequently searched, filtered, joined, or sorted columns.

However, indexes require storage and can slow down INSERT, UPDATE, and DELETE operations slightly because the indexes must also be maintained.

### Proposed Indexes

| Table | Column(s) | Reason |
|---|---|---|
| users | email | Supports quick email lookups. The UNIQUE constraint on email already creates a unique index in PostgreSQL. |
| tasks | user_id | Speeds up retrieving tasks belonging to a particular user and helps queries involving the users table. |
| tasks | status | Speeds up filtering tasks by status, such as PENDING or COMPLETED. |
| tasks | user_id, status | Supports queries that filter tasks by both user and status. |
| comments | task_id | Speeds up retrieving comments belonging to a specific task. |
| comments | user_id | Helps find comments created by a particular user. |

### SQL Implementation

The following SQL statements define the proposed indexes:

```sql
CREATE INDEX idx_tasks_user_id
ON tasks(user_id);

CREATE INDEX idx_tasks_status
ON tasks(status);

CREATE INDEX idx_tasks_user_status
ON tasks(user_id, status);

CREATE INDEX idx_comments_task_id
ON comments(task_id);

CREATE INDEX idx_comments_user_id
ON comments(user_id);
```

A separate index on `users.email` is unnecessary because the existing UNIQUE constraint already creates one.

### Index Selection Strategy

Indexes are selected based on the queries expected in the Task Manager API. For example:

- `GET /api/v1/tasks?status=PENDING` can benefit from the status index.
- Retrieving tasks for a specific user can benefit from the `user_id` index.
- Retrieving comments using `/api/v1/tasks/{id}/comments` can benefit from the `task_id` index.
- Queries filtering by both user and status can benefit from the composite `(user_id, status)` index.

The composite index is most useful when queries filter by `user_id` alone or by both `user_id` and `status`, because its columns are ordered accordingly.

### Performance Evaluation

The indexes should be evaluated using PostgreSQL's `EXPLAIN` and `EXPLAIN ANALYZE` commands with representative queries and realistic data volumes. Indexes should be retained or adjusted based on observed query performance and write overhead.

### Implementation Status

These indexes are proposed as part of the database design. They should be added to the database initialization script or applied through a database migration before they can be considered implemented. Existing PostgreSQL databases with a persistent Docker volume will not automatically rerun the initialization script.