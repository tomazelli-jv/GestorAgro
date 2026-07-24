/******************************************************************************
*
*   GESTOR AGRO
*
*   SCRIPT.......: 010_core.sql
*   MÓDULO.......: CORE
*   BANCO........: MySQL 8+
*
*   DESCRIÇÃO
*
*   Este módulo cria a estrutura principal do sistema.
*
*   Tabelas:
*
*       • tenants
*       • tenant_settings
*       • system_settings
*       • audit_logs
*       • system_logs
*
*   DEPENDÊNCIAS
*
*       000_init.sql
*
******************************************************************************/

SET NAMES utf8mb4;

/******************************************************************************
    TABELA: tenants

    RESPONSABILIDADE

    Representa cada empresa cadastrada no Gestor Agro.

    Todo o sistema é Multi-Tenant.

******************************************************************************/

CREATE TABLE tenants (

    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    uuid CHAR(36) NOT NULL DEFAULT (UUID()),

    company_name VARCHAR(200) NOT NULL,

    trade_name VARCHAR(200) NULL,

    document VARCHAR(20) NULL,

    email VARCHAR(150) NULL,

    phone VARCHAR(20) NULL,

    logo_url VARCHAR(500) NULL,

    is_active BOOLEAN NOT NULL DEFAULT TRUE,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    deleted_at TIMESTAMP NULL DEFAULT NULL,

    created_by BIGINT UNSIGNED NULL,

    updated_by BIGINT UNSIGNED NULL,

    deleted_by BIGINT UNSIGNED NULL,

    CONSTRAINT uq_tenants_uuid
        UNIQUE (uuid),

    CONSTRAINT uq_tenants_document
        UNIQUE (document)

)
ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_unicode_ci
COMMENT='Empresas clientes do sistema.';


/******************************************************************************
    ÍNDICES
******************************************************************************/

CREATE INDEX idx_tenants_company_name
ON tenants(company_name);

CREATE INDEX idx_tenants_is_active
ON tenants(is_active);


/******************************************************************************
    TABELA: tenant_settings

    RESPONSABILIDADE

    Armazena as configurações individuais de cada empresa
    (Tenant) do sistema.

******************************************************************************/

CREATE TABLE tenant_settings (

    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    uuid CHAR(36) NOT NULL DEFAULT (UUID()),

    tenant_id BIGINT UNSIGNED NOT NULL,

    language VARCHAR(10) NOT NULL DEFAULT 'pt-BR',

    timezone VARCHAR(60) NOT NULL DEFAULT 'America/Sao_Paulo',

    currency VARCHAR(10) NOT NULL DEFAULT 'BRL',

    date_format VARCHAR(20) NOT NULL DEFAULT 'dd/MM/yyyy',

    time_format VARCHAR(10) NOT NULL DEFAULT '24h',

    theme VARCHAR(20) NOT NULL DEFAULT 'light',

    is_livestock_enabled BOOLEAN NOT NULL DEFAULT TRUE,

    is_agriculture_enabled BOOLEAN NOT NULL DEFAULT TRUE,

    is_financial_enabled BOOLEAN NOT NULL DEFAULT TRUE,

    is_inventory_enabled BOOLEAN NOT NULL DEFAULT TRUE,

    is_reports_enabled BOOLEAN NOT NULL DEFAULT TRUE,

    is_api_enabled BOOLEAN NOT NULL DEFAULT FALSE,

    is_active BOOLEAN NOT NULL DEFAULT TRUE,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    deleted_at TIMESTAMP NULL DEFAULT NULL,

    created_by BIGINT UNSIGNED NULL,

    updated_by BIGINT UNSIGNED NULL,

    deleted_by BIGINT UNSIGNED NULL,

    CONSTRAINT uq_tenant_settings_uuid
        UNIQUE (uuid),

    CONSTRAINT uq_tenant_settings_tenant
        UNIQUE (tenant_id),

    CONSTRAINT fk_tenant_settings_tenant

        FOREIGN KEY (tenant_id)

        REFERENCES tenants(id)

        ON UPDATE CASCADE

        ON DELETE CASCADE

)
ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_unicode_ci
COMMENT='Configurações individuais de cada empresa.';


/******************************************************************************
    ÍNDICES
******************************************************************************/

CREATE INDEX idx_tenant_settings_active
ON tenant_settings(is_active);


/******************************************************************************
    TABELA: system_settings

    RESPONSABILIDADE

    Armazena as configurações globais do sistema.

    Essas configurações são compartilhadas entre todos
    os tenants e administradas apenas por usuários MASTER.

******************************************************************************/

