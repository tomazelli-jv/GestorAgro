/******************************************************************************
*
*   TABELA: stock_transfers
*
*   RESPONSABILIDADE
*
*   Controla as transferências de estoque entre armazéns, depósitos
*   e fazendas.
*
******************************************************************************/

CREATE TABLE stock_transfers (

    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    uuid CHAR(36) NOT NULL DEFAULT (UUID()),

    source_farm_id BIGINT UNSIGNED NOT NULL,

    destination_farm_id BIGINT UNSIGNED NOT NULL,
    
    transfer_number VARCHAR(30) NOT NULL,

    source_warehouse_id BIGINT UNSIGNED NOT NULL,

    destination_warehouse_id BIGINT UNSIGNED NOT NULL,

    requested_by BIGINT UNSIGNED NOT NULL,

    approved_by BIGINT UNSIGNED NULL,

    transfer_date DATETIME NOT NULL,

    expected_receipt_date DATE NULL,

    received_at DATETIME NULL,

    status VARCHAR(20) NOT NULL DEFAULT 'OPEN',

    observations TEXT NULL,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    deleted_at TIMESTAMP NULL,

    created_by BIGINT UNSIGNED NULL,

    updated_by BIGINT UNSIGNED NULL,

    deleted_by BIGINT UNSIGNED NULL,

    CONSTRAINT uq_stock_transfer_uuid
        UNIQUE (uuid),

    CONSTRAINT uq_stock_transfer_number
        UNIQUE (
            farm_id,
            transfer_number
        ),

    CONSTRAINT chk_stock_transfer_status
        CHECK (

            status IN (

                'OPEN',

                'APPROVED',

                'IN_TRANSIT',

                'RECEIVED',

                'CANCELLED'

            )

        ),

    CONSTRAINT chk_stock_transfer_warehouses
        CHECK (
            source_warehouse_id <> destination_warehouse_id
        ),

    CONSTRAINT fk_stock_transfer_farm
        FOREIGN KEY (farm_id)
        REFERENCES farms(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_stock_transfer_source
        FOREIGN KEY (source_warehouse_id)
        REFERENCES warehouses(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_stock_transfer_destination
        FOREIGN KEY (destination_warehouse_id)
        REFERENCES warehouses(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_stock_transfer_requested
        FOREIGN KEY (requested_by)
        REFERENCES users(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_stock_transfer_approved
        FOREIGN KEY (approved_by)
        REFERENCES users(id)
        ON UPDATE CASCADE
        ON DELETE SET NULL

)

ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_unicode_ci

COMMENT='Transferências internas de estoque.';


CREATE INDEX idx_stock_transfer_status
ON stock_transfers(status);

CREATE INDEX idx_stock_transfer_date
ON stock_transfers(transfer_date);

CREATE INDEX idx_stock_transfer_source
ON stock_transfers(source_warehouse_id);

CREATE INDEX idx_stock_transfer_destination
ON stock_transfers(destination_warehouse_id);

CREATE INDEX idx_stock_transfer_requested
ON stock_transfers(requested_by);


/******************************************************************************
*
*   TABELA: stock_transfer_items
*
*   RESPONSABILIDADE
*
*   Armazena os itens das transferências internas de estoque.
*
******************************************************************************/

CREATE TABLE stock_transfer_items (

    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    uuid CHAR(36) NOT NULL DEFAULT (UUID()),

    stock_transfer_id BIGINT UNSIGNED NOT NULL,

    product_id BIGINT UNSIGNED NOT NULL,

    source_warehouse_id BIGINT UNSIGNED NOT NULL,

    destination_warehouse_id BIGINT UNSIGNED NOT NULL,

    unit_id BIGINT UNSIGNED NOT NULL,

    sequence_number SMALLINT UNSIGNED NOT NULL,

    requested_quantity DECIMAL(18,4) NOT NULL,

    shipped_quantity DECIMAL(18,4) NOT NULL DEFAULT 0,

    received_quantity DECIMAL(18,4) NOT NULL DEFAULT 0,

    unit_cost DECIMAL(18,6) NOT NULL DEFAULT 0,

    observations TEXT NULL,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    created_by BIGINT UNSIGNED NULL,

    updated_by BIGINT UNSIGNED NULL,

    CONSTRAINT uq_stock_transfer_item_uuid
        UNIQUE (uuid),

    CONSTRAINT uq_stock_transfer_item_sequence
        UNIQUE (
            stock_transfer_id,
            sequence_number
        ),

    CONSTRAINT chk_requested_quantity
        CHECK (
            requested_quantity > 0
        ),

    CONSTRAINT chk_shipped_quantity
        CHECK (
            shipped_quantity >= 0
            AND shipped_quantity <= requested_quantity
        ),

    CONSTRAINT chk_received_quantity
        CHECK (
            received_quantity >= 0
            AND received_quantity <= shipped_quantity
        ),

    CONSTRAINT chk_unit_cost
        CHECK (
            unit_cost >= 0
        ),

    CONSTRAINT fk_transfer_item_transfer
        FOREIGN KEY (stock_transfer_id)
        REFERENCES stock_transfers(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_transfer_item_product
        FOREIGN KEY (product_id)
        REFERENCES products(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_transfer_item_source_warehouse
        FOREIGN KEY (source_warehouse_id)
        REFERENCES warehouses(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_transfer_item_destination_warehouse
        FOREIGN KEY (destination_warehouse_id)
        REFERENCES warehouses(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_transfer_item_unit
        FOREIGN KEY (unit_id)
        REFERENCES product_units(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT

)

ENGINE=InnoDB

DEFAULT CHARSET=utf8mb4

COLLATE=utf8mb4_unicode_ci

COMMENT='Itens das transferências internas de estoque.';


/******************************************************************************
    ÍNDICES
******************************************************************************/

CREATE INDEX idx_stock_transfer_items_transfer
ON stock_transfer_items(stock_transfer_id);

CREATE INDEX idx_stock_transfer_items_product
ON stock_transfer_items(product_id);

CREATE INDEX idx_stock_transfer_items_source_warehouse
ON stock_transfer_items(source_warehouse_id);

CREATE INDEX idx_stock_transfer_items_destination_warehouse
ON stock_transfer_items(destination_warehouse_id);

CREATE INDEX idx_stock_transfer_items_unit
ON stock_transfer_items(unit_id);

CREATE INDEX idx_stock_transfer_items_sequence
ON stock_transfer_items(sequence_number);


/******************************************************************************
*
*   TABELA: delivery_routes
*
*   RESPONSABILIDADE
*
*   Armazena as rotas de entrega planejadas.
*
******************************************************************************/

CREATE TABLE delivery_routes (

    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    uuid CHAR(36) NOT NULL DEFAULT (UUID()),

    farm_id BIGINT UNSIGNED NOT NULL,

    route_number VARCHAR(30) NOT NULL,

    route_date DATE NOT NULL,

    vehicle_id BIGINT UNSIGNED NULL,

    driver_id BIGINT UNSIGNED NULL,

    departure_time DATETIME NULL,

    return_time DATETIME NULL,

    status VARCHAR(20) NOT NULL DEFAULT 'PLANNED',

    observations TEXT NULL,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    deleted_at TIMESTAMP NULL,

    created_by BIGINT UNSIGNED NULL,

    updated_by BIGINT UNSIGNED NULL,

    deleted_by BIGINT UNSIGNED NULL,

    CONSTRAINT uq_delivery_routes_uuid
        UNIQUE (uuid),

    CONSTRAINT uq_delivery_routes_number
        UNIQUE (
            farm_id,
            route_number
        ),

    CONSTRAINT chk_delivery_route_status
        CHECK (

            status IN (

                'PLANNED',

                'IN_PROGRESS',

                'FINISHED',

                'CANCELLED'

            )

        ),

    CONSTRAINT chk_delivery_route_times
        CHECK (

            return_time IS NULL

            OR

            departure_time IS NULL

            OR

            return_time >= departure_time

        ),

    CONSTRAINT fk_delivery_routes_farm
        FOREIGN KEY (farm_id)
        REFERENCES farms(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_delivery_routes_vehicle
        FOREIGN KEY (vehicle_id)
        REFERENCES vehicles(id)
        ON UPDATE CASCADE
        ON DELETE SET NULL,

    CONSTRAINT fk_delivery_routes_driver
        FOREIGN KEY (driver_id)
        REFERENCES employees(id)
        ON UPDATE CASCADE
        ON DELETE SET NULL

)

ENGINE=InnoDB

DEFAULT CHARSET=utf8mb4

COLLATE=utf8mb4_unicode_ci

COMMENT='Rotas de entrega.';


/******************************************************************************
    ÍNDICES
******************************************************************************/

CREATE INDEX idx_delivery_routes_date
ON delivery_routes(route_date);

CREATE INDEX idx_delivery_routes_vehicle
ON delivery_routes(vehicle_id);

CREATE INDEX idx_delivery_routes_driver
ON delivery_routes(driver_id);

CREATE INDEX idx_delivery_routes_status
ON delivery_routes(status);


