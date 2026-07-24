/******************************************************************************
*
*   TABELA: ref_countries
*
*   RESPONSABILIDADE
*
*   Armazena os países disponíveis no sistema.
*
*   Esta tabela é global e compartilhada entre todos os tenants.
*
******************************************************************************/

CREATE TABLE ref_countries (

    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    uuid CHAR(36) NOT NULL DEFAULT (UUID()),

    name VARCHAR(150) NOT NULL,

    official_name VARCHAR(200) NULL,

    iso2 CHAR(2) NOT NULL,

    iso3 CHAR(3) NOT NULL,

    numeric_code SMALLINT UNSIGNED NULL,

    phone_code VARCHAR(10) NULL,

    currency_code CHAR(3) NULL,

    language_code VARCHAR(10) NULL,

    nationality VARCHAR(100) NULL,

    continent VARCHAR(50) NULL,

    display_order INT UNSIGNED NOT NULL DEFAULT 0,

    is_active BOOLEAN NOT NULL DEFAULT TRUE,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    deleted_at TIMESTAMP NULL DEFAULT NULL,

    created_by BIGINT UNSIGNED NULL,

    updated_by BIGINT UNSIGNED NULL,

    deleted_by BIGINT UNSIGNED NULL,

    CONSTRAINT uq_ref_countries_uuid
        UNIQUE (uuid),

    CONSTRAINT uq_ref_countries_iso2
        UNIQUE (iso2),

    CONSTRAINT uq_ref_countries_iso3
        UNIQUE (iso3),

    CONSTRAINT uq_ref_countries_numeric_code
        UNIQUE (numeric_code),

    CONSTRAINT chk_ref_countries_name
        CHECK (TRIM(name) <> '')

)
ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_unicode_ci
COMMENT='Tabela de países do sistema.';

/******************************************************************************
    ÍNDICES
******************************************************************************/

CREATE INDEX idx_ref_countries_name
ON ref_countries(name);

CREATE INDEX idx_ref_countries_active
ON ref_countries(is_active);

CREATE INDEX idx_ref_countries_continent
ON ref_countries(continent);

CREATE INDEX idx_ref_countries_currency
ON ref_countries(currency_code);


/******************************************************************************
*
*   TABELA: ref_states
*
*   RESPONSABILIDADE
*
*   Armazena os estados/províncias pertencentes aos países
*   cadastrados no sistema.
*
*   Esta tabela é global e compartilhada entre todos os tenants.
*
******************************************************************************/

CREATE TABLE ref_states (

    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    uuid CHAR(36) NOT NULL DEFAULT (UUID()),

    country_id BIGINT UNSIGNED NOT NULL,

    name VARCHAR(150) NOT NULL,

    code VARCHAR(10) NOT NULL,

    ibge_code VARCHAR(10) NULL,

    region VARCHAR(50) NULL,

    display_order INT UNSIGNED NOT NULL DEFAULT 0,

    is_active BOOLEAN NOT NULL DEFAULT TRUE,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    deleted_at TIMESTAMP NULL DEFAULT NULL,

    created_by BIGINT UNSIGNED NULL,

    updated_by BIGINT UNSIGNED NULL,

    deleted_by BIGINT UNSIGNED NULL,

    CONSTRAINT uq_ref_states_uuid
        UNIQUE (uuid),

    CONSTRAINT uq_ref_states_country_code
        UNIQUE (country_id, code),

    CONSTRAINT uq_ref_states_country_name
        UNIQUE (country_id, name),

    CONSTRAINT chk_ref_states_name
        CHECK (TRIM(name) <> ''),

    CONSTRAINT fk_ref_states_country

        FOREIGN KEY (country_id)

        REFERENCES ref_countries(id)

        ON UPDATE CASCADE

        ON DELETE RESTRICT

)

ENGINE=InnoDB

DEFAULT CHARSET=utf8mb4

COLLATE=utf8mb4_unicode_ci

COMMENT='Estados, províncias ou divisões administrativas dos países.';

/******************************************************************************
    ÍNDICES
******************************************************************************/

CREATE INDEX idx_ref_states_country
ON ref_states(country_id);

CREATE INDEX idx_ref_states_name
ON ref_states(name);

CREATE INDEX idx_ref_states_code
ON ref_states(code);

CREATE INDEX idx_ref_states_region
ON ref_states(region);

CREATE INDEX idx_ref_states_active
ON ref_states(is_active);

/******************************************************************************
*
*   TABELA: ref_cities
*
*   RESPONSABILIDADE
*
*   Armazena as cidades pertencentes aos estados cadastrados
*   no sistema.
*
*   Esta tabela é global e compartilhada entre todos os tenants.
*
******************************************************************************/

