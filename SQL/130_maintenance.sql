/******************************************************************************
*
*   TABELA: maintenance_types
*
*   RESPONSABILIDADE
*
*   Armazena os tipos de manutenção.
*
******************************************************************************/

CREATE TABLE maintenance_types (

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

    CONSTRAINT uq_maintenance_types_uuid
        UNIQUE (uuid),

    CONSTRAINT uq_maintenance_types_name
        UNIQUE (name),

    CONSTRAINT chk_maintenance_types_name
        CHECK (
            TRIM(name) <> ''
        )

)

ENGINE=InnoDB

DEFAULT CHARSET=utf8mb4

COLLATE=utf8mb4_unicode_ci

COMMENT='Tipos de manutenção.';


INSERT INTO maintenance_types (name) VALUES
('Preventiva'),
('Corretiva'),
('Inspeção'),
('Revisão');


/******************************************************************************
*
*   TABELA: maintenance_orders
*
*   RESPONSABILIDADE
*
*   Armazena as ordens de manutenção dos patrimônios.
*
******************************************************************************/

CREATE TABLE maintenance_orders (

    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    uuid CHAR(36) NOT NULL DEFAULT (UUID()),

    farm_id BIGINT UNSIGNED NOT NULL,

    asset_id BIGINT UNSIGNED NOT NULL,

    maintenance_type_id BIGINT UNSIGNED NOT NULL,

    order_number VARCHAR(30) NOT NULL,

    requested_date DATE NOT NULL,

    completed_date DATE NULL,

    status VARCHAR(20) NOT NULL DEFAULT 'OPEN',

    observations TEXT NULL,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    deleted_at TIMESTAMP NULL DEFAULT NULL,

    created_by BIGINT UNSIGNED NULL,

    updated_by BIGINT UNSIGNED NULL,

    deleted_by BIGINT UNSIGNED NULL,

    CONSTRAINT uq_maintenance_orders_uuid
        UNIQUE (uuid),

    CONSTRAINT uq_maintenance_orders_number
        UNIQUE (
            farm_id,
            order_number
        ),

    CONSTRAINT chk_maintenance_orders_number
        CHECK (
            TRIM(order_number) <> ''
        ),

    CONSTRAINT chk_maintenance_orders_dates
        CHECK (
            completed_date IS NULL
            OR completed_date >= requested_date
        ),

    CONSTRAINT chk_maintenance_orders_status
        CHECK (

            status IN (

                'OPEN',

                'IN_PROGRESS',

                'COMPLETED',

                'CANCELLED'

            )

        ),

    CONSTRAINT fk_maintenance_orders_farm
        FOREIGN KEY (farm_id)
        REFERENCES farms(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_maintenance_orders_asset
        FOREIGN KEY (asset_id)
        REFERENCES assets(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_maintenance_orders_type
        FOREIGN KEY (maintenance_type_id)
        REFERENCES maintenance_types(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT

)

ENGINE=InnoDB

DEFAULT CHARSET=utf8mb4

COLLATE=utf8mb4_unicode_ci

COMMENT='Ordens de manutenção.';


/******************************************************************************
    ÍNDICES
******************************************************************************/

CREATE INDEX idx_maintenance_orders_farm
ON maintenance_orders(farm_id);

CREATE INDEX idx_maintenance_orders_asset
ON maintenance_orders(asset_id);

CREATE INDEX idx_maintenance_orders_type
ON maintenance_orders(maintenance_type_id);

CREATE INDEX idx_maintenance_orders_status
ON maintenance_orders(status);

CREATE INDEX idx_maintenance_orders_requested_date
ON maintenance_orders(requested_date);


/******************************************************************************
*
*   TABELA: maintenance_order_items
*
*   RESPONSABILIDADE
*
*   Armazena os itens utilizados na manutenção, podendo representar
*   serviços executados ou produtos consumidos do estoque.
*
******************************************************************************/

CREATE TABLE maintenance_order_items (

    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    uuid CHAR(36) NOT NULL DEFAULT (UUID()),

    maintenance_order_id BIGINT UNSIGNED NOT NULL,

    sequence_number SMALLINT UNSIGNED NOT NULL,

    product_id BIGINT UNSIGNED NULL,

    unit_id BIGINT UNSIGNED NULL,

    description VARCHAR(255) NOT NULL,

    quantity DECIMAL(15,4) NOT NULL DEFAULT 1,

    unit_cost DECIMAL(15,2) NOT NULL DEFAULT 0,

    total_cost DECIMAL(15,2) NOT NULL DEFAULT 0,

    observations TEXT NULL,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    created_by BIGINT UNSIGNED NULL,

    updated_by BIGINT UNSIGNED NULL,

    CONSTRAINT uq_maintenance_order_items_uuid
        UNIQUE (uuid),

    CONSTRAINT uq_maintenance_order_item_sequence
        UNIQUE (
            maintenance_order_id,
            sequence_number
        ),

    CONSTRAINT chk_maintenance_order_item_description
        CHECK (
            TRIM(description) <> ''
        ),

    CONSTRAINT chk_maintenance_order_item_quantity
        CHECK (
            quantity > 0
        ),

    CONSTRAINT chk_maintenance_order_item_unit_cost
        CHECK (
            unit_cost >= 0
        ),

    CONSTRAINT chk_maintenance_order_item_total_cost
        CHECK (
            total_cost >= 0
        ),

    CONSTRAINT fk_maintenance_order_items_order
        FOREIGN KEY (maintenance_order_id)
        REFERENCES maintenance_orders(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_maintenance_order_items_product
        FOREIGN KEY (product_id)
        REFERENCES products(id)
        ON UPDATE CASCADE
        ON DELETE SET NULL,

    CONSTRAINT fk_maintenance_order_items_unit
        FOREIGN KEY (unit_id)
        REFERENCES product_units(id)
        ON UPDATE CASCADE
        ON DELETE SET NULL

)

ENGINE=InnoDB

DEFAULT CHARSET=utf8mb4

COLLATE=utf8mb4_unicode_ci

COMMENT='Itens das ordens de manutenção.';


/******************************************************************************
    ÍNDICES
******************************************************************************/

CREATE INDEX idx_maintenance_order_items_order
ON maintenance_order_items(maintenance_order_id);

CREATE INDEX idx_maintenance_order_items_product
ON maintenance_order_items(product_id);

CREATE INDEX idx_maintenance_order_items_unit
ON maintenance_order_items(unit_id);


