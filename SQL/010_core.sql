/*
===============================================================================
PROJETO.............: GESTOR AGRO
MÓDULO..............: CORE
ARQUIVO.............: 001_core.sql
VERSÃO..............: 1.0.0

AUTOR...............: João Victor Tomazelli
ARQUITETURA.........: PostgreSQL 17
ÚLTIMA ALTERAÇÃO....: 10/07/2026

DEPENDÊNCIAS........:
    • 000_extensions.sql

PRÓXIMO MÓDULO......:
    • 002_auth.sql

DESCRIÇÃO
-------------------------------------------------------------------------------
Este módulo cria toda a infraestrutura principal do sistema.

Responsável por:

• Empresas (Tenants)
• Configurações
• Auditoria
• Logs
• Configurações Globais

Todos os demais módulos dependem deste.

===============================================================================
*/


/******************************************************************************
    TABELA: tenants

    RESPONSABILIDADE

    Representa uma empresa cliente do sistema.

    Cada empresa poderá possuir:

        • usuários
        • fazendas
        • produtos
        • estoque
        • financeiro
        • funcionários
        • máquinas
        • relatórios

    REGRAS

    • Nunca excluir fisicamente.
    • Utilizar Soft Delete.
    • UUID utilizado para API pública.
    • BIGSERIAL utilizado para performance.

******************************************************************************/

CREATE TABLE tenants (

    id                  BIGSERIAL PRIMARY KEY,

    uuid                UUID NOT NULL UNIQUE DEFAULT gen_random_uuid(),

    company_name        VARCHAR(200) NOT NULL,

    trade_name          VARCHAR(200),

    document            VARCHAR(20) UNIQUE,

    email               VARCHAR(150),

    phone               VARCHAR(30),

    active              BOOLEAN NOT NULL DEFAULT TRUE,

    created_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    updated_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    deleted_at          TIMESTAMPTZ,

    created_by          BIGINT,

    updated_by          BIGINT,

    deleted_by          BIGINT,

    CONSTRAINT chk_company_name
        CHECK (TRIM(company_name) <> '')

);

/******************************************************************************
    TRIGGER: trg_update_updated_at

    RESPONSABILIDADE

    Atualiza automaticamente a coluna updated_at antes de um UPDATE.
******************************************************************************/

CREATE TRIGGER trg_update_tenants

BEFORE UPDATE

ON tenants

FOR EACH ROW

EXECUTE FUNCTION fn_update_updated_at();


/******************************************************************************
    TABELA: tenant_settings

    RESPONSABILIDADE

    Configurações individuais de cada empresa.

******************************************************************************/

CREATE TABLE tenant_settings (

    id                  BIGSERIAL PRIMARY KEY,

    tenant_id           BIGINT NOT NULL,

    timezone            VARCHAR(60)
                            DEFAULT 'America/Sao_Paulo',

    language            VARCHAR(10)
                            DEFAULT 'pt-BR',

    currency            VARCHAR(10)
                            DEFAULT 'BRL',

    theme               VARCHAR(20)
                            DEFAULT 'light',

    created_at          TIMESTAMPTZ DEFAULT NOW(),

    updated_at          TIMESTAMPTZ DEFAULT NOW(),

    created_by          BIGINT,

    updated_by          BIGINT,

    CONSTRAINT chk_language
        CHECK (
            language IN (
                'pt-BR',
                'en-US',
                'es-ES'
            )
        ),

    CONSTRAINT fk_tenant_settings_tenant

        FOREIGN KEY (tenant_id)

        REFERENCES tenants(id)

        ON DELETE CASCADE

);

/******************************************************************************
   
    TRIGGER: trg_update_settings_tenant

    RESPONSABILIDADE

    Atualiza automaticamente a tabela settings_tenant antes de um UPDATE.

******************************************************************************/

CREATE TRIGGER trg_update_tenant_settings

BEFORE UPDATE

