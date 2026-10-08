# gRPC Design

## 1. gRPC Overview

gRPC is a high-performance Remote Procedure Call (RPC) framework that allows a client application to call functions or methods on a remote server.

gRPC uses **Protocol Buffers (Protobuf)** to define the structure of requests and responses. The service contract is written in a `.proto` file.

For the Task Manager backend, gRPC will provide operations for managing tasks and comments.

### gRPC Service

The main gRPC service is:

```text
TaskService
```

The service will provide operations for:

* Creating tasks
* Retrieving tasks
* Updating tasks
* Deleting tasks
* Retrieving comments
* Creating comments

### Protocol Buffers

The gRPC API will use **Protocol Buffers** to define:

* Services
* RPC methods
* Request messages
* Response messages
* Data types

The service definition will be stored in:

```text
proto/task_manager.proto
```

### Communication

The client communicates with the gRPC server using **HTTP/2**.

The gRPC interface is designed separately from the REST and GraphQL interfaces, while all three interfaces represent the same Task Manager backend system.


## 2. gRPC Service Definition

The Task Manager gRPC API will use a `TaskService` service.

The service will define RPC methods for task and comment operations.

### Task Operations

| RPC Method | Purpose                  |
| ---------- | ------------------------ |
| CreateTask | Creates a new task       |
| GetTask    | Retrieves a single task  |
| ListTasks  | Retrieves all tasks      |
| UpdateTask | Updates an existing task |
| DeleteTask | Deletes a task           |

### Comment Operations

| RPC Method    | Purpose                       |
| ------------- | ----------------------------- |
| ListComments  | Retrieves comments for a task |
| CreateComment | Creates a new comment         |
| DeleteComment | Deletes a comment             |

### Service Definition

The service can be represented using the following Protocol Buffer definition:

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

Each RPC method accepts a **request message** and returns a **response message**.

The request contains the information required to perform an operation, while the response contains the result returned by the server.

## 3. Request and Response Messages

gRPC uses Protocol Buffer messages to define the data sent between the client and server.

### Task Message

```protobuf
message Task {
  int64 id = 1;
  string title = 2;
  string description = 3;
  string status = 4;
  string priority = 5;
  string due_date = 6;
  int64 user_id = 7;
  string created_at = 8;
  string updated_at = 9;
}
```

### Create Task

```protobuf
message CreateTaskRequest {
  string title = 1;
  string description = 2;
  string status = 3;
  string priority = 4;
  string due_date = 5;
  int64 user_id = 6;
}
```

The server returns the newly created `Task`.

### Get Task

```protobuf
message GetTaskRequest {
  int64 id = 1;
}
```

The server returns the requested `Task`.

### List Tasks

```protobuf
message ListTasksRequest {
  string status = 1;
}

message ListTasksResponse {
  repeated Task tasks = 1;
}
```

The `status` field can be used to filter tasks. If no status is provided, all tasks can be returned.

### Update Task

```protobuf
message UpdateTaskRequest {
  int64 id = 1;
  string title = 2;
  string description = 3;
  string status = 4;
  string priority = 5;
  string due_date = 6;
}
```

The server returns the updated `Task`.

### Delete Task

```protobuf
message DeleteTaskRequest {
  int64 id = 1;
}

message DeleteTaskResponse {
  bool success = 1;
}
```

The `success` field indicates whether the task was successfully deleted.

### Comment Message

```protobuf
message Comment {
  int64 id = 1;
  string content = 2;
  int64 task_id = 3;
  int64 user_id = 4;
  string created_at = 5;
}
```

### Comment Operations

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

These messages define the input and output structure for the gRPC methods documented above.


