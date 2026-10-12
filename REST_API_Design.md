# REST API Design

## 1. REST API Overview

REST (Representational State Transfer) is an architectural style used to build APIs that allow applications to communicate with a server.

The Task Manager API manages three resources: Users, Tasks, and Comments. It uses HTTP methods and JSON for requests and responses.

**Base URL:** `/api/v1`

**HTTP Methods:**
- `GET` – Retrieves data.
- `POST` – Creates data.
- `PUT` – Replaces existing data.
- `PATCH` – Updates selected fields.
- `DELETE` – Deletes data.

**Example JSON Response:**

```json
{
  "id": 1,
  "title": "Complete documentation",
  "status": "PENDING",
  "priority": "HIGH",
  "user_id": 1
}
```

## 2. Users API

- **GET `/api/v1/users`** – Retrieves all users. Response: `200 OK`.
- **GET `/api/v1/users/{id}`** – Retrieves a user by ID. Response: `200 OK`.
- **POST `/api/v1/users`** – Creates a user using name, email, and password. Response: `201 Created`.
- **PUT `/api/v1/users/{id}`** – Updates user details. Response: `200 OK`.
- **DELETE `/api/v1/users/{id}`** – Deletes a user. Response: `204 No Content`.

Passwords must be stored as secure hashes, never as plain text. Deleting a user also deletes their associated tasks and comments through cascade deletion.

## 3. Tasks API

- **GET `/api/v1/tasks`** – Retrieves all tasks. Response: `200 OK`.
- **GET `/api/v1/tasks/{id}`** – Retrieves a task by ID. Response: `200 OK`.
- **GET `/api/v1/tasks?status=PENDING`** – Filters tasks by status. Response: `200 OK`.
- **POST `/api/v1/tasks`** – Creates a task with a title, description, status, priority, due date, and user ID. Response: `201 Created`.
- **PUT `/api/v1/tasks/{id}`** – Replaces the task details. Response: `200 OK`.
- **PATCH `/api/v1/tasks/{id}`** – Updates selected fields, such as task status. Response: `200 OK`.
- **DELETE `/api/v1/tasks/{id}`** – Deletes a task. Response: `204 No Content`.

Deleting a task also deletes its associated comments through cascade deletion.

**Example PATCH Request:**

```json
{
  "status": "COMPLETED"
}
```

## 4. Comments API

- **GET `/api/v1/tasks/{id}/comments`** – Retrieves all comments for a task. Response: `200 OK`.
- **POST `/api/v1/tasks/{id}/comments`** – Creates a comment using its content and user ID. Response: `201 Created`.
- **GET `/api/v1/tasks/{id}/comments/{commentId}`** – Retrieves a specific comment. Response: `200 OK`.
- **DELETE `/api/v1/tasks/{id}/comments/{commentId}`** – Deletes a comment. Response: `204 No Content`.

**Example Comment Request:**

```json
{
  "content": "Documentation is complete.",
  "user_id": 1
}
```

## 5. Export Job API

The export API performs long-running tasks asynchronously, allowing the client to continue without waiting for the export to finish.

- **POST `/api/v1/tasks/export`** – Starts a task export. Response: `202 Accepted`.
- **GET `/api/v1/jobs/{jobId}`** – Checks the export status. Response: `200 OK`.

**Example Response:**

```json
{
  "jobId": "job-12345",
  "status": "PROCESSING"
}
```

Possible statuses are `PROCESSING`, `COMPLETED`, and `FAILED`.

## 6. HTTP Status Codes

- `200 OK` – Request completed successfully.
- `201 Created` – Resource created successfully.
- `202 Accepted` – Request accepted for processing.
- `204 No Content` – Request succeeded without a response body.
- `400 Bad Request` – Invalid request data.
- `401 Unauthorized` – Authentication is missing or invalid.
- `403 Forbidden` – User does not have permission.
- `404 Not Found` – Resource does not exist.
- `409 Conflict` – Duplicate or conflicting data.
- `500 Internal Server Error` – Unexpected server error.

## 7. Error Response Format

The API returns JSON messages when a request fails.

**Example:**

```json
{
  "status": 404,
  "error": "Not Found",
  "message": "Task with ID 10 was not found."
}
```

A consistent error format helps clients understand and handle errors easily.