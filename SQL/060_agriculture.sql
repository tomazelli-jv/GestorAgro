/******************************************************************************
*
*   TABELA: crops
*
*   RESPONSABILIDADE
*
*   Armazena as culturas agrícolas utilizadas pelas fazendas.
*
******************************************************************************/

CREATE TABLE crops (

    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    uuid CHAR(36) NOT NULL DEFAULT (UUID()),

    farm_id BIGINT UNSIGNED NOT NULL,

    code VARCHAR(30) NOT NULL,

    name VARCHAR(150) NOT NULL,

    scientific_name VARCHAR(200) NULL,

    description TEXT NULL,

    cycle_days SMALLINT UNSIGNED NULL,

    is_perennial BOOLEAN NOT NULL DEFAULT FALSE,

    is_active BOOLEAN NOT NULL DEFAULT TRUE,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    deleted_at TIMESTAMP NULL DEFAULT NULL,

    created_by BIGINT UNSIGNED NULL,

    updated_by BIGINT UNSIGNED NULL,

    deleted_by BIGINT UNSIGNED NULL,

    CONSTRAINT uq_crops_uuid
        UNIQUE (uuid),

    CONSTRAINT uq_crops_code
        UNIQUE (farm_id, code),

    CONSTRAINT uq_crops_name
        UNIQUE (farm_id, name),

    CONSTRAINT chk_crops_code
        CHECK (TRIM(code) <> ''),

    CONSTRAINT chk_crops_name
        CHECK (TRIM(name) <> ''),

    CONSTRAINT fk_crops_farm
        FOREIGN KEY (farm_id)
        REFERENCES farms(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE

)

ENGINE=InnoDB

DEFAULT CHARSET=utf8mb4

COLLATE=utf8mb4_unicode_ci

COMMENT='Culturas agrícolas cadastradas na fazenda.';


/******************************************************************************
    ÍNDICES
******************************************************************************/

CREATE INDEX idx_crops_farm
ON crops(farm_id);

CREATE INDEX idx_crops_code
ON crops(code);

CREATE INDEX idx_crops_name
ON crops(name);

CREATE INDEX idx_crops_active
ON crops(is_active);

CREATE INDEX idx_crops_perennial
ON crops(is_perennial);


/******************************************************************************
*
*   TABELA: crop_seasons
*
*   RESPONSABILIDADE
*
*   Armazena as safras agrícolas das fazendas.
*
******************************************************************************/

CREATE TABLE crop_seasons (

    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    uuid CHAR(36) NOT NULL DEFAULT (UUID()),

    farm_id BIGINT UNSIGNED NOT NULL,

    code VARCHAR(30) NOT NULL,

    name VARCHAR(150) NOT NULL,

    season_type VARCHAR(30) NOT NULL,

    start_date DATE NOT NULL,

    end_date DATE NOT NULL,

    is_current BOOLEAN NOT NULL DEFAULT FALSE,

    is_active BOOLEAN NOT NULL DEFAULT TRUE,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    deleted_at TIMESTAMP NULL DEFAULT NULL,

    created_by BIGINT UNSIGNED NULL,

    updated_by BIGINT UNSIGNED NULL,

    deleted_by BIGINT UNSIGNED NULL,

    CONSTRAINT uq_crop_seasons_uuid
        UNIQUE (uuid),

    CONSTRAINT uq_crop_seasons_code
        UNIQUE (farm_id, code),

    CONSTRAINT uq_crop_seasons_name
        UNIQUE (farm_id, name),

    CONSTRAINT chk_crop_seasons_code
        CHECK (TRIM(code) <> ''),

    CONSTRAINT chk_crop_seasons_name
        CHECK (TRIM(name) <> ''),

    CONSTRAINT chk_crop_season_dates
        CHECK (end_date >= start_date),

    CONSTRAINT chk_crop_season_type
        CHECK (

            season_type IN (

                'MAIN',

                'SECOND',

                'SUMMER',

                'WINTER',

                'PERENNIAL',

                'OTHER'

            )

        ),

    CONSTRAINT fk_crop_seasons_farm
        FOREIGN KEY (farm_id)
        REFERENCES farms(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE

)

ENGINE=InnoDB

DEFAULT CHARSET=utf8mb4

COLLATE=utf8mb4_unicode_ci

COMMENT='Safras agrícolas.';


/******************************************************************************
    ÍNDICES
******************************************************************************/

CREATE INDEX idx_crop_seasons_farm
ON crop_seasons(farm_id);

CREATE INDEX idx_crop_seasons_code
ON crop_seasons(code);

CREATE INDEX idx_crop_seasons_name
ON crop_seasons(name);

CREATE INDEX idx_crop_seasons_dates
ON crop_seasons(start_date, end_date);

CREATE INDEX idx_crop_seasons_current
ON crop_seasons(is_current);

CREATE INDEX idx_crop_seasons_active
ON crop_seasons(is_active);


/******************************************************************************
*
*   TABELA: fields
*
*   RESPONSABILIDADE
*
*   Armazena os talhões pertencentes às fazendas.
*
******************************************************************************/

CREATE TABLE fields (

    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    uuid CHAR(36) NOT NULL DEFAULT (UUID()),

    farm_id BIGINT UNSIGNED NOT NULL,

    code VARCHAR(30) NOT NULL,

    name VARCHAR(150) NOT NULL,

    description VARCHAR(255) NULL,

    total_area DECIMAL(12,4) NOT NULL,

    cultivable_area DECIMAL(12,4) NOT NULL,

    altitude DECIMAL(8,2) NULL,

    slope DECIMAL(5,2) NULL,

    soil_type VARCHAR(100) NULL,

    irrigation_type VARCHAR(50) NULL,

    is_irrigated BOOLEAN NOT NULL DEFAULT FALSE,

    is_active BOOLEAN NOT NULL DEFAULT TRUE,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    deleted_at TIMESTAMP NULL DEFAULT NULL,

    created_by BIGINT UNSIGNED NULL,

    updated_by BIGINT UNSIGNED NULL,

    deleted_by BIGINT UNSIGNED NULL,

    CONSTRAINT uq_fields_uuid
        UNIQUE (uuid),

    CONSTRAINT uq_fields_code
        UNIQUE (farm_id, code),

    CONSTRAINT uq_fields_name
        UNIQUE (farm_id, name),

    CONSTRAINT chk_fields_code
        CHECK (TRIM(code) <> ''),

    CONSTRAINT chk_fields_name
        CHECK (TRIM(name) <> ''),

    CONSTRAINT chk_fields_total_area
        CHECK (total_area > 0),

    CONSTRAINT chk_fields_cultivable_area
        CHECK (
            cultivable_area >= 0
            AND cultivable_area <= total_area
        ),

    CONSTRAINT chk_fields_altitude
        CHECK (
            altitude IS NULL
            OR altitude >= 0
        ),

    CONSTRAINT chk_fields_slope
        CHECK (
            slope IS NULL
            OR (
                slope >= 0
                AND slope <= 100
            )
        ),

    CONSTRAINT fk_fields_farm
        FOREIGN KEY (farm_id)
        REFERENCES farms(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE

)

ENGINE=InnoDB

DEFAULT CHARSET=utf8mb4

COLLATE=utf8mb4_unicode_ci

COMMENT='Talhões da fazenda.';


/******************************************************************************
    ÍNDICES
******************************************************************************/

CREATE INDEX idx_fields_farm
ON fields(farm_id);

CREATE INDEX idx_fields_code
ON fields(code);

CREATE INDEX idx_fields_name
ON fields(name);

CREATE INDEX idx_fields_active
ON fields(is_active);

CREATE INDEX idx_fields_irrigated
ON fields(is_irrigated);


/******************************************************************************
*
*   TABELA: field_boundaries
*
*   RESPONSABILIDADE
*
*   Armazena os limites geográficos dos talhões.
*
******************************************************************************/

CREATE TABLE field_boundaries (

    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    uuid CHAR(36) NOT NULL DEFAULT (UUID()),

    field_id BIGINT UNSIGNED NOT NULL,

    boundary_name VARCHAR(150) NOT NULL,

    geometry_format VARCHAR(20) NOT NULL,

    geometry_data LONGTEXT NOT NULL,

    area_hectares DECIMAL(12,4) NULL,

    perimeter_meters DECIMAL(12,2) NULL,

    version_number INT UNSIGNED NOT NULL DEFAULT 1,

    is_current BOOLEAN NOT NULL DEFAULT TRUE,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    created_by BIGINT UNSIGNED NULL,

    CONSTRAINT uq_field_boundaries_uuid
        UNIQUE (uuid),

    CONSTRAINT chk_field_boundary_name
        CHECK (TRIM(boundary_name) <> ''),

    CONSTRAINT chk_field_boundary_geometry
        CHECK (
            geometry_format IN (
                'GEOJSON',
                'KML',
                'WKT',
                'SHAPEFILE'
            )
        ),

    CONSTRAINT fk_field_boundaries_field
        FOREIGN KEY (field_id)
        REFERENCES fields(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE

)

ENGINE=InnoDB

DEFAULT CHARSET=utf8mb4

COLLATE=utf8mb4_unicode_ci

COMMENT='Limites geográficos dos talhões.';


/******************************************************************************
    ÍNDICES
******************************************************************************/

CREATE INDEX idx_field_boundaries_field
ON field_boundaries(field_id);

CREATE INDEX idx_field_boundaries_current
ON field_boundaries(is_current);

CREATE INDEX idx_field_boundaries_version
ON field_boundaries(version_number);

CREATE INDEX idx_field_boundaries_format
ON field_boundaries(geometry_format);


/******************************************************************************
*
*   TABELA: cultivars
*
*   RESPONSABILIDADE
*
*   Armazena as cultivares (variedades/híbridos) das culturas.
*
******************************************************************************/

CREATE TABLE cultivars (

    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    uuid CHAR(36) NOT NULL DEFAULT (UUID()),

    farm_id BIGINT UNSIGNED NOT NULL,

    crop_id BIGINT UNSIGNED NOT NULL,

    code VARCHAR(30) NOT NULL,

    name VARCHAR(200) NOT NULL,

    commercial_name VARCHAR(200) NULL,

    manufacturer VARCHAR(150) NULL,

    maturity_group VARCHAR(30) NULL,

    cycle_days SMALLINT UNSIGNED NULL,

    technology VARCHAR(100) NULL,

    recommended_population INT UNSIGNED NULL,

    notes TEXT NULL,

    is_active BOOLEAN NOT NULL DEFAULT TRUE,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    deleted_at TIMESTAMP NULL DEFAULT NULL,

    created_by BIGINT UNSIGNED NULL,

    updated_by BIGINT UNSIGNED NULL,

    deleted_by BIGINT UNSIGNED NULL,

    CONSTRAINT uq_cultivars_uuid
        UNIQUE (uuid),

    CONSTRAINT uq_cultivars_code
        UNIQUE (farm_id, code),

    CONSTRAINT uq_cultivars_name
        UNIQUE (farm_id, crop_id, name),

    CONSTRAINT chk_cultivars_code
        CHECK (TRIM(code) <> ''),

    CONSTRAINT chk_cultivars_name
        CHECK (TRIM(name) <> ''),

    CONSTRAINT chk_cultivars_cycle
        CHECK (
            cycle_days IS NULL
            OR cycle_days > 0
        ),

    CONSTRAINT chk_cultivars_population
        CHECK (
            recommended_population IS NULL
            OR recommended_population > 0
        ),

    CONSTRAINT fk_cultivars_farm
        FOREIGN KEY (farm_id)
        REFERENCES farms(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_cultivars_crop
        FOREIGN KEY (crop_id)
        REFERENCES crops(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT

)

ENGINE=InnoDB

DEFAULT CHARSET=utf8mb4

COLLATE=utf8mb4_unicode_ci

COMMENT='Cultivares das culturas agrícolas.';


/******************************************************************************
    ÍNDICES
******************************************************************************/

CREATE INDEX idx_cultivars_farm
ON cultivars(farm_id);

CREATE INDEX idx_cultivars_crop
ON cultivars(crop_id);

CREATE INDEX idx_cultivars_code
ON cultivars(code);

CREATE INDEX idx_cultivars_name
ON cultivars(name);

CREATE INDEX idx_cultivars_active
ON cultivars(is_active);

CREATE INDEX idx_cultivars_manufacturer
ON cultivars(manufacturer);


/******************************************************************************
*
*   TABELA: plantings
*
*   RESPONSABILIDADE
*
*   Armazena os plantios realizados nos talhões.
*
******************************************************************************/

CREATE TABLE plantings (

    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    uuid CHAR(36) NOT NULL DEFAULT (UUID()),

    farm_id BIGINT UNSIGNED NOT NULL,

    crop_season_id BIGINT UNSIGNED NOT NULL,

    field_id BIGINT UNSIGNED NOT NULL,

    crop_id BIGINT UNSIGNED NOT NULL,

    cultivar_id BIGINT UNSIGNED NOT NULL,

    planting_code VARCHAR(30) NOT NULL,

    planting_date DATE NOT NULL,

    expected_harvest_date DATE NULL,

    actual_harvest_date DATE NULL,

    planted_area DECIMAL(12,4) NOT NULL,

    row_spacing DECIMAL(6,2) NULL,

    plant_spacing DECIMAL(6,2) NULL,

    seed_density DECIMAL(10,2) NULL,

    expected_population INT UNSIGNED NULL,

    emergence_date DATE NULL,

    status VARCHAR(20) NOT NULL DEFAULT 'PLANNED',

    observations TEXT NULL,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    deleted_at TIMESTAMP NULL DEFAULT NULL,

    created_by BIGINT UNSIGNED NULL,

    updated_by BIGINT UNSIGNED NULL,

    deleted_by BIGINT UNSIGNED NULL,

    CONSTRAINT uq_plantings_uuid
        UNIQUE (uuid),

    CONSTRAINT uq_planting_code
        UNIQUE (farm_id, planting_code),

    CONSTRAINT chk_planting_code
        CHECK (TRIM(planting_code) <> ''),

    CONSTRAINT chk_planted_area
        CHECK (planted_area > 0),

    CONSTRAINT chk_planting_status
        CHECK (

            status IN (

                'PLANNED',

                'PLANTED',

                'EMERGED',

                'DEVELOPMENT',

                'HARVESTED',

                'CANCELLED'

            )

        ),

    CONSTRAINT chk_expected_dates
        CHECK (
            expected_harvest_date IS NULL
            OR expected_harvest_date >= planting_date
        ),

    CONSTRAINT chk_actual_dates
        CHECK (
            actual_harvest_date IS NULL
            OR actual_harvest_date >= planting_date
        ),

    CONSTRAINT fk_plantings_farm
        FOREIGN KEY (farm_id)
        REFERENCES farms(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_plantings_crop_season
        FOREIGN KEY (crop_season_id)
        REFERENCES crop_seasons(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_plantings_field
        FOREIGN KEY (field_id)
        REFERENCES fields(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_plantings_crop
        FOREIGN KEY (crop_id)
        REFERENCES crops(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_plantings_cultivar
        FOREIGN KEY (cultivar_id)
        REFERENCES cultivars(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT

)

ENGINE=InnoDB

DEFAULT CHARSET=utf8mb4

COLLATE=utf8mb4_unicode_ci

COMMENT='Plantios realizados na fazenda.';


/******************************************************************************
    ÍNDICES
******************************************************************************/

CREATE INDEX idx_plantings_farm
ON plantings(farm_id);

CREATE INDEX idx_plantings_crop_season
ON plantings(crop_season_id);

CREATE INDEX idx_plantings_field
ON plantings(field_id);

CREATE INDEX idx_plantings_crop
ON plantings(crop_id);

CREATE INDEX idx_plantings_cultivar
ON plantings(cultivar_id);

CREATE INDEX idx_plantings_date
ON plantings(planting_date);

CREATE INDEX idx_plantings_status
ON plantings(status);


/******************************************************************************
*
*   TABELA: applications
*
*   RESPONSABILIDADE
*
*   Armazena o cabeçalho das aplicações agrícolas.
*
******************************************************************************/

CREATE TABLE applications (

    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    uuid CHAR(36) NOT NULL DEFAULT (UUID()),

    farm_id BIGINT UNSIGNED NOT NULL,

    planting_id BIGINT UNSIGNED NOT NULL,

    application_number VARCHAR(30) NOT NULL,

    application_type VARCHAR(30) NOT NULL,

    application_date DATE NOT NULL,

    start_time TIME NULL,

    end_time TIME NULL,

    status VARCHAR(20) NOT NULL DEFAULT 'PLANNED',

    weather_conditions VARCHAR(255) NULL,

    observations TEXT NULL,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    deleted_at TIMESTAMP NULL DEFAULT NULL,

    created_by BIGINT UNSIGNED NULL,

    updated_by BIGINT UNSIGNED NULL,

    deleted_by BIGINT UNSIGNED NULL,

    CONSTRAINT uq_applications_uuid
        UNIQUE (uuid),

    CONSTRAINT uq_applications_number
        UNIQUE (farm_id, application_number),

    CONSTRAINT chk_application_number
        CHECK (TRIM(application_number) <> ''),

    CONSTRAINT chk_application_type
        CHECK (

            application_type IN (

                'FERTILIZER',

                'DEFENSIVE',

                'HERBICIDE',

                'FUNGICIDE',

                'INSECTICIDE',

                'SEED_TREATMENT',

                'BIOLOGICAL',

                'OTHER'

            )

        ),

    CONSTRAINT chk_application_status
        CHECK (

            status IN (

                'PLANNED',

                'IN_PROGRESS',

                'COMPLETED',

                'CANCELLED'

            )

        ),

    CONSTRAINT fk_applications_farm
        FOREIGN KEY (farm_id)
        REFERENCES farms(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_applications_planting
        FOREIGN KEY (planting_id)
        REFERENCES plantings(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT

)

ENGINE=InnoDB

DEFAULT CHARSET=utf8mb4

COLLATE=utf8mb4_unicode_ci

COMMENT='Cabeçalho das aplicações agrícolas.';


/******************************************************************************
    ÍNDICES
******************************************************************************/

CREATE INDEX idx_applications_farm
ON applications(farm_id);

CREATE INDEX idx_applications_planting
ON applications(planting_id);

CREATE INDEX idx_applications_date
ON applications(application_date);

CREATE INDEX idx_applications_status
ON applications(status);

CREATE INDEX idx_applications_type
ON applications(application_type);


/******************************************************************************
*
*   TABELA: application_items
*
*   RESPONSABILIDADE
*
*   Armazena os produtos utilizados em cada aplicação agrícola.
*
******************************************************************************/

CREATE TABLE application_items (

    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    uuid CHAR(36) NOT NULL DEFAULT (UUID()),

    application_id BIGINT UNSIGNED NOT NULL,

    product_id BIGINT UNSIGNED NOT NULL,

    unit_id BIGINT UNSIGNED NOT NULL,

    sequence_number SMALLINT UNSIGNED NOT NULL,

    planned_quantity DECIMAL(18,4) NULL,

    applied_quantity DECIMAL(18,4) NOT NULL,

    unit_cost DECIMAL(18,6) NOT NULL DEFAULT 0,

    total_cost DECIMAL(18,2) NOT NULL DEFAULT 0,

    dosage_per_hectare DECIMAL(18,4) NULL,

    observations TEXT NULL,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    created_by BIGINT UNSIGNED NULL,

    updated_by BIGINT UNSIGNED NULL,

    CONSTRAINT uq_application_items_uuid
        UNIQUE (uuid),

    CONSTRAINT uq_application_item_sequence
        UNIQUE (
            application_id,
            sequence_number
        ),

    CONSTRAINT chk_application_items_quantity
        CHECK (applied_quantity > 0),

    CONSTRAINT chk_application_items_planned
        CHECK (
            planned_quantity IS NULL
            OR planned_quantity > 0
        ),

    CONSTRAINT chk_application_items_cost
        CHECK (unit_cost >= 0),

    CONSTRAINT chk_application_items_total
        CHECK (total_cost >= 0),

    CONSTRAINT chk_application_items_dosage
        CHECK (
            dosage_per_hectare IS NULL
            OR dosage_per_hectare > 0
        ),

    CONSTRAINT fk_application_items_application
        FOREIGN KEY (application_id)
        REFERENCES applications(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_application_items_product
        FOREIGN KEY (product_id)
        REFERENCES products(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_application_items_unit
        FOREIGN KEY (unit_id)
        REFERENCES product_units(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT

)

ENGINE=InnoDB

DEFAULT CHARSET=utf8mb4

COLLATE=utf8mb4_unicode_ci

COMMENT='Produtos utilizados nas aplicações agrícolas.';


/******************************************************************************
    ÍNDICES
******************************************************************************/

CREATE INDEX idx_application_items_application
ON application_items(application_id);

CREATE INDEX idx_application_items_product
ON application_items(product_id);

CREATE INDEX idx_application_items_unit
ON application_items(unit_id);

CREATE INDEX idx_application_items_sequence
ON application_items(sequence_number);


/******************************************************************************
*
*   TABELA: harvests
*
*   RESPONSABILIDADE
*
*   Armazena o cabeçalho das colheitas.
*
******************************************************************************/

CREATE TABLE harvests (

    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    uuid CHAR(36) NOT NULL DEFAULT (UUID()),

    farm_id BIGINT UNSIGNED NOT NULL,

    planting_id BIGINT UNSIGNED NOT NULL,

    harvest_number VARCHAR(30) NOT NULL,

    harvest_date DATE NOT NULL,

    start_time TIME NULL,

    end_time TIME NULL,

    harvested_area DECIMAL(12,4) NOT NULL,

    moisture_percentage DECIMAL(5,2) NULL,

    impurity_percentage DECIMAL(5,2) NULL,

    status VARCHAR(20) NOT NULL DEFAULT 'OPEN',

    observations TEXT NULL,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    deleted_at TIMESTAMP NULL DEFAULT NULL,

    created_by BIGINT UNSIGNED NULL,

    updated_by BIGINT UNSIGNED NULL,

    deleted_by BIGINT UNSIGNED NULL,

    CONSTRAINT uq_harvests_uuid
        UNIQUE (uuid),

    CONSTRAINT uq_harvest_number
        UNIQUE (farm_id, harvest_number),

    CONSTRAINT chk_harvest_number
        CHECK (TRIM(harvest_number) <> ''),

    CONSTRAINT chk_harvest_area
        CHECK (harvested_area > 0),

    CONSTRAINT chk_harvest_moisture
        CHECK (
            moisture_percentage IS NULL
            OR (
                moisture_percentage >= 0
                AND moisture_percentage <= 100
            )
        ),

    CONSTRAINT chk_harvest_impurity
        CHECK (
            impurity_percentage IS NULL
            OR (
                impurity_percentage >= 0
                AND impurity_percentage <= 100
            )
        ),

    CONSTRAINT chk_harvest_status
        CHECK (
            status IN (
                'OPEN',
                'IN_PROGRESS',
                'COMPLETED',
                'CANCELLED'
            )
        ),

    CONSTRAINT fk_harvests_farm
        FOREIGN KEY (farm_id)
        REFERENCES farms(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_harvests_planting
        FOREIGN KEY (planting_id)
        REFERENCES plantings(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT

)

ENGINE=InnoDB

DEFAULT CHARSET=utf8mb4

COLLATE=utf8mb4_unicode_ci

COMMENT='Cabeçalho das colheitas.';


/******************************************************************************
    ÍNDICES
******************************************************************************/

CREATE INDEX idx_harvests_farm
ON harvests(farm_id);

CREATE INDEX idx_harvests_planting
ON harvests(planting_id);

CREATE INDEX idx_harvests_date
ON harvests(harvest_date);

CREATE INDEX idx_harvests_status
ON harvests(status);



/******************************************************************************
*
*   TABELA: harvest_items
*
*   RESPONSABILIDADE
*
*   Armazena os produtos obtidos em cada colheita.
*
******************************************************************************/

CREATE TABLE harvest_items (

    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    uuid CHAR(36) NOT NULL DEFAULT (UUID()),

    harvest_id BIGINT UNSIGNED NOT NULL,

    product_id BIGINT UNSIGNED NOT NULL,

    unit_id BIGINT UNSIGNED NOT NULL,

    sequence_number SMALLINT UNSIGNED NOT NULL,

    gross_quantity DECIMAL(18,4) NOT NULL,

    moisture_discount DECIMAL(18,4) NOT NULL DEFAULT 0,

    impurity_discount DECIMAL(18,4) NOT NULL DEFAULT 0,

    net_quantity DECIMAL(18,4) NOT NULL,

    unit_cost DECIMAL(18,6) NOT NULL DEFAULT 0,

    total_cost DECIMAL(18,2) NOT NULL DEFAULT 0,

    observations TEXT NULL,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    created_by BIGINT UNSIGNED NULL,

    updated_by BIGINT UNSIGNED NULL,

    CONSTRAINT uq_harvest_items_uuid
        UNIQUE (uuid),

    CONSTRAINT uq_harvest_item_sequence
        UNIQUE (
            harvest_id,
            sequence_number
        ),

    CONSTRAINT chk_harvest_items_gross
        CHECK (gross_quantity > 0),

    CONSTRAINT chk_harvest_items_moisture
        CHECK (moisture_discount >= 0),

    CONSTRAINT chk_harvest_items_impurity
        CHECK (impurity_discount >= 0),

    CONSTRAINT chk_harvest_items_net
        CHECK (net_quantity >= 0),

    CONSTRAINT chk_harvest_items_unit_cost
        CHECK (unit_cost >= 0),

    CONSTRAINT chk_harvest_items_total_cost
        CHECK (total_cost >= 0),

    CONSTRAINT fk_harvest_items_harvest
        FOREIGN KEY (harvest_id)
        REFERENCES harvests(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_harvest_items_product
        FOREIGN KEY (product_id)
        REFERENCES products(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_harvest_items_unit
        FOREIGN KEY (unit_id)
        REFERENCES product_units(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT

)

ENGINE=InnoDB

DEFAULT CHARSET=utf8mb4

COLLATE=utf8mb4_unicode_ci

COMMENT='Produtos obtidos nas colheitas.';



/******************************************************************************
    ÍNDICES
******************************************************************************/

CREATE INDEX idx_harvest_items_harvest
ON harvest_items(harvest_id);

CREATE INDEX idx_harvest_items_product
ON harvest_items(product_id);

CREATE INDEX idx_harvest_items_unit
ON harvest_items(unit_id);

CREATE INDEX idx_harvest_items_sequence
ON harvest_items(sequence_number);


/******************************************************************************
*
*   TABELA: weather_records
*
*   RESPONSABILIDADE
*
*   Armazena os registros climáticos associados aos plantios.
*
******************************************************************************/

CREATE TABLE weather_records (

    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    uuid CHAR(36) NOT NULL DEFAULT (UUID()),

    farm_id BIGINT UNSIGNED NOT NULL,

    planting_id BIGINT UNSIGNED NOT NULL,

    record_datetime DATETIME NOT NULL,

    temperature DECIMAL(5,2) NULL,

    humidity DECIMAL(5,2) NULL,

    rainfall DECIMAL(8,2) NULL,

    wind_speed DECIMAL(6,2) NULL,

    wind_direction SMALLINT UNSIGNED NULL,

    atmospheric_pressure DECIMAL(7,2) NULL,

    solar_radiation DECIMAL(8,2) NULL,

    source VARCHAR(50) NOT NULL DEFAULT 'MANUAL',

    observations TEXT NULL,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    created_by BIGINT UNSIGNED NULL,

    CONSTRAINT uq_weather_records_uuid
        UNIQUE (uuid),

    CONSTRAINT chk_weather_humidity
        CHECK (
            humidity IS NULL
            OR (
                humidity >= 0
                AND humidity <= 100
            )
        ),

    CONSTRAINT chk_weather_rainfall
        CHECK (
            rainfall IS NULL
            OR rainfall >= 0
        ),

    CONSTRAINT chk_weather_wind_speed
        CHECK (
            wind_speed IS NULL
            OR wind_speed >= 0
        ),

    CONSTRAINT chk_weather_wind_direction
        CHECK (
            wind_direction IS NULL
            OR wind_direction <= 360
        ),

    CONSTRAINT chk_weather_pressure
        CHECK (
            atmospheric_pressure IS NULL
            OR atmospheric_pressure > 0
        ),

    CONSTRAINT chk_weather_source
        CHECK (
            source IN (
                'MANUAL',
                'API',
                'STATION',
                'IOT'
            )
        ),

    CONSTRAINT fk_weather_records_farm
        FOREIGN KEY (farm_id)
        REFERENCES farms(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_weather_records_planting
        FOREIGN KEY (planting_id)
        REFERENCES plantings(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE

)

ENGINE=InnoDB

DEFAULT CHARSET=utf8mb4

COLLATE=utf8mb4_unicode_ci

COMMENT='Registros climáticos dos plantios.';


/******************************************************************************
    ÍNDICES
******************************************************************************/

CREATE INDEX idx_weather_records_farm
ON weather_records(farm_id);

CREATE INDEX idx_weather_records_planting
ON weather_records(planting_id);

CREATE INDEX idx_weather_records_datetime
ON weather_records(record_datetime);

CREATE INDEX idx_weather_records_source
ON weather_records(source);


/******************************************************************************
*
*   TABELA: soil_analyses
*
*   RESPONSABILIDADE
*
*   Armazena as análises de solo dos plantios.
*
******************************************************************************/

CREATE TABLE soil_analyses (

    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    uuid CHAR(36) NOT NULL DEFAULT (UUID()),

    farm_id BIGINT UNSIGNED NOT NULL,

    planting_id BIGINT UNSIGNED NOT NULL,

    analysis_number VARCHAR(30) NOT NULL,

    collection_date DATE NOT NULL,

    laboratory_name VARCHAR(150) NULL,

    ph DECIMAL(4,2) NULL,

    organic_matter DECIMAL(6,2) NULL,

    phosphorus DECIMAL(8,2) NULL,

    potassium DECIMAL(8,2) NULL,

    calcium DECIMAL(8,2) NULL,

    magnesium DECIMAL(8,2) NULL,

    sulfur DECIMAL(8,2) NULL,

    cec DECIMAL(8,2) NULL,

    base_saturation DECIMAL(5,2) NULL,

    aluminum_saturation DECIMAL(5,2) NULL,

    recommendations TEXT NULL,

    observations TEXT NULL,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    deleted_at TIMESTAMP NULL DEFAULT NULL,

    created_by BIGINT UNSIGNED NULL,

    updated_by BIGINT UNSIGNED NULL,

    deleted_by BIGINT UNSIGNED NULL,

    CONSTRAINT uq_soil_analyses_uuid
        UNIQUE (uuid),

    CONSTRAINT uq_soil_analysis_number
        UNIQUE (
            farm_id,
            analysis_number
        ),

    CONSTRAINT chk_soil_analysis_number
        CHECK (TRIM(analysis_number) <> ''),

    CONSTRAINT chk_soil_ph
        CHECK (
            ph IS NULL
            OR (
                ph >= 0
                AND ph <= 14
            )
        ),

    CONSTRAINT chk_soil_base_saturation
        CHECK (
            base_saturation IS NULL
            OR (
                base_saturation >= 0
                AND base_saturation <= 100
            )
        ),

    CONSTRAINT chk_soil_aluminum_saturation
        CHECK (
            aluminum_saturation IS NULL
            OR (
                aluminum_saturation >= 0
                AND aluminum_saturation <= 100
            )
        ),

    CONSTRAINT fk_soil_analyses_farm
        FOREIGN KEY (farm_id)
        REFERENCES farms(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_soil_analyses_planting
        FOREIGN KEY (planting_id)
        REFERENCES plantings(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT

)

ENGINE=InnoDB

DEFAULT CHARSET=utf8mb4

COLLATE=utf8mb4_unicode_ci

COMMENT='Análises de solo dos plantios.';


/******************************************************************************
    ÍNDICES
******************************************************************************/

CREATE INDEX idx_soil_analyses_farm
ON soil_analyses(farm_id);

CREATE INDEX idx_soil_analyses_planting
ON soil_analyses(planting_id);

CREATE INDEX idx_soil_analyses_collection
ON soil_analyses(collection_date);

CREATE INDEX idx_soil_analyses_lab
ON soil_analyses(laboratory_name);


