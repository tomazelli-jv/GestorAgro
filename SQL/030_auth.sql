/******************************************************************************
    TABELA: roles

    RESPONSABILIDADE

    Armazena os perfis de acesso disponíveis no sistema.

    Cada perfil representa um conjunto de permissões atribuídas aos usuários.

    Exemplos:

        • Administrador
        • Gerente
        • Agrônomo
        • Operador
        • Financeiro
        • Visualizador

    REGRAS

    • Cada perfil pertence a um Tenant.
    • O nome do perfil deve ser único dentro do Tenant.
    • Perfis não devem ser excluídos fisicamente.
    • Utilizar Soft Delete.

******************************************************************************/

CREATE TABLE roles (

    id                  BIGSERIAL PRIMARY KEY,

    uuid                UUID NOT NULL UNIQUE DEFAULT gen_random_uuid(),

    tenant_id           BIGINT NOT NULL,

    name                VARCHAR(100) NOT NULL,

    description         TEXT,

    active              BOOLEAN NOT NULL DEFAULT TRUE,

    created_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    updated_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    deleted_at          TIMESTAMPTZ,

    created_by          BIGINT,

    updated_by          BIGINT,

    deleted_by          BIGINT,

    CONSTRAINT chk_role_name
        CHECK (TRIM(name) <> ''),

    CONSTRAINT uq_roles_tenant_name
        UNIQUE (tenant_id, name),

    CONSTRAINT fk_roles_tenant
        FOREIGN KEY (tenant_id)
        REFERENCES tenants(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT

);


/******************************************************************************
    ÍNDICES
******************************************************************************/

CREATE INDEX idx_roles_tenant
ON roles (tenant_id);

CREATE INDEX idx_roles_name
ON roles (name);

CREATE INDEX idx_roles_active
ON roles (active);


/******************************************************************************
    TRIGGER

    Atualiza automaticamente o campo updated_at.

******************************************************************************/

CREATE TRIGGER trg_roles_updated_at

BEFORE UPDATE

ON roles

FOR EACH ROW

EXECUTE FUNCTION fn_update_updated_at();


/******************************************************************************
    COMENTÁRIOS DA TABELA
******************************************************************************/

COMMENT ON TABLE roles IS
'Perfis de acesso do sistema. Cada perfil agrupa um conjunto de permissões.';

COMMENT ON COLUMN roles.name IS
'Nome do perfil de acesso.';

COMMENT ON COLUMN roles.description IS
'Descrição detalhada da finalidade do perfil.';

COMMENT ON COLUMN roles.active IS
'Indica se o perfil está ativo para utilização.';


/******************************************************************************
    TABELA: system_modules

    RESPONSABILIDADE

    Armazena todos os módulos disponíveis no Gestor Agro.

    Esta tabela é utilizada para:

        • Organização do sistema
        • Controle de permissões
        • Construção dinâmica do menu
        • Controle de disponibilidade de módulos

    REGRAS

    • Os módulos são globais.
    • Não pertencem a um Tenant.
    • Não devem ser excluídos fisicamente.
    • Apenas usuários MASTER e DEV poderão alterá-los.

******************************************************************************/

CREATE TABLE system_modules (

    id                  BIGSERIAL PRIMARY KEY,

    uuid                UUID NOT NULL UNIQUE DEFAULT gen_random_uuid(),

    code                VARCHAR(100) NOT NULL UNIQUE,

    name                VARCHAR(150) NOT NULL,

    description         TEXT,

    icon                VARCHAR(100),

    menu_order          INTEGER NOT NULL DEFAULT 0,

    route               VARCHAR(200),

    active              BOOLEAN NOT NULL DEFAULT TRUE,

    created_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    updated_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT chk_module_code
        CHECK (TRIM(code) <> ''),

    CONSTRAINT chk_module_name
        CHECK (TRIM(name) <> '')

    parent_module_id BIGINT,
    is_visible BOOLEAN NOT NULL DEFAULT TRUE

);



/******************************************************************************
    ÍNDICES
******************************************************************************/

CREATE INDEX idx_system_modules_code
ON system_modules(code);

CREATE INDEX idx_system_modules_active
ON system_modules(active);

CREATE INDEX idx_system_modules_menu_order
ON system_modules(menu_order);



/******************************************************************************
    TRIGGER

    Atualiza automaticamente o campo updated_at.

******************************************************************************/

CREATE TRIGGER trg_system_modules_updated_at

BEFORE UPDATE

ON system_modules

FOR EACH ROW

EXECUTE FUNCTION fn_update_updated_at();



/******************************************************************************
    COMENTÁRIOS
******************************************************************************/

COMMENT ON TABLE system_modules IS
'Módulos disponíveis no sistema Gestor Agro.';

COMMENT ON COLUMN system_modules.code IS
'Código único utilizado internamente pelo sistema.';

COMMENT ON COLUMN system_modules.name IS
'Nome apresentado ao usuário.';

COMMENT ON COLUMN system_modules.icon IS
'Nome do ícone utilizado no frontend.';

COMMENT ON COLUMN system_modules.menu_order IS
'Ordem de exibição no menu lateral.';

COMMENT ON COLUMN system_modules.route IS
'Rota principal do módulo.';



/******************************************************************************
    TABELA: permission_actions

    RESPONSABILIDADE

    Armazena todas as ações possíveis que podem ser atribuídas
    às permissões do sistema.

    Esta tabela é global.

    Exemplos:

        • Visualizar
        • Adicionar
        • Alterar
        • Excluir
        • Aprovar
        • Exportar
        • Importar

******************************************************************************/

CREATE TABLE permission_actions (

    id                  BIGSERIAL PRIMARY KEY,

    uuid                UUID NOT NULL UNIQUE DEFAULT gen_random_uuid(),

    code                VARCHAR(50) NOT NULL UNIQUE,

    name                VARCHAR(100) NOT NULL,

    description         TEXT,

    active              BOOLEAN NOT NULL DEFAULT TRUE,

    display_order       INTEGER NOT NULL DEFAULT 0,

    created_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    updated_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT chk_permission_action_code
        CHECK (TRIM(code) <> ''),

    CONSTRAINT chk_permission_action_name
        CHECK (TRIM(name) <> '')

);



/******************************************************************************
    ÍNDICES
******************************************************************************/

CREATE INDEX idx_permission_actions_code
ON permission_actions(code);

CREATE INDEX idx_permission_actions_active
ON permission_actions(active);

CREATE INDEX idx_permission_actions_order
ON permission_actions(display_order);



/******************************************************************************
    TRIGGER
******************************************************************************/

CREATE TRIGGER trg_permission_actions_updated_at

BEFORE UPDATE

ON permission_actions

FOR EACH ROW

EXECUTE FUNCTION fn_update_updated_at();



/******************************************************************************
    COMENTÁRIOS
******************************************************************************/

COMMENT ON TABLE permission_actions IS
'Ações disponíveis para o sistema de permissões.';

COMMENT ON COLUMN permission_actions.code IS
'Código interno da ação.';

COMMENT ON COLUMN permission_actions.name IS
'Nome apresentado ao usuário.';

COMMENT ON COLUMN permission_actions.display_order IS
'Ordem de exibição na interface.';





/******************************************************************************
    TABELA: permissions

    RESPONSABILIDADE

    Armazena todas as permissões disponíveis no sistema.

    Cada permissão está vinculada a um módulo e representa
    uma ação que pode ser realizada.

    Exemplos:

        Fazenda
            • Visualizar
            • Adicionar
            • Alterar
            • Excluir

        Estoque
            • Visualizar
            • Adicionar
            • Alterar
            • Excluir

******************************************************************************/

CREATE TABLE permissions (

    id                  BIGSERIAL PRIMARY KEY,

    uuid                UUID NOT NULL UNIQUE DEFAULT gen_random_uuid(),

    module_id           BIGINT NOT NULL,

    action_id           BIGINT NOT NULL

    code                VARCHAR(150) NOT NULL UNIQUE,

    name                VARCHAR(150) NOT NULL,

    description         TEXT,

    active              BOOLEAN NOT NULL DEFAULT TRUE,

    created_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    updated_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    

    CONSTRAINT fk_permissions_action

    FOREIGN KEY (action_id)

    REFERENCES permission_actions(id)

    ON UPDATE CASCADE

    ON DELETE RESTRICT

    CONSTRAINT chk_permission_name
        CHECK (TRIM(name) <> ''),

    CONSTRAINT chk_permission_code
        CHECK (TRIM(code) <> ''),

    CONSTRAINT fk_permissions_module

        FOREIGN KEY (module_id)

        REFERENCES system_modules(id)

        ON UPDATE CASCADE

        ON DELETE RESTRICT

);


/******************************************************************************
    ÍNDICES
******************************************************************************/

CREATE INDEX idx_permissions_module
ON permissions(module_id);

CREATE INDEX idx_permissions_action
ON permissions(action);

CREATE INDEX idx_permissions_code
ON permissions(code);

CREATE INDEX idx_permissions_active
ON permissions(active);


/******************************************************************************
    TRIGGER

    Atualiza automaticamente o campo updated_at.

******************************************************************************/

CREATE TRIGGER trg_permissions_updated_at

BEFORE UPDATE

ON permissions

FOR EACH ROW

EXECUTE FUNCTION fn_update_updated_at();


/******************************************************************************
    COMENTÁRIOS
******************************************************************************/

COMMENT ON TABLE permissions IS
'Permissões disponíveis no sistema.';

COMMENT ON COLUMN permissions.module_id IS
'Módulo ao qual a permissão pertence.';

COMMENT ON COLUMN permissions.action IS
'Ação permitida dentro do módulo.';

COMMENT ON COLUMN permissions.code IS
'Código único utilizado pelo backend para validação da permissão.';

COMMENT ON COLUMN permissions.name IS
'Nome amigável apresentado ao usuário.';


/******************************************************************************
    TABELA: role_permissions

    RESPONSABILIDADE

    Relaciona os perfis (roles) às permissões do sistema.

    Esta tabela implementa o modelo RBAC (Role Based Access Control).

    Um perfil pode possuir diversas permissões.

    Uma permissão pode pertencer a diversos perfis.

******************************************************************************/

CREATE TABLE role_permissions (

    id                  BIGSERIAL PRIMARY KEY,

    role_id             BIGINT NOT NULL,

    permission_id       BIGINT NOT NULL,

    granted             BOOLEAN NOT NULL DEFAULT TRUE,

    created_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT uq_role_permission
        UNIQUE (role_id, permission_id),

    CONSTRAINT fk_role_permissions_role

        FOREIGN KEY (role_id)

        REFERENCES roles(id)

        ON UPDATE CASCADE

        ON DELETE CASCADE,

    CONSTRAINT fk_role_permissions_permission

        FOREIGN KEY (permission_id)

        REFERENCES permissions(id)

        ON UPDATE CASCADE

        ON DELETE CASCADE

);


/******************************************************************************
    ÍNDICES
******************************************************************************/

CREATE INDEX idx_role_permissions_role
ON role_permissions(role_id);

CREATE INDEX idx_role_permissions_permission
ON role_permissions(permission_id);



/******************************************************************************
    COMENTÁRIOS
******************************************************************************/

COMMENT ON TABLE role_permissions IS
'Relaciona os perfis às permissões do sistema.';

COMMENT ON COLUMN role_permissions.granted IS
'Indica se a permissão foi concedida ao perfil.'; 