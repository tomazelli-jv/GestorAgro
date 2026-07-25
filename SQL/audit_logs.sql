/******************************************************************************
*
*   TABELA: audit_logs
*
*   RESPONSABILIDADE
*
*   Armazena o histórico de ações realizadas pelos usuários no sistema.
*
******************************************************************************/

CREATE TABLE audit_logs (

    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    uuid CHAR(36) NOT NULL DEFAULT (UUID()),

    user_id BIGINT UNSIGNED NULL,

    module VARCHAR(50) NOT NULL,

    record_id BIGINT UNSIGNED NULL,

    action VARCHAR(20) NOT NULL,

    ip_address VARCHAR(45) NULL,

    user_agent VARCHAR(500) NULL,

    old_values JSON NULL,

    new_values JSON NULL,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT uq_audit_logs_uuid
        UNIQUE (uuid),

    CONSTRAINT chk_audit_logs_module
        CHECK (
            TRIM(module) <> ''
        ),

    CONSTRAINT chk_audit_logs_action
        CHECK (

            action IN (

                'CREATE',

                'UPDATE',

                'DELETE',

                'LOGIN',

                'LOGOUT',

                'RESTORE',

                'EXPORT',

                'IMPORT'

            )

        ),

    CONSTRAINT fk_audit_logs_user
        FOREIGN KEY (user_id)
        REFERENCES users(id)
        ON UPDATE CASCADE
        ON DELETE SET NULL

)

ENGINE=InnoDB

DEFAULT CHARSET=utf8mb4

COLLATE=utf8mb4_unicode_ci

COMMENT='Histórico de auditoria do sistema.';


/******************************************************************************
    ÍNDICES
******************************************************************************/

CREATE INDEX idx_audit_logs_user
ON audit_logs(user_id);

CREATE INDEX idx_audit_logs_module
ON audit_logs(module);

CREATE INDEX idx_audit_logs_record
ON audit_logs(record_id);

CREATE INDEX idx_audit_logs_action
ON audit_logs(action);

CREATE INDEX idx_audit_logs_created_at
ON audit_logs(created_at);


