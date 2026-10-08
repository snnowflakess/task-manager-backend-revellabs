# JWT Authentication Design

## 1. JWT Authentication Overview

The Task Manager backend will use **JSON Web Token (JWT)** for authentication.

JWT allows the server to verify the identity of a user without storing the user's login session on the server.

When a user logs in successfully, the server generates a JWT and sends it to the client. The client then sends this token with subsequent API requests.

The REST API will use the token to identify authenticated users and protect resources such as tasks and comments.

### Authentication Flow

The authentication process will work as follows:

1. The user provides their email and password.
2. The server verifies the user's credentials.
3. The server generates a JWT if the credentials are valid.
4. The client stores the JWT securely.
5. The client sends the JWT with protected API requests.
6. The server validates the JWT before processing the request.
7. If the token is valid, the request is allowed.
8. If the token is missing or invalid, the server returns an authentication error.

### Authorization Header

The JWT will be sent using the HTTP `Authorization` header:

```text
Authorization: Bearer <JWT_TOKEN>
```

### Protected Resources

The following REST API resources will require authentication:

* Tasks
* Comments
* User-specific operations

The user's identity from the JWT can be used to determine which resources they are allowed to access.


## 2. JWT Structure

A JWT consists of three parts:

```text
Header.Payload.Signature
```

### Header

The header contains information about the token, such as the signing algorithm and token type.

Example:

```json
{
  "alg": "HS256",
  "typ": "JWT"
}
```

### Payload

The payload contains claims that identify the authenticated user.

Example:

```json
{
  "sub": "1",
  "email": "rachael@example.com",
  "iat": 1760000000,
  "exp": 1760086400
}
```

Where:

* `sub` identifies the user.
* `email` contains the user's email.
* `iat` represents when the token was issued.
* `exp` represents when the token expires.

Passwords will **not** be stored inside the JWT payload.

### Signature

The signature is used to verify that the token has not been modified.

The server will sign the JWT using a secure secret key stored in environment configuration rather than directly in the source code.

## 3. Login API

The REST API will provide a login endpoint:

```text
POST /api/v1/auth/login
```

### Request

```json
{
  "email": "rachael@example.com",
  "password": "user_password"
}
```

### Successful Response

**HTTP 200 OK**

```json
{
  "token": "<JWT_TOKEN>",
  "tokenType": "Bearer",
  "expiresIn": 86400
}
```

The client will use the returned token when accessing protected REST API endpoints.

### Invalid Credentials

If the email or password is incorrect, the API will return:

**HTTP 401 Unauthorized**

```json
{
  "status": 401,
  "error": "Unauthorized",
  "message": "Invalid email or password."
}
```
## 4. JWT Validation

For every protected API request, the server will validate the JWT before processing the request.

The validation process will be:

1. Read the JWT from the `Authorization` header.
2. Verify that the token uses the expected signing algorithm.
3. Verify the token signature.
4. Check whether the token has expired.
5. Extract the user's identity from the token.
6. Allow the request if the token is valid.
7. Return `401 Unauthorized` if the token is missing, invalid, or expired.

### Example Protected Request

```http
GET /api/v1/tasks
Authorization: Bearer <JWT_TOKEN>
```

### Authentication Errors

| Situation     |          HTTP Status |
| ------------- | -------------------: |
| Missing token |     401 Unauthorized |
| Invalid token |     401 Unauthorized |
| Expired token |     401 Unauthorized |
| Valid token   | Request is processed |

## 5. JWT Security Considerations

The following security practices will be followed:

* Passwords will be stored as hashes, never as plain text.
* The JWT secret key will be stored using environment variables.
* JWT tokens will have an expiration time.
* Sensitive information will not be stored in the JWT payload.
* HTTPS should be used when the API is deployed.
* Protected endpoints will require a valid JWT.

This JWT strategy provides authentication for the Task Manager REST API while keeping the authentication mechanism stateless.
