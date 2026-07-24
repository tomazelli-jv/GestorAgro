/******************************************************************************
*
*   GESTOR AGRO
*
*   SCRIPT.......: 030_auth.sql
*   MÓDULO.......: AUTHENTICATION
*   BANCO........: MySQL 8+
*
*   DESCRIÇÃO
*
*   Este módulo controla:
*
*       • Usuários
*       • Autenticação
*       • Papéis (Roles)
*       • Permissões
*       • Sessões
*       • Histórico de login
*
******************************************************************************/

SET NAMES utf8mb4;


/******************************************************************************
*
*   TABELA: ref_user_statuses
*
*   RESPONSABILIDADE
*
*   Armazena os status possíveis de um usuário.
*
*   Esta tabela pertence ao módulo de autenticação.
*
******************************************************************************/

CREATE TABLE ref_user_statuses (

    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    uuid CHAR(36) NOT NULL DEFAULT (UUID()),

    code VARCHAR(50) NOT NULL,

    name VARCHAR(100) NOT NULL,

    description VARCHAR(255) NULL,

    display_order INT UNSIGNED NOT NULL DEFAULT 0,

    is_default BOOLEAN NOT NULL DEFAULT FALSE,

    is_active BOOLEAN NOT NULL DEFAULT TRUE,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    deleted_at TIMESTAMP NULL DEFAULT NULL,

    created_by BIGINT UNSIGNED NULL,

    updated_by BIGINT UNSIGNED NULL,

    deleted_by BIGINT UNSIGNED NULL,

    CONSTRAINT uq_ref_user_statuses_uuid
        UNIQUE (uuid),

    CONSTRAINT uq_ref_user_statuses_code
        UNIQUE (code),

    CONSTRAINT uq_ref_user_statuses_name
        UNIQUE (name),

    CONSTRAINT chk_ref_user_statuses_code
        CHECK (TRIM(code) <> ''),

    CONSTRAINT chk_ref_user_statuses_name
        CHECK (TRIM(name) <> '')

)
ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_unicode_ci
COMMENT='Status disponíveis para usuários do sistema.';


/******************************************************************************
    ÍNDICES
******************************************************************************/

CREATE INDEX idx_ref_user_statuses_code
ON ref_user_statuses(code);

CREATE INDEX idx_ref_user_statuses_active
ON ref_user_statuses(is_active);

CREATE INDEX idx_ref_user_statuses_default
ON ref_user_statuses(is_default);



/******************************************************************************
    TABELA: users

    RESPONSABILIDADE

    Armazena os usuários que possuem acesso ao sistema.

    Cada usuário pertence a um Tenant.

******************************************************************************/

