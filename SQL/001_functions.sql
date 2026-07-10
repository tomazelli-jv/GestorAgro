/*
===============================================================================
PROJETO.............: GESTOR AGRO
MÓDULO..............: FUNCTIONS
ARQUIVO.............: 001_functions.sql
VERSÃO..............: 1.0.0

AUTOR...............: João Victor Tomazelli
ARQUITETURA.........: PostgreSQL 17
ÚLTIMA ALTERAÇÃO....: 10/07/2026

DEPENDÊNCIAS........:
    • 000_extensions.sql

DESCRIÇÃO
-------------------------------------------------------------------------------
Este módulo concentra todas as funções reutilizáveis do banco de dados.

Nenhum módulo deverá criar funções próprias sem necessidade.

Caso uma função possa ser reutilizada por outros módulos,
ela deverá ser adicionada neste arquivo.

===============================================================================
*/


/******************************************************************************
    FUNÇÃO: fn_update_updated_at()

    RESPONSABILIDADE

    Atualiza automaticamente a coluna updated_at antes de qualquer UPDATE.

******************************************************************************/

CREATE OR REPLACE FUNCTION fn_update_updated_at()

RETURNS TRIGGER

LANGUAGE plpgsql

AS $$

BEGIN

    NEW.updated_at = NOW();

    RETURN NEW;

END;

$$;



/******************************************************************************
    FUNÇÃO: fn_generate_uuid()

    RESPONSABILIDADE

    Centraliza a geração de UUID.

    Caso futuramente seja necessário alterar a forma de geração,
    apenas esta função precisará ser modificada.

******************************************************************************/

CREATE OR REPLACE FUNCTION fn_generate_uuid()

RETURNS UUID

LANGUAGE sql

AS $$

    SELECT gen_random_uuid();

$$;



/******************************************************************************
    FUNÇÃO: fn_soft_delete()

    RESPONSABILIDADE

    Padroniza o Soft Delete.

    Atualmente utilizada apenas como base para futuras implementações.

******************************************************************************/

CREATE OR REPLACE FUNCTION fn_soft_delete()

RETURNS TIMESTAMPTZ

LANGUAGE sql

AS $$

    SELECT NOW();

$$;



/******************************************************************************
    COMENTÁRIOS DAS FUNÇÕES
******************************************************************************/

COMMENT ON FUNCTION fn_update_updated_at()
IS 'Atualiza automaticamente a coluna updated_at antes de um UPDATE.';

COMMENT ON FUNCTION fn_generate_uuid()
IS 'Retorna um UUID utilizando a estratégia padrão do sistema.';

COMMENT ON FUNCTION fn_soft_delete()
IS 'Retorna a data/hora utilizada para marcação de exclusão lógica.';



/******************************************************************************
    DECISÕES DE ARQUITETURA

    • Todas as funções compartilhadas deverão ficar neste módulo.

    • Nenhum módulo deverá duplicar funções.

    • As funções deverão possuir prefixo "fn_".

******************************************************************************/

/*
===============================================================================

FIM DO MÓDULO 001

Próximo:

002_triggers.sql

===============================================================================
*/