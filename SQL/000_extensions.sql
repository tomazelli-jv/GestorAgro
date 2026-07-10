/*
===============================================================================
PROJETO.............: GESTOR AGRO
MÓDULO..............: EXTENSIONS
ARQUIVO.............: 000_extensions.sql
VERSÃO..............: 1.0.0

AUTOR...............: João Victor Tomazelli
ARQUITETURA.........: PostgreSQL 17
ÚLTIMA ALTERAÇÃO....: 10/07/2026

DESCRIÇÃO
-------------------------------------------------------------------------------
Este módulo instala todas as extensões necessárias para o funcionamento do
Gestor Agro.

As extensões são instaladas apenas uma vez por banco de dados.

Todos os demais módulos dependem deste.

===============================================================================
*/


/******************************************************************************
    EXTENSÃO: pgcrypto

    RESPONSABILIDADE

    Disponibiliza funções criptográficas para o PostgreSQL.

    Utilizada principalmente para:

    • gen_random_uuid()
    • Criptografia
    • Hashes

******************************************************************************/

CREATE EXTENSION IF NOT EXISTS pgcrypto;


/******************************************************************************
    EXTENSÃO: uuid-ossp

    RESPONSABILIDADE

    Disponibiliza funções alternativas para geração de UUID.

    Atualmente utilizaremos principalmente o pgcrypto, porém esta extensão é
    mantida instalada para compatibilidade futura.

******************************************************************************/

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";


/******************************************************************************
    EXTENSÃO: citext

    RESPONSABILIDADE

    Tipo de dado "Case Insensitive Text".

    Permite comparações sem diferenciação entre maiúsculas e minúsculas.

    Exemplos:

        joao@email.com
        JOAO@email.com

    Ambos serão considerados iguais.

******************************************************************************/

CREATE EXTENSION IF NOT EXISTS citext;


/******************************************************************************
    EXTENSÃO: unaccent

    RESPONSABILIDADE

    Remove acentos durante pesquisas.

    Exemplos:

        João
        Joao

    Produzem o mesmo resultado em consultas.

******************************************************************************/

CREATE EXTENSION IF NOT EXISTS unaccent;


/******************************************************************************
    EXTENSÃO: pg_trgm

    RESPONSABILIDADE

    Melhora pesquisas por similaridade de texto.

    Utilizada para:

    • Busca inteligente
    • Autocomplete
    • Pesquisa por nome
    • Pesquisa por produtos

******************************************************************************/

CREATE EXTENSION IF NOT EXISTS pg_trgm;


/******************************************************************************
    DECISÕES DE ARQUITETURA

    • Todas as extensões são instaladas utilizando
      CREATE EXTENSION IF NOT EXISTS.

    • Isso permite executar o script várias vezes sem gerar erro.

    • Novas extensões deverão ser adicionadas apenas neste arquivo.

******************************************************************************/

/*
===============================================================================

FIM DO MÓDULO 000

Próximo:

001_functions.sql

===============================================================================
*/