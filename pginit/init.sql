

-- Install Extensions
CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE SCHEMA api;


CREATE TABLE roles
(
    id SERIAL PRIMARY KEY,
    name text not null,
    CONSTRAINT idx_roles_unique_name UNIQUE (name)
);

CREATE TABLE users
(
    id SERIAL PRIMARY KEY,
    email TEXT NOT NULL,
    username TEXT NOT NULL,
    password TEXT NOT NULL,
    active BOOLEAN NOT NULL DEFAULT true,
    location_latitude NUMERIC(9,6) NOT NULL,
    location_longitude NUMERIC(9,6) NOT NULL,
    date_registered DATE NOT NULL,
    locked_until DATE NULL,
    date_verified DATE NULL,
    avatar TEXT NULL,
    bio TEXT NULL,
    CONSTRAINT idx_users_unique_email UNIQUE (email),
    CONSTRAINT idx_users_unique_username UNIQUE (username)
);

CREATE TABLE user_roles
(
    user_id BIGINT NOT NULL,
    role_id BIGINT NOT NULL,
    CONSTRAINT pk_user_roles PRIMARY KEY (user_id, role_id),
    CONSTRAINT fk_user_roles_user FOREIGN KEY (user_id) REFERENCES users(id),
    CONSTRAINT fk_user_roles_role FOREIGN KEY (role_id) REFERENCES roles(id)
);

INSERT INTO roles(name) VALUES ('Administrator');
INSERT INTO roles(name) VALUES ('User');

CREATE OR REPLACE FUNCTION encrypt_password(plain_password TEXT)
RETURNS TEXT AS $$
BEGIN
    RETURN crypt(plain_password, gen_salt('bf'));
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION validate_password
(
    p_email TEXT,
    p_password TEXT
)
RETURNS BOOLEAN AS $$
DECLARE
    stored_hash TEXT;
BEGIN
    SELECT password INTO stored_hash
    FROM users
    WHERE email = p_email;

    IF stored_hash IS NOT NULL THEN
        RETURN stored_hash = crypt(p_password, stored_hash);
    ELSE
        RETURN FALSE;
    END IF;

END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION api.validate_user
(
    p_email TEXT,
    p_password TEXT
)
RETURNS INTEGER AS $$
DECLARE
    v_password TEXT;
    v_email TEXT;
    v_active TEXT;
    v_date_verified DATE;
    v_locked_until DATE;
    v_password_verified BOOLEAN;
BEGIN

    -- 0: Authentication Failure
    -- 1: Authenticated
    -- 2: Not Verfied
    -- 3: Locked
    -- 4: Inactive

    SELECT password, email, active, date_verified, locked_until INTO
        v_password, v_email, v_active, v_date_verified, v_locked_until
    FROM users
    WHERE email = p_email;

    IF v_email IS NOT NULL THEN

        SELECT validate_password(p_email, p_password) INTO v_password_verified;

        IF v_password_verified == FALSE THEN
            RETURN 0;
        ELSE

            -- Check Verfified
            IF v_date_verified IS NULL THEN
                RETURN 2;
            END IF;

            -- Check Locked
            IF v_locked_until IS NOT NULL THEN
                IF v_locked_until > CURRENT_DATE THEN   
                    RETURN 3;
                END IF;
            END IF;

            -- Check Inactive
            IF v_active == FASLE THEN
                RETURN 4;
            END IF;

            -- If we are here then we are authenticated
            RETURN 1;
        END IF;
    END IF;
END;
$$ LANGUAGE plpgsql;


CREATE VIEW api.users AS
    SELECT u.email, u.username, u.active, u.location_latitude,
    u.location_longitude, u.avatar, u.bio, STRING_AGG(r.name, ', ') as roles
    FROM users u INNER JOIN user_roles ur ON
        u.id = ur.user_id INNER JOIN roles r ON
            ur.role_id = r.id
    GROUP BY u.email, u.username, u.active, u.location_latitude,
    u.location_longitude, u.avatar, u.bio



