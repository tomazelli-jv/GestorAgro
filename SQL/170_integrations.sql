/******************************************************************************
*
*   TABELA: integrations
*
*   RESPONSABILIDADE
*
*   Armazena as integrações externas do sistema.
*
******************************************************************************/

CREATE TABLE integrations (

    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    uuid CHAR(36) NOT NULL DEFAULT (UUID()),

    code VARCHAR(50) NOT NULL,

    name VARCHAR(100) NOT NULL,

    category VARCHAR(30) NOT NULL,

    endpoint VARCHAR(500) NOT NULL,

    api_key TEXT NULL,

    is_active BOOLEAN NOT NULL DEFAULT TRUE,

    observations TEXT NULL,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    deleted_at TIMESTAMP NULL DEFAULT NULL,

    created_by BIGINT UNSIGNED NULL,

    updated_by BIGINT UNSIGNED NULL,

    deleted_by BIGINT UNSIGNED NULL,

    CONSTRAINT uq_integrations_uuid
        UNIQUE (uuid),

    CONSTRAINT uq_integrations_code
        UNIQUE (code),

    CONSTRAINT chk_integrations_code
        CHECK (
            TRIM(code) <> ''
        ),

    CONSTRAINT chk_integrations_name
        CHECK (
            TRIM(name) <> ''
        ),

    CONSTRAINT chk_integrations_category
        CHECK (

            category IN (

                'WEATHER',

                'BANK',

                'FISCAL',

                'AI',

                'MESSAGING',

                'OTHER'

            )

        )

)

ENGINE=InnoDB

DEFAULT CHARSET=utf8mb4

COLLATE=utf8mb4_unicode_ci

COMMENT='Integrações externas do sistema.';

/******************************************************************************
    ÍNDICES
******************************************************************************/

CREATE INDEX idx_integrations_category
ON integrations(category);

CREATE INDEX idx_integrations_active
ON integrations(is_active);

CREATE INDEX idx_integrations_name
ON integrations(name);

/******************************************************************************
*
*   TABELA: integration_logs
*
*   RESPONSABILIDADE
*
*   Armazena o histórico de execução das integrações externas.
*
******************************************************************************/

CREATE TABLE integration_logs (

    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    uuid CHAR(36) NOT NULL DEFAULT (UUID()),

    integration_id BIGINT UNSIGNED NOT NULL,

    request_url VARCHAR(500) NOT NULL,

    request_method VARCHAR(10) NOT NULL,

    status_code SMALLINT UNSIGNED NULL,

    success BOOLEAN NOT NULL DEFAULT FALSE,

    response_time_ms INT UNSIGNED NULL,

    error_message TEXT NULL,

    executed_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT uq_integration_logs_uuid
        UNIQUE (uuid),

    CONSTRAINT chk_integration_logs_method
        CHECK (

            request_method IN (

                'GET',

                'POST',

                'PUT',

                'PATCH',

                'DELETE'

            )

        ),

    CONSTRAINT fk_integration_logs_integration
        FOREIGN KEY (integration_id)
        REFERENCES integrations(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE

)

ENGINE=InnoDB

DEFAULT CHARSET=utf8mb4

COLLATE=utf8mb4_unicode_ci

COMMENT='Histórico de execução das integrações.';


/******************************************************************************
    ÍNDICES
******************************************************************************/

CREATE INDEX idx_integration_logs_integration
ON integration_logs(integration_id);

CREATE INDEX idx_integration_logs_success
ON integration_logs(success);

CREATE INDEX idx_integration_logs_status_code
ON integration_logs(status_code);

CREATE INDEX idx_integration_logs_executed_at
ON integration_logs(executed_at);

