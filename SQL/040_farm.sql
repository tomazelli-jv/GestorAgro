/******************************************************************************
*
*   TABELA: farms
*
*   RESPONSABILIDADE
*
*   Armazena as fazendas pertencentes a cada empresa (tenant).
*
******************************************************************************/

CREATE TABLE farms (

    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    uuid CHAR(36) NOT NULL DEFAULT (UUID()),

    tenant_id BIGINT UNSIGNED NOT NULL,

    code VARCHAR(30) NOT NULL,

    name VARCHAR(200) NOT NULL,

    description TEXT NULL,

    total_area DECIMAL(15,2) NULL,

    productive_area DECIMAL(15,2) NULL,

    preserved_area DECIMAL(15,2) NULL,

    is_active BOOLEAN NOT NULL DEFAULT TRUE,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    deleted_at TIMESTAMP NULL DEFAULT NULL,

    created_by BIGINT UNSIGNED NULL,

    updated_by BIGINT UNSIGNED NULL,

    deleted_by BIGINT UNSIGNED NULL,

    CONSTRAINT uq_farms_uuid
        UNIQUE (uuid),

    CONSTRAINT uq_farms_tenant_code
        UNIQUE (tenant_id, code),

    CONSTRAINT uq_farms_tenant_name
        UNIQUE (tenant_id, name),

    CONSTRAINT chk_farms_name
        CHECK (TRIM(name) <> ''),

    CONSTRAINT chk_farms_code
        CHECK (TRIM(code) <> ''),

    CONSTRAINT fk_farms_tenant
        FOREIGN KEY (tenant_id)
        REFERENCES tenants(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE

)
ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_unicode_ci
COMMENT='Cadastro de fazendas do sistema.';


/******************************************************************************
    ÍNDICES
******************************************************************************/

CREATE INDEX idx_farms_tenant
ON farms(tenant_id);

CREATE INDEX idx_farms_code
ON farms(code);

CREATE INDEX idx_farms_name
ON farms(name);

CREATE INDEX idx_farms_active
ON farms(is_active);


/******************************************************************************
*
*   TABELA: farm_addresses
*
*   RESPONSABILIDADE
*
*   Armazena os endereços das fazendas.
*
******************************************************************************/

CREATE TABLE farm_addresses (

    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    uuid CHAR(36) NOT NULL DEFAULT (UUID()),

    farm_id BIGINT UNSIGNED NOT NULL,

    country_id BIGINT UNSIGNED NOT NULL,

    state_id BIGINT UNSIGNED NOT NULL,

    city_id BIGINT UNSIGNED NOT NULL,

    zip_code VARCHAR(15) NULL,

    street VARCHAR(255) NULL,

    number VARCHAR(20) NULL,

    district VARCHAR(100) NULL,

    complement VARCHAR(255) NULL,

    latitude DECIMAL(10,8) NULL,

    longitude DECIMAL(11,8) NULL,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    deleted_at TIMESTAMP NULL DEFAULT NULL,

    created_by BIGINT UNSIGNED NULL,

    updated_by BIGINT UNSIGNED NULL,

    deleted_by BIGINT UNSIGNED NULL,

    CONSTRAINT uq_farm_addresses_uuid
        UNIQUE (uuid),

    CONSTRAINT uq_farm_address
        UNIQUE (farm_id),

    CONSTRAINT fk_farm_addresses_farm
        FOREIGN KEY (farm_id)
        REFERENCES farms(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_farm_addresses_country
        FOREIGN KEY (country_id)
        REFERENCES ref_countries(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_farm_addresses_state
        FOREIGN KEY (state_id)
        REFERENCES ref_states(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_farm_addresses_city
        FOREIGN KEY (city_id)
        REFERENCES ref_cities(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT

)
ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_unicode_ci
COMMENT='Endereço da fazenda.';


/******************************************************************************
    ÍNDICES
******************************************************************************/

CREATE INDEX idx_farm_addresses_farm
ON farm_addresses(farm_id);

CREATE INDEX idx_farm_addresses_country
ON farm_addresses(country_id);

CREATE INDEX idx_farm_addresses_state
ON farm_addresses(state_id);

CREATE INDEX idx_farm_addresses_city
ON farm_addresses(city_id);


/******************************************************************************
*
*   TABELA: farm_contacts
*
*   RESPONSABILIDADE
*
*   Armazena os meios de contato das fazendas.
*
*   Uma fazenda pode possuir vários contatos, como telefones,
*   e-mails e WhatsApp.
*
******************************************************************************/

CREATE TABLE farm_contacts (

    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    uuid CHAR(36) NOT NULL DEFAULT (UUID()),

    farm_id BIGINT UNSIGNED NOT NULL,

    contact_type VARCHAR(30) NOT NULL,

    contact_value VARCHAR(255) NOT NULL,

    contact_name VARCHAR(150) NULL,

    is_primary BOOLEAN NOT NULL DEFAULT FALSE,

    is_active BOOLEAN NOT NULL DEFAULT TRUE,

    notes VARCHAR(500) NULL,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    deleted_at TIMESTAMP NULL DEFAULT NULL,

    created_by BIGINT UNSIGNED NULL,

    updated_by BIGINT UNSIGNED NULL,

    deleted_by BIGINT UNSIGNED NULL,

    CONSTRAINT uq_farm_contacts_uuid
        UNIQUE (uuid),

    CONSTRAINT chk_farm_contacts_type
        CHECK (
            contact_type IN (
                'PHONE',
                'MOBILE',
                'WHATSAPP',
                'EMAIL',
                'OTHER'
            )
        ),

    CONSTRAINT chk_farm_contacts_value
        CHECK (TRIM(contact_value) <> ''),

    CONSTRAINT fk_farm_contacts_farm
        FOREIGN KEY (farm_id)
        REFERENCES farms(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE

)
ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_unicode_ci
COMMENT='Contatos das fazendas.';


/******************************************************************************
    ÍNDICES
******************************************************************************/

CREATE INDEX idx_farm_contacts_farm
ON farm_contacts(farm_id);

CREATE INDEX idx_farm_contacts_type
ON farm_contacts(contact_type);

CREATE INDEX idx_farm_contacts_primary
ON farm_contacts(is_primary);

CREATE INDEX idx_farm_contacts_active
ON farm_contacts(is_active);


/******************************************************************************
*
*   TABELA: farm_documents
*
*   RESPONSABILIDADE
*
*   Armazena os documentos oficiais vinculados às fazendas.
*
******************************************************************************/

CREATE TABLE farm_documents (

    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    uuid CHAR(36) NOT NULL DEFAULT (UUID()),

    farm_id BIGINT UNSIGNED NOT NULL,

    document_type VARCHAR(30) NOT NULL,

    document_number VARCHAR(50) NOT NULL,

    issuing_agency VARCHAR(150) NULL,

    issue_date DATE NULL,

    expiration_date DATE NULL,

    is_active BOOLEAN NOT NULL DEFAULT TRUE,

    observations VARCHAR(500) NULL,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    deleted_at TIMESTAMP NULL DEFAULT NULL,

    created_by BIGINT UNSIGNED NULL,

    updated_by BIGINT UNSIGNED NULL,

    deleted_by BIGINT UNSIGNED NULL,

    CONSTRAINT uq_farm_documents_uuid
        UNIQUE (uuid),

    CONSTRAINT uq_farm_document
        UNIQUE (farm_id, document_type, document_number),

    CONSTRAINT chk_farm_document_type
        CHECK (
            document_type IN (
                'CPF',
                'CNPJ',
                'IE',
                'CCIR',
                'CAR',
                'ITR',
                'OTHER'
            )
        ),

    CONSTRAINT chk_farm_document_number
        CHECK (TRIM(document_number) <> ''),

    CONSTRAINT fk_farm_documents_farm
        FOREIGN KEY (farm_id)
        REFERENCES farms(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE

)
ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_unicode_ci
COMMENT='Documentos oficiais das fazendas.';


/******************************************************************************
    ÍNDICES
******************************************************************************/

CREATE INDEX idx_farm_documents_farm
ON farm_documents(farm_id);

CREATE INDEX idx_farm_documents_type
ON farm_documents(document_type);

CREATE INDEX idx_farm_documents_active
ON farm_documents(is_active);

CREATE INDEX idx_farm_documents_expiration
ON farm_documents(expiration_date);


/******************************************************************************
*
*   TABELA: farm_owners
*
*   RESPONSABILIDADE
*
*   Armazena os proprietários das fazendas.
*
*   Uma fazenda pode possuir um ou mais proprietários.
*
******************************************************************************/

CREATE TABLE farm_owners (

    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    uuid CHAR(36) NOT NULL DEFAULT (UUID()),

    farm_id BIGINT UNSIGNED NOT NULL,

    owner_name VARCHAR(200) NOT NULL,

    document_type VARCHAR(10) NOT NULL,

    document_number VARCHAR(30) NOT NULL,

    email VARCHAR(150) NULL,

    phone VARCHAR(30) NULL,

    ownership_percentage DECIMAL(5,2) NOT NULL DEFAULT 100.00,

    is_primary BOOLEAN NOT NULL DEFAULT FALSE,

    is_active BOOLEAN NOT NULL DEFAULT TRUE,

    notes VARCHAR(500) NULL,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    deleted_at TIMESTAMP NULL DEFAULT NULL,

    created_by BIGINT UNSIGNED NULL,

    updated_by BIGINT UNSIGNED NULL,

    deleted_by BIGINT UNSIGNED NULL,

    CONSTRAINT uq_farm_owners_uuid
        UNIQUE (uuid),

    CONSTRAINT uq_farm_owner_document
        UNIQUE (farm_id, document_number),

    CONSTRAINT chk_farm_owner_name
        CHECK (TRIM(owner_name) <> ''),

    CONSTRAINT chk_farm_owner_document
        CHECK (TRIM(document_number) <> ''),

    CONSTRAINT chk_farm_owner_document_type
        CHECK (
            document_type IN (
                'CPF',
                'CNPJ'
            )
        ),

    CONSTRAINT chk_farm_owner_percentage
        CHECK (
            ownership_percentage > 0
            AND ownership_percentage <= 100
        ),

    CONSTRAINT fk_farm_owners_farm
        FOREIGN KEY (farm_id)
        REFERENCES farms(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE

)
ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_unicode_ci
COMMENT='Proprietários das fazendas.';


/******************************************************************************
    ÍNDICES
******************************************************************************/

CREATE INDEX idx_farm_owners_farm
ON farm_owners(farm_id);

CREATE INDEX idx_farm_owners_document
ON farm_owners(document_number);

CREATE INDEX idx_farm_owners_primary
ON farm_owners(is_primary);

CREATE INDEX idx_farm_owners_active
ON farm_owners(is_active);


/******************************************************************************
*
*   TABELA: farm_members
*
*   RESPONSABILIDADE
*
*   Relaciona usuários às fazendas que possuem acesso.
*
******************************************************************************/

CREATE TABLE farm_members (

    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    uuid CHAR(36) NOT NULL DEFAULT (UUID()),

    farm_id BIGINT UNSIGNED NOT NULL,

    user_id BIGINT UNSIGNED NOT NULL,

    is_default BOOLEAN NOT NULL DEFAULT FALSE,

    is_active BOOLEAN NOT NULL DEFAULT TRUE,

    access_start_date DATE NULL,

    access_end_date DATE NULL,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    deleted_at TIMESTAMP NULL DEFAULT NULL,

    created_by BIGINT UNSIGNED NULL,

    updated_by BIGINT UNSIGNED NULL,

    deleted_by BIGINT UNSIGNED NULL,

    CONSTRAINT uq_farm_members_uuid
        UNIQUE (uuid),

    CONSTRAINT uq_farm_members
        UNIQUE (farm_id, user_id),

    CONSTRAINT fk_farm_members_farm
        FOREIGN KEY (farm_id)
        REFERENCES farms(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_farm_members_user
        FOREIGN KEY (user_id)
        REFERENCES users(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE

)
ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_unicode_ci
COMMENT='Usuários autorizados a acessar cada fazenda.';


/******************************************************************************
    ÍNDICES
******************************************************************************/

CREATE INDEX idx_farm_members_farm
ON farm_members(farm_id);

CREATE INDEX idx_farm_members_user
ON farm_members(user_id);

CREATE INDEX idx_farm_members_active
ON farm_members(is_active);

CREATE INDEX idx_farm_members_default
ON farm_members(is_default);



/******************************************************************************
*
*   TABELA: farm_settings
*
*   RESPONSABILIDADE
*
*   Armazena as configurações específicas de cada fazenda.
*
******************************************************************************/

CREATE TABLE farm_settings (

    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    uuid CHAR(36) NOT NULL DEFAULT (UUID()),

    farm_id BIGINT UNSIGNED NOT NULL,

    setting_key VARCHAR(100) NOT NULL,

    setting_value TEXT NULL,

    description VARCHAR(255) NULL,

    is_system BOOLEAN NOT NULL DEFAULT FALSE,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    deleted_at TIMESTAMP NULL DEFAULT NULL,

    created_by BIGINT UNSIGNED NULL,

    updated_by BIGINT UNSIGNED NULL,

    deleted_by BIGINT UNSIGNED NULL,

    CONSTRAINT uq_farm_settings_uuid
        UNIQUE (uuid),

    CONSTRAINT uq_farm_setting
        UNIQUE (farm_id, setting_key),

    CONSTRAINT chk_farm_setting_key
        CHECK (TRIM(setting_key) <> ''),

    CONSTRAINT fk_farm_settings_farm
        FOREIGN KEY (farm_id)
        REFERENCES farms(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE

)
ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_unicode_ci
COMMENT='Configurações específicas das fazendas.';


/******************************************************************************
    ÍNDICES
******************************************************************************/

CREATE INDEX idx_farm_settings_farm
ON farm_settings(farm_id);

CREATE INDEX idx_farm_settings_key
ON farm_settings(setting_key);

CREATE INDEX idx_farm_settings_system
ON farm_settings(is_system);