CREATE TABLE users (

    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    uuid CHAR(36) NOT NULL DEFAULT (UUID()),

    tenant_id BIGINT UNSIGNED NOT NULL,

    username VARCHAR(100) NOT NULL,

    email VARCHAR(150) NOT NULL,

    password_hash VARCHAR(255) NOT NULL,

    first_name VARCHAR(100) NOT NULL,

    last_name VARCHAR(100) NULL,

    phone VARCHAR(30) NULL,

    avatar_url VARCHAR(500) NULL,

    is_active BOOLEAN NOT NULL DEFAULT TRUE,

    is_verified BOOLEAN NOT NULL DEFAULT FALSE,

    email_verified_at TIMESTAMP NULL DEFAULT NULL,

    last_login_at TIMESTAMP NULL DEFAULT NULL,

    last_login_ip VARCHAR(45) NULL,

    failed_login_attempts INT UNSIGNED NOT NULL DEFAULT 0,

    locked_until TIMESTAMP NULL DEFAULT NULL,

    password_changed_at TIMESTAMP NULL DEFAULT NULL,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    deleted_at TIMESTAMP NULL DEFAULT NULL,

    created_by BIGINT UNSIGNED NULL,

    updated_by BIGINT UNSIGNED NULL,

    deleted_by BIGINT UNSIGNED NULL,

    CONSTRAINT uq_users_uuid
        UNIQUE (uuid),

    CONSTRAINT uq_users_tenant_username
        UNIQUE (tenant_id, username),

    CONSTRAINT uq_users_tenant_email
        UNIQUE (tenant_id, email),

    CONSTRAINT chk_users_username
        CHECK (TRIM(username) <> ''),

    CONSTRAINT chk_users_email
        CHECK (TRIM(email) <> ''),

    CONSTRAINT chk_users_first_name
        CHECK (TRIM(first_name) <> ''),

    CONSTRAINT fk_users_tenant
        FOREIGN KEY (tenant_id)
        REFERENCES tenants(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT

        ALTER TABLE users

ADD COLUMN user_status_id BIGINT UNSIGNED NOT NULL,

ADD CONSTRAINT fk_users_status

    FOREIGN KEY (user_status_id)

    REFERENCES ref_user_statuses(id)

    ON UPDATE CASCADE

    ON DELETE RESTRICT;

)
ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_unicode_ci
COMMENT='Usuários com acesso ao sistema.';


/******************************************************************************
    ÍNDICES
******************************************************************************/

CREATE INDEX idx_users_tenant
ON users(tenant_id);

CREATE INDEX idx_users_username
ON users(username);

CREATE INDEX idx_users_email
ON users(email);

CREATE INDEX idx_users_active
ON users(is_active);

CREATE INDEX idx_users_last_login
ON users(last_login_at);

CREATE INDEX idx_users_status
ON users(user_status_id);



/******************************************************************************
*
*   TABELA: roles
*
*   RESPONSABILIDADE
*
*   Armazena os papéis/perfis de acesso disponíveis no sistema.
*
*   Um role agrupa permissões e pode ser atribuído a um ou mais usuários.
*
******************************************************************************/

CREATE TABLE roles (

    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    uuid CHAR(36) NOT NULL DEFAULT (UUID()),

    tenant_id BIGINT UNSIGNED NULL,

    code VARCHAR(50) NOT NULL,

    name VARCHAR(100) NOT NULL,

    description VARCHAR(255) NULL,

    is_system_role BOOLEAN NOT NULL DEFAULT FALSE,

    is_default BOOLEAN NOT NULL DEFAULT FALSE,

    is_active BOOLEAN NOT NULL DEFAULT TRUE,

    display_order INT UNSIGNED NOT NULL DEFAULT 0,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    deleted_at TIMESTAMP NULL DEFAULT NULL,

    created_by BIGINT UNSIGNED NULL,

    updated_by BIGINT UNSIGNED NULL,

    deleted_by BIGINT UNSIGNED NULL,

    CONSTRAINT uq_roles_uuid
        UNIQUE (uuid),

    CONSTRAINT uq_roles_tenant_code
        UNIQUE (tenant_id, code),

    CONSTRAINT uq_roles_tenant_name
        UNIQUE (tenant_id, name),

    CONSTRAINT chk_roles_code
        CHECK (TRIM(code) <> ''),

    CONSTRAINT chk_roles_name
        CHECK (TRIM(name) <> ''),

    CONSTRAINT fk_roles_tenant
        FOREIGN KEY (tenant_id)
        REFERENCES tenants(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE

)
ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_unicode_ci
COMMENT='Papéis e perfis de acesso dos usuários.';

/******************************************************************************
    ÍNDICES
******************************************************************************/

CREATE INDEX idx_roles_tenant
ON roles(tenant_id);

CREATE INDEX idx_roles_code
ON roles(code);

CREATE INDEX idx_roles_active
ON roles(is_active);

CREATE INDEX idx_roles_system
ON roles(is_system_role);


/******************************************************************************
*
*   TABELA: permissions
*
*   RESPONSABILIDADE
*
*   Armazena as permissões granulares do sistema.
*
*   Cada permissão representa uma ação que pode ser executada
*   dentro de um módulo.
*
******************************************************************************/

CREATE TABLE permissions (

    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    uuid CHAR(36) NOT NULL DEFAULT (UUID()),

    module_code VARCHAR(50) NOT NULL,

    action_code VARCHAR(50) NOT NULL,

    name VARCHAR(150) NOT NULL,

    description VARCHAR(255) NULL,

    is_system_permission BOOLEAN NOT NULL DEFAULT TRUE,

    is_active BOOLEAN NOT NULL DEFAULT TRUE,

    display_order INT UNSIGNED NOT NULL DEFAULT 0,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    deleted_at TIMESTAMP NULL DEFAULT NULL,

    created_by BIGINT UNSIGNED NULL,

    updated_by BIGINT UNSIGNED NULL,

    deleted_by BIGINT UNSIGNED NULL,

    CONSTRAINT uq_permissions_uuid
        UNIQUE (uuid),

    CONSTRAINT uq_permissions_module_action
        UNIQUE (module_code, action_code),

    CONSTRAINT uq_permissions_name
        UNIQUE (name),

    CONSTRAINT chk_permissions_module
        CHECK (TRIM(module_code) <> ''),

    CONSTRAINT chk_permissions_action
        CHECK (TRIM(action_code) <> ''),

    CONSTRAINT chk_permissions_name
        CHECK (TRIM(name) <> '')

)
ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_unicode_ci
COMMENT='Permissões granulares do sistema.';


/******************************************************************************
    ÍNDICES
******************************************************************************/

CREATE INDEX idx_permissions_module
ON permissions(module_code);

CREATE INDEX idx_permissions_action
ON permissions(action_code);

CREATE INDEX idx_permissions_active
ON permissions(is_active);

/******************************************************************************
*
*   TABELA: role_permissions
*
*   RESPONSABILIDADE
*
*   Relaciona papéis (roles) às permissões que eles possuem.
*
******************************************************************************/

CREATE TABLE role_permissions (

    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    uuid CHAR(36) NOT NULL DEFAULT (UUID()),

    role_id BIGINT UNSIGNED NOT NULL,

    permission_id BIGINT UNSIGNED NOT NULL,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    deleted_at TIMESTAMP NULL DEFAULT NULL,

    created_by BIGINT UNSIGNED NULL,

    updated_by BIGINT UNSIGNED NULL,

    deleted_by BIGINT UNSIGNED NULL,

    CONSTRAINT uq_role_permissions_uuid
        UNIQUE (uuid),

    CONSTRAINT uq_role_permissions_role_permission
        UNIQUE (role_id, permission_id),

    CONSTRAINT fk_role_permissions_role
        FOREIGN KEY (role_id)
        REFERENCES roles(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_role_permissions_permission
        FOREIGN KEY (permission_id)
        REFERENCES permissions(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE

)
ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_unicode_ci
COMMENT='Relacionamento entre papéis e permissões.';


/******************************************************************************
    ÍNDICES
******************************************************************************/

CREATE INDEX idx_role_permissions_role
ON role_permissions(role_id);

CREATE INDEX idx_role_permissions_permission
ON role_permissions(permission_id);

/******************************************************************************
*
*   TABELA: user_roles
*
*   RESPONSABILIDADE
*
*   Relaciona usuários aos seus papéis (roles).
*
******************************************************************************/

CREATE TABLE user_roles (

    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    uuid CHAR(36) NOT NULL DEFAULT (UUID()),

    user_id BIGINT UNSIGNED NOT NULL,

    role_id BIGINT UNSIGNED NOT NULL,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    deleted_at TIMESTAMP NULL DEFAULT NULL,

    created_by BIGINT UNSIGNED NULL,

    updated_by BIGINT UNSIGNED NULL,

    deleted_by BIGINT UNSIGNED NULL,

    CONSTRAINT uq_user_roles_uuid
        UNIQUE (uuid),

    CONSTRAINT uq_user_roles_user_role
        UNIQUE (user_id, role_id),

    CONSTRAINT fk_user_roles_user
        FOREIGN KEY (user_id)
        REFERENCES users(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_user_roles_role
        FOREIGN KEY (role_id)
        REFERENCES roles(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE

)
ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_unicode_ci
COMMENT='Relacionamento entre usuários e papéis de acesso.';


/******************************************************************************
    ÍNDICES
******************************************************************************/

CREATE INDEX idx_user_roles_user
ON user_roles(user_id);

CREATE INDEX idx_user_roles_role
ON user_roles(role_id);


/******************************************************************************
*
*   TABELA: user_permissions
*
*   RESPONSABILIDADE
*
*   Armazena permissões específicas atribuídas diretamente a usuários.
*
*   Essas permissões funcionam como exceções às permissões herdadas
*   através dos roles.
*
******************************************************************************/

CREATE TABLE user_permissions (

    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    uuid CHAR(36) NOT NULL DEFAULT (UUID()),

    user_id BIGINT UNSIGNED NOT NULL,

    permission_id BIGINT UNSIGNED NOT NULL,

    is_allowed BOOLEAN NOT NULL DEFAULT TRUE,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    deleted_at TIMESTAMP NULL DEFAULT NULL,

    created_by BIGINT UNSIGNED NULL,

    updated_by BIGINT UNSIGNED NULL,

    deleted_by BIGINT UNSIGNED NULL,

    CONSTRAINT uq_user_permissions_uuid
        UNIQUE (uuid),

    CONSTRAINT uq_user_permissions_user_permission
        UNIQUE (user_id, permission_id),

    CONSTRAINT fk_user_permissions_user
        FOREIGN KEY (user_id)
        REFERENCES users(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_user_permissions_permission
        FOREIGN KEY (permission_id)
        REFERENCES permissions(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE

)
ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_unicode_ci
COMMENT='Permissões individuais atribuídas diretamente aos usuários.';

/******************************************************************************
    ÍNDICES
******************************************************************************/

CREATE INDEX idx_user_permissions_user
ON user_permissions(user_id);

CREATE INDEX idx_user_permissions_permission
ON user_permissions(permission_id);

CREATE INDEX idx_user_permissions_allowed
ON user_permissions(is_allowed);


/******************************************************************************
*
*   TABELA: login_status
*
*   RESPONSABILIDADE
*
*   Armazena o histórico das tentativas e eventos de autenticação
*   dos usuários.
*
******************************************************************************/

CREATE TABLE login_status (

    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    uuid CHAR(36) NOT NULL DEFAULT (UUID()),

    user_id BIGINT UNSIGNED NULL,

    tenant_id BIGINT UNSIGNED NULL,

    username_attempted VARCHAR(150) NULL,

    status_code VARCHAR(50) NOT NULL,

    ip_address VARCHAR(45) NULL,

    user_agent VARCHAR(500) NULL,

    failure_reason VARCHAR(255) NULL,

    session_id VARCHAR(255) NULL,

    occurred_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT uq_login_status_uuid
        UNIQUE (uuid),

    CONSTRAINT chk_login_status_code
        CHECK (TRIM(status_code) <> ''),

    CONSTRAINT fk_login_status_user
        FOREIGN KEY (user_id)
        REFERENCES users(id)
        ON UPDATE CASCADE
        ON DELETE SET NULL,

    CONSTRAINT fk_login_status_tenant
        FOREIGN KEY (tenant_id)
        REFERENCES tenants(id)
        ON UPDATE CASCADE
        ON DELETE SET NULL

)
ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_unicode_ci
COMMENT='Histórico de eventos de autenticação dos usuários.';


/******************************************************************************
    ÍNDICES
******************************************************************************/

CREATE INDEX idx_login_status_user
ON login_status(user_id);

CREATE INDEX idx_login_status_tenant
ON login_status(tenant_id);

CREATE INDEX idx_login_status_username
ON login_status(username_attempted);

CREATE INDEX idx_login_status_status
ON login_status(status_code);

CREATE INDEX idx_login_status_occurred
ON login_status(occurred_at);

CREATE INDEX idx_login_status_ip
ON login_status(ip_address);


/******************************************************************************
    STATUS PADRÃO DE USUÁRIOS
******************************************************************************/

INSERT INTO ref_user_statuses (
    code,
    name,
    description,
    display_order,
    is_default
)
VALUES

(
    'ACTIVE',
    'Ativo',
    'Usuário autorizado a acessar o sistema.',
    1,
    TRUE
),

(
    'INACTIVE',
    'Inativo',
    'Usuário sem acesso ativo ao sistema.',
    2,
    FALSE
),

(
    'PENDING',
    'Pendente',
    'Usuário aguardando ativação.',
    3,
    FALSE
),

(
    'BLOCKED',
    'Bloqueado',
    'Usuário bloqueado por segurança ou ação administrativa.',
    4,
    FALSE
),

(
    'SUSPENDED',
    'Suspenso',
    'Usuário temporariamente suspenso.',
    5,
    FALSE
);


/******************************************************************************
    ROLES GLOBAIS
******************************************************************************/

INSERT INTO roles (
    tenant_id,
    code,
    name,
    description,
    is_system_role,
    is_default,
    display_order
)
VALUES

(
    NULL,
    'MASTER',
    'Master',
    'Acesso total e irrestrito ao sistema.',
    TRUE,
    FALSE,
    1
),

(
    NULL,
    'DEV',
    'Desenvolvedor',
    'Acesso técnico e administrativo destinado à equipe de desenvolvimento.',
    TRUE,
    FALSE,
    2
);



/******************************************************************************
    PERMISSÕES INICIAIS
******************************************************************************/

INSERT INTO permissions (
    module_code,
    action_code,
    name,
    description,
    display_order
)

SELECT
    modules.module_code,
    actions.action_code,
    CONCAT(modules.module_code, '_', actions.action_code),
    CONCAT(
        actions.action_name,
        ' informações do módulo ',
        modules.module_name,
        '.'
    ),
    modules.display_order * 10 + actions.display_order

FROM (

    SELECT 'FAZENDA' AS module_code, 'Fazenda' AS module_name, 1 AS display_order
    UNION ALL
    SELECT 'ESTOQUE', 'Estoque', 2
    UNION ALL
    SELECT 'AGRICULTURA', 'Agricultura', 3
    UNION ALL
    SELECT 'FINANCEIRO', 'Financeiro', 4
    UNION ALL
    SELECT 'MAPA', 'Mapa', 5
    UNION ALL
    SELECT 'CONFIGURACOES', 'Configurações', 6

) AS modules

CROSS JOIN (

    SELECT 'VISUALIZAR' AS action_code, 'Visualizar' AS action_name, 1 AS display_order
    UNION ALL
    SELECT 'ADICIONAR', 'Adicionar', 2
    UNION ALL
    SELECT 'ALTERAR', 'Alterar', 3
    UNION ALL
    SELECT 'EXCLUIR', 'Excluir', 4

) AS actions;


/******************************************************************************
    PERMISSÕES DO ROLE MASTER
******************************************************************************/

INSERT INTO role_permissions (
    role_id,
    permission_id
)

SELECT
    r.id,
    p.id

FROM roles r

CROSS JOIN permissions p

WHERE r.code = 'MASTER'

  AND r.tenant_id IS NULL;


  /******************************************************************************
    PERMISSÕES DO ROLE DEV
******************************************************************************/

INSERT INTO role_permissions (
    role_id,
    permission_id
)

SELECT
    r.id,
    p.id

FROM roles r

CROSS JOIN permissions p

WHERE r.code = 'DEV'

  AND r.tenant_id IS NULL;


  /******************************************************************************
*
*   PROCEDURE: sp_create_default_tenant_roles
*
*   RESPONSABILIDADE
*
*   Cria os roles padrão de um tenant.
*
*   Roles criados:
*
*       • GESTOR
*       • OPERADOR
*       • FINANCEIRO
*       • VISUALIZADOR
*
******************************************************************************/

DELIMITER $$

CREATE PROCEDURE sp_create_default_tenant_roles (

    IN p_tenant_id BIGINT UNSIGNED

)

BEGIN

    INSERT INTO roles (

        tenant_id,

        code,

        name,

        description,

        is_system_role,

        is_default,

        display_order

    )

    VALUES

    (

        p_tenant_id,

        'GESTOR',

        'Gestor',

        'Acesso gerencial aos módulos do sistema.',

        FALSE,

        TRUE,

        1

    ),

    (

        p_tenant_id,

        'OPERADOR',

        'Operador',

        'Acesso operacional aos módulos permitidos.',

        FALSE,

        TRUE,

        2

    ),

    (

        p_tenant_id,

        'FINANCEIRO',

        'Financeiro',

        'Acesso às funcionalidades financeiras.',

        FALSE,

        TRUE,

        3

    ),

    (

        p_tenant_id,

        'VISUALIZADOR',

        'Visualizador',

        'Acesso somente para visualização.',

        FALSE,

        TRUE,

        4

    );

END$$

DELIMITER ;

INSERT INTO role_permissions (
    role_id,
    permission_id
)

SELECT
    r.id,
    p.id

FROM roles r

CROSS JOIN permissions p

WHERE r.tenant_id = p_tenant_id

  AND r.code = 'GESTOR';


  /******************************************************************************
*
*   PROCEDURE: sp_create_default_tenant_roles
*
*   RESPONSABILIDADE
*
*   Cria os roles padrão de um tenant e atribui suas permissões iniciais.
*
*   ROLES:
*
*       • GESTOR
*       • OPERADOR
*       • FINANCEIRO
*       • VISUALIZADOR
*
******************************************************************************/

DELIMITER $$

CREATE PROCEDURE sp_create_default_tenant_roles (

    IN p_tenant_id BIGINT UNSIGNED

)

BEGIN

    DECLARE v_gestor_role_id BIGINT UNSIGNED;

    DECLARE v_operador_role_id BIGINT UNSIGNED;

    DECLARE v_financeiro_role_id BIGINT UNSIGNED;

    DECLARE v_visualizador_role_id BIGINT UNSIGNED;


    /*
    ============================================================
    VALIDAÇÃO DO TENANT
    ============================================================
    */

    IF NOT EXISTS (

        SELECT 1

        FROM tenants

        WHERE id = p_tenant_id

          AND deleted_at IS NULL

          AND active = TRUE

    ) THEN

        SIGNAL SQLSTATE '45000'

        SET MESSAGE_TEXT =
            'Tenant inexistente ou inativo.';

    END IF;


    /*
    ============================================================
    CRIAÇÃO DO ROLE GESTOR
    ============================================================
    */

    INSERT INTO roles (

        tenant_id,

        code,

        name,

        description,

        is_system_role,

        is_default,

        display_order

    )

    VALUES (

        p_tenant_id,

        'GESTOR',

        'Gestor',

        'Acesso gerencial aos módulos do sistema.',

        FALSE,

        TRUE,

        1

    );


    SET v_gestor_role_id = LAST_INSERT_ID();


    /*
    ============================================================
    GESTOR
    ============================================================

    Recebe todas as permissões do sistema,
    incluindo CONFIGURACOES.
    */

    INSERT INTO role_permissions (

        role_id,

        permission_id

    )

    SELECT

        v_gestor_role_id,

        id

    FROM permissions

    WHERE is_active = TRUE

      AND deleted_at IS NULL;


    /*
    ============================================================
    CRIAÇÃO DO ROLE OPERADOR
    ============================================================
    */

    INSERT INTO roles (

        tenant_id,

        code,

        name,

        description,

        is_system_role,

        is_default,

        display_order

    )

    VALUES (

        p_tenant_id,

        'OPERADOR',

        'Operador',

        'Acesso operacional aos módulos permitidos.',

        FALSE,

        TRUE,

        2

    );


    SET v_operador_role_id = LAST_INSERT_ID();


    /*
    ============================================================
    PERMISSÕES DO OPERADOR
    ============================================================
    */

    INSERT INTO role_permissions (

        role_id,

        permission_id

    )

    SELECT

        v_operador_role_id,

        id

    FROM permissions

    WHERE is_active = TRUE

      AND deleted_at IS NULL

      AND (

            (

                module_code IN (

                    'FAZENDA',

                    'ESTOQUE',

                    'AGRICULTURA'

                )

                AND action_code IN (

                    'VISUALIZAR',

                    'ADICIONAR',

                    'ALTERAR'

                )

            )

            OR

            (

                module_code = 'MAPA'

                AND action_code = 'VISUALIZAR'

            )

      );


    /*
    ============================================================
    CRIAÇÃO DO ROLE FINANCEIRO
    ============================================================
    */

    INSERT INTO roles (

        tenant_id,

        code,

        name,

        description,

        is_system_role,

        is_default,

        display_order

    )

    VALUES (

        p_tenant_id,

        'FINANCEIRO',

        'Financeiro',

        'Acesso às funcionalidades financeiras.',

        FALSE,

        TRUE,

        3

    );


    SET v_financeiro_role_id = LAST_INSERT_ID();


    /*
    ============================================================
    PERMISSÕES DO FINANCEIRO
    ============================================================
    */

    INSERT INTO role_permissions (

        role_id,

        permission_id

    )

    SELECT

        v_financeiro_role_id,

        id

    FROM permissions

    WHERE module_code = 'FINANCEIRO'

      AND is_active = TRUE

      AND deleted_at IS NULL;


    /*
    ============================================================
    CRIAÇÃO DO ROLE VISUALIZADOR
    ============================================================
    */

    INSERT INTO roles (

        tenant_id,

        code,

        name,

        description,

        is_system_role,

        is_default,

        display_order

    )

    VALUES (

        p_tenant_id,

        'VISUALIZADOR',

        'Visualizador',

        'Acesso somente para visualização.',

        FALSE,

        TRUE,

        4

    );


    SET v_visualizador_role_id = LAST_INSERT_ID();


    /*
    ============================================================
    PERMISSÕES DO VISUALIZADOR
    ============================================================
    */

    INSERT INTO role_permissions (

        role_id,

        permission_id

    )

    SELECT

        v_visualizador_role_id,

        id

    FROM permissions

    WHERE action_code = 'VISUALIZAR'

      AND module_code IN (

            'FAZENDA',

            'ESTOQUE',

            'AGRICULTURA',

            'FINANCEIRO',

            'MAPA'

      )

      AND is_active = TRUE

      AND deleted_at IS NULL;


END$$

DELIMITER ;