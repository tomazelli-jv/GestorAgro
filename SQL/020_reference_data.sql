/******************************************************************************
    TABELA: ref_countries

    RESPONSABILIDADE

    Armazena os países disponíveis no sistema.

    Esta tabela é global e compartilhada entre todos os tenants.

******************************************************************************/

CREATE TABLE ref_countries (

    id                  BIGSERIAL PRIMARY KEY,

    uuid                UUID NOT NULL UNIQUE DEFAULT gen_random_uuid(),

    name                VARCHAR(150) NOT NULL,

    iso2                CHAR(2) NOT NULL UNIQUE,

    iso3                CHAR(3) NOT NULL UNIQUE,

    phone_code           VARCHAR(10) NOT NULL,

    active              BOOLEAN NOT NULL DEFAULT TRUE,

    created_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    updated_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT chk_country_name
        CHECK (TRIM(name) <> '')

    CONSTRAINT chk_iso2
        CHECK (LENGTH(TRIM(iso2)) = 2),
 
    CONSTRAINT chk_iso3
        CHECK (LENGTH(TRIM(iso3)) = 3)
);

/******************************************************************************
    TABELA: ref_states

    RESPONSABILIDADE

    Armazena os estados ou províncias pertencentes a um país.

    Esta tabela é global e compartilhada entre todos os tenants.

******************************************************************************/

CREATE TABLE ref_states (

    id                  BIGSERIAL PRIMARY KEY,

    uuid                UUID NOT NULL UNIQUE DEFAULT gen_random_uuid(),

    country_id          BIGINT NOT NULL,

    name                VARCHAR(150) NOT NULL,

    abbreviation        VARCHAR(10) NOT NULL,

    ibge_code           VARCHAR(10),

    active              BOOLEAN NOT NULL DEFAULT TRUE,

    created_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    updated_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT chk_state_name
        CHECK (TRIM(name) <> ''),

    CONSTRAINT fk_ref_states_country
        FOREIGN KEY (country_id)
        REFERENCES ref_countries(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT

);

/******************************************************************************
    TRIGGER: ref_states

    Atualiza automaticamente o campo updated_at.
******************************************************************************/

CREATE TRIGGER trg_ref_states_updated_at

BEFORE UPDATE

ON ref_states

FOR EACH ROW

EXECUTE FUNCTION fn_update_updated_at();

/******************************************************************************
    TABELA: ref_cities

    RESPONSABILIDADE

    Armazena todas as cidades pertencentes a um estado.

    Esta tabela é global e compartilhada entre todos os tenants.

******************************************************************************/

CREATE TABLE ref_cities (

    id                  BIGSERIAL PRIMARY KEY,

    uuid                UUID NOT NULL UNIQUE DEFAULT gen_random_uuid(),

    state_id            BIGINT NOT NULL,

    name                VARCHAR(150) NOT NULL,

    ibge_code           VARCHAR(10),

    latitude            DECIMAL(10,8),

    longitude           DECIMAL(11,8),

    active              BOOLEAN NOT NULL DEFAULT TRUE,

    created_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    updated_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT chk_city_name
        CHECK (TRIM(name) <> ''),

    CONSTRAINT fk_ref_cities_state
        FOREIGN KEY (state_id)
        REFERENCES ref_states(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT

);

/******************************************************************************
    TRIGGER: ref_cities

    Atualiza automaticamente o campo updated_at.

******************************************************************************/

CREATE TRIGGER trg_ref_cities_updated_at

BEFORE UPDATE

ON ref_cities

FOR EACH ROW

EXECUTE FUNCTION fn_update_updated_at();


/******************************************************************************
    ÍNDICES
******************************************************************************/

CREATE INDEX idx_ref_states_country
ON ref_states(country_id);

CREATE INDEX idx_ref_states_name
ON ref_states(name);

CREATE INDEX idx_ref_cities_state
ON ref_cities(state_id);

CREATE INDEX idx_ref_cities_name
ON ref_cities(name);

CREATE INDEX idx_ref_cities_ibge
ON ref_cities(ibge_code);


/******************************************************************************
    COMENTÁRIOS DAS TABELAS
******************************************************************************/

COMMENT ON TABLE ref_countries IS
'Países disponíveis no sistema.';

COMMENT ON TABLE ref_states IS
'Estados ou províncias vinculados aos países.';

COMMENT ON TABLE ref_cities IS
'Cidades vinculadas aos estados.';


/*
===============================================================================

FIM DO MÓDULO 020

Próximo:

030_auth.sql

===============================================================================
*/