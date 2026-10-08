# REST API Design

## 1. REST API Overview

The Task Manager backend provides a **RESTful API** for managing users, tasks, and comments.

REST (Representational State Transfer) is an architectural style used to design web APIs. The API uses standard HTTP methods to perform operations on resources.

The main resources in the Task Manager system are:

* **Users** – represents users of the system.
* **Tasks** – represents tasks created by users.
* **Comments** – represents comments added to tasks.

The API follows a resource-based URL structure and uses **JSON** for request and response data.

### API Base URL

```text
/api/v1
```

API versioning is included using `/v1` so that future versions can be introduced without breaking existing clients.

### HTTP Methods

| Method | Purpose                      | Example            |
| ------ | ---------------------------- | ------------------ |
| GET    | Retrieve data                | Get all tasks      |
| POST   | Create new data              | Create a task      |
| PUT    | Replace/update existing data | Update a task      |
| PATCH  | Partially update data        | Update task status |
| DELETE | Delete data                  | Delete a task      |

### Response Format

The API uses **JSON** as the primary data format for requests and responses.

Example task response:

```json
{
  "id": 1,
  "title": "Complete backend documentation",
  "description": "Finish REST, GraphQL and gRPC API documentation.",
  "status": "PENDING",
  "priority": "HIGH",
  "due_date": "2026-10-15",
  "user_id": 1
}
```
## 2. Users API

The Users API provides endpoints for creating, retrieving, updating, and deleting users.

### 2.1 Get All Users

**Endpoint:**

```text
GET /api/v1/users
```

**Description:**
Retrieves a list of all users in the system.

**Response:** `200 OK`

**Example Response:**

```json
[
  {
    "id": 1,
    "name": "Rachael Biju",
    "email": "rachael@example.com"
  },
  {
    "id": 2,
    "name": "John Doe",
    "email": "john@example.com"
  }
]
```

---

### 2.2 Get User by ID

**Endpoint:**

```text
GET /api/v1/users/{id}
```

**Description:**
Retrieves a specific user using their unique ID.

**Example:**

```text
GET /api/v1/users/1
```

**Response:** `200 OK`

---

### 2.3 Create User

**Endpoint:**

```text
POST /api/v1/users
```

**Description:**
Creates a new user.

**Request Body:**

```json
{
  "name": "Alice Johnson",
  "email": "alice@example.com",
  "password": "password123"
}
```

**Response:** `201 Created`

The password should not be returned in the response. The backend should store the password as a secure hash in the `password_hash` database column.

---

### 2.4 Update User

**Endpoint:**

```text
PUT /api/v1/users/{id}
```

**Description:**
Updates the details of an existing user.

**Example:**

```text
PUT /api/v1/users/1
```

**Request Body:**

```json
{
  "name": "Rachael Elizabeth Biju",
  "email": "rachael@example.com"
}
```

**Response:** `200 OK`

---

### 2.5 Delete User

**Endpoint:**

```text
DELETE /api/v1/users/{id}
```

**Description:**
Deletes a user from the system.

**Example:**

```text
DELETE /api/v1/users/1
```

**Response:** `204 No Content`

When a user is deleted, their associated tasks and comments are also deleted because of the database's `ON DELETE CASCADE` constraints.

## 3. Tasks API

The Tasks API provides endpoints for creating, retrieving, updating, filtering, and deleting tasks.

### 3.1 Get All Tasks

**Endpoint:**

```text
GET /api/v1/tasks
```

**Description:**
Retrieves all tasks in the system.

**Response:** `200 OK`

---

### 3.2 Get Task by ID

**Endpoint:**

```text
GET /api/v1/tasks/{id}
```

**Description:**
Retrieves a specific task using its unique ID.

**Example:**

```text
GET /api/v1/tasks/1
```

**Response:** `200 OK`

---

### 3.3 Filter Tasks by Status

**Endpoint:**

```text
GET /api/v1/tasks?status=pending
```

**Description:**
Retrieves tasks based on their status.

The `status` value can be used as a query parameter to filter the tasks.

**Example:**

```text
GET /api/v1/tasks?status=pending
```

**Response:** `200 OK`

---

### 3.4 Create Task

**Endpoint:**

```text
POST /api/v1/tasks
```

**Description:**
Creates a new task for a user.

**Request Body:**

```json
{
  "title": "Complete backend documentation",
  "description": "Finish REST, GraphQL and gRPC API documentation.",
  "status": "PENDING",
  "priority": "HIGH",
  "due_date": "2026-10-15",
  "user_id": 1
}
```

**Response:** `201 Created`

---

### 3.5 Replace Task

**Endpoint:**

```text
PUT /api/v1/tasks/{id}
```

**Description:**
Replaces the details of an existing task.

**Example:**

```text
PUT /api/v1/tasks/1
```

**Request Body:**

```json
{
  "title": "Complete REST API documentation",
  "description": "Finish the REST API design documentation.",
  "status": "IN_PROGRESS",
  "priority": "HIGH",
  "due_date": "2026-10-15",
  "user_id": 1
}
```

