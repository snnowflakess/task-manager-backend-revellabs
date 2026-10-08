CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE tasks (
    id SERIAL PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    status VARCHAR(20) NOT NULL DEFAULT 'PENDING',
    priority VARCHAR(20) NOT NULL DEFAULT 'MEDIUM',
    due_date DATE,
    user_id INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_task_user
        FOREIGN KEY (user_id)
        REFERENCES users(id)
        ON DELETE CASCADE -- means if a user is deleted, their tasks are automatically deleted too.
);

CREATE TABLE comments (
    id SERIAL PRIMARY KEY,
    content TEXT NOT NULL,
    task_id INTEGER NOT NULL,
    user_id INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_comment_task
        FOREIGN KEY (task_id)
        REFERENCES tasks(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_comment_user
        FOREIGN KEY (user_id)
        REFERENCES users(id)
        ON DELETE CASCADE
);

INSERT INTO users (name, email, password_hash)
VALUES
    ('Rachael Biju', 'rachael@example.com', 'hashed_password_123'),
    ('John Doe', 'john@example.com', 'hashed_password_456'),
    ('Jane Smith', 'jane@example.com', 'hashed_password_789');

INSERT INTO tasks (title, description, status, priority, due_date, user_id)
VALUES
    (
        'Complete backend documentation',
        'Finish REST, GraphQL and gRPC API documentation.',
        'PENDING',
        'HIGH',
        '2026-10-15',
        1
    ),
    (
        'Set up PostgreSQL with Docker',
        'Configure PostgreSQL and verify database initialization.',
        'COMPLETED',
        'HIGH',
        '2026-10-10',
        1
    ),
    (
        'Review project requirements',
        'Review the Task Manager backend project requirements.',
        'PENDING',
        'MEDIUM',
        '2026-10-12',
        2
    ),
    (
        'Test API endpoints',
        'Test the REST API endpoints using Postman.',
        'PENDING',
        'LOW',
        '2026-10-20',
        3
    );

INSERT INTO comments (content, task_id, user_id)
VALUES
    (
        'I have started working on the documentation.',
        1,
        1
    ),
    (
        'PostgreSQL Docker setup has been completed successfully.',
        2,
        1
    ),
    (
        'I will review the requirements today.',
        3,
        2
    ),
    (
        'I can help test the API endpoints.',
        1,
        3
    );