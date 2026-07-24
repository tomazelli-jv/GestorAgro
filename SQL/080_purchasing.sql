/******************************************************************************
*
*   TABELA: purchase_requests
*
*   RESPONSABILIDADE
*
*   Armazena as solicitações de compra.
*
******************************************************************************/

CREATE TABLE purchase_requests (

    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    uuid CHAR(36) NOT NULL DEFAULT (UUID()),

    farm_id BIGINT UNSIGNED NOT NULL,

    request_number VARCHAR(30) NOT NULL,

    requester_id BIGINT UNSIGNED NOT NULL,

    request_date DATE NOT NULL,

    needed_date DATE NULL,

    priority VARCHAR(20) NOT NULL DEFAULT 'NORMAL',

    status VARCHAR(20) NOT NULL DEFAULT 'OPEN',

    observations TEXT NULL,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    deleted_at TIMESTAMP NULL DEFAULT NULL,

    created_by BIGINT UNSIGNED NULL,

    updated_by BIGINT UNSIGNED NULL,

    deleted_by BIGINT UNSIGNED NULL,

    CONSTRAINT uq_purchase_requests_uuid
        UNIQUE (uuid),

    CONSTRAINT uq_purchase_request_number
        UNIQUE (
            farm_id,
            request_number
        ),

    CONSTRAINT chk_purchase_request_number
        CHECK (
            TRIM(request_number) <> ''
        ),

    CONSTRAINT chk_purchase_request_priority
        CHECK (

            priority IN (

                'LOW',

                'NORMAL',

                'HIGH',

                'URGENT'

            )

        ),

    CONSTRAINT chk_purchase_request_status
        CHECK (

            status IN (

                'OPEN',

                'APPROVED',

                'REJECTED',

                'PARTIALLY_ORDERED',

                'ORDERED',

                'CANCELLED'

            )

        ),

    CONSTRAINT fk_purchase_requests_farm
        FOREIGN KEY (farm_id)
        REFERENCES farms(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_purchase_requests_requester
        FOREIGN KEY (requester_id)
        REFERENCES users(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT

)

ENGINE=InnoDB

DEFAULT CHARSET=utf8mb4

COLLATE=utf8mb4_unicode_ci

COMMENT='Solicitações de compra.';


/******************************************************************************
    ÍNDICES
******************************************************************************/

CREATE INDEX idx_purchase_requests_farm
ON purchase_requests(farm_id);

CREATE INDEX idx_purchase_requests_requester
ON purchase_requests(requester_id);

CREATE INDEX idx_purchase_requests_date
ON purchase_requests(request_date);

CREATE INDEX idx_purchase_requests_needed
ON purchase_requests(needed_date);

CREATE INDEX idx_purchase_requests_priority
ON purchase_requests(priority);

CREATE INDEX idx_purchase_requests_status
ON purchase_requests(status);


/******************************************************************************
    ÍNDICES
******************************************************************************/

CREATE INDEX idx_purchase_request_items_request
ON purchase_request_items(purchase_request_id);

CREATE INDEX idx_purchase_request_items_product
ON purchase_request_items(product_id);

CREATE INDEX idx_purchase_request_items_unit
ON purchase_request_items(unit_id);

CREATE INDEX idx_purchase_request_items_cost_center
ON purchase_request_items(cost_center_id);

CREATE INDEX idx_purchase_request_items_sequence
ON purchase_request_items(sequence_number);


/******************************************************************************
*
*   TABELA: supplier_quotations
*
*   RESPONSABILIDADE
*
*   Armazena as cotações recebidas dos fornecedores.
*
******************************************************************************/

CREATE TABLE supplier_quotations (

    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    uuid CHAR(36) NOT NULL DEFAULT (UUID()),

    farm_id BIGINT UNSIGNED NOT NULL,

    purchase_request_id BIGINT UNSIGNED NOT NULL,

    supplier_id BIGINT UNSIGNED NOT NULL,

    quotation_number VARCHAR(30) NOT NULL,

    quotation_date DATE NOT NULL,

    valid_until DATE NULL,

    payment_method_id BIGINT UNSIGNED NULL,

    delivery_deadline DATE NULL,

    total_amount DECIMAL(18,2) NOT NULL DEFAULT 0,

    status VARCHAR(20) NOT NULL DEFAULT 'PENDING',

    observations TEXT NULL,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    deleted_at TIMESTAMP NULL DEFAULT NULL,

    created_by BIGINT UNSIGNED NULL,

    updated_by BIGINT UNSIGNED NULL,

    deleted_by BIGINT UNSIGNED NULL,

    CONSTRAINT uq_supplier_quotations_uuid
        UNIQUE (uuid),

    CONSTRAINT uq_supplier_quotation_number
        UNIQUE (
            farm_id,
            quotation_number
        ),

    CONSTRAINT chk_supplier_quotation_number
        CHECK (TRIM(quotation_number) <> ''),

    CONSTRAINT chk_supplier_quotation_amount
        CHECK (total_amount >= 0),

    CONSTRAINT chk_supplier_quotation_dates
        CHECK (
            valid_until IS NULL
            OR valid_until >= quotation_date
        ),

    CONSTRAINT chk_supplier_quotation_delivery
        CHECK (
            delivery_deadline IS NULL
            OR delivery_deadline >= quotation_date
        ),

    CONSTRAINT chk_supplier_quotation_status
        CHECK (

            status IN (

                'PENDING',

                'RECEIVED',

                'SELECTED',

                'REJECTED',

                'EXPIRED',

                'CANCELLED'

            )

        ),

    CONSTRAINT fk_supplier_quotations_farm
        FOREIGN KEY (farm_id)
        REFERENCES farms(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_supplier_quotations_request
        FOREIGN KEY (purchase_request_id)
        REFERENCES purchase_requests(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_supplier_quotations_supplier
        FOREIGN KEY (supplier_id)
        REFERENCES contacts(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_supplier_quotations_payment_method
        FOREIGN KEY (payment_method_id)
        REFERENCES payment_methods(id)
        ON UPDATE CASCADE
        ON DELETE SET NULL

)

ENGINE=InnoDB

DEFAULT CHARSET=utf8mb4

COLLATE=utf8mb4_unicode_ci

COMMENT='Cotações de fornecedores.';


/******************************************************************************
    ÍNDICES
******************************************************************************/

CREATE INDEX idx_supplier_quotations_farm
ON supplier_quotations(farm_id);

CREATE INDEX idx_supplier_quotations_request
ON supplier_quotations(purchase_request_id);

CREATE INDEX idx_supplier_quotations_supplier
ON supplier_quotations(supplier_id);

CREATE INDEX idx_supplier_quotations_date
ON supplier_quotations(quotation_date);

CREATE INDEX idx_supplier_quotations_valid_until
ON supplier_quotations(valid_until);

CREATE INDEX idx_supplier_quotations_status
ON supplier_quotations(status);


/******************************************************************************
*
*   TABELA: supplier_quotation_items
*
*   RESPONSABILIDADE
*
*   Armazena os itens das cotações dos fornecedores.
*
******************************************************************************/

CREATE TABLE supplier_quotation_items (

    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    uuid CHAR(36) NOT NULL DEFAULT (UUID()),

    supplier_quotation_id BIGINT UNSIGNED NOT NULL,

    purchase_request_item_id BIGINT UNSIGNED NOT NULL,

    sequence_number SMALLINT UNSIGNED NOT NULL,

    quoted_quantity DECIMAL(18,4) NOT NULL,

    unit_price DECIMAL(18,6) NOT NULL,

    discount_amount DECIMAL(18,2) NOT NULL DEFAULT 0,

    tax_amount DECIMAL(18,2) NOT NULL DEFAULT 0,

    freight_amount DECIMAL(18,2) NOT NULL DEFAULT 0,

    delivery_days SMALLINT UNSIGNED NULL,

    is_selected BOOLEAN NOT NULL DEFAULT FALSE,

    observations TEXT NULL,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    created_by BIGINT UNSIGNED NULL,

    updated_by BIGINT UNSIGNED NULL,

    CONSTRAINT uq_supplier_quotation_items_uuid
        UNIQUE (uuid),

    CONSTRAINT uq_supplier_quotation_item_sequence
        UNIQUE (
            supplier_quotation_id,
            sequence_number
        ),

    CONSTRAINT uq_supplier_quotation_request_item
        UNIQUE (
            supplier_quotation_id,
            purchase_request_item_id
        ),

    CONSTRAINT chk_supplier_quotation_quantity
        CHECK (quoted_quantity > 0),

    CONSTRAINT chk_supplier_quotation_unit_price
        CHECK (unit_price >= 0),

    CONSTRAINT chk_supplier_quotation_discount
        CHECK (discount_amount >= 0),

    CONSTRAINT chk_supplier_quotation_tax
        CHECK (tax_amount >= 0),

    CONSTRAINT chk_supplier_quotation_freight
        CHECK (freight_amount >= 0),

    CONSTRAINT chk_supplier_quotation_delivery_days
        CHECK (
            delivery_days IS NULL
            OR delivery_days >= 0
        ),

    CONSTRAINT fk_supplier_quotation_items_quotation
        FOREIGN KEY (supplier_quotation_id)
        REFERENCES supplier_quotations(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_supplier_quotation_items_request_item
        FOREIGN KEY (purchase_request_item_id)
        REFERENCES purchase_request_items(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT

)

ENGINE=InnoDB

DEFAULT CHARSET=utf8mb4

COLLATE=utf8mb4_unicode_ci

COMMENT='Itens das cotações de fornecedores.';


/******************************************************************************
    ÍNDICES
******************************************************************************/

CREATE INDEX idx_supplier_quotation_items_quotation
ON supplier_quotation_items(supplier_quotation_id);

CREATE INDEX idx_supplier_quotation_items_request_item
ON supplier_quotation_items(purchase_request_item_id);

CREATE INDEX idx_supplier_quotation_items_selected
ON supplier_quotation_items(is_selected);

CREATE INDEX idx_supplier_quotation_items_delivery
ON supplier_quotation_items(delivery_days);

CREATE INDEX idx_supplier_quotation_items_sequence
ON supplier_quotation_items(sequence_number);


/******************************************************************************
*
*   TABELA: purchase_orders
*
*   RESPONSABILIDADE
*
*   Armazena os pedidos de compra emitidos para os fornecedores.
*
******************************************************************************/

CREATE TABLE purchase_orders (

    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    uuid CHAR(36) NOT NULL DEFAULT (UUID()),

    farm_id BIGINT UNSIGNED NOT NULL,

    supplier_quotation_id BIGINT UNSIGNED NULL,

    supplier_id BIGINT UNSIGNED NOT NULL,

    order_number VARCHAR(30) NOT NULL,

    order_date DATE NOT NULL,

    expected_delivery_date DATE NULL,

    payment_method_id BIGINT UNSIGNED NULL,

    total_amount DECIMAL(18,2) NOT NULL DEFAULT 0,

    freight_amount DECIMAL(18,2) NOT NULL DEFAULT 0,

    discount_amount DECIMAL(18,2) NOT NULL DEFAULT 0,

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

    CONSTRAINT uq_purchase_orders_uuid
        UNIQUE (uuid),

    CONSTRAINT uq_purchase_order_number
        UNIQUE (
            farm_id,
            order_number
        ),

    CONSTRAINT chk_purchase_order_number
        CHECK (TRIM(order_number) <> ''),

    CONSTRAINT chk_purchase_order_total
        CHECK (total_amount >= 0),

    CONSTRAINT chk_purchase_order_freight
        CHECK (freight_amount >= 0),

    CONSTRAINT chk_purchase_order_discount
        CHECK (discount_amount >= 0),

    CONSTRAINT chk_purchase_order_dates
        CHECK (
            expected_delivery_date IS NULL
            OR expected_delivery_date >= order_date
        ),

    CONSTRAINT chk_purchase_order_status
        CHECK (

            status IN (

                'OPEN',

                'APPROVED',

                'PARTIALLY_RECEIVED',

                'RECEIVED',

                'CANCELLED',

                'CLOSED'

            )

        ),

    CONSTRAINT fk_purchase_orders_farm
        FOREIGN KEY (farm_id)
        REFERENCES farms(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_purchase_orders_supplier
        FOREIGN KEY (supplier_id)
        REFERENCES contacts(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_purchase_orders_quotation
        FOREIGN KEY (supplier_quotation_id)
        REFERENCES supplier_quotations(id)
        ON UPDATE CASCADE
        ON DELETE SET NULL,

    CONSTRAINT fk_purchase_orders_payment_method
        FOREIGN KEY (payment_method_id)
        REFERENCES payment_methods(id)
        ON UPDATE CASCADE
        ON DELETE SET NULL,

    CONSTRAINT fk_purchase_orders_approved_by
        FOREIGN KEY (approved_by)
        REFERENCES users(id)
        ON UPDATE CASCADE
        ON DELETE SET NULL

)

ENGINE=InnoDB

DEFAULT CHARSET=utf8mb4

COLLATE=utf8mb4_unicode_ci

COMMENT='Pedidos de compra.';


/******************************************************************************
    ÍNDICES
******************************************************************************/

CREATE INDEX idx_purchase_orders_farm
ON purchase_orders(farm_id);

CREATE INDEX idx_purchase_orders_supplier
ON purchase_orders(supplier_id);

CREATE INDEX idx_purchase_orders_quotation
ON purchase_orders(supplier_quotation_id);

CREATE INDEX idx_purchase_orders_order_date
ON purchase_orders(order_date);

CREATE INDEX idx_purchase_orders_expected_delivery
ON purchase_orders(expected_delivery_date);

CREATE INDEX idx_purchase_orders_status
ON purchase_orders(status);

CREATE INDEX idx_purchase_orders_approved_by
ON purchase_orders(approved_by);


/******************************************************************************
*
*   TABELA: purchase_order_items
*
*   RESPONSABILIDADE
*
*   Armazena os itens dos pedidos de compra.
*
******************************************************************************/

CREATE TABLE purchase_order_items (

    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    uuid CHAR(36) NOT NULL DEFAULT (UUID()),

    purchase_order_id BIGINT UNSIGNED NOT NULL,

    supplier_quotation_item_id BIGINT UNSIGNED NULL,

    product_id BIGINT UNSIGNED NOT NULL,

    unit_id BIGINT UNSIGNED NOT NULL,

    cost_center_id BIGINT UNSIGNED NOT NULL,

    account_id BIGINT UNSIGNED NULL,

    sequence_number SMALLINT UNSIGNED NOT NULL,

    ordered_quantity DECIMAL(18,4) NOT NULL,

    received_quantity DECIMAL(18,4) NOT NULL DEFAULT 0,

    unit_price DECIMAL(18,6) NOT NULL,

    discount_amount DECIMAL(18,2) NOT NULL DEFAULT 0,

    tax_amount DECIMAL(18,2) NOT NULL DEFAULT 0,

    freight_amount DECIMAL(18,2) NOT NULL DEFAULT 0,

    total_amount DECIMAL(18,2) NOT NULL,

    status VARCHAR(20) NOT NULL DEFAULT 'OPEN',

    observations TEXT NULL,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    created_by BIGINT UNSIGNED NULL,

    updated_by BIGINT UNSIGNED NULL,

    CONSTRAINT uq_purchase_order_items_uuid
        UNIQUE (uuid),

    CONSTRAINT uq_purchase_order_item_sequence
        UNIQUE (
            purchase_order_id,
            sequence_number
        ),

    CONSTRAINT chk_purchase_order_ordered
        CHECK (ordered_quantity > 0),

    CONSTRAINT chk_purchase_order_received
        CHECK (
            received_quantity >= 0
            AND
            received_quantity <= ordered_quantity
        ),

    CONSTRAINT chk_purchase_order_unit_price
        CHECK (unit_price >= 0),

    CONSTRAINT chk_purchase_order_discount
        CHECK (discount_amount >= 0),

    CONSTRAINT chk_purchase_order_tax
        CHECK (tax_amount >= 0),

    CONSTRAINT chk_purchase_order_freight
        CHECK (freight_amount >= 0),

    CONSTRAINT chk_purchase_order_total
        CHECK (total_amount >= 0),

    CONSTRAINT chk_purchase_order_status
        CHECK (

            status IN (

                'OPEN',

                'PARTIALLY_RECEIVED',

                'RECEIVED',

                'CANCELLED'

            )

        ),

    CONSTRAINT fk_purchase_order_items_order
        FOREIGN KEY (purchase_order_id)
        REFERENCES purchase_orders(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_purchase_order_items_quotation_item
        FOREIGN KEY (supplier_quotation_item_id)
        REFERENCES supplier_quotation_items(id)
        ON UPDATE CASCADE
        ON DELETE SET NULL,

    CONSTRAINT fk_purchase_order_items_product
        FOREIGN KEY (product_id)
        REFERENCES products(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_purchase_order_items_unit
        FOREIGN KEY (unit_id)
        REFERENCES product_units(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_purchase_order_items_cost_center
        FOREIGN KEY (cost_center_id)
        REFERENCES cost_centers(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_purchase_order_items_account
        FOREIGN KEY (account_id)
        REFERENCES accounts(id)
        ON UPDATE CASCADE
        ON DELETE SET NULL

)

ENGINE=InnoDB

DEFAULT CHARSET=utf8mb4

COLLATE=utf8mb4_unicode_ci

COMMENT='Itens dos pedidos de compra.';


/******************************************************************************
    ÍNDICES
******************************************************************************/

CREATE INDEX idx_purchase_order_items_order
ON purchase_order_items(purchase_order_id);

CREATE INDEX idx_purchase_order_items_product
ON purchase_order_items(product_id);

CREATE INDEX idx_purchase_order_items_unit
ON purchase_order_items(unit_id);

CREATE INDEX idx_purchase_order_items_cost_center
ON purchase_order_items(cost_center_id);

CREATE INDEX idx_purchase_order_items_account
ON purchase_order_items(account_id);

CREATE INDEX idx_purchase_order_items_status
ON purchase_order_items(status);

CREATE INDEX idx_purchase_order_items_sequence
ON purchase_order_items(sequence_number);


/******************************************************************************
*
*   TABELA: purchase_receipts
*
*   RESPONSABILIDADE
*
*   Armazena os recebimentos de mercadorias provenientes dos pedidos de compra.
*
******************************************************************************/

CREATE TABLE purchase_receipts (

    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    uuid CHAR(36) NOT NULL DEFAULT (UUID()),

    farm_id BIGINT UNSIGNED NOT NULL,

    purchase_order_id BIGINT UNSIGNED NOT NULL,

    receipt_number VARCHAR(30) NOT NULL,

    receipt_date DATETIME NOT NULL,

    supplier_invoice_number VARCHAR(50) NULL,

    supplier_invoice_series VARCHAR(10) NULL,

    supplier_invoice_key CHAR(44) NULL,

    supplier_invoice_date DATE NULL,

    total_amount DECIMAL(18,2) NOT NULL DEFAULT 0,

    status VARCHAR(20) NOT NULL DEFAULT 'OPEN',

    observations TEXT NULL,

    received_by BIGINT UNSIGNED NULL,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    deleted_at TIMESTAMP NULL DEFAULT NULL,

    created_by BIGINT UNSIGNED NULL,

    updated_by BIGINT UNSIGNED NULL,

    deleted_by BIGINT UNSIGNED NULL,

    CONSTRAINT uq_purchase_receipts_uuid
        UNIQUE (uuid),

    CONSTRAINT uq_purchase_receipt_number
        UNIQUE (
            farm_id,
            receipt_number
        ),

    CONSTRAINT uq_purchase_receipt_invoice
        UNIQUE (
            farm_id,
            supplier_invoice_key
        ),

    CONSTRAINT chk_purchase_receipt_number
        CHECK (
            TRIM(receipt_number) <> ''
        ),

    CONSTRAINT chk_purchase_receipt_total
        CHECK (
            total_amount >= 0
        ),

    CONSTRAINT chk_purchase_receipt_status
        CHECK (

            status IN (

                'OPEN',

                'CONFERRED',

                'POSTED',

                'CANCELLED'

            )

        ),

    CONSTRAINT fk_purchase_receipts_farm
        FOREIGN KEY (farm_id)
        REFERENCES farms(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_purchase_receipts_order
        FOREIGN KEY (purchase_order_id)
        REFERENCES purchase_orders(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_purchase_receipts_received_by
        FOREIGN KEY (received_by)
        REFERENCES users(id)
        ON UPDATE CASCADE
        ON DELETE SET NULL

)

ENGINE=InnoDB

DEFAULT CHARSET=utf8mb4

COLLATE=utf8mb4_unicode_ci

COMMENT='Recebimentos de mercadorias.';


/******************************************************************************
    ÍNDICES
******************************************************************************/

CREATE INDEX idx_purchase_receipts_farm
ON purchase_receipts(farm_id);

CREATE INDEX idx_purchase_receipts_order
ON purchase_receipts(purchase_order_id);

CREATE INDEX idx_purchase_receipts_date
ON purchase_receipts(receipt_date);

CREATE INDEX idx_purchase_receipts_invoice
ON purchase_receipts(supplier_invoice_number);

CREATE INDEX idx_purchase_receipts_status
ON purchase_receipts(status);

CREATE INDEX idx_purchase_receipts_received_by
ON purchase_receipts(received_by);


/******************************************************************************
*
*   TABELA: purchase_receipt_items
*
*   RESPONSABILIDADE
*
*   Armazena os itens efetivamente recebidos das compras.
*
******************************************************************************/

CREATE TABLE purchase_receipt_items (

    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    uuid CHAR(36) NOT NULL DEFAULT (UUID()),

    purchase_receipt_id BIGINT UNSIGNED NOT NULL,

    purchase_order_item_id BIGINT UNSIGNED NOT NULL,

    warehouse_id BIGINT UNSIGNED NOT NULL,

    product_id BIGINT UNSIGNED NOT NULL,

    unit_id BIGINT UNSIGNED NOT NULL,

    sequence_number SMALLINT UNSIGNED NOT NULL,

    received_quantity DECIMAL(18,4) NOT NULL,

    accepted_quantity DECIMAL(18,4) NOT NULL,

    rejected_quantity DECIMAL(18,4) NOT NULL DEFAULT 0,

    unit_cost DECIMAL(18,6) NOT NULL,

    total_cost DECIMAL(18,2) NOT NULL,

    batch_number VARCHAR(50) NULL,

    manufacture_date DATE NULL,

    expiration_date DATE NULL,

    storage_location VARCHAR(100) NULL,

    observations TEXT NULL,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    created_by BIGINT UNSIGNED NULL,

    updated_by BIGINT UNSIGNED NULL,

    CONSTRAINT uq_purchase_receipt_items_uuid
        UNIQUE (uuid),

    CONSTRAINT uq_purchase_receipt_item_sequence
        UNIQUE (
            purchase_receipt_id,
            sequence_number
        ),

    CONSTRAINT chk_purchase_receipt_received
        CHECK (
            received_quantity > 0
        ),

    CONSTRAINT chk_purchase_receipt_accepted
        CHECK (
            accepted_quantity >= 0
        ),

    CONSTRAINT chk_purchase_receipt_rejected
        CHECK (
            rejected_quantity >= 0
        ),

    CONSTRAINT chk_purchase_receipt_quantities
        CHECK (
            accepted_quantity + rejected_quantity =
            received_quantity
        ),

    CONSTRAINT chk_purchase_receipt_cost
        CHECK (
            unit_cost >= 0
        ),

    CONSTRAINT chk_purchase_receipt_total
        CHECK (
            total_cost >= 0
        ),

    CONSTRAINT chk_purchase_receipt_expiration
        CHECK (
            expiration_date IS NULL
            OR manufacture_date IS NULL
            OR expiration_date >= manufacture_date
        ),

    CONSTRAINT fk_purchase_receipt_items_receipt
        FOREIGN KEY (purchase_receipt_id)
        REFERENCES purchase_receipts(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_purchase_receipt_items_order_item
        FOREIGN KEY (purchase_order_item_id)
        REFERENCES purchase_order_items(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_purchase_receipt_items_warehouse
        FOREIGN KEY (warehouse_id)
        REFERENCES warehouses(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_purchase_receipt_items_product
        FOREIGN KEY (product_id)
        REFERENCES products(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_purchase_receipt_items_unit
        FOREIGN KEY (unit_id)
        REFERENCES product_units(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT

)

ENGINE=InnoDB

DEFAULT CHARSET=utf8mb4

COLLATE=utf8mb4_unicode_ci

COMMENT='Itens dos recebimentos de compras.';


/******************************************************************************
    ÍNDICES
******************************************************************************/

CREATE INDEX idx_purchase_receipt_items_receipt
ON purchase_receipt_items(purchase_receipt_id);

CREATE INDEX idx_purchase_receipt_items_order_item
ON purchase_receipt_items(purchase_order_item_id);

CREATE INDEX idx_purchase_receipt_items_warehouse
ON purchase_receipt_items(warehouse_id);

CREATE INDEX idx_purchase_receipt_items_product
ON purchase_receipt_items(product_id);

CREATE INDEX idx_purchase_receipt_items_batch
ON purchase_receipt_items(batch_number);

CREATE INDEX idx_purchase_receipt_items_expiration
ON purchase_receipt_items(expiration_date);

CREATE INDEX idx_purchase_receipt_items_sequence
ON purchase_receipt_items(sequence_number);


/******************************************************************************
*
*   TABELA: purchase_contracts
*
*   RESPONSABILIDADE
*
*   Armazena os contratos de fornecimento firmados com fornecedores.
*
******************************************************************************/

CREATE TABLE purchase_contracts (

    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    uuid CHAR(36) NOT NULL DEFAULT (UUID()),

    farm_id BIGINT UNSIGNED NOT NULL,

    supplier_id BIGINT UNSIGNED NOT NULL,

    contract_number VARCHAR(50) NOT NULL,

    contract_name VARCHAR(150) NOT NULL,

    contract_date DATE NOT NULL,

    start_date DATE NOT NULL,

    end_date DATE NOT NULL,

    payment_method_id BIGINT UNSIGNED NULL,

    total_contract_value DECIMAL(18,2) NOT NULL DEFAULT 0,

    consumed_value DECIMAL(18,2) NOT NULL DEFAULT 0,

    remaining_value DECIMAL(18,2) NOT NULL DEFAULT 0,

    status VARCHAR(20) NOT NULL DEFAULT 'DRAFT',

    observations TEXT NULL,

    signed_at DATETIME NULL,

    signed_by BIGINT UNSIGNED NULL,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    deleted_at TIMESTAMP NULL DEFAULT NULL,

    created_by BIGINT UNSIGNED NULL,

    updated_by BIGINT UNSIGNED NULL,

    deleted_by BIGINT UNSIGNED NULL,

    CONSTRAINT uq_purchase_contracts_uuid
        UNIQUE (uuid),

    CONSTRAINT uq_purchase_contract_number
        UNIQUE (
            farm_id,
            contract_number
        ),

    CONSTRAINT chk_purchase_contract_number
        CHECK (
            TRIM(contract_number) <> ''
        ),

    CONSTRAINT chk_purchase_contract_name
        CHECK (
            TRIM(contract_name) <> ''
        ),

    CONSTRAINT chk_purchase_contract_dates
        CHECK (
            end_date >= start_date
        ),

    CONSTRAINT chk_purchase_contract_total
        CHECK (
            total_contract_value >= 0
        ),

    CONSTRAINT chk_purchase_contract_consumed
        CHECK (
            consumed_value >= 0
        ),

    CONSTRAINT chk_purchase_contract_remaining
        CHECK (
            remaining_value >= 0
        ),

    CONSTRAINT chk_purchase_contract_status
        CHECK (

            status IN (

                'DRAFT',

                'ACTIVE',

                'SUSPENDED',

                'FINISHED',

                'CANCELLED'

            )

        ),

    CONSTRAINT fk_purchase_contracts_farm
        FOREIGN KEY (farm_id)
        REFERENCES farms(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_purchase_contracts_supplier
        FOREIGN KEY (supplier_id)
        REFERENCES contacts(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_purchase_contracts_payment_method
        FOREIGN KEY (payment_method_id)
        REFERENCES payment_methods(id)
        ON UPDATE CASCADE
        ON DELETE SET NULL,

    CONSTRAINT fk_purchase_contracts_signed_by
        FOREIGN KEY (signed_by)
        REFERENCES users(id)
        ON UPDATE CASCADE
        ON DELETE SET NULL

)

ENGINE=InnoDB

DEFAULT CHARSET=utf8mb4

COLLATE=utf8mb4_unicode_ci

COMMENT='Contratos de fornecimento.';


/******************************************************************************
    ÍNDICES
******************************************************************************/

CREATE INDEX idx_purchase_contracts_farm
ON purchase_contracts(farm_id);

CREATE INDEX idx_purchase_contracts_supplier
ON purchase_contracts(supplier_id);

CREATE INDEX idx_purchase_contracts_start
ON purchase_contracts(start_date);

CREATE INDEX idx_purchase_contracts_end
ON purchase_contracts(end_date);

CREATE INDEX idx_purchase_contracts_status
ON purchase_contracts(status);

CREATE INDEX idx_purchase_contracts_signed
ON purchase_contracts(signed_by);


/******************************************************************************
*
*   TABELA: purchase_contract_items
*
*   RESPONSABILIDADE
*
*   Armazena os produtos e serviços previstos nos contratos de fornecimento.
*
******************************************************************************/

CREATE TABLE purchase_contract_items (

    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    uuid CHAR(36) NOT NULL DEFAULT (UUID()),

    purchase_contract_id BIGINT UNSIGNED NOT NULL,

    product_id BIGINT UNSIGNED NOT NULL,

    unit_id BIGINT UNSIGNED NOT NULL,

    cost_center_id BIGINT UNSIGNED NULL,

    account_id BIGINT UNSIGNED NULL,

    sequence_number SMALLINT UNSIGNED NOT NULL,

    contracted_quantity DECIMAL(18,4) NOT NULL,

    consumed_quantity DECIMAL(18,4) NOT NULL DEFAULT 0,

    remaining_quantity DECIMAL(18,4) NOT NULL,

    unit_price DECIMAL(18,6) NOT NULL,

    total_value DECIMAL(18,2) NOT NULL,

    start_date DATE NULL,

    end_date DATE NULL,

    observations TEXT NULL,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    created_by BIGINT UNSIGNED NULL,

    updated_by BIGINT UNSIGNED NULL,

    CONSTRAINT uq_purchase_contract_items_uuid
        UNIQUE (uuid),

    CONSTRAINT uq_purchase_contract_item_sequence
        UNIQUE (
            purchase_contract_id,
            sequence_number
        ),

    CONSTRAINT chk_purchase_contract_contracted
        CHECK (
            contracted_quantity > 0
        ),

    CONSTRAINT chk_purchase_contract_consumed
        CHECK (
            consumed_quantity >= 0
        ),

    CONSTRAINT chk_purchase_contract_remaining
        CHECK (
            remaining_quantity >= 0
        ),

    CONSTRAINT chk_purchase_contract_quantities
        CHECK (

            contracted_quantity =
            consumed_quantity +
            remaining_quantity

        ),

    CONSTRAINT chk_purchase_contract_price
        CHECK (
            unit_price >= 0
        ),

    CONSTRAINT chk_purchase_contract_total
        CHECK (
            total_value >= 0
        ),

    CONSTRAINT chk_purchase_contract_dates
        CHECK (

            end_date IS NULL
            OR
            start_date IS NULL
            OR
            end_date >= start_date

        ),

    CONSTRAINT fk_purchase_contract_items_contract
        FOREIGN KEY (purchase_contract_id)
        REFERENCES purchase_contracts(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_purchase_contract_items_product
        FOREIGN KEY (product_id)
        REFERENCES products(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_purchase_contract_items_unit
        FOREIGN KEY (unit_id)
        REFERENCES product_units(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_purchase_contract_items_cost_center
        FOREIGN KEY (cost_center_id)
        REFERENCES cost_centers(id)
        ON UPDATE CASCADE
        ON DELETE SET NULL,

    CONSTRAINT fk_purchase_contract_items_account
        FOREIGN KEY (account_id)
        REFERENCES accounts(id)
        ON UPDATE CASCADE
        ON DELETE SET NULL

)

ENGINE=InnoDB

DEFAULT CHARSET=utf8mb4

COLLATE=utf8mb4_unicode_ci

COMMENT='Itens dos contratos de fornecimento.';


/******************************************************************************
    ÍNDICES
******************************************************************************/

CREATE INDEX idx_purchase_contract_items_contract
ON purchase_contract_items(purchase_contract_id);

CREATE INDEX idx_purchase_contract_items_product
ON purchase_contract_items(product_id);

CREATE INDEX idx_purchase_contract_items_unit
ON purchase_contract_items(unit_id);

CREATE INDEX idx_purchase_contract_items_cost_center
ON purchase_contract_items(cost_center_id);

CREATE INDEX idx_purchase_contract_items_account
ON purchase_contract_items(account_id);

CREATE INDEX idx_purchase_contract_items_end_date
ON purchase_contract_items(end_date);

CREATE INDEX idx_purchase_contract_items_sequence
ON purchase_contract_items(sequence_number);


