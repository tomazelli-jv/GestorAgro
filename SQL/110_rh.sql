/******************************************************************************
*
*   TABELA: departments
*
*   RESPONSABILIDADE
*
*   Cadastro de departamentos da empresa.
*
******************************************************************************/

CREATE TABLE departments (

    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    uuid CHAR(36) NOT NULL DEFAULT (UUID()),

    company_id BIGINT UNSIGNED NOT NULL,

    code VARCHAR(20) NOT NULL,

    name VARCHAR(120) NOT NULL,

    description TEXT NULL,

    manager_employee_id BIGINT UNSIGNED NULL,

    is_active BOOLEAN NOT NULL DEFAULT TRUE,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    deleted_at TIMESTAMP NULL,

    created_by BIGINT UNSIGNED NULL,

    updated_by BIGINT UNSIGNED NULL,

    deleted_by BIGINT UNSIGNED NULL,

    CONSTRAINT uq_departments_uuid
        UNIQUE (uuid),

    CONSTRAINT uq_departments_code
        UNIQUE (
            company_id,
            code
        ),

    CONSTRAINT uq_departments_name
        UNIQUE (
            company_id,
            name
        ),

    CONSTRAINT chk_departments_code
        CHECK (
            TRIM(code) <> ''
        ),

    CONSTRAINT chk_departments_name
        CHECK (
            TRIM(name) <> ''
        ),

    CONSTRAINT fk_departments_company
        FOREIGN KEY (company_id)
        REFERENCES companies(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE

)

ENGINE=InnoDB

DEFAULT CHARSET=utf8mb4

COLLATE=utf8mb4_unicode_ci

COMMENT='Departamentos da empresa.';


/******************************************************************************
    ÍNDICES
******************************************************************************/

CREATE INDEX idx_departments_company
ON departments(company_id);

CREATE INDEX idx_departments_active
ON departments(is_active);

CREATE INDEX idx_departments_manager
ON departments(manager_employee_id);


/******************************************************************************
*
*   TABELA: positions
*
*   RESPONSABILIDADE
*
*   Cadastro de cargos da empresa.
*
******************************************************************************/

CREATE TABLE positions (

    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    uuid CHAR(36) NOT NULL DEFAULT (UUID()),

    company_id BIGINT UNSIGNED NOT NULL,

    department_id BIGINT UNSIGNED NOT NULL,

    code VARCHAR(20) NOT NULL,

    name VARCHAR(120) NOT NULL,

    description TEXT NULL,

    hierarchy_level SMALLINT UNSIGNED NOT NULL DEFAULT 1,

    requires_approval BOOLEAN NOT NULL DEFAULT FALSE,

    is_management BOOLEAN NOT NULL DEFAULT FALSE,

    is_active BOOLEAN NOT NULL DEFAULT TRUE,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    deleted_at TIMESTAMP NULL,

    created_by BIGINT UNSIGNED NULL,

    updated_by BIGINT UNSIGNED NULL,

    deleted_by BIGINT UNSIGNED NULL,

    CONSTRAINT uq_positions_uuid
        UNIQUE (uuid),

    CONSTRAINT uq_positions_code
        UNIQUE (
            company_id,
            code
        ),

    CONSTRAINT uq_positions_name
        UNIQUE (
            company_id,
            department_id,
            name
        ),

    CONSTRAINT chk_positions_code
        CHECK (
            TRIM(code) <> ''
        ),

    CONSTRAINT chk_positions_name
        CHECK (
            TRIM(name) <> ''
        ),

    CONSTRAINT chk_positions_level
        CHECK (
            hierarchy_level > 0
        ),

    CONSTRAINT fk_positions_company
        FOREIGN KEY (company_id)
        REFERENCES companies(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_positions_department
        FOREIGN KEY (department_id)
        REFERENCES departments(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT

)

ENGINE=InnoDB

DEFAULT CHARSET=utf8mb4

COLLATE=utf8mb4_unicode_ci

COMMENT='Cargos da empresa.';


/******************************************************************************
    ÍNDICES
******************************************************************************/

CREATE INDEX idx_positions_company
ON positions(company_id);

CREATE INDEX idx_positions_department
ON positions(department_id);

CREATE INDEX idx_positions_level
ON positions(hierarchy_level);

CREATE INDEX idx_positions_management
ON positions(is_management);

CREATE INDEX idx_positions_active
ON positions(is_active);


/******************************************************************************
*
*   TABELA: employees
*
*   RESPONSABILIDADE
*
*   Cadastro de colaboradores da empresa.
*
******************************************************************************/

CREATE TABLE employees (

    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    uuid CHAR(36) NOT NULL DEFAULT (UUID()),

    company_id BIGINT UNSIGNED NOT NULL,

    department_id BIGINT UNSIGNED NOT NULL,

    position_id BIGINT UNSIGNED NOT NULL,

    employee_code VARCHAR(20) NOT NULL,

    full_name VARCHAR(150) NOT NULL,

    preferred_name VARCHAR(100) NULL,

    cpf CHAR(11) NOT NULL,

    rg VARCHAR(20) NULL,

    birth_date DATE NULL,

    hire_date DATE NOT NULL,

    termination_date DATE NULL,

    employment_type VARCHAR(20) NOT NULL DEFAULT 'CLT',

    status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',

    email VARCHAR(150) NULL,

    mobile_phone VARCHAR(20) NULL,

    salary DECIMAL(18,2) NULL,

    observations TEXT NULL,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    deleted_at TIMESTAMP NULL,

    created_by BIGINT UNSIGNED NULL,

    updated_by BIGINT UNSIGNED NULL,

    deleted_by BIGINT UNSIGNED NULL,

    CONSTRAINT uq_employees_uuid
        UNIQUE (uuid),

    CONSTRAINT uq_employees_code
        UNIQUE (
            company_id,
            employee_code
        ),

    CONSTRAINT uq_employees_cpf
        UNIQUE (cpf),

    CONSTRAINT chk_employee_name
        CHECK (
            TRIM(full_name) <> ''
        ),

    CONSTRAINT chk_employee_dates
        CHECK (
            termination_date IS NULL
            OR
            termination_date >= hire_date
        ),

    CONSTRAINT chk_employee_type
        CHECK (

            employment_type IN (

                'CLT',

                'TEMPORARY',

                'INTERN',

                'CONTRACTOR',

                'SERVICE_PROVIDER'

            )

        ),

    CONSTRAINT chk_employee_status
        CHECK (

            status IN (

                'ACTIVE',

                'ON_LEAVE',

                'VACATION',

                'TERMINATED',

                'INACTIVE'

            )

        ),

    CONSTRAINT chk_employee_salary
        CHECK (
            salary IS NULL
            OR
            salary >= 0
        ),

    CONSTRAINT fk_employees_company
        FOREIGN KEY (company_id)
        REFERENCES companies(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_employees_department
        FOREIGN KEY (department_id)
        REFERENCES departments(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_employees_position
        FOREIGN KEY (position_id)
        REFERENCES positions(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT

)

ENGINE=InnoDB

DEFAULT CHARSET=utf8mb4

COLLATE=utf8mb4_unicode_ci

COMMENT='Cadastro de colaboradores.';






/******************************************************************************
    ÍNDICES
******************************************************************************/

CREATE INDEX idx_employees_company
ON employees(company_id);

CREATE INDEX idx_employees_department
ON employees(department_id);

CREATE INDEX idx_employees_position
ON employees(position_id);

CREATE INDEX idx_employees_status
ON employees(status);

CREATE INDEX idx_employees_name
ON employees(full_name);

CREATE INDEX idx_employees_hire_date
ON employees(hire_date);


/******************************************************************************
*
*   AJUSTE DE DEPENDÊNCIA
*
*   DEPARTMENTS → EMPLOYEES
*
******************************************************************************/

ALTER TABLE departments

ADD CONSTRAINT fk_departments_manager

FOREIGN KEY (manager_employee_id)

REFERENCES employees(id)

ON UPDATE CASCADE

ON DELETE SET NULL;


/******************************************************************************
*
*   TABELA: employee_contacts
*
*   RESPONSABILIDADE
*
*   Armazena os dados de contato dos colaboradores.
*
******************************************************************************/

CREATE TABLE employee_contacts (

    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    uuid CHAR(36) NOT NULL DEFAULT (UUID()),

    employee_id BIGINT UNSIGNED NOT NULL,

    address VARCHAR(255) NULL,

    number VARCHAR(20) NULL,

    complement VARCHAR(100) NULL,

    neighborhood VARCHAR(120) NULL,

    city VARCHAR(120) NULL,

    state CHAR(2) NULL,

    zip_code VARCHAR(10) NULL,

    phone VARCHAR(20) NULL,

    mobile_phone VARCHAR(20) NULL,

    email VARCHAR(150) NULL,

    emergency_contact_name VARCHAR(150) NULL,

    emergency_contact_phone VARCHAR(20) NULL,

    observations TEXT NULL,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    created_by BIGINT UNSIGNED NULL,

    updated_by BIGINT UNSIGNED NULL,

    CONSTRAINT uq_employee_contacts_uuid
        UNIQUE (uuid),

    CONSTRAINT uq_employee_contact_employee
        UNIQUE (employee_id),

    CONSTRAINT fk_employee_contacts_employee
        FOREIGN KEY (employee_id)
        REFERENCES employees(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE

)

ENGINE=InnoDB

DEFAULT CHARSET=utf8mb4

COLLATE=utf8mb4_unicode_ci

COMMENT='Dados de contato dos colaboradores.';


/******************************************************************************
    ÍNDICES
******************************************************************************/

CREATE INDEX idx_employee_contacts_city
ON employee_contacts(city);

CREATE INDEX idx_employee_contacts_state
ON employee_contacts(state);

CREATE INDEX idx_employee_contacts_email
ON employee_contacts(email);


/******************************************************************************
*
*   TABELA: employee_documents
*
*   RESPONSABILIDADE
*
*   Armazena documentos e arquivos dos colaboradores.
*
******************************************************************************/

CREATE TABLE employee_documents (

    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    uuid CHAR(36) NOT NULL DEFAULT (UUID()),

    employee_id BIGINT UNSIGNED NOT NULL,

    document_type VARCHAR(50) NOT NULL,

    document_name VARCHAR(150) NOT NULL,

    document_number VARCHAR(80) NULL,

    issue_date DATE NULL,

    expiration_date DATE NULL,

    issuing_authority VARCHAR(120) NULL,

    file_name VARCHAR(255) NULL,

    file_path VARCHAR(500) NULL,

    file_size BIGINT UNSIGNED NULL,

    mime_type VARCHAR(100) NULL,

    observations TEXT NULL,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    created_by BIGINT UNSIGNED NULL,

    updated_by BIGINT UNSIGNED NULL,

    CONSTRAINT uq_employee_documents_uuid
        UNIQUE (uuid),

    CONSTRAINT chk_document_name
        CHECK (
            TRIM(document_name) <> ''
        ),

    CONSTRAINT chk_document_type
        CHECK (
            TRIM(document_type) <> ''
        ),

    CONSTRAINT chk_document_dates
        CHECK (

            expiration_date IS NULL

            OR

            issue_date IS NULL

            OR

            expiration_date >= issue_date

        ),

    CONSTRAINT fk_employee_documents_employee
        FOREIGN KEY (employee_id)
        REFERENCES employees(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE

)

ENGINE=InnoDB

DEFAULT CHARSET=utf8mb4

COLLATE=utf8mb4_unicode_ci

COMMENT='Documentos dos colaboradores.';


/******************************************************************************
    ÍNDICES
******************************************************************************/

CREATE INDEX idx_employee_documents_employee
ON employee_documents(employee_id);

CREATE INDEX idx_employee_documents_type
ON employee_documents(document_type);

CREATE INDEX idx_employee_documents_expiration
ON employee_documents(expiration_date);

CREATE INDEX idx_employee_documents_number
ON employee_documents(document_number);


/******************************************************************************
*
*   TABELA: employee_allocations
*
*   RESPONSABILIDADE
*
*   Histórico de alocação dos colaboradores.
*
******************************************************************************/

CREATE TABLE employee_allocations (

    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    uuid CHAR(36) NOT NULL DEFAULT (UUID()),

    employee_id BIGINT UNSIGNED NOT NULL,

    farm_id BIGINT UNSIGNED NOT NULL,

    department_id BIGINT UNSIGNED NOT NULL,

    position_id BIGINT UNSIGNED NOT NULL,

work_team_id BIGINT UNSIGNED NULL,

    cost_center_id BIGINT UNSIGNED NULL,

    start_date DATE NOT NULL,

    end_date DATE NULL,

    is_primary BOOLEAN NOT NULL DEFAULT TRUE,

    observations TEXT NULL,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    created_by BIGINT UNSIGNED NULL,

    updated_by BIGINT UNSIGNED NULL,

    CONSTRAINT uq_employee_allocations_uuid
        UNIQUE (uuid),

    CONSTRAINT chk_employee_allocations_dates
        CHECK (

            end_date IS NULL

            OR

            end_date >= start_date

        ),

    CONSTRAINT fk_employee_allocations_employee
        FOREIGN KEY (employee_id)
        REFERENCES employees(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_employee_allocations_farm
        FOREIGN KEY (farm_id)
        REFERENCES farms(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_employee_allocations_department
        FOREIGN KEY (department_id)
        REFERENCES departments(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_employee_allocations_cost_center
        FOREIGN KEY (cost_center_id)
        REFERENCES cost_centers(id)
        ON UPDATE CASCADE
        ON DELETE SET NULL

)

ENGINE=InnoDB

DEFAULT CHARSET=utf8mb4

COLLATE=utf8mb4_unicode_ci

COMMENT='Histórico de alocação dos colaboradores.';


/******************************************************************************
    ÍNDICES
******************************************************************************/

CREATE INDEX idx_employee_allocations_employee
ON employee_allocations(employee_id);

CREATE INDEX idx_employee_allocations_farm
ON employee_allocations(farm_id);

CREATE INDEX idx_employee_allocations_department
ON employee_allocations(department_id);

CREATE INDEX idx_employee_allocations_cost_center
ON employee_allocations(cost_center_id);

CREATE INDEX idx_employee_allocations_start_date
ON employee_allocations(start_date);

CREATE INDEX idx_employee_allocations_end_date
ON employee_allocations(end_date);

CREATE INDEX idx_employee_allocations_primary
ON employee_allocations(is_primary);



/******************************************************************************
*
*   TABELA: work_teams
*
*   RESPONSABILIDADE
*
*   Cadastro das equipes operacionais.
*
******************************************************************************/

CREATE TABLE work_teams (

    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    uuid CHAR(36) NOT NULL DEFAULT (UUID()),

    company_id BIGINT UNSIGNED NOT NULL,

    department_id BIGINT UNSIGNED NOT NULL,

    farm_id BIGINT UNSIGNED NULL,

    team_code VARCHAR(20) NOT NULL,

    team_name VARCHAR(120) NOT NULL,

    supervisor_employee_id BIGINT UNSIGNED NULL,

    is_active BOOLEAN NOT NULL DEFAULT TRUE,

    observations TEXT NULL,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    deleted_at TIMESTAMP NULL,

    created_by BIGINT UNSIGNED NULL,

    updated_by BIGINT UNSIGNED NULL,

    deleted_by BIGINT UNSIGNED NULL,

    CONSTRAINT uq_work_teams_uuid
        UNIQUE (uuid),

    CONSTRAINT uq_work_teams_code
        UNIQUE (
            company_id,
            team_code
        ),

    CONSTRAINT uq_work_teams_name
        UNIQUE (
            company_id,
            team_name
        ),

    CONSTRAINT chk_work_team_code
        CHECK (
            TRIM(team_code) <> ''
        ),

    CONSTRAINT chk_work_team_name
        CHECK (
            TRIM(team_name) <> ''
        ),

    CONSTRAINT fk_work_teams_company
        FOREIGN KEY (company_id)
        REFERENCES companies(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_work_teams_department
        FOREIGN KEY (department_id)
        REFERENCES departments(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_work_teams_farm
        FOREIGN KEY (farm_id)
        REFERENCES farms(id)
        ON UPDATE CASCADE
        ON DELETE SET NULL,

    CONSTRAINT fk_work_teams_supervisor
        FOREIGN KEY (supervisor_employee_id)
        REFERENCES employees(id)
        ON UPDATE CASCADE
        ON DELETE SET NULL

)

ENGINE=InnoDB

DEFAULT CHARSET=utf8mb4

COLLATE=utf8mb4_unicode_ci

COMMENT='Equipes operacionais.';


/******************************************************************************
    ÍNDICES
******************************************************************************/

CREATE INDEX idx_work_teams_company
ON work_teams(company_id);

CREATE INDEX idx_work_teams_department
ON work_teams(department_id);

CREATE INDEX idx_work_teams_farm
ON work_teams(farm_id);

CREATE INDEX idx_work_teams_supervisor
ON work_teams(supervisor_employee_id);

CREATE INDEX idx_work_teams_active
ON work_teams(is_active);


/******************************************************************************
*
*   TABELA: work_team_members
*
*   RESPONSABILIDADE
*
*   Histórico dos membros das equipes.
*
******************************************************************************/

CREATE TABLE work_team_members (

    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    uuid CHAR(36) NOT NULL DEFAULT (UUID()),

    work_team_id BIGINT UNSIGNED NOT NULL,

    employee_id BIGINT UNSIGNED NOT NULL,

    role_in_team VARCHAR(50) NULL,

    start_date DATE NOT NULL,

    end_date DATE NULL,

    is_leader BOOLEAN NOT NULL DEFAULT FALSE,

    observations TEXT NULL,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    created_by BIGINT UNSIGNED NULL,

    updated_by BIGINT UNSIGNED NULL,

    CONSTRAINT uq_work_team_members_uuid
        UNIQUE (uuid),

    CONSTRAINT chk_work_team_member_dates
        CHECK (

            end_date IS NULL

            OR

            end_date >= start_date

        ),

    CONSTRAINT fk_work_team_members_team
        FOREIGN KEY (work_team_id)
        REFERENCES work_teams(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_work_team_members_employee
        FOREIGN KEY (employee_id)
        REFERENCES employees(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE

)

ENGINE=InnoDB

DEFAULT CHARSET=utf8mb4

COLLATE=utf8mb4_unicode_ci

COMMENT='Histórico dos membros das equipes.';



/******************************************************************************
*
*   TABELA: work_team_members
*
*   RESPONSABILIDADE
*
*   Histórico dos membros das equipes.
*
******************************************************************************/

CREATE TABLE work_team_members (

    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    uuid CHAR(36) NOT NULL DEFAULT (UUID()),

    work_team_id BIGINT UNSIGNED NOT NULL,

    employee_id BIGINT UNSIGNED NOT NULL,

    role_in_team VARCHAR(50) NULL,

    start_date DATE NOT NULL,

    end_date DATE NULL,

    is_leader BOOLEAN NOT NULL DEFAULT FALSE,

    observations TEXT NULL,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    created_by BIGINT UNSIGNED NULL,

    updated_by BIGINT UNSIGNED NULL,

    CONSTRAINT uq_work_team_members_uuid
        UNIQUE (uuid),

    CONSTRAINT chk_work_team_member_dates
        CHECK (

            end_date IS NULL

            OR

            end_date >= start_date

        ),

    CONSTRAINT fk_work_team_members_team
        FOREIGN KEY (work_team_id)
        REFERENCES work_teams(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_work_team_members_employee
        FOREIGN KEY (employee_id)
        REFERENCES employees(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE

)

ENGINE=InnoDB

DEFAULT CHARSET=utf8mb4

COLLATE=utf8mb4_unicode_ci

COMMENT='Histórico dos membros das equipes.';


/******************************************************************************
    ÍNDICES
******************************************************************************/

CREATE INDEX idx_work_team_members_team
ON work_team_members(work_team_id);

CREATE INDEX idx_work_team_members_employee
ON work_team_members(employee_id);

CREATE INDEX idx_work_team_members_start
ON work_team_members(start_date);

CREATE INDEX idx_work_team_members_end
ON work_team_members(end_date);

CREATE INDEX idx_work_team_members_leader
ON work_team_members(is_leader);


/******************************************************************************
*
*   TABELA: employee_dependents
*
*   RESPONSABILIDADE
*
*   Armazena os dependentes dos funcionários.
*
******************************************************************************/

CREATE TABLE employee_dependents (

    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    uuid CHAR(36) NOT NULL DEFAULT (UUID()),

    employee_id BIGINT UNSIGNED NOT NULL,

    full_name VARCHAR(150) NOT NULL,

    relationship VARCHAR(30) NOT NULL,

    birth_date DATE NOT NULL,

    cpf CHAR(11) NULL,

    observations TEXT NULL,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    deleted_at TIMESTAMP NULL DEFAULT NULL,

    created_by BIGINT UNSIGNED NULL,

    updated_by BIGINT UNSIGNED NULL,

    deleted_by BIGINT UNSIGNED NULL,

    CONSTRAINT uq_employee_dependents_uuid
        UNIQUE (uuid),

    CONSTRAINT chk_employee_dependent_name
        CHECK (TRIM(full_name) <> ''),

    CONSTRAINT chk_employee_dependent_relationship
        CHECK (

            relationship IN (

                'SPOUSE',

                'CHILD',

                'FATHER',

                'MOTHER',

                'STEPCHILD',

                'OTHER'

            )

        ),

    CONSTRAINT chk_employee_dependent_cpf
        CHECK (
            cpf IS NULL
            OR CHAR_LENGTH(cpf) = 11
        ),

    CONSTRAINT fk_employee_dependents_employee
        FOREIGN KEY (employee_id)
        REFERENCES employees(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE

)

ENGINE=InnoDB

DEFAULT CHARSET=utf8mb4

COLLATE=utf8mb4_unicode_ci

COMMENT='Dependentes dos funcionários.';

/******************************************************************************
    ÍNDICES
******************************************************************************/

CREATE INDEX idx_employee_dependents_employee
ON employee_dependents(employee_id);

CREATE INDEX idx_employee_dependents_name
ON employee_dependents(full_name);

CREATE INDEX idx_employee_dependents_relationship
ON employee_dependents(relationship);

CREATE INDEX idx_employee_dependents_birth_date
ON employee_dependents(birth_date);

/******************************************************************************
*
*   TABELA: employee_bank_accounts
*
*   RESPONSABILIDADE
*
*   Armazena as contas bancárias dos funcionários.
*
******************************************************************************/

CREATE TABLE employee_bank_accounts (

    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    uuid CHAR(36) NOT NULL DEFAULT (UUID()),

    employee_id BIGINT UNSIGNED NOT NULL,

    bank_name VARCHAR(100) NOT NULL,

    account_type VARCHAR(20) NOT NULL,

    agency VARCHAR(20) NOT NULL,

    account_number VARCHAR(30) NOT NULL,

    pix_key_type VARCHAR(20) NULL,

    pix_key VARCHAR(255) NULL,

    is_primary BOOLEAN NOT NULL DEFAULT TRUE,

    observations TEXT NULL,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    deleted_at TIMESTAMP NULL DEFAULT NULL,

    created_by BIGINT UNSIGNED NULL,

    updated_by BIGINT UNSIGNED NULL,

    deleted_by BIGINT UNSIGNED NULL,

    CONSTRAINT uq_employee_bank_accounts_uuid
        UNIQUE (uuid),

    CONSTRAINT chk_employee_bank_account_type
        CHECK (

            account_type IN (

                'CHECKING',

                'SAVINGS',

                'SALARY',

                'OTHER'

            )

        ),

    CONSTRAINT chk_employee_bank_pix_type
        CHECK (

            pix_key_type IS NULL

            OR

            pix_key_type IN (

                'CPF',

                'CNPJ',

                'EMAIL',

                'PHONE',

                'RANDOM'

            )

        ),

    CONSTRAINT fk_employee_bank_accounts_employee
        FOREIGN KEY (employee_id)
        REFERENCES employees(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE

)

ENGINE=InnoDB

DEFAULT CHARSET=utf8mb4

COLLATE=utf8mb4_unicode_ci

COMMENT='Contas bancárias dos funcionários.';

/******************************************************************************
    ÍNDICES
******************************************************************************/

CREATE INDEX idx_employee_bank_accounts_employee
ON employee_bank_accounts(employee_id);

CREATE INDEX idx_employee_bank_accounts_primary
ON employee_bank_accounts(is_primary);

CREATE INDEX idx_employee_bank_accounts_bank
ON employee_bank_accounts(bank_name);


/******************************************************************************
*
*   TABELA: employee_salary_history
*
*   RESPONSABILIDADE
*
*   Armazena o histórico salarial dos funcionários.
*
******************************************************************************/

CREATE TABLE employee_salary_history (

    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    uuid CHAR(36) NOT NULL DEFAULT (UUID()),

    employee_id BIGINT UNSIGNED NOT NULL,

    salary DECIMAL(15,2) NOT NULL,

    effective_date DATE NOT NULL,

    reason VARCHAR(30) NOT NULL DEFAULT 'ADJUSTMENT',

    observations TEXT NULL,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    deleted_at TIMESTAMP NULL DEFAULT NULL,

    created_by BIGINT UNSIGNED NULL,

    updated_by BIGINT UNSIGNED NULL,

    deleted_by BIGINT UNSIGNED NULL,

    CONSTRAINT uq_employee_salary_history_uuid
        UNIQUE (uuid),

    CONSTRAINT chk_employee_salary
        CHECK (
            salary >= 0
        ),

    CONSTRAINT chk_employee_salary_reason
        CHECK (

            reason IN (

                'HIRING',

                'PROMOTION',

                'ADJUSTMENT',

                'TRANSFER',

                'BONUS',

                'OTHER'

            )

        ),

    CONSTRAINT fk_employee_salary_history_employee
        FOREIGN KEY (employee_id)
        REFERENCES employees(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE

)

ENGINE=InnoDB

DEFAULT CHARSET=utf8mb4

COLLATE=utf8mb4_unicode_ci

COMMENT='Histórico salarial dos funcionários.';


/******************************************************************************
    ÍNDICES
******************************************************************************/

CREATE INDEX idx_employee_salary_history_employee
ON employee_salary_history(employee_id);

CREATE INDEX idx_employee_salary_history_effective_date
ON employee_salary_history(effective_date);

CREATE INDEX idx_employee_salary_history_reason
ON employee_salary_history(reason);


