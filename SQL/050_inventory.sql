/******************************************************************************
*
*   TABELA: warehouses
*
*   RESPONSABILIDADE
*
*   Armazena os armazéns/depósitos pertencentes às fazendas.
*
******************************************************************************/

CREATE TABLE warehouses (

    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    uuid CHAR(36) NOT NULL DEFAULT (UUID()),

    farm_id BIGINT UNSIGNED NOT NULL,

    code VARCHAR(30) NOT NULL,

    name VARCHAR(150) NOT NULL,

    description VARCHAR(255) NULL,

    warehouse_type VARCHAR(30) NOT NULL DEFAULT 'GENERAL',

    is_default BOOLEAN NOT NULL DEFAULT FALSE,

    is_active BOOLEAN NOT NULL DEFAULT TRUE,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    deleted_at TIMESTAMP NULL DEFAULT NULL,

    created_by BIGINT UNSIGNED NULL,

    updated_by BIGINT UNSIGNED NULL,

    deleted_by BIGINT UNSIGNED NULL,

    CONSTRAINT uq_warehouses_uuid
        UNIQUE (uuid),

    CONSTRAINT uq_warehouses_code
        UNIQUE (farm_id, code),

    CONSTRAINT uq_warehouses_name
        UNIQUE (farm_id, name),

    CONSTRAINT chk_warehouse_code
        CHECK (TRIM(code) <> ''),

    CONSTRAINT chk_warehouse_name
        CHECK (TRIM(name) <> ''),

    CONSTRAINT chk_warehouse_type
        CHECK (
            warehouse_type IN (
                'GENERAL',
                'SEED',
                'FERTILIZER',
                'DEFENSIVE',
                'FUEL',
                'HARVEST',
                'MACHINERY',
                'OTHER'
            )
        ),

    CONSTRAINT fk_warehouses_farm
        FOREIGN KEY (farm_id)
        REFERENCES farms(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE

)
ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_unicode_ci
COMMENT='Armazéns e depósitos da fazenda.';


/******************************************************************************
    ÍNDICES
******************************************************************************/

CREATE INDEX idx_warehouses_farm
ON warehouses(farm_id);

CREATE INDEX idx_warehouses_code
ON warehouses(code);

CREATE INDEX idx_warehouses_name
ON warehouses(name);

CREATE INDEX idx_warehouses_type
ON warehouses(warehouse_type);

CREATE INDEX idx_warehouses_active
ON warehouses(is_active);


/******************************************************************************
*
*   TABELA: warehouse_locations
*
*   RESPONSABILIDADE
*
*   Armazena as localizações físicas dos armazéns.
*
******************************************************************************/

CREATE TABLE warehouse_locations (

    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    uuid CHAR(36) NOT NULL DEFAULT (UUID()),

    warehouse_id BIGINT UNSIGNED NOT NULL,

    code VARCHAR(30) NOT NULL,

    name VARCHAR(150) NOT NULL,

    description VARCHAR(255) NULL,

    parent_location_id BIGINT UNSIGNED NULL,

    location_type VARCHAR(30) NOT NULL DEFAULT 'LOCATION',

    capacity DECIMAL(15,3) NULL,

    is_default BOOLEAN NOT NULL DEFAULT FALSE,

    is_active BOOLEAN NOT NULL DEFAULT TRUE,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    deleted_at TIMESTAMP NULL DEFAULT NULL,

    created_by BIGINT UNSIGNED NULL,

    updated_by BIGINT UNSIGNED NULL,

    deleted_by BIGINT UNSIGNED NULL,

    CONSTRAINT uq_warehouse_locations_uuid
        UNIQUE (uuid),

    CONSTRAINT uq_warehouse_location_code
        UNIQUE (warehouse_id, code),

    CONSTRAINT uq_warehouse_location_name
        UNIQUE (warehouse_id, name),

    CONSTRAINT chk_warehouse_location_code
        CHECK (TRIM(code) <> ''),

    CONSTRAINT chk_warehouse_location_name
        CHECK (TRIM(name) <> ''),

    CONSTRAINT chk_warehouse_location_type
        CHECK (
            location_type IN (
                'LOCATION',
                'AISLE',
                'ROW',
                'SHELF',
                'LEVEL',
                'BOX',
                'BIN',
                'SILO',
                'BAY'
            )
        ),

    CONSTRAINT fk_warehouse_locations_warehouse
        FOREIGN KEY (warehouse_id)
        REFERENCES warehouses(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_warehouse_locations_parent
        FOREIGN KEY (parent_location_id)
        REFERENCES warehouse_locations(id)
        ON UPDATE CASCADE
        ON DELETE SET NULL

)
ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_unicode_ci
COMMENT='Localizações físicas dos armazéns.';


/******************************************************************************
    ÍNDICES
******************************************************************************/

CREATE INDEX idx_warehouse_locations_warehouse
ON warehouse_locations(warehouse_id);

CREATE INDEX idx_warehouse_locations_parent
ON warehouse_locations(parent_location_id);

CREATE INDEX idx_warehouse_locations_type
ON warehouse_locations(location_type);

CREATE INDEX idx_warehouse_locations_active
ON warehouse_locations(is_active);


/******************************************************************************
*
*   TABELA: product_categories
*
*   RESPONSABILIDADE
*
*   Armazena as categorias e subcategorias dos produtos.
*
******************************************************************************/

CREATE TABLE product_categories (

    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    uuid CHAR(36) NOT NULL DEFAULT (UUID()),

    farm_id BIGINT UNSIGNED NOT NULL,

    parent_category_id BIGINT UNSIGNED NULL,

    code VARCHAR(30) NOT NULL,

    name VARCHAR(150) NOT NULL,

    description VARCHAR(255) NULL,

    display_order INT UNSIGNED NOT NULL DEFAULT 0,

    is_active BOOLEAN NOT NULL DEFAULT TRUE,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    deleted_at TIMESTAMP NULL DEFAULT NULL,

    created_by BIGINT UNSIGNED NULL,

    updated_by BIGINT UNSIGNED NULL,

    deleted_by BIGINT UNSIGNED NULL,

    CONSTRAINT uq_product_categories_uuid
        UNIQUE (uuid),

    CONSTRAINT uq_product_categories_code
        UNIQUE (farm_id, code),

    CONSTRAINT uq_product_categories_name
        UNIQUE (farm_id, name),

    CONSTRAINT chk_product_categories_code
        CHECK (TRIM(code) <> ''),

    CONSTRAINT chk_product_categories_name
        CHECK (TRIM(name) <> ''),

    CONSTRAINT fk_product_categories_farm
        FOREIGN KEY (farm_id)
        REFERENCES farms(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_product_categories_parent
        FOREIGN KEY (parent_category_id)
        REFERENCES product_categories(id)
        ON UPDATE CASCADE
        ON DELETE SET NULL

)
ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_unicode_ci
COMMENT='Categorias e subcategorias dos produtos.';


/******************************************************************************
    ÍNDICES
******************************************************************************/

CREATE INDEX idx_product_categories_farm
ON product_categories(farm_id);

CREATE INDEX idx_product_categories_parent
ON product_categories(parent_category_id);

CREATE INDEX idx_product_categories_code
ON product_categories(code);

CREATE INDEX idx_product_categories_name
ON product_categories(name);

CREATE INDEX idx_product_categories_active
ON product_categories(is_active);


/******************************************************************************
*
*   TABELA: product_units
*
*   RESPONSABILIDADE
*
*   Armazena as unidades de medida utilizadas pelos produtos.
*
******************************************************************************/

CREATE TABLE product_units (

    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    uuid CHAR(36) NOT NULL DEFAULT (UUID()),

    code VARCHAR(20) NOT NULL,

    symbol VARCHAR(20) NOT NULL,

    name VARCHAR(100) NOT NULL,

    unit_type VARCHAR(30) NOT NULL,

    decimal_places TINYINT UNSIGNED NOT NULL DEFAULT 2,

    is_system BOOLEAN NOT NULL DEFAULT TRUE,

    is_active BOOLEAN NOT NULL DEFAULT TRUE,

    display_order INT UNSIGNED NOT NULL DEFAULT 0,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    deleted_at TIMESTAMP NULL DEFAULT NULL,

    created_by BIGINT UNSIGNED NULL,

    updated_by BIGINT UNSIGNED NULL,

    deleted_by BIGINT UNSIGNED NULL,

    CONSTRAINT uq_product_units_uuid
        UNIQUE (uuid),

    CONSTRAINT uq_product_units_code
        UNIQUE (code),

    CONSTRAINT uq_product_units_symbol
        UNIQUE (symbol),

    CONSTRAINT chk_product_units_code
        CHECK (TRIM(code) <> ''),

    CONSTRAINT chk_product_units_symbol
        CHECK (TRIM(symbol) <> ''),

    CONSTRAINT chk_product_units_name
        CHECK (TRIM(name) <> ''),

    CONSTRAINT chk_product_units_type
        CHECK (
            unit_type IN (
                'WEIGHT',
                'VOLUME',
                'LENGTH',
                'AREA',
                'UNIT',
                'TIME',
                'PACKAGE'
            )
        ),

    CONSTRAINT chk_product_units_decimal
        CHECK (
            decimal_places <= 6
        )

)
ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_unicode_ci
COMMENT='Unidades de medida utilizadas pelo sistema.';


/******************************************************************************
    ÍNDICES
******************************************************************************/

CREATE INDEX idx_product_units_type
ON product_units(unit_type);

CREATE INDEX idx_product_units_active
ON product_units(is_active);

CREATE INDEX idx_product_units_system
ON product_units(is_system);

CREATE INDEX idx_product_units_display
ON product_units(display_order);


/******************************************************************************
    UNIDADES PADRÃO
******************************************************************************/

INSERT INTO product_units
(
    code,
    symbol,
    name,
    unit_type,
    decimal_places,
    display_order
)
VALUES

('UN','un','Unidade','UNIT',0,1),
('KG','kg','Quilograma','WEIGHT',3,2),
('G','g','Grama','WEIGHT',3,3),
('T','t','Tonelada','WEIGHT',3,4),

('L','L','Litro','VOLUME',3,5),
('ML','mL','Mililitro','VOLUME',3,6),

('M','m','Metro','LENGTH',3,7),
('CM','cm','Centímetro','LENGTH',2,8),
('KM','km','Quilômetro','LENGTH',3,9),

('HA','ha','Hectare','AREA',4,10),
('M2','m²','Metro Quadrado','AREA',2,11),

('SC','sc','Saca','PACKAGE',2,12),
('CX','cx','Caixa','PACKAGE',0,13),
('FD','fd','Fardo','PACKAGE',0,14),
('PCT','pct','Pacote','PACKAGE',0,15),

('H','h','Hora','TIME',2,16),
('MIN','min','Minuto','TIME',2,17);


/******************************************************************************
*
*   TABELA: products
*
*   RESPONSABILIDADE
*
*   Armazena os produtos utilizados pela fazenda.
*
******************************************************************************/

CREATE TABLE products (

    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    uuid CHAR(36) NOT NULL DEFAULT (UUID()),

    farm_id BIGINT UNSIGNED NOT NULL,

    category_id BIGINT UNSIGNED NOT NULL,

    unit_id BIGINT UNSIGNED NOT NULL,

    code VARCHAR(30) NOT NULL,

    barcode VARCHAR(100) NULL,

    sku VARCHAR(100) NULL,

    name VARCHAR(200) NOT NULL,

    commercial_name VARCHAR(200) NULL,

    manufacturer VARCHAR(150) NULL,

    brand VARCHAR(150) NULL,

    description TEXT NULL,

    product_type VARCHAR(30) NOT NULL,

    minimum_stock DECIMAL(18,4) NOT NULL DEFAULT 0,

    maximum_stock DECIMAL(18,4) NULL,

    reorder_point DECIMAL(18,4) NULL,

    average_cost DECIMAL(18,6) NOT NULL DEFAULT 0,

    last_purchase_cost DECIMAL(18,6) NOT NULL DEFAULT 0,

    active BOOLEAN NOT NULL DEFAULT TRUE,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    deleted_at TIMESTAMP NULL DEFAULT NULL,

    created_by BIGINT UNSIGNED NULL,

    updated_by BIGINT UNSIGNED NULL,

    deleted_by BIGINT UNSIGNED NULL,

    CONSTRAINT uq_products_uuid
        UNIQUE (uuid),

    CONSTRAINT uq_products_code
        UNIQUE (farm_id, code),

    CONSTRAINT uq_products_barcode
        UNIQUE (farm_id, barcode),

    CONSTRAINT uq_products_sku
        UNIQUE (farm_id, sku),

    CONSTRAINT chk_products_code
        CHECK (TRIM(code) <> ''),

    CONSTRAINT chk_products_name
        CHECK (TRIM(name) <> ''),

    CONSTRAINT chk_products_type
        CHECK (

            product_type IN (

                'INPUT',

                'SEED',

                'FERTILIZER',

                'DEFENSIVE',

                'FUEL',

                'LUBRICANT',

                'PART',

                'MACHINERY',

                'TOOL',

                'HARVEST',

                'ANIMAL_FEED',

                'SERVICE',

                'OTHER'

            )

        ),

    CONSTRAINT fk_products_farm
        FOREIGN KEY (farm_id)
        REFERENCES farms(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_products_category
        FOREIGN KEY (category_id)
        REFERENCES product_categories(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_products_unit
        FOREIGN KEY (unit_id)
        REFERENCES product_units(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT

)

ENGINE=InnoDB

DEFAULT CHARSET=utf8mb4

COLLATE=utf8mb4_unicode_ci

COMMENT='Cadastro de produtos.';


/******************************************************************************
    ÍNDICES
******************************************************************************/

CREATE INDEX idx_products_farm
ON products(farm_id);

CREATE INDEX idx_products_category
ON products(category_id);

CREATE INDEX idx_products_unit
ON products(unit_id);

CREATE INDEX idx_products_name
ON products(name);

CREATE INDEX idx_products_type
ON products(product_type);

CREATE INDEX idx_products_active
ON products(active);

CREATE INDEX idx_products_barcode
ON products(barcode);


/******************************************************************************
*
*   TABELA: inventory_balances
*
*   RESPONSABILIDADE
*
*   Armazena o saldo atual dos produtos em cada localização do estoque.
*
******************************************************************************/

CREATE TABLE inventory_balances (

    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    uuid CHAR(36) NOT NULL DEFAULT (UUID()),

    farm_id BIGINT UNSIGNED NOT NULL,

    warehouse_id BIGINT UNSIGNED NOT NULL,

    location_id BIGINT UNSIGNED NOT NULL,

    product_id BIGINT UNSIGNED NOT NULL,

    quantity DECIMAL(18,4) NOT NULL DEFAULT 0,

    reserved_quantity DECIMAL(18,4) NOT NULL DEFAULT 0,

    available_quantity DECIMAL(18,4) NOT NULL DEFAULT 0,

    average_cost DECIMAL(18,6) NOT NULL DEFAULT 0,

    last_cost DECIMAL(18,6) NOT NULL DEFAULT 0,

    inventory_value DECIMAL(18,2) NOT NULL DEFAULT 0,

    last_movement_at TIMESTAMP NULL,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT uq_inventory_balance
        UNIQUE (
            warehouse_id,
            location_id,
            product_id
        ),

    CONSTRAINT uq_inventory_balances_uuid
        UNIQUE (uuid),

    CONSTRAINT chk_inventory_quantity
        CHECK (quantity >= 0),

    CONSTRAINT chk_inventory_reserved
        CHECK (reserved_quantity >= 0),

    CONSTRAINT chk_inventory_available
        CHECK (available_quantity >= 0),

    CONSTRAINT fk_inventory_balance_farm
        FOREIGN KEY (farm_id)
        REFERENCES farms(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_inventory_balance_warehouse
        FOREIGN KEY (warehouse_id)
        REFERENCES warehouses(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_inventory_balance_location
        FOREIGN KEY (location_id)
        REFERENCES warehouse_locations(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_inventory_balance_product
        FOREIGN KEY (product_id)
        REFERENCES products(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE

)

ENGINE=InnoDB

DEFAULT CHARSET=utf8mb4

COLLATE=utf8mb4_unicode_ci

COMMENT='Saldo atual dos produtos em estoque.';


/******************************************************************************
    ÍNDICES
******************************************************************************/

CREATE INDEX idx_inventory_balances_farm
ON inventory_balances(farm_id);

CREATE INDEX idx_inventory_balances_warehouse
ON inventory_balances(warehouse_id);

CREATE INDEX idx_inventory_balances_location
ON inventory_balances(location_id);

CREATE INDEX idx_inventory_balances_product
ON inventory_balances(product_id);

CREATE INDEX idx_inventory_balances_last_movement
ON inventory_balances(last_movement_at);


/******************************************************************************
*
*   TABELA: inventory_movements
*
*   RESPONSABILIDADE
*
*   Armazena todas as movimentações de estoque realizadas no sistema.
*
*   Esta tabela representa o histórico completo de entradas, saídas,
*   transferências, ajustes e consumos.
*
******************************************************************************/

CREATE TABLE inventory_movements (

    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    uuid CHAR(36) NOT NULL DEFAULT (UUID()),

    farm_id BIGINT UNSIGNED NOT NULL,

    warehouse_id BIGINT UNSIGNED NOT NULL,

    location_id BIGINT UNSIGNED NOT NULL,

    product_id BIGINT UNSIGNED NOT NULL,

    movement_type_id BIGINT UNSIGNED NOT NULL,

    movement_date DATETIME NOT NULL,

    quantity DECIMAL(18,4) NOT NULL,

    unit_cost DECIMAL(18,6) NOT NULL DEFAULT 0,

    total_cost DECIMAL(18,2) NOT NULL DEFAULT 0,

    reference_type VARCHAR(50) NULL,

    reference_id BIGINT UNSIGNED NULL,

    notes TEXT NULL,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    created_by BIGINT UNSIGNED NULL,

    CONSTRAINT uq_inventory_movements_uuid
        UNIQUE (uuid),

    CONSTRAINT chk_inventory_movements_quantity
        CHECK (quantity > 0),

    CONSTRAINT chk_inventory_movements_unit_cost
        CHECK (unit_cost >= 0),

    CONSTRAINT chk_inventory_movements_total_cost
        CHECK (total_cost >= 0),

    CONSTRAINT fk_inventory_movements_farm
        FOREIGN KEY (farm_id)
        REFERENCES farms(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_inventory_movements_warehouse
        FOREIGN KEY (warehouse_id)
        REFERENCES warehouses(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_inventory_movements_location
        FOREIGN KEY (location_id)
        REFERENCES warehouse_locations(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_inventory_movements_product
        FOREIGN KEY (product_id)
        REFERENCES products(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_inventory_movements_type
        FOREIGN KEY (movement_type_id)
        REFERENCES movement_types(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT

)

ENGINE=InnoDB

DEFAULT CHARSET=utf8mb4

COLLATE=utf8mb4_unicode_ci

COMMENT='Histórico completo das movimentações de estoque.';


/******************************************************************************
    ÍNDICES
******************************************************************************/

CREATE INDEX idx_inventory_movements_farm
ON inventory_movements(farm_id);

CREATE INDEX idx_inventory_movements_product
ON inventory_movements(product_id);

CREATE INDEX idx_inventory_movements_type
ON inventory_movements(movement_type_id);

CREATE INDEX idx_inventory_movements_date
ON inventory_movements(movement_date);

CREATE INDEX idx_inventory_movements_reference
ON inventory_movements(reference_type, reference_id);

CREATE INDEX idx_inventory_movements_warehouse
ON inventory_movements(warehouse_id);

CREATE INDEX idx_inventory_movements_location
ON inventory_movements(location_id);


/******************************************************************************
*
*   TABELA: movement_types
*
*   RESPONSABILIDADE
*
*   Armazena os tipos de movimentação de estoque utilizados pelo sistema.
*
******************************************************************************/

CREATE TABLE movement_types (

    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    uuid CHAR(36) NOT NULL DEFAULT (UUID()),

    code VARCHAR(30) NOT NULL,

    name VARCHAR(100) NOT NULL,

    description VARCHAR(255) NULL,

    operation_type VARCHAR(20) NOT NULL,

    affects_stock BOOLEAN NOT NULL DEFAULT TRUE,

    affects_cost BOOLEAN NOT NULL DEFAULT TRUE,

    is_system BOOLEAN NOT NULL DEFAULT TRUE,

    is_active BOOLEAN NOT NULL DEFAULT TRUE,

    display_order INT UNSIGNED NOT NULL DEFAULT 0,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    deleted_at TIMESTAMP NULL DEFAULT NULL,

    created_by BIGINT UNSIGNED NULL,

    updated_by BIGINT UNSIGNED NULL,

    deleted_by BIGINT UNSIGNED NULL,

    CONSTRAINT uq_movement_types_uuid
        UNIQUE (uuid),

    CONSTRAINT uq_movement_types_code
        UNIQUE (code),

    CONSTRAINT uq_movement_types_name
        UNIQUE (name),

    CONSTRAINT chk_movement_types_code
        CHECK (TRIM(code) <> ''),

    CONSTRAINT chk_movement_types_name
        CHECK (TRIM(name) <> ''),

    CONSTRAINT chk_movement_operation_type
        CHECK (
            operation_type IN (
                'IN',
                'OUT',
                'TRANSFER',
                'ADJUSTMENT'
            )
        )

)
ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_unicode_ci
COMMENT='Tipos de movimentação de estoque.';


/******************************************************************************
    ÍNDICES
******************************************************************************/

CREATE INDEX idx_movement_types_operation
ON movement_types(operation_type);

CREATE INDEX idx_movement_types_active
ON movement_types(is_active);

CREATE INDEX idx_movement_types_system
ON movement_types(is_system);

CREATE INDEX idx_movement_types_display
ON movement_types(display_order);


/******************************************************************************
    TIPOS PADRÃO DE MOVIMENTAÇÃO
******************************************************************************/

INSERT INTO movement_types
(
    code,
    name,
    description,
    operation_type,
    affects_stock,
    affects_cost,
    display_order
)
VALUES

(
    'PURCHASE',
    'Compra',
    'Entrada por compra.',
    'IN',
    TRUE,
    TRUE,
    1
),

(
    'SALE',
    'Venda',
    'Saída por venda.',
    'OUT',
    TRUE,
    TRUE,
    2
),

(
    'TRANSFER_IN',
    'Transferência de Entrada',
    'Recebimento por transferência.',
    'IN',
    TRUE,
    FALSE,
    3
),

(
    'TRANSFER_OUT',
    'Transferência de Saída',
    'Envio por transferência.',
    'OUT',
    TRUE,
    FALSE,
    4
),

(
    'INVENTORY_GAIN',
    'Sobra de Inventário',
    'Ajuste positivo de inventário.',
    'ADJUSTMENT',
    TRUE,
    TRUE,
    5
),

(
    'INVENTORY_LOSS',
    'Falta de Inventário',
    'Ajuste negativo de inventário.',
    'ADJUSTMENT',
    TRUE,
    TRUE,
    6
),

(
    'APPLICATION',
    'Aplicação Agrícola',
    'Consumo em operações agrícolas.',
    'OUT',
    TRUE,
    TRUE,
    7
),

(
    'HARVEST',
    'Colheita',
    'Entrada proveniente da colheita.',
    'IN',
    TRUE,
    TRUE,
    8
),

(
    'PRODUCTION',
    'Produção',
    'Entrada por processo produtivo.',
    'IN',
    TRUE,
    TRUE,
    9
),

(
    'CONSUMPTION',
    'Consumo Interno',
    'Consumo interno de materiais.',
    'OUT',
    TRUE,
    TRUE,
    10
),

(
    'RETURN_IN',
    'Devolução de Entrada',
    'Retorno de materiais ao estoque.',
    'IN',
    TRUE,
    TRUE,
    11
),

(
    'RETURN_OUT',
    'Devolução ao Fornecedor',
    'Saída por devolução.',
    'OUT',
    TRUE,
    TRUE,
    12
);


/******************************************************************************
*
*   TABELA: inventory_adjustments
*
*   RESPONSABILIDADE
*
*   Armazena os cabeçalhos dos ajustes e inventários de estoque.
*
******************************************************************************/

CREATE TABLE inventory_adjustments (

    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    uuid CHAR(36) NOT NULL DEFAULT (UUID()),

    farm_id BIGINT UNSIGNED NOT NULL,

    warehouse_id BIGINT UNSIGNED NOT NULL,

    adjustment_number VARCHAR(30) NOT NULL,

    adjustment_type VARCHAR(30) NOT NULL,

    adjustment_date DATETIME NOT NULL,

    status VARCHAR(20) NOT NULL DEFAULT 'OPEN',

    reason VARCHAR(255) NULL,

    observations TEXT NULL,

    completed_at DATETIME NULL,

    completed_by BIGINT UNSIGNED NULL,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    deleted_at TIMESTAMP NULL DEFAULT NULL,

    created_by BIGINT UNSIGNED NULL,

    updated_by BIGINT UNSIGNED NULL,

    deleted_by BIGINT UNSIGNED NULL,

    CONSTRAINT uq_inventory_adjustments_uuid
        UNIQUE (uuid),

    CONSTRAINT uq_inventory_adjustment_number
        UNIQUE (farm_id, adjustment_number),

    CONSTRAINT chk_inventory_adjustment_type
        CHECK (
            adjustment_type IN (
                'INVENTORY',
                'ADJUSTMENT',
                'COUNT'
            )
        ),

    CONSTRAINT chk_inventory_adjustment_status
        CHECK (
            status IN (
                'OPEN',
                'PROCESSING',
                'COMPLETED',
                'CANCELLED'
            )
        ),

    CONSTRAINT fk_inventory_adjustments_farm
        FOREIGN KEY (farm_id)
        REFERENCES farms(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_inventory_adjustments_warehouse
        FOREIGN KEY (warehouse_id)
        REFERENCES warehouses(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_inventory_adjustments_completed_by
        FOREIGN KEY (completed_by)
        REFERENCES users(id)
        ON UPDATE CASCADE
        ON DELETE SET NULL

)

ENGINE=InnoDB

DEFAULT CHARSET=utf8mb4

COLLATE=utf8mb4_unicode_ci

COMMENT='Cabeçalho dos ajustes e inventários de estoque.';


/******************************************************************************
    ÍNDICES
******************************************************************************/

CREATE INDEX idx_inventory_adjustments_farm
ON inventory_adjustments(farm_id);

CREATE INDEX idx_inventory_adjustments_warehouse
ON inventory_adjustments(warehouse_id);

CREATE INDEX idx_inventory_adjustments_date
ON inventory_adjustments(adjustment_date);

CREATE INDEX idx_inventory_adjustments_status
ON inventory_adjustments(status);

CREATE INDEX idx_inventory_adjustments_type
ON inventory_adjustments(adjustment_type);


