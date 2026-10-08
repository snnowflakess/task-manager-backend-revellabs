# GraphQL Design

## 1. GraphQL Overview

GraphQL is a query language and API technology that allows clients to request exactly the data they need from a server.

Unlike REST, where different endpoints are commonly used for different resources, GraphQL generally uses a single endpoint through which clients send queries and mutations.

For the Task Manager system, GraphQL will provide access to the following resources:

* **Users**
* **Tasks**
* **Comments**

### GraphQL Endpoint

```text
/api/graphql
```

The GraphQL API will use JSON for requests and responses.

### Queries and Mutations

GraphQL operations are mainly divided into:

* **Query** – used to retrieve data.
* **Mutation** – used to create, update, or delete data.

For example, a client can request a task and only select the fields it needs instead of receiving every available field.

### Advantages of GraphQL

The Task Manager GraphQL API provides the following benefits:

* Clients can request only the required fields.
* Related data can be requested in a single query.
* A strongly typed schema defines the available data and operations.
* Multiple resources can be retrieved through a single GraphQL endpoint.

## 2. GraphQL Types

The GraphQL schema defines the structure of the data available through the API.

The Task Manager system contains three main GraphQL types: `User`, `Task`, and `Comment`.

### 2.1 User Type

```graphql
type User {
  id: ID!
  name: String!
  email: String!
  createdAt: String!
  tasks: [Task!]!
  comments: [Comment!]!
}
```

The `User` type represents a user in the Task Manager system.

* `id` – unique identifier of the user.
* `name` – user's name.
* `email` – user's email address.
* `createdAt` – date and time when the user was created.
* `tasks` – tasks created by the user.
* `comments` – comments created by the user.

### 2.2 Task Type

```graphql
type Task {
  id: ID!
  title: String!
  description: String
  status: String!
  priority: String!
  dueDate: String
  createdAt: String!
  updatedAt: String!
  user: User!
  comments: [Comment!]!
}
```

The `Task` type represents a task in the system.

* `id` – unique identifier of the task.
* `title` – title of the task.
* `description` – detailed task description.
* `status` – current task status.
* `priority` – task priority.
* `dueDate` – task deadline.
* `createdAt` – task creation time.
* `updatedAt` – last update time.
* `user` – user who created the task.
* `comments` – comments associated with the task.

### 2.3 Comment Type

```graphql
type Comment {
  id: ID!
  content: String!
  createdAt: String!
  task: Task!
  user: User!
}
```

The `Comment` type represents a comment associated with a task.

* `id` – unique identifier of the comment.
* `content` – comment text.
* `createdAt` – date and time when the comment was created.
* `task` – task to which the comment belongs.
* `user` – user who created the comment.

### 2.4 Type Relationships

The GraphQL types represent the same relationships as the PostgreSQL database:

```text
User
 ├── tasks ──────> Task
 └── comments ───> Comment

Task
 ├── user ───────> User
 └── comments ───> Comment

Comment
 ├── task ───────> Task
 └── user ───────> User
```

This allows a client to request related information in a single GraphQL query.

## 3. GraphQL Queries

Queries are used to retrieve data from the Task Manager system.

The following queries are defined for users, tasks, and comments.

### 3.1 Get All Users

```graphql
type Query {
  users: [User!]!
}
```

**Description:**
Returns a list of all users.

**Example Query:**

```graphql
query {
  users {
    id
    name
    email
  }
}
```

---

### 3.2 Get User by ID

```graphql
user(id: ID!): User
```

**Description:**
Returns a specific user using their ID.

**Example Query:**

```graphql
query {
  user(id: 1) {
    id
    name
    email
  }
}
```

---

### 3.3 Get All Tasks

```graphql
tasks: [Task!]!
```

**Description:**
Returns all tasks in the system.

**Example Query:**

