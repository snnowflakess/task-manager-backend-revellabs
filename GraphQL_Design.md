# GraphQL Design

## 1. GraphQL Overview

GraphQL is an API technology that allows clients to request only the data they need. Unlike REST, which uses multiple endpoints, GraphQL usually uses a single endpoint.

**Endpoint:** `/api/graphql`

GraphQL uses:
- **Query:** To retrieve data.
- **Mutation:** To create, update, or delete data.

The Task Manager API manages Users, Tasks, and Comments. It allows related data to be retrieved in one request.

## 2. GraphQL Types

GraphQL uses types to define the structure of data.

```graphql
type User {
  id: ID!
  name: String!
  email: String!
  tasks: [Task!]!
}

type Task {
  id: ID!
  title: String!
  description: String
  status: String!
  priority: String!
  user: User!
  comments: [Comment!]!
}

type Comment {
  id: ID!
  content: String!
  task: Task!
  user: User!
}
```

- **User:** Stores user details and their tasks.
- **Task:** Stores task details, status, and priority.
- **Comment:** Stores comments linked to a task and user.

## 3. GraphQL Queries

Queries retrieve information from the server.

**Get all tasks:**

```graphql
query {
  tasks {
    id
    title
    status
  }
}
```

**Get a task by ID:**

```graphql
query {
  task(id: 1) {
    id
    title
    status
  }
}
```

**Get comments for a task:**

```graphql
query {
  commentsByTask(taskId: 1) {
    id
    content
  }
}
```

## 4. GraphQL Mutations

Mutations create, update, or delete data.

**Create a task:**

```graphql
mutation {
  createTask(
    title: "Complete API documentation"
    userId: 1
  ) {
    id
    title
    status
  }
}
```

**Update a task:**

```graphql
mutation {
  updateTask(id: 1, status: "COMPLETED") {
    id
    title
    status
  }
}
```

**Delete a task:**

```graphql
mutation {
  deleteTask(id: 1)
}
```

**Create a comment:**

```graphql
mutation {
  createComment(
    taskId: 1
    userId: 1
    content: "Task is almost complete."
  ) {
    id
    content
  }
}
```

## 5. GraphQL and REST Comparison

REST vs GraphQL
- Endpoints: REST uses multiple endpoints, while GraphQL usually uses one endpoint.
- Data Retrieval: REST returns predefined data, while GraphQL lets clients select required fields.
- Operations: REST uses GET, POST, PUT, PATCH, and DELETE, while GraphQL uses queries and mutations.
- Related Data: REST may require multiple requests, while GraphQL can fetch related data in one request.
- Response Format: Both commonly use JSON.
- Schema: REST APIs can be documented using OpenAPI, while GraphQL has a built-in schema.
- Versioning: REST commonly uses URL versioning, while GraphQL can evolve its schema without traditional URL versioning.

Both REST and GraphQL allow clients to communicate with the backend and access Task Manager data.