CREATE TABLE ref_cities (

    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    uuid CHAR(36) NOT NULL DEFAULT (UUID()),

    state_id BIGINT UNSIGNED NOT NULL,

    name VARCHAR(150) NOT NULL,

    ibge_code VARCHAR(10) NULL,

    latitude DECIMAL(10,8) NULL,

    longitude DECIMAL(11,8) NULL,

    display_order INT UNSIGNED NOT NULL DEFAULT 0,

    is_active BOOLEAN NOT NULL DEFAULT TRUE,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    deleted_at TIMESTAMP NULL DEFAULT NULL,

    created_by BIGINT UNSIGNED NULL,

    updated_by BIGINT UNSIGNED NULL,

    deleted_by BIGINT UNSIGNED NULL,

    CONSTRAINT uq_ref_cities_uuid
        UNIQUE (uuid),

    CONSTRAINT uq_ref_cities_state_name
        UNIQUE (state_id, name),

    CONSTRAINT uq_ref_cities_ibge
        UNIQUE (ibge_code),

    CONSTRAINT chk_ref_cities_name
        CHECK (TRIM(name) <> ''),

    CONSTRAINT fk_ref_cities_state

        FOREIGN KEY (state_id)

        REFERENCES ref_states(id)

        ON UPDATE CASCADE

        ON DELETE RESTRICT

)

ENGINE=InnoDB

DEFAULT CHARSET=utf8mb4

COLLATE=utf8mb4_unicode_ci

COMMENT='Cidades pertencentes aos estados cadastrados.';

/******************************************************************************
    ÍNDICES
******************************************************************************/

CREATE INDEX idx_ref_cities_state
ON ref_cities(state_id);

CREATE INDEX idx_ref_cities_name
ON ref_cities(name);

CREATE INDEX idx_ref_cities_active
ON ref_cities(is_active);

CREATE INDEX idx_ref_cities_latitude
ON ref_cities(latitude);

CREATE INDEX idx_ref_cities_longitude
ON ref_cities(longitude);


/******************************************************************************
*
*   TABELA: ref_languages
*
*   RESPONSABILIDADE
*
*   Armazena os idiomas disponíveis no sistema.
*
*   Esta tabela é global e compartilhada entre todos os tenants.
*
******************************************************************************/

CREATE TABLE ref_languages (

    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    uuid CHAR(36) NOT NULL DEFAULT (UUID()),

    name VARCHAR(100) NOT NULL,

    native_name VARCHAR(100) NOT NULL,

    iso_code VARCHAR(10) NOT NULL,

    locale VARCHAR(20) NOT NULL,

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

    CONSTRAINT uq_ref_languages_uuid
        UNIQUE (uuid),

    CONSTRAINT uq_ref_languages_iso_code
        UNIQUE (iso_code),

    CONSTRAINT uq_ref_languages_locale
        UNIQUE (locale),

    CONSTRAINT chk_ref_languages_name
        CHECK (TRIM(name) <> ''),

    CONSTRAINT chk_ref_languages_native_name
        CHECK (TRIM(native_name) <> '')

)

ENGINE=InnoDB

DEFAULT CHARSET=utf8mb4

COLLATE=utf8mb4_unicode_ci

COMMENT='Idiomas disponíveis no sistema.';

/******************************************************************************
    ÍNDICES
******************************************************************************/

CREATE INDEX idx_ref_languages_name
ON ref_languages(name);

CREATE INDEX idx_ref_languages_active
ON ref_languages(is_active);

CREATE INDEX idx_ref_languages_default
ON ref_languages(is_default);

/******************************************************************************
*
*   TABELA: ref_currencies
*
*   RESPONSABILIDADE
*
*   Armazena as moedas disponíveis no sistema.
*
*   Esta tabela é global e compartilhada entre todos os tenants.
*
******************************************************************************/

CREATE TABLE ref_currencies (

    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    uuid CHAR(36) NOT NULL DEFAULT (UUID()),

    name VARCHAR(100) NOT NULL,

    code CHAR(3) NOT NULL,

    symbol VARCHAR(10) NOT NULL,

    decimal_places TINYINT UNSIGNED NOT NULL DEFAULT 2,

    is_default BOOLEAN NOT NULL DEFAULT FALSE,

    display_order INT UNSIGNED NOT NULL DEFAULT 0,

    is_active BOOLEAN NOT NULL DEFAULT TRUE,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    deleted_at TIMESTAMP NULL DEFAULT NULL,

    created_by BIGINT UNSIGNED NULL,

    updated_by BIGINT UNSIGNED NULL,

    deleted_by BIGINT UNSIGNED NULL,

    CONSTRAINT uq_ref_currencies_uuid
        UNIQUE (uuid),

    CONSTRAINT uq_ref_currencies_code
        UNIQUE (code),

    CONSTRAINT chk_ref_currencies_name
        CHECK (TRIM(name) <> '')

)

ENGINE=InnoDB

DEFAULT CHARSET=utf8mb4

COLLATE=utf8mb4_unicode_ci

COMMENT='Moedas disponíveis no sistema.';

/******************************************************************************
    ÍNDICES
******************************************************************************/

CREATE INDEX idx_ref_currencies_name
ON ref_currencies(name);

CREATE INDEX idx_ref_currencies_active
ON ref_currencies(is_active);

CREATE INDEX idx_ref_currencies_default
ON ref_currencies(is_default);