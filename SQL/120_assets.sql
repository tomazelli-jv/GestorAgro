/******************************************************************************
*
*   TABELA: asset_categories
*
*   RESPONSABILIDADE
*
*   Armazena as categorias dos patrimônios.
*
******************************************************************************/

CREATE TABLE asset_categories (

    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    uuid CHAR(36) NOT NULL DEFAULT (UUID()),

    name VARCHAR(100) NOT NULL,

    description TEXT NULL,

    is_active BOOLEAN NOT NULL DEFAULT TRUE,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    deleted_at TIMESTAMP NULL DEFAULT NULL,

    created_by BIGINT UNSIGNED NULL,

    updated_by BIGINT UNSIGNED NULL,

    deleted_by BIGINT UNSIGNED NULL,

    CONSTRAINT uq_asset_categories_uuid
        UNIQUE (uuid),

    CONSTRAINT uq_asset_categories_name
        UNIQUE (name),

    CONSTRAINT chk_asset_categories_name
        CHECK (
            TRIM(name) <> ''
        )

)

ENGINE=InnoDB

DEFAULT CHARSET=utf8mb4

COLLATE=utf8mb4_unicode_ci

COMMENT='Categorias de patrimônios.';


/******************************************************************************
    ÍNDICES
******************************************************************************/

CREATE INDEX idx_asset_categories_name
ON asset_categories(name);

CREATE INDEX idx_asset_categories_active
ON asset_categories(is_active);


/******************************************************************************
*
*   TABELA: assets
*
*   RESPONSABILIDADE
*
*   Armazena os patrimônios da empresa.
*
******************************************************************************/

CREATE TABLE assets (

    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    uuid CHAR(36) NOT NULL DEFAULT (UUID()),

    farm_id BIGINT UNSIGNED NOT NULL,

    asset_category_id BIGINT UNSIGNED NOT NULL,

    code VARCHAR(30) NOT NULL,

    name VARCHAR(150) NOT NULL,

    manufacturer VARCHAR(100) NULL,

    model VARCHAR(100) NULL,

    serial_number VARCHAR(100) NULL,

    acquisition_date DATE NULL,

    acquisition_value DECIMAL(15,2) NULL,

    current_location VARCHAR(100) NULL,

    status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',

    observations TEXT NULL,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    deleted_at TIMESTAMP NULL DEFAULT NULL,

    created_by BIGINT UNSIGNED NULL,

    updated_by BIGINT UNSIGNED NULL,

    deleted_by BIGINT UNSIGNED NULL,

    CONSTRAINT uq_assets_uuid
        UNIQUE (uuid),

    CONSTRAINT uq_assets_code
        UNIQUE (
            farm_id,
            code
        ),

    CONSTRAINT chk_assets_name
        CHECK (
            TRIM(name) <> ''
        ),

    CONSTRAINT chk_assets_code
        CHECK (
            TRIM(code) <> ''
        ),

    CONSTRAINT chk_assets_value
        CHECK (
            acquisition_value IS NULL
            OR acquisition_value >= 0
        ),

    CONSTRAINT chk_assets_status
        CHECK (

            status IN (

                'ACTIVE',

                'INACTIVE',

                'DISPOSED'

            )

        ),

    CONSTRAINT fk_assets_farm
        FOREIGN KEY (farm_id)
        REFERENCES farms(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_assets_category
        FOREIGN KEY (asset_category_id)
        REFERENCES asset_categories(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT

)

ENGINE=InnoDB

DEFAULT CHARSET=utf8mb4

COLLATE=utf8mb4_unicode_ci

COMMENT='Patrimônios da empresa.';


/******************************************************************************
    ÍNDICES
******************************************************************************/

CREATE INDEX idx_assets_farm
ON assets(farm_id);

CREATE INDEX idx_assets_category
ON assets(asset_category_id);

CREATE INDEX idx_assets_name
ON assets(name);

CREATE INDEX idx_assets_status
ON assets(status);


/******************************************************************************
*
*   TABELA: asset_movements
*
*   RESPONSABILIDADE
*
*   Armazena o histórico de movimentações dos patrimônios.
*
******************************************************************************/

CREATE TABLE asset_movements (

    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    uuid CHAR(36) NOT NULL DEFAULT (UUID()),

    asset_id BIGINT UNSIGNED NOT NULL,

    from_farm_id BIGINT UNSIGNED NULL,

    to_farm_id BIGINT UNSIGNED NULL,

    movement_date DATETIME NOT NULL,

    reason VARCHAR(50) NOT NULL,

    observations TEXT NULL,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    created_by BIGINT UNSIGNED NULL,

    updated_by BIGINT UNSIGNED NULL,

    CONSTRAINT uq_asset_movements_uuid
        UNIQUE (uuid),

    CONSTRAINT chk_asset_movements_reason
        CHECK (

            reason IN (

                'TRANSFER',

                'ASSIGNMENT',

                'RETURN',

                'DISPOSAL',

                'OTHER'

            )

        ),

    CONSTRAINT fk_asset_movements_asset
        FOREIGN KEY (asset_id)
        REFERENCES assets(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_asset_movements_from_farm
        FOREIGN KEY (from_farm_id)
        REFERENCES farms(id)
        ON UPDATE CASCADE
        ON DELETE SET NULL,

    CONSTRAINT fk_asset_movements_to_farm
        FOREIGN KEY (to_farm_id)
        REFERENCES farms(id)
        ON UPDATE CASCADE
        ON DELETE SET NULL

)

ENGINE=InnoDB

DEFAULT CHARSET=utf8mb4

COLLATE=utf8mb4_unicode_ci

COMMENT='Histórico de movimentações dos patrimônios.';


/******************************************************************************
    ÍNDICES
******************************************************************************/

CREATE INDEX idx_asset_movements_asset
ON asset_movements(asset_id);

CREATE INDEX idx_asset_movements_from_farm
ON asset_movements(from_farm_id);

CREATE INDEX idx_asset_movements_to_farm
ON asset_movements(to_farm_id);

CREATE INDEX idx_asset_movements_date
ON asset_movements(movement_date);

CREATE INDEX idx_asset_movements_reason
ON asset_movements(reason);


