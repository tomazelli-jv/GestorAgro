/******************************************************************************
*
*   TABELA: cost_centers
*
*   RESPONSABILIDADE
*
*   Armazena os centros de custo das fazendas.
*
******************************************************************************/

CREATE TABLE cost_centers (

    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    uuid CHAR(36) NOT NULL DEFAULT (UUID()),

    farm_id BIGINT UNSIGNED NOT NULL,

    code VARCHAR(30) NOT NULL,

    name VARCHAR(150) NOT NULL,

    description VARCHAR(255) NULL,

    parent_id BIGINT UNSIGNED NULL,

    is_active BOOLEAN NOT NULL DEFAULT TRUE,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    deleted_at TIMESTAMP NULL DEFAULT NULL,

    created_by BIGINT UNSIGNED NULL,

    updated_by BIGINT UNSIGNED NULL,

    deleted_by BIGINT UNSIGNED NULL,

    CONSTRAINT uq_cost_centers_uuid
        UNIQUE (uuid),

    CONSTRAINT uq_cost_centers_code
        UNIQUE (farm_id, code),

    CONSTRAINT uq_cost_centers_name
        UNIQUE (farm_id, name),

    CONSTRAINT chk_cost_centers_code
        CHECK (TRIM(code) <> ''),

    CONSTRAINT chk_cost_centers_name
        CHECK (TRIM(name) <> ''),

    CONSTRAINT fk_cost_centers_farm
        FOREIGN KEY (farm_id)
        REFERENCES farms(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_cost_centers_parent
        FOREIGN KEY (parent_id)
        REFERENCES cost_centers(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT

)

ENGINE=InnoDB

DEFAULT CHARSET=utf8mb4

COLLATE=utf8mb4_unicode_ci

COMMENT='Centros de custo da fazenda.';


/******************************************************************************
    ÍNDICES
******************************************************************************/

CREATE INDEX idx_cost_centers_farm
ON cost_centers(farm_id);

CREATE INDEX idx_cost_centers_parent
ON cost_centers(parent_id);

CREATE INDEX idx_cost_centers_code
ON cost_centers(code);

CREATE INDEX idx_cost_centers_name
ON cost_centers(name);

CREATE INDEX idx_cost_centers_active
ON cost_centers(is_active);


/******************************************************************************
*
*   TABELA: accounts
*
*   RESPONSABILIDADE
*
*   Armazena o plano de contas financeiro.
*
******************************************************************************/

CREATE TABLE accounts (

    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    uuid CHAR(36) NOT NULL DEFAULT (UUID()),

    farm_id BIGINT UNSIGNED NOT NULL,

    parent_id BIGINT UNSIGNED NULL,

    code VARCHAR(30) NOT NULL,

    name VARCHAR(200) NOT NULL,

    account_type VARCHAR(20) NOT NULL,

    accepts_entries BOOLEAN NOT NULL DEFAULT TRUE,

    is_active BOOLEAN NOT NULL DEFAULT TRUE,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    deleted_at TIMESTAMP NULL DEFAULT NULL,

    created_by BIGINT UNSIGNED NULL,

    updated_by BIGINT UNSIGNED NULL,

    deleted_by BIGINT UNSIGNED NULL,

    CONSTRAINT uq_accounts_uuid
        UNIQUE (uuid),

    CONSTRAINT uq_accounts_code
        UNIQUE (farm_id, code),

    CONSTRAINT uq_accounts_name
        UNIQUE (farm_id, name),

    CONSTRAINT chk_accounts_code
        CHECK (TRIM(code) <> ''),

    CONSTRAINT chk_accounts_name
        CHECK (TRIM(name) <> ''),

    CONSTRAINT chk_accounts_type
        CHECK (

            account_type IN (

                'ASSET',

                'LIABILITY',

                'EQUITY',

                'REVENUE',

                'EXPENSE'

            )

        ),

    CONSTRAINT fk_accounts_farm
        FOREIGN KEY (farm_id)
        REFERENCES farms(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_accounts_parent
        FOREIGN KEY (parent_id)
        REFERENCES accounts(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT

)

ENGINE=InnoDB

DEFAULT CHARSET=utf8mb4

COLLATE=utf8mb4_unicode_ci

COMMENT='Plano de contas financeiro.';


/******************************************************************************
    ÍNDICES
******************************************************************************/

CREATE INDEX idx_accounts_farm
ON accounts(farm_id);

CREATE INDEX idx_accounts_parent
ON accounts(parent_id);

CREATE INDEX idx_accounts_code
ON accounts(code);

CREATE INDEX idx_accounts_name
ON accounts(name);

CREATE INDEX idx_accounts_type
ON accounts(account_type);

CREATE INDEX idx_accounts_active
ON accounts(is_active);


/******************************************************************************
*
*   TABELA: accounts_receivable
*
*   RESPONSABILIDADE
*
*   Armazena os títulos a receber da fazenda.
*
******************************************************************************/

CREATE TABLE accounts_receivable (

    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    uuid CHAR(36) NOT NULL DEFAULT (UUID()),

    farm_id BIGINT UNSIGNED NOT NULL,

    cost_center_id BIGINT UNSIGNED NOT NULL,

    account_id BIGINT UNSIGNED NOT NULL,

    customer_id BIGINT UNSIGNED NULL,

    document_number VARCHAR(50) NOT NULL,

    description VARCHAR(255) NOT NULL,

    issue_date DATE NOT NULL,

    due_date DATE NOT NULL,

    original_amount DECIMAL(18,2) NOT NULL,

    received_amount DECIMAL(18,2) NOT NULL DEFAULT 0,

    discount_amount DECIMAL(18,2) NOT NULL DEFAULT 0,

    interest_amount DECIMAL(18,2) NOT NULL DEFAULT 0,

    penalty_amount DECIMAL(18,2) NOT NULL DEFAULT 0,

    status VARCHAR(20) NOT NULL DEFAULT 'OPEN',

    observations TEXT NULL,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    deleted_at TIMESTAMP NULL DEFAULT NULL,

    created_by BIGINT UNSIGNED NULL,

    updated_by BIGINT UNSIGNED NULL,

    deleted_by BIGINT UNSIGNED NULL,

    CONSTRAINT uq_accounts_receivable_uuid
        UNIQUE (uuid),

    CONSTRAINT uq_accounts_receivable_document
        UNIQUE (
            farm_id,
            document_number
        ),

    CONSTRAINT chk_accounts_receivable_document
        CHECK (TRIM(document_number) <> ''),

    CONSTRAINT chk_accounts_receivable_description
        CHECK (TRIM(description) <> ''),

    CONSTRAINT chk_accounts_receivable_amount
        CHECK (original_amount > 0),

    CONSTRAINT chk_accounts_receivable_received
        CHECK (received_amount >= 0),

    CONSTRAINT chk_accounts_receivable_discount
        CHECK (discount_amount >= 0),

    CONSTRAINT chk_accounts_receivable_interest
        CHECK (interest_amount >= 0),

    CONSTRAINT chk_accounts_receivable_penalty
        CHECK (penalty_amount >= 0),

    CONSTRAINT chk_accounts_receivable_dates
        CHECK (due_date >= issue_date),

    CONSTRAINT chk_accounts_receivable_status
        CHECK (

            status IN (

                'OPEN',

                'PARTIALLY_RECEIVED',

                'RECEIVED',

                'OVERDUE',

                'CANCELLED'

            )

        ),

    CONSTRAINT fk_accounts_receivable_farm
        FOREIGN KEY (farm_id)
        REFERENCES farms(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_accounts_receivable_cost_center
        FOREIGN KEY (cost_center_id)
        REFERENCES cost_centers(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_accounts_receivable_account
        FOREIGN KEY (account_id)
        REFERENCES accounts(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_accounts_receivable_customer
        FOREIGN KEY (customer_id)
        REFERENCES contacts(id)
        ON UPDATE CASCADE
        ON DELETE SET NULL

)

ENGINE=InnoDB

DEFAULT CHARSET=utf8mb4

COLLATE=utf8mb4_unicode_ci

COMMENT='Títulos a receber da fazenda.';


/******************************************************************************
    ÍNDICES
******************************************************************************/

CREATE INDEX idx_accounts_receivable_farm
ON accounts_receivable(farm_id);

CREATE INDEX idx_accounts_receivable_customer
ON accounts_receivable(customer_id);

CREATE INDEX idx_accounts_receivable_cost_center
ON accounts_receivable(cost_center_id);

CREATE INDEX idx_accounts_receivable_account
ON accounts_receivable(account_id);

CREATE INDEX idx_accounts_receivable_due_date
ON accounts_receivable(due_date);

CREATE INDEX idx_accounts_receivable_status
ON accounts_receivable(status);


/******************************************************************************
*
*   TABELA: accounts_payable
*
*   RESPONSABILIDADE
*
*   Armazena os títulos a pagar da fazenda.
*
******************************************************************************/

CREATE TABLE accounts_payable (

    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    uuid CHAR(36) NOT NULL DEFAULT (UUID()),

    farm_id BIGINT UNSIGNED NOT NULL,

    cost_center_id BIGINT UNSIGNED NOT NULL,

    account_id BIGINT UNSIGNED NOT NULL,

    supplier_id BIGINT UNSIGNED NULL,

    document_number VARCHAR(50) NOT NULL,

    description VARCHAR(255) NOT NULL,

    issue_date DATE NOT NULL,

    due_date DATE NOT NULL,

    original_amount DECIMAL(18,2) NOT NULL,

    paid_amount DECIMAL(18,2) NOT NULL DEFAULT 0,

    discount_amount DECIMAL(18,2) NOT NULL DEFAULT 0,

    interest_amount DECIMAL(18,2) NOT NULL DEFAULT 0,

    penalty_amount DECIMAL(18,2) NOT NULL DEFAULT 0,

    status VARCHAR(20) NOT NULL DEFAULT 'OPEN',

    observations TEXT NULL,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    deleted_at TIMESTAMP NULL DEFAULT NULL,

    created_by BIGINT UNSIGNED NULL,

    updated_by BIGINT UNSIGNED NULL,

    deleted_by BIGINT UNSIGNED NULL,

    CONSTRAINT uq_accounts_payable_uuid
        UNIQUE (uuid),

    CONSTRAINT uq_accounts_payable_document
        UNIQUE (
            farm_id,
            document_number
        ),

    CONSTRAINT chk_accounts_payable_document
        CHECK (TRIM(document_number) <> ''),

    CONSTRAINT chk_accounts_payable_description
        CHECK (TRIM(description) <> ''),

    CONSTRAINT chk_accounts_payable_amount
        CHECK (original_amount > 0),

    CONSTRAINT chk_accounts_payable_paid
        CHECK (paid_amount >= 0),

    CONSTRAINT chk_accounts_payable_discount
        CHECK (discount_amount >= 0),

    CONSTRAINT chk_accounts_payable_interest
        CHECK (interest_amount >= 0),

    CONSTRAINT chk_accounts_payable_penalty
        CHECK (penalty_amount >= 0),

    CONSTRAINT chk_accounts_payable_dates
        CHECK (due_date >= issue_date),

    CONSTRAINT chk_accounts_payable_status
        CHECK (

            status IN (

                'OPEN',

                'PARTIALLY_PAID',

                'PAID',

                'OVERDUE',

                'CANCELLED'

            )

        ),

    CONSTRAINT fk_accounts_payable_farm
        FOREIGN KEY (farm_id)
        REFERENCES farms(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_accounts_payable_cost_center
        FOREIGN KEY (cost_center_id)
        REFERENCES cost_centers(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_accounts_payable_account
        FOREIGN KEY (account_id)
        REFERENCES accounts(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_accounts_payable_supplier
        FOREIGN KEY (supplier_id)
        REFERENCES contacts(id)
        ON UPDATE CASCADE
        ON DELETE SET NULL

)

ENGINE=InnoDB

DEFAULT CHARSET=utf8mb4

COLLATE=utf8mb4_unicode_ci

COMMENT='Títulos a pagar da fazenda.';


/******************************************************************************
    ÍNDICES
******************************************************************************/

CREATE INDEX idx_accounts_payable_farm
ON accounts_payable(farm_id);

CREATE INDEX idx_accounts_payable_supplier
ON accounts_payable(supplier_id);

CREATE INDEX idx_accounts_payable_cost_center
ON accounts_payable(cost_center_id);

CREATE INDEX idx_accounts_payable_account
ON accounts_payable(account_id);

CREATE INDEX idx_accounts_payable_due_date
ON accounts_payable(due_date);

CREATE INDEX idx_accounts_payable_status
ON accounts_payable(status);


/******************************************************************************
*
*   TABELA: financial_transactions
*
*   RESPONSABILIDADE
*
*   Armazena todas as movimentações financeiras efetivamente realizadas.
*
******************************************************************************/

CREATE TABLE financial_transactions (

    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    uuid CHAR(36) NOT NULL DEFAULT (UUID()),

    farm_id BIGINT UNSIGNED NOT NULL,

    bank_account_id BIGINT UNSIGNED NOT NULL,

    payment_method_id BIGINT UNSIGNED NOT NULL,

    cost_center_id BIGINT UNSIGNED NOT NULL,

    account_id BIGINT UNSIGNED NOT NULL,

    accounts_receivable_id BIGINT UNSIGNED NULL,

    accounts_payable_id BIGINT UNSIGNED NULL,

    transaction_type VARCHAR(20) NOT NULL,

    transaction_date DATETIME NOT NULL,

    amount DECIMAL(18,2) NOT NULL,

    document_number VARCHAR(50) NULL,

    reference_number VARCHAR(100) NULL,

    description VARCHAR(255) NOT NULL,

    observations TEXT NULL,

    is_reconciled BOOLEAN NOT NULL DEFAULT FALSE,

    reconciled_at TIMESTAMP NULL,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    created_by BIGINT UNSIGNED NULL,

    updated_by BIGINT UNSIGNED NULL,

    CONSTRAINT uq_financial_transactions_uuid
        UNIQUE (uuid),

    CONSTRAINT chk_financial_transaction_amount
        CHECK (amount > 0),

    CONSTRAINT chk_financial_transaction_description
        CHECK (TRIM(description) <> ''),

    CONSTRAINT chk_financial_transaction_type
        CHECK (

            transaction_type IN (

                'RECEIPT',

                'PAYMENT',

                'TRANSFER',

                'ADJUSTMENT',

                'REVERSAL'

            )

        ),

    CONSTRAINT chk_financial_transaction_reference
        CHECK (
            NOT (
                accounts_receivable_id IS NOT NULL
                AND
                accounts_payable_id IS NOT NULL
            )
        ),

    CONSTRAINT fk_financial_transactions_farm
        FOREIGN KEY (farm_id)
        REFERENCES farms(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_financial_transactions_bank
        FOREIGN KEY (bank_account_id)
        REFERENCES bank_accounts(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_financial_transactions_payment_method
        FOREIGN KEY (payment_method_id)
        REFERENCES payment_methods(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_financial_transactions_cost_center
        FOREIGN KEY (cost_center_id)
        REFERENCES cost_centers(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_financial_transactions_account
        FOREIGN KEY (account_id)
        REFERENCES accounts(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_financial_transactions_receivable
        FOREIGN KEY (accounts_receivable_id)
        REFERENCES accounts_receivable(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_financial_transactions_payable
        FOREIGN KEY (accounts_payable_id)
        REFERENCES accounts_payable(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT

)

ENGINE=InnoDB

DEFAULT CHARSET=utf8mb4

COLLATE=utf8mb4_unicode_ci

COMMENT='Movimentações financeiras realizadas.';


/******************************************************************************
    ÍNDICES
******************************************************************************/

CREATE INDEX idx_financial_transactions_farm
ON financial_transactions(farm_id);

CREATE INDEX idx_financial_transactions_bank
ON financial_transactions(bank_account_id);

CREATE INDEX idx_financial_transactions_payment_method
ON financial_transactions(payment_method_id);

CREATE INDEX idx_financial_transactions_cost_center
ON financial_transactions(cost_center_id);

CREATE INDEX idx_financial_transactions_account
ON financial_transactions(account_id);

CREATE INDEX idx_financial_transactions_receivable
ON financial_transactions(accounts_receivable_id);

CREATE INDEX idx_financial_transactions_payable
ON financial_transactions(accounts_payable_id);

CREATE INDEX idx_financial_transactions_date
ON financial_transactions(transaction_date);

CREATE INDEX idx_financial_transactions_type
ON financial_transactions(transaction_type);

CREATE INDEX idx_financial_transactions_reconciled
ON financial_transactions(is_reconciled);


/******************************************************************************
*
*   TABELA: payment_methods
*
*   RESPONSABILIDADE
*
*   Armazena as formas de pagamento e recebimento utilizadas pela fazenda.
*
******************************************************************************/

CREATE TABLE payment_methods (

    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    uuid CHAR(36) NOT NULL DEFAULT (UUID()),

    farm_id BIGINT UNSIGNED NOT NULL,

    code VARCHAR(30) NOT NULL,

    name VARCHAR(100) NOT NULL,

    description VARCHAR(255) NULL,

    method_type VARCHAR(20) NOT NULL,

    allows_installments BOOLEAN NOT NULL DEFAULT FALSE,

    requires_authorization BOOLEAN NOT NULL DEFAULT FALSE,

    is_active BOOLEAN NOT NULL DEFAULT TRUE,

    display_order SMALLINT UNSIGNED NOT NULL DEFAULT 0,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    deleted_at TIMESTAMP NULL DEFAULT NULL,

    created_by BIGINT UNSIGNED NULL,

    updated_by BIGINT UNSIGNED NULL,

    deleted_by BIGINT UNSIGNED NULL,

    CONSTRAINT uq_payment_methods_uuid
        UNIQUE (uuid),

    CONSTRAINT uq_payment_methods_code
        UNIQUE (farm_id, code),

    CONSTRAINT uq_payment_methods_name
        UNIQUE (farm_id, name),

    CONSTRAINT chk_payment_methods_code
        CHECK (TRIM(code) <> ''),

    CONSTRAINT chk_payment_methods_name
        CHECK (TRIM(name) <> ''),

    CONSTRAINT chk_payment_methods_type
        CHECK (

            method_type IN (

                'CASH',

                'BANK',

                'CARD',

                'CHECK',

                'DIGITAL',

                'OTHER'

            )

        ),

    CONSTRAINT fk_payment_methods_farm
        FOREIGN KEY (farm_id)
        REFERENCES farms(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE

)

ENGINE=InnoDB

DEFAULT CHARSET=utf8mb4

COLLATE=utf8mb4_unicode_ci

COMMENT='Formas de pagamento e recebimento.';


/******************************************************************************
    ÍNDICES
******************************************************************************/

CREATE INDEX idx_payment_methods_farm
ON payment_methods(farm_id);

CREATE INDEX idx_payment_methods_code
ON payment_methods(code);

CREATE INDEX idx_payment_methods_name
ON payment_methods(name);

CREATE INDEX idx_payment_methods_type
ON payment_methods(method_type);

CREATE INDEX idx_payment_methods_active
ON payment_methods(is_active);

CREATE INDEX idx_payment_methods_order
ON payment_methods(display_order);

/******************************************************************************
*
*   TABELA: bank_accounts
*
*   RESPONSABILIDADE
*
*   Armazena contas bancárias, caixas e carteiras financeiras.
*
******************************************************************************/

CREATE TABLE bank_accounts (

    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    uuid CHAR(36) NOT NULL DEFAULT (UUID()),

    farm_id BIGINT UNSIGNED NOT NULL,

    code VARCHAR(30) NOT NULL,

    name VARCHAR(150) NOT NULL,

    account_type VARCHAR(20) NOT NULL,

    bank_name VARCHAR(150) NULL,

    bank_code VARCHAR(10) NULL,

    agency VARCHAR(20) NULL,

    account_number VARCHAR(30) NULL,

    account_digit VARCHAR(5) NULL,

    pix_key VARCHAR(255) NULL,

    initial_balance DECIMAL(18,2) NOT NULL DEFAULT 0,

    current_balance DECIMAL(18,2) NOT NULL DEFAULT 0,

    is_default BOOLEAN NOT NULL DEFAULT FALSE,

    is_active BOOLEAN NOT NULL DEFAULT TRUE,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    deleted_at TIMESTAMP NULL DEFAULT NULL,

    created_by BIGINT UNSIGNED NULL,

    updated_by BIGINT UNSIGNED NULL,

    deleted_by BIGINT UNSIGNED NULL,

    CONSTRAINT uq_bank_accounts_uuid
        UNIQUE (uuid),

    CONSTRAINT uq_bank_accounts_code
        UNIQUE (farm_id, code),

    CONSTRAINT uq_bank_accounts_name
        UNIQUE (farm_id, name),

    CONSTRAINT chk_bank_accounts_code
        CHECK (TRIM(code) <> ''),

    CONSTRAINT chk_bank_accounts_name
        CHECK (TRIM(name) <> ''),

    CONSTRAINT chk_bank_accounts_type
        CHECK (

            account_type IN (

                'CASH',

                'CHECKING',

                'SAVINGS',

                'INVESTMENT',

                'DIGITAL'

            )

        ),

    CONSTRAINT fk_bank_accounts_farm
        FOREIGN KEY (farm_id)
        REFERENCES farms(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE

)

ENGINE=InnoDB

DEFAULT CHARSET=utf8mb4

COLLATE=utf8mb4_unicode_ci

COMMENT='Contas bancárias, caixas e carteiras financeiras.';


/******************************************************************************
    ÍNDICES
******************************************************************************/

CREATE INDEX idx_bank_accounts_farm
ON bank_accounts(farm_id);

CREATE INDEX idx_bank_accounts_code
ON bank_accounts(code);

CREATE INDEX idx_bank_accounts_name
ON bank_accounts(name);

CREATE INDEX idx_bank_accounts_type
ON bank_accounts(account_type);

CREATE INDEX idx_bank_accounts_default
ON bank_accounts(is_default);

CREATE INDEX idx_bank_accounts_active
ON bank_accounts(is_active);


/******************************************************************************
*
*   TABELA: bank_reconciliations
*
*   RESPONSABILIDADE
*
*   Armazena as conciliações bancárias das contas financeiras.
*
******************************************************************************/

CREATE TABLE bank_reconciliations (

    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    uuid CHAR(36) NOT NULL DEFAULT (UUID()),

    farm_id BIGINT UNSIGNED NOT NULL,

    bank_account_id BIGINT UNSIGNED NOT NULL,

    reconciliation_number VARCHAR(30) NOT NULL,

    period_start DATE NOT NULL,

    period_end DATE NOT NULL,

    bank_opening_balance DECIMAL(18,2) NOT NULL,

    bank_closing_balance DECIMAL(18,2) NOT NULL,

    system_closing_balance DECIMAL(18,2) NOT NULL,

    difference_amount DECIMAL(18,2) NOT NULL DEFAULT 0,

    status VARCHAR(20) NOT NULL DEFAULT 'OPEN',

    reconciled_at DATETIME NULL,

    observations TEXT NULL,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    created_by BIGINT UNSIGNED NULL,

    updated_by BIGINT UNSIGNED NULL,

    CONSTRAINT uq_bank_reconciliations_uuid
        UNIQUE (uuid),

    CONSTRAINT uq_bank_reconciliation_number
        UNIQUE (farm_id, reconciliation_number),

    CONSTRAINT chk_bank_reconciliation_number
        CHECK (TRIM(reconciliation_number) <> ''),

    CONSTRAINT chk_bank_reconciliation_period
        CHECK (period_end >= period_start),

    CONSTRAINT chk_bank_reconciliation_status
        CHECK (

            status IN (

                'OPEN',

                'IN_PROGRESS',

                'RECONCILED',

                'CANCELLED'

            )

        ),

    CONSTRAINT fk_bank_reconciliations_farm
        FOREIGN KEY (farm_id)
        REFERENCES farms(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_bank_reconciliations_bank
        FOREIGN KEY (bank_account_id)
        REFERENCES bank_accounts(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT

)

ENGINE=InnoDB

DEFAULT CHARSET=utf8mb4

COLLATE=utf8mb4_unicode_ci

COMMENT='Conciliações bancárias.';


/******************************************************************************
    ÍNDICES
******************************************************************************/

CREATE INDEX idx_bank_reconciliations_farm
ON bank_reconciliations(farm_id);

CREATE INDEX idx_bank_reconciliations_bank
ON bank_reconciliations(bank_account_id);

CREATE INDEX idx_bank_reconciliations_period
ON bank_reconciliations(period_start, period_end);

CREATE INDEX idx_bank_reconciliations_status
ON bank_reconciliations(status);

CREATE INDEX idx_bank_reconciliations_reconciled_at
ON bank_reconciliations(reconciled_at);


/******************************************************************************
*
*   TABELA: budgets
*
*   RESPONSABILIDADE
*
*   Armazena os orçamentos financeiros da fazenda.
*
******************************************************************************/

CREATE TABLE budgets (

    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    uuid CHAR(36) NOT NULL DEFAULT (UUID()),

    farm_id BIGINT UNSIGNED NOT NULL,

    budget_number VARCHAR(30) NOT NULL,

    name VARCHAR(150) NOT NULL,

    fiscal_year SMALLINT UNSIGNED NOT NULL,

    start_date DATE NOT NULL,

    end_date DATE NOT NULL,

    status VARCHAR(20) NOT NULL DEFAULT 'DRAFT',

    observations TEXT NULL,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    deleted_at TIMESTAMP NULL DEFAULT NULL,

    created_by BIGINT UNSIGNED NULL,

    updated_by BIGINT UNSIGNED NULL,

    deleted_by BIGINT UNSIGNED NULL,

    CONSTRAINT uq_budgets_uuid
        UNIQUE (uuid),

    CONSTRAINT uq_budget_number
        UNIQUE (farm_id, budget_number),

    CONSTRAINT chk_budget_number
        CHECK (TRIM(budget_number) <> ''),

    CONSTRAINT chk_budget_name
        CHECK (TRIM(name) <> ''),

    CONSTRAINT chk_budget_dates
        CHECK (end_date >= start_date),

    CONSTRAINT chk_budget_status
        CHECK (

            status IN (

                'DRAFT',

                'APPROVED',

                'ACTIVE',

                'CLOSED',

                'CANCELLED'

            )

        ),

    CONSTRAINT fk_budgets_farm
        FOREIGN KEY (farm_id)
        REFERENCES farms(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE

)

ENGINE=InnoDB

DEFAULT CHARSET=utf8mb4

COLLATE=utf8mb4_unicode_ci

COMMENT='Orçamentos financeiros.';


/******************************************************************************
    ÍNDICES
******************************************************************************/

CREATE INDEX idx_budgets_farm
ON budgets(farm_id);

CREATE INDEX idx_budgets_year
ON budgets(fiscal_year);

CREATE INDEX idx_budgets_status
ON budgets(status);

CREATE INDEX idx_budgets_period
ON budgets(start_date, end_date);


/******************************************************************************
*
*   TABELA: budget_items
*
*   RESPONSABILIDADE
*
*   Armazena os itens dos orçamentos financeiros.
*
******************************************************************************/

CREATE TABLE budget_items (

    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    uuid CHAR(36) NOT NULL DEFAULT (UUID()),

    budget_id BIGINT UNSIGNED NOT NULL,

    cost_center_id BIGINT UNSIGNED NOT NULL,

    account_id BIGINT UNSIGNED NOT NULL,

    sequence_number SMALLINT UNSIGNED NOT NULL,

    reference_month TINYINT UNSIGNED NOT NULL,

    planned_amount DECIMAL(18,2) NOT NULL,

    actual_amount DECIMAL(18,2) NOT NULL DEFAULT 0,

    observations TEXT NULL,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    created_by BIGINT UNSIGNED NULL,

    updated_by BIGINT UNSIGNED NULL,

    CONSTRAINT uq_budget_items_uuid
        UNIQUE (uuid),

    CONSTRAINT uq_budget_item
        UNIQUE (
            budget_id,
            cost_center_id,
            account_id,
            reference_month
        ),

    CONSTRAINT uq_budget_sequence
        UNIQUE (
            budget_id,
            sequence_number
        ),

    CONSTRAINT chk_budget_reference_month
        CHECK (
            reference_month BETWEEN 1 AND 12
        ),

    CONSTRAINT chk_budget_planned_amount
        CHECK (
            planned_amount >= 0
        ),

    CONSTRAINT chk_budget_actual_amount
        CHECK (
            actual_amount >= 0
        ),

    CONSTRAINT fk_budget_items_budget
        FOREIGN KEY (budget_id)
        REFERENCES budgets(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_budget_items_cost_center
        FOREIGN KEY (cost_center_id)
        REFERENCES cost_centers(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_budget_items_account
        FOREIGN KEY (account_id)
        REFERENCES accounts(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT

)

ENGINE=InnoDB

DEFAULT CHARSET=utf8mb4

COLLATE=utf8mb4_unicode_ci

COMMENT='Itens dos orçamentos financeiros.';


/******************************************************************************
    ÍNDICES
******************************************************************************/

CREATE INDEX idx_budget_items_budget
ON budget_items(budget_id);

CREATE INDEX idx_budget_items_cost_center
ON budget_items(cost_center_id);

CREATE INDEX idx_budget_items_account
ON budget_items(account_id);

CREATE INDEX idx_budget_items_month
ON budget_items(reference_month);

CREATE INDEX idx_budget_items_sequence
ON budget_items(sequence_number);


/******************************************************************************
*
*   TABELA: financial_categories
*
*   RESPONSABILIDADE
*
*   Armazena as categorias financeiras gerenciais utilizadas para
*   agrupamento de receitas e despesas.
*
******************************************************************************/

CREATE TABLE financial_categories (

    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    uuid CHAR(36) NOT NULL DEFAULT (UUID()),

    farm_id BIGINT UNSIGNED NOT NULL,

    parent_id BIGINT UNSIGNED NULL,

    code VARCHAR(30) NOT NULL,

    name VARCHAR(150) NOT NULL,

    category_type VARCHAR(20) NOT NULL,

    description VARCHAR(255) NULL,

    color VARCHAR(7) NULL,

    icon VARCHAR(100) NULL,

    is_active BOOLEAN NOT NULL DEFAULT TRUE,

    display_order SMALLINT UNSIGNED NOT NULL DEFAULT 0,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    deleted_at TIMESTAMP NULL DEFAULT NULL,

    created_by BIGINT UNSIGNED NULL,

    updated_by BIGINT UNSIGNED NULL,

    deleted_by BIGINT UNSIGNED NULL,

    CONSTRAINT uq_financial_categories_uuid
        UNIQUE (uuid),

    CONSTRAINT uq_financial_categories_code
        UNIQUE (farm_id, code),

    CONSTRAINT uq_financial_categories_name
        UNIQUE (farm_id, name),

    CONSTRAINT chk_financial_categories_code
        CHECK (TRIM(code) <> ''),

    CONSTRAINT chk_financial_categories_name
        CHECK (TRIM(name) <> ''),

    CONSTRAINT chk_financial_categories_type
        CHECK (
            category_type IN (
                'REVENUE',
                'EXPENSE',
                'BOTH'
            )
        ),

    CONSTRAINT fk_financial_categories_farm
        FOREIGN KEY (farm_id)
        REFERENCES farms(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_financial_categories_parent
        FOREIGN KEY (parent_id)
        REFERENCES financial_categories(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT

)

ENGINE=InnoDB

DEFAULT CHARSET=utf8mb4

COLLATE=utf8mb4_unicode_ci

COMMENT='Categorias financeiras gerenciais.';


/******************************************************************************
    ÍNDICES
******************************************************************************/

CREATE INDEX idx_financial_categories_farm
ON financial_categories(farm_id);

CREATE INDEX idx_financial_categories_parent
ON financial_categories(parent_id);

CREATE INDEX idx_financial_categories_code
ON financial_categories(code);

CREATE INDEX idx_financial_categories_name
ON financial_categories(name);

CREATE INDEX idx_financial_categories_type
ON financial_categories(category_type);

CREATE INDEX idx_financial_categories_active
ON financial_categories(is_active);

CREATE INDEX idx_financial_categories_order
ON financial_categories(display_order);