**Response:** `200 OK`

---

### 3.6 Partially Update Task

**Endpoint:**

```text
PATCH /api/v1/tasks/{id}
```

**Description:**
Updates only specific fields of an existing task.

For example, only the task status can be updated without sending all other fields.

**Request Body:**

```json
{
  "status": "COMPLETED"
}
```

**Response:** `200 OK`

---

### 3.7 Delete Task

**Endpoint:**

```text
DELETE /api/v1/tasks/{id}
```

**Description:**
Deletes a specific task.

**Example:**

```text
DELETE /api/v1/tasks/1
```

**Response:** `204 No Content`

When a task is deleted, its associated comments are also deleted because of the database's `ON DELETE CASCADE` constraint.

---

### 3.8 Export Tasks

**Endpoint:**

```text
POST /api/v1/tasks/export
```

**Description:**
Starts an asynchronous task export operation.

The API creates an export job instead of making the client wait for the complete export process.

**Response:** `202 Accepted`

**Example Response:**

```json
{
  "jobId": "job-12345",
  "status": "PROCESSING"
}
```

The returned `jobId` can be used to check the status of the export job.

## 4. Comments API

The Comments API allows users to view and create comments associated with a specific task.

### 4.1 Get Comments for a Task

**Endpoint:**

```text
GET /api/v1/tasks/{id}/comments
```

**Description:**
Retrieves all comments associated with a specific task.

**Example:**

```text
GET /api/v1/tasks/1/comments
```

**Response:** `200 OK`

**Example Response:**

```json
[
  {
    "id": 1,
    "content": "I have started working on the documentation.",
    "task_id": 1,
    "user_id": 1,
    "created_at": "2026-10-08T10:00:00"
  }
]
```

---

### 4.2 Create Comment

**Endpoint:**

```text
POST /api/v1/tasks/{id}/comments
```

**Description:**
Creates a new comment for a specific task.

**Example:**

```text
POST /api/v1/tasks/1/comments
```

**Request Body:**

```json
{
  "content": "I have completed the API documentation.",
  "user_id": 1
}
```

**Response:** `201 Created`

---

### 4.3 Get a Specific Comment

**Endpoint:**

```text
GET /api/v1/tasks/{id}/comments/{commentId}
```

**Description:**
Retrieves a specific comment belonging to a task.

**Example:**

```text
GET /api/v1/tasks/1/comments/1
```

**Response:** `200 OK`

---

### 4.4 Delete Comment

**Endpoint:**

```text
DELETE /api/v1/tasks/{id}/comments/{commentId}
```

**Description:**
Deletes a specific comment from a task.

**Example:**

```text
DELETE /api/v1/tasks/1/comments/1
```

**Response:** `204 No Content`

---

## 5. Export Job Status API

The task export operation is asynchronous. This means the client does not have to wait while the export is being processed.

After calling:

```text
POST /api/v1/tasks/export
```

the API returns a `jobId`.

The client can then use the job ID to check the export status.

### 5.1 Get Export Job Status

**Endpoint:**

```text
GET /api/v1/jobs/{jobId}
```

**Description:**
Retrieves the current status of an export job.

**Example:**

```text
GET /api/v1/jobs/job-12345
```

**Response:** `200 OK`

**Example Response:**

```json
{
  "jobId": "job-12345",
  "status": "COMPLETED",
  "downloadUrl": "/api/v1/jobs/job-12345/download"
}
```

Possible job statuses include:

* `PROCESSING`
* `COMPLETED`
* `FAILED`

## 6. HTTP Status Codes

The REST API uses standard HTTP status codes to indicate the result of each request.

| Status Code                 | Meaning                                  | Usage                                           |
| --------------------------- | ---------------------------------------- | ----------------------------------------------- |
| `200 OK`                    | Request successful                       | Successful GET, PUT, or PATCH request           |
| `201 Created`               | Resource created                         | Successful POST request                         |
| `202 Accepted`              | Request accepted for processing          | Asynchronous task export                        |
| `204 No Content`            | Request successful with no response body | Successful DELETE request                       |
| `400 Bad Request`           | Invalid request                          | Missing or invalid request data                 |
| `401 Unauthorized`          | Authentication required or invalid       | Missing or invalid JWT                          |
| `403 Forbidden`             | Access denied                            | User does not have permission                   |
| `404 Not Found`             | Resource not found                       | Requested user, task, or comment does not exist |
| `409 Conflict`              | Resource conflict                        | Duplicate email or conflicting data             |
| `500 Internal Server Error` | Server-side error                        | Unexpected server error                         |

## 7. Error Response Format

When an API request fails, the API returns a consistent JSON error response.

### Example

```json id="07qax4"
{
  "status": 404,
  "error": "Not Found",
  "message": "Task with ID 10 was not found."
}
```

A validation error can be returned as:

```json id="7b6qyu"
{
  "status": 400,
  "error": "Bad Request",
  "message": "Task title is required."
}
```

Using a consistent error format makes it easier for clients such as web applications and mobile applications to understand and handle API errors.