CREATE TABLE system_settings (

    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    uuid CHAR(36) NOT NULL DEFAULT (UUID()),

    setting_key VARCHAR(100) NOT NULL,

    setting_value TEXT NULL,

    description VARCHAR(255) NULL,

    is_public BOOLEAN NOT NULL DEFAULT FALSE,

    is_editable BOOLEAN NOT NULL DEFAULT TRUE,

    is_active BOOLEAN NOT NULL DEFAULT TRUE,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    deleted_at TIMESTAMP NULL DEFAULT NULL,

    created_by BIGINT UNSIGNED NULL,

    updated_by BIGINT UNSIGNED NULL,

    deleted_by BIGINT UNSIGNED NULL,

    CONSTRAINT uq_system_settings_uuid
        UNIQUE (uuid),

    CONSTRAINT uq_system_settings_key
        UNIQUE (setting_key)

)
ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_unicode_ci
COMMENT='Configurações globais do Gestor Agro.';


/******************************************************************************
    ÍNDICES
******************************************************************************/

CREATE INDEX idx_system_settings_active
ON system_settings(is_active);

CREATE INDEX idx_system_settings_public
ON system_settings(is_public);



/******************************************************************************
    TABELA: audit_logs

    RESPONSABILIDADE

    Armazena todas as ações realizadas pelos usuários
    dentro do sistema.

    Esta tabela é utilizada para auditoria, rastreabilidade,
    segurança e conformidade.

******************************************************************************/

CREATE TABLE audit_logs (

    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    uuid CHAR(36) NOT NULL DEFAULT (UUID()),

    tenant_id BIGINT UNSIGNED NOT NULL,

    user_id BIGINT UNSIGNED NULL,

    module VARCHAR(100) NOT NULL,

    table_name VARCHAR(100) NOT NULL,

    record_id BIGINT UNSIGNED NULL,

    action VARCHAR(30) NOT NULL,

    old_data JSON NULL,

    new_data JSON NULL,

    ip_address VARCHAR(45) NULL,

    user_agent TEXT NULL,

    session_id CHAR(36) NULL,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT uq_audit_logs_uuid
        UNIQUE (uuid),

    CONSTRAINT fk_audit_logs_tenant

        FOREIGN KEY (tenant_id)

        REFERENCES tenants(id)

        ON UPDATE CASCADE

        ON DELETE RESTRICT

)
ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_unicode_ci
COMMENT='Registro de auditoria de todas as operações realizadas no sistema.';



/******************************************************************************
    ÍNDICES
******************************************************************************/

CREATE INDEX idx_audit_logs_tenant
ON audit_logs(tenant_id);

CREATE INDEX idx_audit_logs_user
ON audit_logs(user_id);

CREATE INDEX idx_audit_logs_module
ON audit_logs(module);

CREATE INDEX idx_audit_logs_table
ON audit_logs(table_name);

CREATE INDEX idx_audit_logs_record
ON audit_logs(record_id);

CREATE INDEX idx_audit_logs_action
ON audit_logs(action);

CREATE INDEX idx_audit_logs_created_at
ON audit_logs(created_at);

/******************************************************************************
    COMENTÁRIOS
******************************************************************************/

COMMENT ON TABLE audit_logs IS
'Histórico de auditoria das operações realizadas pelos usuários.';

/******************************************************************************
    TABELA: system_logs

    RESPONSABILIDADE

    Armazena eventos técnicos, erros, avisos e informações
    geradas pelo sistema.

    Esta tabela NÃO substitui a auditoria de usuários.

******************************************************************************/

CREATE TABLE system_logs (

    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    uuid CHAR(36) NOT NULL DEFAULT (UUID()),

    tenant_id BIGINT UNSIGNED NULL,

    level ENUM(
        'DEBUG',
        'INFO',
        'WARNING',
        'ERROR',
        'CRITICAL'
    ) NOT NULL,

    module VARCHAR(100) NOT NULL,

    source VARCHAR(150) NULL,

    message TEXT NOT NULL,

    details JSON NULL,

    ip_address VARCHAR(45) NULL,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT uq_system_logs_uuid
        UNIQUE (uuid),

    CONSTRAINT fk_system_logs_tenant
        FOREIGN KEY (tenant_id)
        REFERENCES tenants(id)
        ON UPDATE CASCADE
        ON DELETE SET NULL

)
ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_unicode_ci
COMMENT='Logs técnicos do sistema.';

/******************************************************************************
    ÍNDICES
******************************************************************************/

CREATE INDEX idx_system_logs_level
ON system_logs(level);

CREATE INDEX idx_system_logs_module
ON system_logs(module);

CREATE INDEX idx_system_logs_source
ON system_logs(source);

CREATE INDEX idx_system_logs_created_at
ON system_logs(created_at);

CREATE INDEX idx_system_logs_tenant
ON system_logs(tenant_id);

/******************************************************************************
    FIM DO MÓDULO CORE

    Tabelas criadas:

    ✔ tenants
    ✔ tenant_settings
    ✔ system_settings
    ✔ audit_logs
    ✔ system_logs

    Próximo módulo:

    020_reference_data.sql

******************************************************************************/