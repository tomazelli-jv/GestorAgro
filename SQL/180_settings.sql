/******************************************************************************
*
*   TABELA: settings
*
*   RESPONSABILIDADE
*
*   Armazena as configurações gerais do sistema.
*
******************************************************************************/

CREATE TABLE settings (

    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    uuid CHAR(36) NOT NULL DEFAULT (UUID()),

    `key` VARCHAR(100) NOT NULL,

    `value` TEXT NULL,

    description VARCHAR(255) NULL,

    is_public BOOLEAN NOT NULL DEFAULT FALSE,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    created_by BIGINT UNSIGNED NULL,

    updated_by BIGINT UNSIGNED NULL,

    CONSTRAINT uq_settings_uuid
        UNIQUE (uuid),

    CONSTRAINT uq_settings_key
        UNIQUE (`key`),

    CONSTRAINT chk_settings_key
        CHECK (
            TRIM(`key`) <> ''
        )

)

ENGINE=InnoDB

DEFAULT CHARSET=utf8mb4

COLLATE=utf8mb4_unicode_ci

COMMENT='Configurações gerais do sistema.';


/******************************************************************************
    ÍNDICES
******************************************************************************/

CREATE INDEX idx_settings_key
ON settings(`key`);

CREATE INDEX idx_settings_public
ON settings(is_public);

/*******************************************************************************
        DADOS INICIAIS
********************************************************************************/

INSERT INTO settings (`key`, `value`, description) VALUES

('system_name', 'AgroERP', 'Nome do sistema'),

('system_version', '1.0.0', 'Versão atual'),

('default_language', 'pt-BR', 'Idioma padrão'),

('default_timezone', 'America/Araguaina', 'Fuso horário'),

('default_currency', 'BRL', 'Moeda padrão');



  
