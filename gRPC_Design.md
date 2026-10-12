# gRPC Design

## 1. gRPC Overview

gRPC is a framework that allows applications to communicate with a server by calling its methods remotely.

It uses **Protocol Buffers (Protobuf)** to define requests and responses and **HTTP/2** for communication.

The Task Manager gRPC service is called `TaskService`. Its definition is stored in `proto/task_manager.proto`.

It supports task and comment operations such as creating, retrieving, updating, and deleting data.

## 2. gRPC Service Definition

The `TaskService` provides the following methods:

**Task Operations:**
- `CreateTask` – Creates a task.
- `GetTask` – Retrieves a task by ID.
- `ListTasks` – Retrieves all tasks.
- `UpdateTask` – Updates a task.
- `DeleteTask` – Deletes a task.

**Comment Operations:**
- `ListComments` – Retrieves comments for a task.
- `CreateComment` – Creates a comment.
- `DeleteComment` – Deletes a comment.

Example service definition:

```protobuf
service TaskService {
  rpc CreateTask(CreateTaskRequest) returns (Task);
  rpc GetTask(GetTaskRequest) returns (Task);
  rpc ListTasks(ListTasksRequest) returns (ListTasksResponse);
  rpc UpdateTask(UpdateTaskRequest) returns (Task);
  rpc DeleteTask(DeleteTaskRequest) returns (DeleteTaskResponse);
  rpc ListComments(ListCommentsRequest) returns (ListCommentsResponse);
  rpc CreateComment(CreateCommentRequest) returns (Comment);
  rpc DeleteComment(DeleteCommentRequest) returns (DeleteCommentResponse);
}
```

Each RPC method receives a request message and returns a response message.

## 3. Request and Response Messages

Protocol Buffer messages define the data exchanged between the client and server.

**Task Message:**

```protobuf
message Task {
  int64 id = 1;
  string title = 2;
  string description = 3;
  string status = 4;
  string priority = 5;
  string due_date = 6;
  int64 user_id = 7;
}
```

**Create Task:**

```protobuf
message CreateTaskRequest {
  string title = 1;
  string description = 2;
  string status = 3;
  string priority = 4;
  int64 user_id = 5;
}
```

**Get Task:**

```protobuf
message GetTaskRequest {
  int64 id = 1;
}
```

**List Tasks:**

```protobuf
message ListTasksRequest {
  string status = 1;
}

message ListTasksResponse {
  repeated Task tasks = 1;
}
```

The status field can filter tasks. The `repeated` keyword allows the response to contain multiple tasks.

**Delete Task:**

```protobuf
message DeleteTaskRequest {
  int64 id = 1;
}

message DeleteTaskResponse {
  bool success = 1;
}
```

**Comment Message:**

```protobuf
message Comment {
  int64 id = 1;
  string content = 2;
  int64 task_id = 3;
  int64 user_id = 4;
}
```

**Comment Operations:**

```protobuf
message ListCommentsRequest {
  int64 task_id = 1;
}

message ListCommentsResponse {
  repeated Comment comments = 1;
}

message CreateCommentRequest {
  int64 task_id = 1;
  int64 user_id = 2;
  string content = 3;
}

message DeleteCommentRequest {
  int64 id = 1;
}

message DeleteCommentResponse {
  bool success = 1;
}
```

These messages define the information required to create, retrieve, and delete tasks and comments.