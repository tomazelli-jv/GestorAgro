/******************************************************************************
*
*   GESTOR AGRO
*
*   SCRIPT.......: 000_init.sql
*   RESPONSÁVEL..: Inicialização do banco de dados
*   BANCO........: MySQL 8+
*   ENGINE.......: InnoDB
*
*   DESCRIÇÃO
*
*   Este script prepara o banco de dados para receber
*   todos os demais módulos do sistema.
*
*   Ele deve ser executado apenas uma vez.
*
******************************************************************************/

/******************************************************************************
    CONFIGURAÇÕES DA SESSÃO
******************************************************************************/

SET NAMES utf8mb4;

SET time_zone = '-03:00';


/******************************************************************************
    TABELA: database_migrations

    RESPONSABILIDADE

    Controla todos os scripts SQL executados
    no banco de dados.

******************************************************************************/

CREATE TABLE database_migrations (

    id                  BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    version             VARCHAR(20) NOT NULL,

    script_name         VARCHAR(255) NOT NULL,

    checksum            CHAR(64),

    execution_time_ms   INT UNSIGNED,

    executed_at         TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    executed_by         VARCHAR(100),

    CONSTRAINT uq_database_migrations_version
        UNIQUE (version)

)
ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_unicode_ci
COMMENT='Controle de execução das migrações do banco de dados.';

/*--------------------------------------------------------------------------------
    INDICES
--------------------------------------------------------------------------------*/

CREATE INDEX idx_database_migrations_executed_at
ON database_migrations(executed_at);

/******************************************************************************
    FIM DO SCRIPT

    Próximo arquivo:

    001_functions.sql

******************************************************************************/