ON tenant_settings

FOR EACH ROW

EXECUTE FUNCTION fn_update_updated_at();

/******************************************************************************
    TABELA: audit_logs

    RESPONSABILIDADE

    Armazena toda alteração realizada pelos usuários.

******************************************************************************/

CREATE TABLE audit_logs (

    id                  BIGSERIAL PRIMARY KEY,

    tenant_id           BIGINT NOT NULL,

    user_id             BIGINT,

    table_name          VARCHAR(100),

    record_id           BIGINT,

    action              VARCHAR(30),

    ip_address          VARCHAR(50),

    user_agent          TEXT,

    old_data            JSONB,

    new_data            JSONB,

    created_at          TIMESTAMPTZ DEFAULT NOW()

);



/******************************************************************************
    TABELA: application_logs

    RESPONSABILIDADE

    Logs internos da aplicação.

******************************************************************************/

CREATE TABLE application_logs (

    id                  BIGSERIAL PRIMARY KEY,

    level               VARCHAR(20),

    module              VARCHAR(100),

    message             TEXT,

    details             JSONB,

    created_at          TIMESTAMPTZ DEFAULT NOW()

);



/******************************************************************************
    TABELA: system_settings

    RESPONSABILIDADE

    Configurações globais da aplicação.

******************************************************************************/

CREATE TABLE system_settings (

    id                  BIGSERIAL PRIMARY KEY,

    setting_key         VARCHAR(100) UNIQUE,

    setting_value       TEXT,

    description         TEXT

);



/******************************************************************************
    ÍNDICES
******************************************************************************/

CREATE INDEX idx_tenants_document
ON tenants(document);

CREATE INDEX idx_tenants_company
ON tenants(company_name);

CREATE INDEX idx_audit_tenant
ON audit_logs(tenant_id);

CREATE INDEX idx_audit_user
ON audit_logs(user_id);

CREATE INDEX idx_logs_module
ON application_logs(module);




/******************************************************************************
    COMENTÁRIOS DAS TABELAS
******************************************************************************/

COMMENT ON TABLE tenants IS
'Empresas clientes do sistema (Multi-Tenant).';

COMMENT ON TABLE tenant_settings IS
'Configurações individuais de cada empresa.';

COMMENT ON TABLE audit_logs IS
'Auditoria completa de alterações realizadas pelos usuários.';

COMMENT ON TABLE application_logs IS
'Logs internos da aplicação.';

COMMENT ON TABLE system_settings IS
'Configurações globais da aplicação.';



/******************************************************************************
    COMENTÁRIOS DAS COLUNAS
******************************************************************************/

COMMENT ON COLUMN tenants.uuid IS
'UUID público utilizado pela API.';

COMMENT ON COLUMN tenants.company_name IS
'Razão Social da empresa.';

COMMENT ON COLUMN tenants.trade_name IS
'Nome Fantasia da empresa.';

COMMENT ON COLUMN tenants.document IS
'CNPJ ou CPF.';

COMMENT ON COLUMN tenants.active IS
'Indica se a empresa está ativa no sistema.';

COMMENT ON COLUMN tenant_settings.timezone IS
'Fuso horário utilizado pela empresa.';

COMMENT ON COLUMN tenant_settings.language IS
'Idioma padrão da empresa.';

COMMENT ON COLUMN tenant_settings.currency IS
'Moeda padrão utilizada.';



/******************************************************************************
    DECISÕES DE ARQUITETURA

    • BIGSERIAL para melhor performance.
    • UUID para exposição pública.
    • Soft Delete em tabelas principais.
    • TIMESTAMPTZ em todas as datas.
    • JSONB para auditoria.
    • Índices criados junto das tabelas.
    • Trigger automática para updated_at.
******************************************************************************/

/*
===============================================================================

FIM DO MÓDULO 001

Próximo:

002_auth.sql

===============================================================================
*/