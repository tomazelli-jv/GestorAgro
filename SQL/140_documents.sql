/******************************************************************************
*
*   TABELA: documents
*
*   RESPONSABILIDADE
*
*   Armazena documentos anexados aos registros do sistema.
*
******************************************************************************/

CREATE TABLE documents (

    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    uuid CHAR(36) NOT NULL DEFAULT (UUID()),

    farm_id BIGINT UNSIGNED NULL,

    module VARCHAR(50) NOT NULL,

    record_id BIGINT UNSIGNED NOT NULL,

    file_name VARCHAR(255) NOT NULL,

    original_name VARCHAR(255) NOT NULL,

    mime_type VARCHAR(100) NOT NULL,

    file_extension VARCHAR(20) NOT NULL,

    file_size BIGINT UNSIGNED NOT NULL,

    storage_path VARCHAR(500) NOT NULL,

    observations TEXT NULL,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    created_by BIGINT UNSIGNED NULL,

    CONSTRAINT uq_documents_uuid
        UNIQUE (uuid),

    CONSTRAINT chk_documents_module
        CHECK (
            TRIM(module) <> ''
        ),

    CONSTRAINT chk_documents_file_name
        CHECK (
            TRIM(file_name) <> ''
        ),

    CONSTRAINT chk_documents_original_name
        CHECK (
            TRIM(original_name) <> ''
        ),

    CONSTRAINT chk_documents_storage_path
        CHECK (
            TRIM(storage_path) <> ''
        ),

    CONSTRAINT chk_documents_file_size
        CHECK (
            file_size > 0
        ),

    CONSTRAINT fk_documents_farm
        FOREIGN KEY (farm_id)
        REFERENCES farms(id)
        ON UPDATE CASCADE
        ON DELETE SET NULL

)

ENGINE=InnoDB

DEFAULT CHARSET=utf8mb4

COLLATE=utf8mb4_unicode_ci

COMMENT='Documentos anexados aos registros do sistema.';

/******************************************************************************
    ÍNDICES
******************************************************************************/

CREATE INDEX idx_documents_module_record
ON documents(module, record_id);

CREATE INDEX idx_documents_farm
ON documents(farm_id);

CREATE INDEX idx_documents_created_at
ON documents(created_at);
