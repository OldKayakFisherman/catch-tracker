psql -a -b -U ${POSTGRES_USER} -d ${POSTGRES_DB} -c "

    INSERT INTO users (
        email,
        username,
        password,
        active,
        location_latitude,
        location_longitude,
        date_registered,
        date_verified
    )
    VALUES
    (
        '${ADMIN_USER_EMAIL}',
        '${ADMIN_USER_USERNAME}',
        encrypt_password('${ADMIN_USER_PASSWORD}'),
        true,
        ${ADMIN_USER_LATITUDE},
        ${ADMIN_USER_LONGITUDE},
        CURRENT_DATE,
        CURRENT_DATE
    );

    INSERT INTO user_roles
    (
        user_id,
        role_id
    )
    VALUES
    (
        (SELECT id from users WHERE email = '${ADMIN_USER_EMAIL}'),
        (SELECT id from roles WHERE name = 'Administrator')
    );
"