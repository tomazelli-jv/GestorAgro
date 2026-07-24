/******************************************************************************
*
*   TABELA: sales_quotes
*
*   RESPONSABILIDADE
*
*   Armazena os orçamentos/propostas comerciais emitidos aos clientes.
*
******************************************************************************/

CREATE TABLE sales_quotes (

    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    uuid CHAR(36) NOT NULL DEFAULT (UUID()),

    farm_id BIGINT UNSIGNED NOT NULL,

    customer_id BIGINT UNSIGNED NOT NULL,

    quote_number VARCHAR(30) NOT NULL,

    quote_date DATE NOT NULL,

    valid_until DATE NULL,

    payment_method_id BIGINT UNSIGNED NULL,

    expected_delivery_date DATE NULL,

    total_amount DECIMAL(18,2) NOT NULL DEFAULT 0,

    discount_amount DECIMAL(18,2) NOT NULL DEFAULT 0,

    status VARCHAR(20) NOT NULL DEFAULT 'OPEN',

    observations TEXT NULL,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    deleted_at TIMESTAMP NULL DEFAULT NULL,

    created_by BIGINT UNSIGNED NULL,

    updated_by BIGINT UNSIGNED NULL,

    deleted_by BIGINT UNSIGNED NULL,

    CONSTRAINT uq_sales_quotes_uuid
        UNIQUE (uuid),

    CONSTRAINT uq_sales_quote_number
        UNIQUE (
            farm_id,
            quote_number
        ),

    CONSTRAINT chk_sales_quote_number
        CHECK (
            TRIM(quote_number) <> ''
        ),

    CONSTRAINT chk_sales_quote_total
        CHECK (
            total_amount >= 0
        ),

    CONSTRAINT chk_sales_quote_discount
        CHECK (
            discount_amount >= 0
        ),

    CONSTRAINT chk_sales_quote_dates
        CHECK (

            valid_until IS NULL
            OR
            valid_until >= quote_date

        ),

    CONSTRAINT chk_sales_quote_delivery
        CHECK (

            expected_delivery_date IS NULL
            OR
            expected_delivery_date >= quote_date

        ),

    CONSTRAINT chk_sales_quote_status
        CHECK (

            status IN (

                'OPEN',

                'APPROVED',

                'REJECTED',

                'EXPIRED',

                'CANCELLED',

                'CONVERTED'

            )

        ),

    CONSTRAINT fk_sales_quotes_farm
        FOREIGN KEY (farm_id)
        REFERENCES farms(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_sales_quotes_customer
        FOREIGN KEY (customer_id)
        REFERENCES contacts(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_sales_quotes_payment_method
        FOREIGN KEY (payment_method_id)
        REFERENCES payment_methods(id)
        ON UPDATE CASCADE
        ON DELETE SET NULL

)

ENGINE=InnoDB

DEFAULT CHARSET=utf8mb4

COLLATE=utf8mb4_unicode_ci

COMMENT='Orçamentos comerciais.';

/******************************************************************************
    ÍNDICES
******************************************************************************/

CREATE INDEX idx_sales_quotes_farm
ON sales_quotes(farm_id);

CREATE INDEX idx_sales_quotes_customer
ON sales_quotes(customer_id);

CREATE INDEX idx_sales_quotes_date
ON sales_quotes(quote_date);

CREATE INDEX idx_sales_quotes_valid_until
ON sales_quotes(valid_until);

CREATE INDEX idx_sales_quotes_status
ON sales_quotes(status);


/******************************************************************************
*
*   TABELA: sales_quote_items
*
*   RESPONSABILIDADE
*
*   Armazena os itens dos orçamentos comerciais.
*
******************************************************************************/

CREATE TABLE sales_quote_items (

    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    uuid CHAR(36) NOT NULL DEFAULT (UUID()),

    sales_quote_id BIGINT UNSIGNED NOT NULL,

    product_id BIGINT UNSIGNED NOT NULL,

    unit_id BIGINT UNSIGNED NOT NULL,

    warehouse_id BIGINT UNSIGNED NULL,

    sequence_number SMALLINT UNSIGNED NOT NULL,

    quoted_quantity DECIMAL(18,4) NOT NULL,

    approved_quantity DECIMAL(18,4) NOT NULL DEFAULT 0,

    unit_price DECIMAL(18,6) NOT NULL,

    discount_amount DECIMAL(18,2) NOT NULL DEFAULT 0,

    tax_amount DECIMAL(18,2) NOT NULL DEFAULT 0,

    total_amount DECIMAL(18,2) NOT NULL,

    expected_delivery_date DATE NULL,

    observations TEXT NULL,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    created_by BIGINT UNSIGNED NULL,

    updated_by BIGINT UNSIGNED NULL,

    CONSTRAINT uq_sales_quote_items_uuid
        UNIQUE (uuid),

    CONSTRAINT uq_sales_quote_item_sequence
        UNIQUE (
            sales_quote_id,
            sequence_number
        ),

    CONSTRAINT chk_sales_quote_quantity
        CHECK (
            quoted_quantity > 0
        ),

    CONSTRAINT chk_sales_quote_approved
        CHECK (
            approved_quantity >= 0
            AND
            approved_quantity <= quoted_quantity
        ),

    CONSTRAINT chk_sales_quote_price
        CHECK (
            unit_price >= 0
        ),

    CONSTRAINT chk_sales_quote_discount
        CHECK (
            discount_amount >= 0
        ),

    CONSTRAINT chk_sales_quote_tax
        CHECK (
            tax_amount >= 0
        ),

    CONSTRAINT chk_sales_quote_total
        CHECK (
            total_amount >= 0
        ),

    CONSTRAINT fk_sales_quote_items_quote
        FOREIGN KEY (sales_quote_id)
        REFERENCES sales_quotes(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_sales_quote_items_product
        FOREIGN KEY (product_id)
        REFERENCES products(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_sales_quote_items_unit
        FOREIGN KEY (unit_id)
        REFERENCES product_units(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_sales_quote_items_warehouse
        FOREIGN KEY (warehouse_id)
        REFERENCES warehouses(id)
        ON UPDATE CASCADE
        ON DELETE SET NULL

)

ENGINE=InnoDB

DEFAULT CHARSET=utf8mb4

COLLATE=utf8mb4_unicode_ci

COMMENT='Itens dos orçamentos comerciais.';


/******************************************************************************
    ÍNDICES
******************************************************************************/

CREATE INDEX idx_sales_quote_items_quote
ON sales_quote_items(sales_quote_id);

CREATE INDEX idx_sales_quote_items_product
ON sales_quote_items(product_id);

CREATE INDEX idx_sales_quote_items_unit
ON sales_quote_items(unit_id);

CREATE INDEX idx_sales_quote_items_warehouse
ON sales_quote_items(warehouse_id);

CREATE INDEX idx_sales_quote_items_delivery
ON sales_quote_items(expected_delivery_date);

CREATE INDEX idx_sales_quote_items_sequence
ON sales_quote_items(sequence_number);


/******************************************************************************
*
*   TABELA: sales_orders
*
*   RESPONSABILIDADE
*
*   Armazena os pedidos de venda emitidos aos clientes.
*
******************************************************************************/

CREATE TABLE sales_orders (

    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    uuid CHAR(36) NOT NULL DEFAULT (UUID()),

    farm_id BIGINT UNSIGNED NOT NULL,

    sales_quote_id BIGINT UNSIGNED NULL,

    customer_id BIGINT UNSIGNED NOT NULL,

    salesperson_id BIGINT UNSIGNED NULL,

    order_number VARCHAR(30) NOT NULL,

    order_date DATE NOT NULL,

    expected_delivery_date DATE NULL,

    payment_method_id BIGINT UNSIGNED NULL,

    total_amount DECIMAL(18,2) NOT NULL DEFAULT 0,

    discount_amount DECIMAL(18,2) NOT NULL DEFAULT 0,

    freight_amount DECIMAL(18,2) NOT NULL DEFAULT 0,

    status VARCHAR(25) NOT NULL DEFAULT 'OPEN',

    observations TEXT NULL,

    approved_at DATETIME NULL,

    approved_by BIGINT UNSIGNED NULL,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    deleted_at TIMESTAMP NULL DEFAULT NULL,

    created_by BIGINT UNSIGNED NULL,

    updated_by BIGINT UNSIGNED NULL,

    deleted_by BIGINT UNSIGNED NULL,

    CONSTRAINT uq_sales_orders_uuid
        UNIQUE (uuid),

    CONSTRAINT uq_sales_order_number
        UNIQUE (
            farm_id,
            order_number
        ),

    CONSTRAINT chk_sales_order_number
        CHECK (
            TRIM(order_number) <> ''
        ),

    CONSTRAINT chk_sales_order_total
        CHECK (
            total_amount >= 0
        ),

    CONSTRAINT chk_sales_order_discount
        CHECK (
            discount_amount >= 0
        ),

    CONSTRAINT chk_sales_order_freight
        CHECK (
            freight_amount >= 0
        ),

    CONSTRAINT chk_sales_order_dates
        CHECK (

            expected_delivery_date IS NULL

            OR

            expected_delivery_date >= order_date

        ),

    CONSTRAINT chk_sales_order_status
        CHECK (

            status IN (

                'OPEN',

                'APPROVED',

                'PARTIALLY_SHIPPED',

                'SHIPPED',

                'PARTIALLY_INVOICED',

                'INVOICED',

                'CANCELLED',

                'CLOSED'

            )

        ),

    CONSTRAINT fk_sales_orders_farm
        FOREIGN KEY (farm_id)
        REFERENCES farms(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_sales_orders_quote
        FOREIGN KEY (sales_quote_id)
        REFERENCES sales_quotes(id)
        ON UPDATE CASCADE
        ON DELETE SET NULL,

    CONSTRAINT fk_sales_orders_customer
        FOREIGN KEY (customer_id)
        REFERENCES contacts(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_sales_orders_salesperson
        FOREIGN KEY (salesperson_id)
        REFERENCES users(id)
        ON UPDATE CASCADE
        ON DELETE SET NULL,

    CONSTRAINT fk_sales_orders_payment_method
        FOREIGN KEY (payment_method_id)
        REFERENCES payment_methods(id)
        ON UPDATE CASCADE
        ON DELETE SET NULL,

    CONSTRAINT fk_sales_orders_approved_by
        FOREIGN KEY (approved_by)
        REFERENCES users(id)
        ON UPDATE CASCADE
        ON DELETE SET NULL

)

ENGINE=InnoDB

DEFAULT CHARSET=utf8mb4

COLLATE=utf8mb4_unicode_ci

COMMENT='Pedidos de venda.';


/******************************************************************************
    ÍNDICES
******************************************************************************/

CREATE INDEX idx_sales_orders_farm
ON sales_orders(farm_id);

CREATE INDEX idx_sales_orders_quote
ON sales_orders(sales_quote_id);

CREATE INDEX idx_sales_orders_customer
ON sales_orders(customer_id);

CREATE INDEX idx_sales_orders_salesperson
ON sales_orders(salesperson_id);

CREATE INDEX idx_sales_orders_order_date
ON sales_orders(order_date);

CREATE INDEX idx_sales_orders_expected_delivery
ON sales_orders(expected_delivery_date);

CREATE INDEX idx_sales_orders_status
ON sales_orders(status);

CREATE INDEX idx_sales_orders_approved_by
ON sales_orders(approved_by);


/******************************************************************************
*
*   TABELA: sales_order_items
*
*   RESPONSABILIDADE
*
*   Armazena os itens dos pedidos de venda.
*
******************************************************************************/

CREATE TABLE sales_order_items (

    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    uuid CHAR(36) NOT NULL DEFAULT (UUID()),

    sales_order_id BIGINT UNSIGNED NOT NULL,

    sales_quote_item_id BIGINT UNSIGNED NULL,

    product_id BIGINT UNSIGNED NOT NULL,

    warehouse_id BIGINT UNSIGNED NOT NULL,

    unit_id BIGINT UNSIGNED NOT NULL,

    cost_center_id BIGINT UNSIGNED NULL,

    account_id BIGINT UNSIGNED NULL,

    sequence_number SMALLINT UNSIGNED NOT NULL,

    ordered_quantity DECIMAL(18,4) NOT NULL,

    reserved_quantity DECIMAL(18,4) NOT NULL DEFAULT 0,

    shipped_quantity DECIMAL(18,4) NOT NULL DEFAULT 0,

    invoiced_quantity DECIMAL(18,4) NOT NULL DEFAULT 0,

    unit_price DECIMAL(18,6) NOT NULL,

    discount_amount DECIMAL(18,2) NOT NULL DEFAULT 0,

    tax_amount DECIMAL(18,2) NOT NULL DEFAULT 0,

    total_amount DECIMAL(18,2) NOT NULL,

    status VARCHAR(25) NOT NULL DEFAULT 'OPEN',

    observations TEXT NULL,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    created_by BIGINT UNSIGNED NULL,

    updated_by BIGINT UNSIGNED NULL,

    CONSTRAINT uq_sales_order_items_uuid
        UNIQUE (uuid),

    CONSTRAINT uq_sales_order_item_sequence
        UNIQUE (
            sales_order_id,
            sequence_number
        ),

    CONSTRAINT chk_sales_order_ordered
        CHECK (
            ordered_quantity > 0
        ),

    CONSTRAINT chk_sales_order_reserved
        CHECK (
            reserved_quantity >= 0
            AND
            reserved_quantity <= ordered_quantity
        ),

    CONSTRAINT chk_sales_order_shipped
        CHECK (
            shipped_quantity >= 0
            AND
            shipped_quantity <= ordered_quantity
        ),

    CONSTRAINT chk_sales_order_invoiced
        CHECK (
            invoiced_quantity >= 0
            AND
            invoiced_quantity <= shipped_quantity
        ),

    CONSTRAINT chk_sales_order_price
        CHECK (
            unit_price >= 0
        ),

    CONSTRAINT chk_sales_order_discount
        CHECK (
            discount_amount >= 0
        ),

    CONSTRAINT chk_sales_order_tax
        CHECK (
            tax_amount >= 0
        ),

    CONSTRAINT chk_sales_order_total
        CHECK (
            total_amount >= 0
        ),

    CONSTRAINT chk_sales_order_status
        CHECK (

            status IN (

                'OPEN',

                'RESERVED',

                'PARTIALLY_SHIPPED',

                'SHIPPED',

                'PARTIALLY_INVOICED',

                'INVOICED',

                'CANCELLED'

            )

        ),

    CONSTRAINT fk_sales_order_items_order
        FOREIGN KEY (sales_order_id)
        REFERENCES sales_orders(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_sales_order_items_quote_item
        FOREIGN KEY (sales_quote_item_id)
        REFERENCES sales_quote_items(id)
        ON UPDATE CASCADE
        ON DELETE SET NULL,

    CONSTRAINT fk_sales_order_items_product
        FOREIGN KEY (product_id)
        REFERENCES products(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_sales_order_items_warehouse
        FOREIGN KEY (warehouse_id)
        REFERENCES warehouses(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_sales_order_items_unit
        FOREIGN KEY (unit_id)
        REFERENCES product_units(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_sales_order_items_cost_center
        FOREIGN KEY (cost_center_id)
        REFERENCES cost_centers(id)
        ON UPDATE CASCADE
        ON DELETE SET NULL,

    CONSTRAINT fk_sales_order_items_account
        FOREIGN KEY (account_id)
        REFERENCES accounts(id)
        ON UPDATE CASCADE
        ON DELETE SET NULL

)

ENGINE=InnoDB

DEFAULT CHARSET=utf8mb4

COLLATE=utf8mb4_unicode_ci

COMMENT='Itens dos pedidos de venda.';


/******************************************************************************
    ÍNDICES
******************************************************************************/

CREATE INDEX idx_sales_order_items_order
ON sales_order_items(sales_order_id);

CREATE INDEX idx_sales_order_items_quote_item
ON sales_order_items(sales_quote_item_id);

CREATE INDEX idx_sales_order_items_product
ON sales_order_items(product_id);

CREATE INDEX idx_sales_order_items_warehouse
ON sales_order_items(warehouse_id);

CREATE INDEX idx_sales_order_items_unit
ON sales_order_items(unit_id);

CREATE INDEX idx_sales_order_items_cost_center
ON sales_order_items(cost_center_id);

CREATE INDEX idx_sales_order_items_account
ON sales_order_items(account_id);

CREATE INDEX idx_sales_order_items_status
ON sales_order_items(status);

CREATE INDEX idx_sales_order_items_sequence
ON sales_order_items(sequence_number);


/******************************************************************************
*
*   TABELA: shipments
*
*   RESPONSABILIDADE
*
*   Armazena as expedições de mercadorias para entrega aos clientes.
*
******************************************************************************/

CREATE TABLE shipments (

    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    uuid CHAR(36) NOT NULL DEFAULT (UUID()),

    farm_id BIGINT UNSIGNED NOT NULL,

    sales_order_id BIGINT UNSIGNED NOT NULL,

    shipment_number VARCHAR(30) NOT NULL,

    shipment_date DATETIME NOT NULL,

    expected_delivery_date DATE NULL,

    carrier_id BIGINT UNSIGNED NULL,

    vehicle_plate VARCHAR(10) NULL,

    driver_name VARCHAR(150) NULL,

    freight_type VARCHAR(20) NOT NULL DEFAULT 'CIF',

    freight_amount DECIMAL(18,2) NOT NULL DEFAULT 0,

    gross_weight DECIMAL(18,3) NULL,

    net_weight DECIMAL(18,3) NULL,

    package_quantity INT UNSIGNED NOT NULL DEFAULT 0,

    tracking_code VARCHAR(100) NULL,

    status VARCHAR(20) NOT NULL DEFAULT 'OPEN',

    observations TEXT NULL,

    shipped_by BIGINT UNSIGNED NULL,

    delivered_at DATETIME NULL,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    deleted_at TIMESTAMP NULL DEFAULT NULL,

    created_by BIGINT UNSIGNED NULL,

    updated_by BIGINT UNSIGNED NULL,

    deleted_by BIGINT UNSIGNED NULL,

    CONSTRAINT uq_shipments_uuid
        UNIQUE (uuid),

    CONSTRAINT uq_shipment_number
        UNIQUE (
            farm_id,
            shipment_number
        ),

    CONSTRAINT chk_shipment_number
        CHECK (
            TRIM(shipment_number) <> ''
        ),

    CONSTRAINT chk_shipment_freight
        CHECK (
            freight_amount >= 0
        ),

    CONSTRAINT chk_shipment_gross_weight
        CHECK (
            gross_weight IS NULL
            OR gross_weight >= 0
        ),

    CONSTRAINT chk_shipment_net_weight
        CHECK (
            net_weight IS NULL
            OR net_weight >= 0
        ),

    CONSTRAINT chk_shipment_packages
        CHECK (
            package_quantity >= 0
        ),

    CONSTRAINT chk_shipment_freight_type
        CHECK (

            freight_type IN (

                'CIF',

                'FOB',

                'THIRD_PARTY',

                'OWN_VEHICLE'

            )

        ),

    CONSTRAINT chk_shipment_status
        CHECK (

            status IN (

                'OPEN',

                'PICKING',

                'SHIPPED',

                'IN_TRANSIT',

                'DELIVERED',

                'RETURNED',

                'CANCELLED'

            )

        ),

    CONSTRAINT fk_shipments_farm
        FOREIGN KEY (farm_id)
        REFERENCES farms(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_shipments_order
        FOREIGN KEY (sales_order_id)
        REFERENCES sales_orders(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_shipments_carrier
        FOREIGN KEY (carrier_id)
        REFERENCES contacts(id)
        ON UPDATE CASCADE
        ON DELETE SET NULL,

    CONSTRAINT fk_shipments_shipped_by
        FOREIGN KEY (shipped_by)
        REFERENCES users(id)
        ON UPDATE CASCADE
        ON DELETE SET NULL

)

ENGINE=InnoDB

DEFAULT CHARSET=utf8mb4

COLLATE=utf8mb4_unicode_ci

COMMENT='Expedições de mercadorias.';


/******************************************************************************
    ÍNDICES
******************************************************************************/

CREATE INDEX idx_shipments_farm
ON shipments(farm_id);

CREATE INDEX idx_shipments_order
ON shipments(sales_order_id);

CREATE INDEX idx_shipments_carrier
ON shipments(carrier_id);

CREATE INDEX idx_shipments_date
ON shipments(shipment_date);

CREATE INDEX idx_shipments_expected_delivery
ON shipments(expected_delivery_date);

CREATE INDEX idx_shipments_tracking
ON shipments(tracking_code);

CREATE INDEX idx_shipments_status
ON shipments(status);

CREATE INDEX idx_shipments_shipped_by
ON shipments(shipped_by);


/******************************************************************************
*
*   TABELA: shipment_items
*
*   RESPONSABILIDADE
*
*   Armazena os itens das expedições de mercadorias.
*
******************************************************************************/

CREATE TABLE shipment_items (

    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    uuid CHAR(36) NOT NULL DEFAULT (UUID()),

    shipment_id BIGINT UNSIGNED NOT NULL,

    sales_order_item_id BIGINT UNSIGNED NOT NULL,

    warehouse_id BIGINT UNSIGNED NOT NULL,

    product_id BIGINT UNSIGNED NOT NULL,

    unit_id BIGINT UNSIGNED NOT NULL,

    sequence_number SMALLINT UNSIGNED NOT NULL,

    picked_quantity DECIMAL(18,4) NOT NULL DEFAULT 0,

    loaded_quantity DECIMAL(18,4) NOT NULL DEFAULT 0,

    shipped_quantity DECIMAL(18,4) NOT NULL,

    unit_price DECIMAL(18,6) NOT NULL,

    total_amount DECIMAL(18,2) NOT NULL,

    batch_number VARCHAR(50) NULL,

    storage_location VARCHAR(100) NULL,

    observations TEXT NULL,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    created_by BIGINT UNSIGNED NULL,

    updated_by BIGINT UNSIGNED NULL,

    CONSTRAINT uq_shipment_items_uuid
        UNIQUE (uuid),

    CONSTRAINT uq_shipment_item_sequence
        UNIQUE (
            shipment_id,
            sequence_number
        ),

    CONSTRAINT chk_shipment_item_picked
        CHECK (
            picked_quantity >= 0
        ),

    CONSTRAINT chk_shipment_item_loaded
        CHECK (
            loaded_quantity >= 0
        ),

    CONSTRAINT chk_shipment_item_shipped
        CHECK (
            shipped_quantity > 0
        ),

    CONSTRAINT chk_shipment_item_pick_logic
        CHECK (
            picked_quantity >= loaded_quantity
        ),

    CONSTRAINT chk_shipment_item_load_logic
        CHECK (
            loaded_quantity >= shipped_quantity
        ),

    CONSTRAINT chk_shipment_item_price
        CHECK (
            unit_price >= 0
        ),

    CONSTRAINT chk_shipment_item_total
        CHECK (
            total_amount >= 0
        ),

    CONSTRAINT fk_shipment_items_shipment
        FOREIGN KEY (shipment_id)
        REFERENCES shipments(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_shipment_items_order_item
        FOREIGN KEY (sales_order_item_id)
        REFERENCES sales_order_items(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_shipment_items_warehouse
        FOREIGN KEY (warehouse_id)
        REFERENCES warehouses(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_shipment_items_product
        FOREIGN KEY (product_id)
        REFERENCES products(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_shipment_items_unit
        FOREIGN KEY (unit_id)
        REFERENCES product_units(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT

)

ENGINE=InnoDB

DEFAULT CHARSET=utf8mb4

COLLATE=utf8mb4_unicode_ci

COMMENT='Itens das expedições.';


/******************************************************************************
    ÍNDICES
******************************************************************************/

CREATE INDEX idx_shipment_items_shipment
ON shipment_items(shipment_id);

CREATE INDEX idx_shipment_items_order_item
ON shipment_items(sales_order_item_id);

CREATE INDEX idx_shipment_items_product
ON shipment_items(product_id);

CREATE INDEX idx_shipment_items_warehouse
ON shipment_items(warehouse_id);

CREATE INDEX idx_shipment_items_batch
ON shipment_items(batch_number);

CREATE INDEX idx_shipment_items_location
ON shipment_items(storage_location);

CREATE INDEX idx_shipment_items_sequence
ON shipment_items(sequence_number);


/******************************************************************************
*
*   TABELA: sales_invoices
*
*   RESPONSABILIDADE
*
*   Armazena as notas fiscais de saída emitidas aos clientes.
*
******************************************************************************/

CREATE TABLE sales_invoices (

    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    uuid CHAR(36) NOT NULL DEFAULT (UUID()),

    farm_id BIGINT UNSIGNED NOT NULL,

    sales_order_id BIGINT UNSIGNED NOT NULL,

    shipment_id BIGINT UNSIGNED NULL,

    customer_id BIGINT UNSIGNED NOT NULL,

    invoice_number VARCHAR(20) NOT NULL,

    invoice_series VARCHAR(10) NOT NULL,

    invoice_key CHAR(44) NULL,

    invoice_date DATETIME NOT NULL,

    operation_type VARCHAR(30) NOT NULL DEFAULT 'SALE',

    payment_method_id BIGINT UNSIGNED NULL,

    total_products DECIMAL(18,2) NOT NULL DEFAULT 0,

    total_discount DECIMAL(18,2) NOT NULL DEFAULT 0,

    total_freight DECIMAL(18,2) NOT NULL DEFAULT 0,

    total_taxes DECIMAL(18,2) NOT NULL DEFAULT 0,

    total_invoice DECIMAL(18,2) NOT NULL DEFAULT 0,

    status VARCHAR(20) NOT NULL DEFAULT 'DRAFT',

    observations TEXT NULL,

    authorized_at DATETIME NULL,

    cancelled_at DATETIME NULL,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    deleted_at TIMESTAMP NULL DEFAULT NULL,

    created_by BIGINT UNSIGNED NULL,

    updated_by BIGINT UNSIGNED NULL,

    deleted_by BIGINT UNSIGNED NULL,

    CONSTRAINT uq_sales_invoices_uuid
        UNIQUE (uuid),

    CONSTRAINT uq_sales_invoice_number
        UNIQUE (
            farm_id,
            invoice_series,
            invoice_number
        ),

    CONSTRAINT uq_sales_invoice_key
        UNIQUE (
            invoice_key
        ),

    CONSTRAINT chk_sales_invoice_number
        CHECK (
            TRIM(invoice_number) <> ''
        ),

    CONSTRAINT chk_sales_invoice_series
        CHECK (
            TRIM(invoice_series) <> ''
        ),

    CONSTRAINT chk_sales_invoice_products
        CHECK (
            total_products >= 0
        ),

    CONSTRAINT chk_sales_invoice_discount
        CHECK (
            total_discount >= 0
        ),

    CONSTRAINT chk_sales_invoice_freight
        CHECK (
            total_freight >= 0
        ),

    CONSTRAINT chk_sales_invoice_taxes
        CHECK (
            total_taxes >= 0
        ),

    CONSTRAINT chk_sales_invoice_total
        CHECK (
            total_invoice >= 0
        ),

    CONSTRAINT chk_sales_invoice_status
        CHECK (

            status IN (

                'DRAFT',

                'AUTHORIZED',

                'DENIED',

                'CANCELLED'

            )

        ),

    CONSTRAINT fk_sales_invoices_farm
        FOREIGN KEY (farm_id)
        REFERENCES farms(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_sales_invoices_order
        FOREIGN KEY (sales_order_id)
        REFERENCES sales_orders(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_sales_invoices_shipment
        FOREIGN KEY (shipment_id)
        REFERENCES shipments(id)
        ON UPDATE CASCADE
        ON DELETE SET NULL,

    CONSTRAINT fk_sales_invoices_customer
        FOREIGN KEY (customer_id)
        REFERENCES contacts(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_sales_invoices_payment_method
        FOREIGN KEY (payment_method_id)
        REFERENCES payment_methods(id)
        ON UPDATE CASCADE
        ON DELETE SET NULL

)

ENGINE=InnoDB

DEFAULT CHARSET=utf8mb4

COLLATE=utf8mb4_unicode_ci

COMMENT='Notas fiscais de saída.';


/******************************************************************************
    ÍNDICES
******************************************************************************/

CREATE INDEX idx_sales_invoices_farm
ON sales_invoices(farm_id);

CREATE INDEX idx_sales_invoices_order
ON sales_invoices(sales_order_id);

CREATE INDEX idx_sales_invoices_shipment
ON sales_invoices(shipment_id);

CREATE INDEX idx_sales_invoices_customer
ON sales_invoices(customer_id);

CREATE INDEX idx_sales_invoices_date
ON sales_invoices(invoice_date);

CREATE INDEX idx_sales_invoices_status
ON sales_invoices(status);

CREATE INDEX idx_sales_invoices_key
ON sales_invoices(invoice_key);


/******************************************************************************
*
*   TABELA: sales_invoice_items
*
*   RESPONSABILIDADE
*
*   Armazena os itens das notas fiscais de saída.
*
******************************************************************************/

CREATE TABLE sales_invoice_items (

    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    uuid CHAR(36) NOT NULL DEFAULT (UUID()),

    sales_invoice_id BIGINT UNSIGNED NOT NULL,

    sales_order_item_id BIGINT UNSIGNED NOT NULL,

    shipment_item_id BIGINT UNSIGNED NULL,

    product_id BIGINT UNSIGNED NOT NULL,

    warehouse_id BIGINT UNSIGNED NOT NULL,

    unit_id BIGINT UNSIGNED NOT NULL,

    cost_center_id BIGINT UNSIGNED NULL,

    account_id BIGINT UNSIGNED NULL,

    sequence_number SMALLINT UNSIGNED NOT NULL,

    invoiced_quantity DECIMAL(18,4) NOT NULL,

    unit_price DECIMAL(18,6) NOT NULL,

    discount_amount DECIMAL(18,2) NOT NULL DEFAULT 0,

    freight_amount DECIMAL(18,2) NOT NULL DEFAULT 0,

    tax_amount DECIMAL(18,2) NOT NULL DEFAULT 0,

    total_amount DECIMAL(18,2) NOT NULL,

    cfop VARCHAR(4) NULL,

    ncm VARCHAR(8) NULL,

    cest VARCHAR(7) NULL,

    observations TEXT NULL,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    created_by BIGINT UNSIGNED NULL,

    updated_by BIGINT UNSIGNED NULL,

    CONSTRAINT uq_sales_invoice_items_uuid
        UNIQUE (uuid),

    CONSTRAINT uq_sales_invoice_item_sequence
        UNIQUE (
            sales_invoice_id,
            sequence_number
        ),

    CONSTRAINT chk_sales_invoice_item_quantity
        CHECK (
            invoiced_quantity > 0
        ),

    CONSTRAINT chk_sales_invoice_item_price
        CHECK (
            unit_price >= 0
        ),

    CONSTRAINT chk_sales_invoice_item_discount
        CHECK (
            discount_amount >= 0
        ),

    CONSTRAINT chk_sales_invoice_item_freight
        CHECK (
            freight_amount >= 0
        ),

    CONSTRAINT chk_sales_invoice_item_tax
        CHECK (
            tax_amount >= 0
        ),

    CONSTRAINT chk_sales_invoice_item_total
        CHECK (
            total_amount >= 0
        ),

    CONSTRAINT fk_sales_invoice_items_invoice
        FOREIGN KEY (sales_invoice_id)
        REFERENCES sales_invoices(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_sales_invoice_items_order_item
        FOREIGN KEY (sales_order_item_id)
        REFERENCES sales_order_items(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_sales_invoice_items_shipment_item
        FOREIGN KEY (shipment_item_id)
        REFERENCES shipment_items(id)
        ON UPDATE CASCADE
        ON DELETE SET NULL,

    CONSTRAINT fk_sales_invoice_items_product
        FOREIGN KEY (product_id)
        REFERENCES products(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_sales_invoice_items_warehouse
        FOREIGN KEY (warehouse_id)
        REFERENCES warehouses(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_sales_invoice_items_unit
        FOREIGN KEY (unit_id)
        REFERENCES product_units(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_sales_invoice_items_cost_center
        FOREIGN KEY (cost_center_id)
        REFERENCES cost_centers(id)
        ON UPDATE CASCADE
        ON DELETE SET NULL,

    CONSTRAINT fk_sales_invoice_items_account
        FOREIGN KEY (account_id)
        REFERENCES accounts(id)
        ON UPDATE CASCADE
        ON DELETE SET NULL

)

ENGINE=InnoDB

DEFAULT CHARSET=utf8mb4

COLLATE=utf8mb4_unicode_ci

COMMENT='Itens das notas fiscais de saída.';


/******************************************************************************
    ÍNDICES
******************************************************************************/

CREATE INDEX idx_sales_invoice_items_invoice
ON sales_invoice_items(sales_invoice_id);

CREATE INDEX idx_sales_invoice_items_order_item
ON sales_invoice_items(sales_order_item_id);

CREATE INDEX idx_sales_invoice_items_shipment_item
ON sales_invoice_items(shipment_item_id);

CREATE INDEX idx_sales_invoice_items_product
ON sales_invoice_items(product_id);

CREATE INDEX idx_sales_invoice_items_warehouse
ON sales_invoice_items(warehouse_id);

CREATE INDEX idx_sales_invoice_items_unit
ON sales_invoice_items(unit_id);

CREATE INDEX idx_sales_invoice_items_cost_center
ON sales_invoice_items(cost_center_id);

CREATE INDEX idx_sales_invoice_items_account
ON sales_invoice_items(account_id);

CREATE INDEX idx_sales_invoice_items_cfop
ON sales_invoice_items(cfop);

CREATE INDEX idx_sales_invoice_items_ncm
ON sales_invoice_items(ncm);

CREATE INDEX idx_sales_invoice_items_sequence
ON sales_invoice_items(sequence_number);


/******************************************************************************
*
*   TABELA: sales_returns
*
*   RESPONSABILIDADE
*
*   Armazena as devoluções de vendas realizadas pelos clientes.
*
******************************************************************************/

CREATE TABLE sales_returns (

    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    uuid CHAR(36) NOT NULL DEFAULT (UUID()),

    farm_id BIGINT UNSIGNED NOT NULL,

    sales_invoice_id BIGINT UNSIGNED NOT NULL,

    customer_id BIGINT UNSIGNED NOT NULL,

    return_number VARCHAR(30) NOT NULL,

    return_date DATETIME NOT NULL,

    return_reason_id BIGINT UNSIGNED NULL,

    total_amount DECIMAL(18,2) NOT NULL DEFAULT 0,

    status VARCHAR(20) NOT NULL DEFAULT 'OPEN',

    observations TEXT NULL,

    approved_at DATETIME NULL,

    approved_by BIGINT UNSIGNED NULL,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    deleted_at TIMESTAMP NULL DEFAULT NULL,

    created_by BIGINT UNSIGNED NULL,

    updated_by BIGINT UNSIGNED NULL,

    deleted_by BIGINT UNSIGNED NULL,

    CONSTRAINT uq_sales_returns_uuid
        UNIQUE (uuid),

    CONSTRAINT uq_sales_return_number
        UNIQUE (
            farm_id,
            return_number
        ),

    CONSTRAINT chk_sales_return_total
        CHECK (
            total_amount >= 0
        ),

    CONSTRAINT chk_sales_return_status
        CHECK (

            status IN (

                'OPEN',

                'APPROVED',

                'REJECTED',

                'RECEIVED',

                'CANCELLED',

                'CLOSED'

            )

        ),

    CONSTRAINT fk_sales_returns_farm
        FOREIGN KEY (farm_id)
        REFERENCES farms(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_sales_returns_invoice
        FOREIGN KEY (sales_invoice_id)
        REFERENCES sales_invoices(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_sales_returns_customer
        FOREIGN KEY (customer_id)
        REFERENCES contacts(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_sales_returns_reason
        FOREIGN KEY (return_reason_id)
        REFERENCES return_reasons(id)
        ON UPDATE CASCADE
        ON DELETE SET NULL,

    CONSTRAINT fk_sales_returns_approved_by
        FOREIGN KEY (approved_by)
        REFERENCES users(id)
        ON UPDATE CASCADE
        ON DELETE SET NULL

)

ENGINE=InnoDB

DEFAULT CHARSET=utf8mb4

COLLATE=utf8mb4_unicode_ci

COMMENT='Cabeçalho das devoluções de vendas.';


/******************************************************************************
    ÍNDICES
******************************************************************************/

CREATE INDEX idx_sales_returns_farm
ON sales_returns(farm_id);

CREATE INDEX idx_sales_returns_invoice
ON sales_returns(sales_invoice_id);

CREATE INDEX idx_sales_returns_customer
ON sales_returns(customer_id);

CREATE INDEX idx_sales_returns_date
ON sales_returns(return_date);

CREATE INDEX idx_sales_returns_status
ON sales_returns(status);

CREATE INDEX idx_sales_returns_reason
ON sales_returns(return_reason_id);


