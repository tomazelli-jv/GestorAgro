
database

000_database.sql                ← Configuração do banco
001_functions.sql               ← Functions e Triggers comuns
010_core.sql                    ← Estrutura principal do sistema

020_reference_data.sql          ← Países, estados, cidades...

030_auth.sql                    ← Autenticação

040_farms.sql                   ← Fazendas

050_fields.sql                  ← Talhões

060_pastures.sql                ← Pastos

070_livestock.sql               ← Pecuária

080_agriculture.sql             ← Agricultura

090_inventory.sql               ← Estoque

100_financial.sql               ← Financeiro

110_reports.sql                 ← Relatórios

900_seed_reference.sql

910_seed_auth.sql

920_seed_system.sql



Farms

↓

Talhões

    ↓
    Culturas
    Plantios
    Safras
    Colheitas

↓

Pastos

    ↓
    Piquetes
    Pastejo
    Lotação