```graphql
query {
  tasks {
    id
    title
    status
    priority
  }
}


---

### 3.4 Get Task by ID

```graphql
task(id: ID!): Task
```

**Description:**
Returns a specific task using its ID.

**Example Query:**

```graphql
query {
  task(id: 1) {
    id
    title
    description
    status
    priority
  }
}
```

---

### 3.5 Filter Tasks by Status

```graphql
tasksByStatus(status: String!): [Task!]!
```

**Description:**
Returns tasks matching the specified status.

**Example Query:**

```graphql
query {
  tasksByStatus(status: "PENDING") {
    id
    title
    status
    priority
  }
}
```

---

### 3.6 Get Comments for a Task

```graphql
commentsByTask(taskId: ID!): [Comment!]!
```

**Description:**
Returns all comments associated with a specific task.

**Example Query:**

```graphql
query {
  commentsByTask(taskId: 1) {
    id
    content
    createdAt
    user {
      id
      name
    }
  }
}
```

## 4. GraphQL Mutations

Mutations are used to create, update, and delete data in the Task Manager system.

### 4.1 Create User

```graphql id="md2gfg"
createUser(
  name: String!
  email: String!
  password: String!
): User!
```

**Description:**
Creates a new user.

**Example:**

```graphql id="avjv5n"
mutation {
  createUser(
    name: "Alice Johnson"
    email: "alice@example.com"
    password: "password123"
  ) {
    id
    name
    email
  }
}
```

The password should be securely hashed before being stored in the database.

---

### 4.2 Create Task

```graphql id="8jq0wo"
createTask(
  title: String!
  description: String
  status: String
  priority: String
  dueDate: String
  userId: ID!
): Task!
```

**Description:**
Creates a new task for a user.

**Example:**

```graphql id="j3psj6"
mutation {
  createTask(
    title: "Complete API documentation"
    description: "Finish GraphQL and gRPC documentation."
    status: "PENDING"
    priority: "HIGH"
    dueDate: "2026-10-15"
    userId: 1
  ) {
    id
    title
    status
    priority
  }
}
```

---

### 4.3 Update Task

```graphql id="72n7q7"
updateTask(
  id: ID!
  title: String
  description: String
  status: String
  priority: String
  dueDate: String
): Task!
```

**Description:**
Updates one or more fields of an existing task.

**Example:**

```graphql id="e0l1v7"
mutation {
  updateTask(
    id: 1
    status: "COMPLETED"
  ) {
    id
    title
    status
  }
}
```

---

### 4.4 Delete Task

```graphql id="c9n4gy"
deleteTask(id: ID!): Boolean!
```

**Description:**
Deletes an existing task.

**Example:**

```graphql id="i0x6tw"
mutation {
  deleteTask(id: 1)
}
```

The mutation returns `true` when the task is successfully deleted.

---

### 4.5 Create Comment

```graphql id="3a1x3m"
createComment(
  taskId: ID!
  userId: ID!
  content: String!
): Comment!
```

**Description:**
Creates a new comment for a specific task.

**Example:**

```graphql id="1ixy4n"
mutation {
  createComment(
    taskId: 1
    userId: 1
    content: "The documentation is almost complete."
  ) {
    id
    content
    user {
      name
    }
  }
}
```

---

### 4.6 Delete Comment

```graphql id="c5dx4f"
deleteComment(id: ID!): Boolean!
```

**Description:**
Deletes an existing comment.

**Example:**

```graphql id="9j7h1x"
mutation {
  deleteComment(id: 1)
}
```

## 6. GraphQL and REST Comparison

Both REST and GraphQL are designed for communication between clients and the backend, but they handle data retrieval differently.

| Feature         | REST                                        | GraphQL                                              |
| --------------- | ------------------------------------------- | ---------------------------------------------------- |
| Endpoints       | Multiple endpoints                          | Usually one endpoint                                 |
| Data retrieval  | Server defines response structure           | Client selects required fields                       |
| Related data    | May require multiple requests               | Can be requested in one query                        |
| Operations      | HTTP methods such as GET, POST, PUT, DELETE | Queries and Mutations                                |
| API versioning  | Commonly uses URL versions such as `/v1`    | Schema can evolve without traditional URL versioning |
| Response format | Commonly JSON                               | Commonly JSON                                        |
| Schema          | OpenAPI can describe the API                | Schema is built into GraphQL                         |

For the Task Manager system, REST and GraphQL provide two different interfaces to access the same underlying application data and database.
