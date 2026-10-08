# Database Design

## 1. Database Overview

The Task Manager backend uses **PostgreSQL** as its relational database.

The database is named `task_manager` and runs inside a Docker container using PostgreSQL 16. The database is automatically initialized through the `init.sql` file when the Docker container is created for the first time.

The database contains three main tables:

* **users** – stores user information.
* **tasks** – stores tasks created by users.
* **comments** – stores comments made on tasks.

The tables are connected using **primary keys and foreign keys** to maintain relationships and data integrity.

## 2. Users Table

The `users` table stores the basic information of users in the Task Manager system.

| Column          | Data Type    | Constraint                | Description                                         |
| --------------- | ------------ | ------------------------- | --------------------------------------------------- |
| `id`            | SERIAL       | Primary Key               | Unique identifier for each user.                    |
| `name`          | VARCHAR(100) | NOT NULL                  | Name of the user.                                   |
| `email`         | VARCHAR(255) | UNIQUE, NOT NULL          | User's email address.                               |
| `password_hash` | VARCHAR(255) | NOT NULL                  | Stores the hashed password of the user.             |
| `created_at`    | TIMESTAMP    | DEFAULT CURRENT_TIMESTAMP | Stores the date and time when the user was created. |

### Primary Key

The `id` column is the **Primary Key** of the `users` table. It uniquely identifies each user.

### Constraints

* `name` cannot be empty because it has a `NOT NULL` constraint.
* `email` must be unique so that two users cannot register with the same email address.
* `password_hash` is required for every user.
* `created_at` is automatically set to the current date and time when a user is created.

## 3. Tasks Table

The `tasks` table stores the tasks created by users in the Task Manager system.

| Column        | Data Type    | Constraint                  | Description                                   |
| ------------- | ------------ | --------------------------- | --------------------------------------------- |
| `id`          | SERIAL       | Primary Key                 | Unique identifier for each task.              |
| `title`       | VARCHAR(200) | NOT NULL                    | Title or name of the task.                    |
| `description` | TEXT         | —                           | Detailed description of the task.             |
| `status`      | VARCHAR(20)  | NOT NULL, DEFAULT 'PENDING' | Current status of the task.                   |
| `priority`    | VARCHAR(20)  | NOT NULL, DEFAULT 'MEDIUM'  | Priority level of the task.                   |
| `due_date`    | DATE         | —                           | Date by which the task should be completed.   |
| `user_id`     | INTEGER      | NOT NULL, Foreign Key       | Identifies the user who created the task.     |
| `created_at`  | TIMESTAMP    | DEFAULT CURRENT_TIMESTAMP   | Date and time when the task was created.      |
| `updated_at`  | TIMESTAMP    | DEFAULT CURRENT_TIMESTAMP   | Date and time when the task was last updated. |

### Primary Key

The `id` column is the **Primary Key** of the `tasks` table. It uniquely identifies each task.

### Foreign Key

The `user_id` column is a **Foreign Key** that references the `id` column of the `users` table.

This creates a **one-to-many relationship**:

**One user → Many tasks**

### Constraints

* `title` cannot be empty.
* `status` is required and defaults to `PENDING`.
* `priority` is required and defaults to `MEDIUM`.
* `user_id` is required for every task.
* If a user is deleted, their associated tasks are also deleted because of `ON DELETE CASCADE`.


## 4. Comments Table

The `comments` table stores comments added by users to tasks.

| Column       | Data Type | Constraint                | Description                                       |
| ------------ | --------- | ------------------------- | ------------------------------------------------- |
| `id`         | SERIAL    | Primary Key               | Unique identifier for each comment.               |
| `content`    | TEXT      | NOT NULL                  | The actual content of the comment.                |
| `task_id`    | INTEGER   | NOT NULL, Foreign Key     | Identifies the task to which the comment belongs. |
| `user_id`    | INTEGER   | NOT NULL, Foreign Key     | Identifies the user who created the comment.      |
| `created_at` | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Date and time when the comment was created.       |

### Primary Key

The `id` column is the **Primary Key** of the `comments` table. It uniquely identifies each comment.

### Foreign Keys

The `task_id` column references the `id` column of the `tasks` table.

The `user_id` column references the `id` column of the `users` table.

This creates two relationships:

* **One task → Many comments**
* **One user → Many comments**

### Constraints

* `content` cannot be empty.
* `task_id` is required for every comment.
* `user_id` is required for every comment.
* If a task is deleted, its associated comments are also deleted because of `ON DELETE CASCADE`.
* If a user is deleted, their associated comments are also deleted because of `ON DELETE CASCADE`.




## 5. Relationships and Constraints

The Task Manager database contains relationships between the `users`, `tasks`, and `comments` tables.

### 5.1 User–Task Relationship

A user can create multiple tasks, while each task belongs to one user.

**Relationship:**

`users (1) → tasks (many)`

The `tasks.user_id` column references `users.id`.

### 5.2 Task–Comment Relationship

A task can have multiple comments, while each comment belongs to one task.

**Relationship:**

`tasks (1) → comments (many)`

The `comments.task_id` column references `tasks.id`.

### 5.3 User–Comment Relationship

A user can create multiple comments, while each comment is created by one user.

**Relationship:**

`users (1) → comments (many)`

The `comments.user_id` column references `users.id`.

### 5.4 Foreign Key Constraints

The database uses foreign keys to maintain referential integrity.

| Foreign Key        | References | Purpose                         |
| ------------------ | ---------- | ------------------------------- |
| `tasks.user_id`    | `users.id` | Connects a task to its user.    |
| `comments.task_id` | `tasks.id` | Connects a comment to its task. |
| `comments.user_id` | `users.id` | Connects a comment to its user. |

### 5.5 Cascade Delete

The database uses `ON DELETE CASCADE` for the foreign key relationships.

This means:

* Deleting a user deletes their associated tasks.
* Deleting a user deletes their associated comments.
* Deleting a task deletes its associated comments.

This prevents orphan records from remaining in the database.
