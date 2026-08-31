-- ============================================================
-- CAR RENTAL DATABASE
-- Technology: Oracle SQL
-- ============================================================

-- ============================================================
-- CUSTOMERS
-- ============================================================

CREATE TABLE customers (
    customer_id NUMBER(6) PRIMARY KEY,
    first_name VARCHAR2(30) NOT NULL,
    last_name VARCHAR2(50) NOT NULL,
    national_id VARCHAR2(20) UNIQUE,
    phone VARCHAR2(20),
    email VARCHAR2(100) UNIQUE
);

COMMENT ON TABLE customers IS
'Customers registered in the car rental system';


-- ============================================================
-- EMPLOYEES
-- ============================================================

CREATE TABLE employees (
    employee_id NUMBER(6) PRIMARY KEY,
    first_name VARCHAR2(30) NOT NULL,
    last_name VARCHAR2(50) NOT NULL,
    email VARCHAR2(100) UNIQUE,
    position VARCHAR2(50) NOT NULL
);

COMMENT ON TABLE employees IS
'Employees responsible for handling rentals';


-- ============================================================
-- VEHICLE TYPES
-- ============================================================

CREATE TABLE vehicle_types (
    vehicle_type_id NUMBER(3) PRIMARY KEY,
    type_name VARCHAR2(30) NOT NULL UNIQUE
);

COMMENT ON TABLE vehicle_types IS
'Available vehicle categories such as SUV, sedan or estate';


-- ============================================================
-- VEHICLE STATUSES
-- ============================================================

CREATE TABLE vehicle_statuses (
    status_id NUMBER(3) PRIMARY KEY,
    status_name VARCHAR2(30) NOT NULL UNIQUE
);

COMMENT ON TABLE vehicle_statuses IS
'Current operational status of a vehicle';


-- ============================================================
-- VEHICLES
-- ============================================================

CREATE TABLE vehicles (
    vehicle_id NUMBER(6) PRIMARY KEY,
    brand VARCHAR2(40) NOT NULL,
    model VARCHAR2(50) NOT NULL,
    production_year NUMBER(4) NOT NULL,
    registration_number VARCHAR2(15) NOT NULL UNIQUE,
    vin VARCHAR2(17) NOT NULL UNIQUE,
    vehicle_type_id NUMBER(3) NOT NULL,
    status_id NUMBER(3) NOT NULL,
    daily_rate NUMBER(8,2) NOT NULL,

    CONSTRAINT chk_vehicle_year
        CHECK (production_year >= 1990),

    CONSTRAINT chk_daily_rate
        CHECK (daily_rate > 0),

    CONSTRAINT fk_vehicle_type
        FOREIGN KEY (vehicle_type_id)
        REFERENCES vehicle_types(vehicle_type_id),

    CONSTRAINT fk_vehicle_status
        FOREIGN KEY (status_id)
        REFERENCES vehicle_statuses(status_id)
);

COMMENT ON TABLE vehicles IS
'Vehicles available in the rental fleet';


-- ============================================================
-- RENTALS
-- ============================================================

CREATE TABLE rentals (
    rental_id NUMBER(6) PRIMARY KEY,
    customer_id NUMBER(6) NOT NULL,
    employee_id NUMBER(6) NOT NULL,
    rental_date DATE DEFAULT SYSDATE NOT NULL,
    planned_return_date DATE NOT NULL,
    rental_status VARCHAR2(20) DEFAULT 'ACTIVE' NOT NULL,

    CONSTRAINT chk_return_date
        CHECK (planned_return_date >= rental_date),

    CONSTRAINT chk_rental_status
        CHECK (
            rental_status IN (
                'ACTIVE',
                'COMPLETED',
                'CANCELLED'
            )
        ),

    CONSTRAINT fk_rental_customer
        FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id),

    CONSTRAINT fk_rental_employee
        FOREIGN KEY (employee_id)
        REFERENCES employees(employee_id)
);

COMMENT ON TABLE rentals IS
'Rental contracts created for customers';


-- ============================================================
-- RENTAL VEHICLES
-- ============================================================

CREATE TABLE rental_vehicles (
    rental_id NUMBER(6) NOT NULL,
    vehicle_id NUMBER(6) NOT NULL,
    agreed_daily_rate NUMBER(8,2) NOT NULL,

    CONSTRAINT pk_rental_vehicles
        PRIMARY KEY (rental_id, vehicle_id),

    CONSTRAINT chk_agreed_rate
        CHECK (agreed_daily_rate > 0),

    CONSTRAINT fk_rv_rental
        FOREIGN KEY (rental_id)
        REFERENCES rentals(rental_id),

    CONSTRAINT fk_rv_vehicle
        FOREIGN KEY (vehicle_id)
        REFERENCES vehicles(vehicle_id)
);

COMMENT ON TABLE rental_vehicles IS
'Vehicles assigned to rental contracts';


-- ============================================================
-- RETURNS
-- ============================================================

CREATE TABLE rental_returns (
    rental_id NUMBER(6) PRIMARY KEY,
    return_date DATE NOT NULL,
    mileage_after NUMBER(10),
    notes VARCHAR2(300),

    CONSTRAINT chk_return_mileage
        CHECK (
            mileage_after IS NULL
            OR mileage_after >= 0
        ),

    CONSTRAINT fk_return_rental
        FOREIGN KEY (rental_id)
        REFERENCES rentals(rental_id)
);

COMMENT ON TABLE rental_returns IS
'Information recorded when rented vehicles are returned';


-- ============================================================
-- PAYMENTS
-- ============================================================

CREATE TABLE payments (
    payment_id NUMBER(6) PRIMARY KEY,
    rental_id NUMBER(6) NOT NULL,
    payment_date DATE DEFAULT SYSDATE NOT NULL,
    amount NUMBER(10,2) NOT NULL,
    payment_method VARCHAR2(20) NOT NULL,

    CONSTRAINT chk_payment_amount
        CHECK (amount > 0),

    CONSTRAINT chk_payment_method
        CHECK (
            payment_method IN (
                'CARD',
                'CASH',
                'TRANSFER'
            )
        ),

    CONSTRAINT fk_payment_rental
        FOREIGN KEY (rental_id)
        REFERENCES rentals(rental_id)
);

COMMENT ON TABLE payments IS
'Payments associated with rental contracts';


-- ============================================================
-- INSURANCE POLICIES
-- ============================================================

CREATE TABLE insurance_policies (
    insurance_id NUMBER(6) PRIMARY KEY,
    vehicle_id NUMBER(6) NOT NULL,
    insurance_type VARCHAR2(20) NOT NULL,
    provider VARCHAR2(50) NOT NULL,
    valid_from DATE NOT NULL,
    valid_until DATE NOT NULL,

    CONSTRAINT chk_insurance_dates
        CHECK (valid_until > valid_from),

    CONSTRAINT fk_insurance_vehicle
        FOREIGN KEY (vehicle_id)
        REFERENCES vehicles(vehicle_id)
);

COMMENT ON TABLE insurance_policies IS
'Insurance policies assigned to rental vehicles';


-- ============================================================
-- SAMPLE DATA
-- ============================================================

-- CUSTOMERS

INSERT INTO customers
VALUES (
    1,
    'Marek',
    'Kowalski',
    '89010112345',
    '505111222',
    'marek.kowalski@example.com'
);

INSERT INTO customers
VALUES (
    2,
    'Katarzyna',
    'Nowak',
    '92030598765',
    '505333444',
    'katarzyna.nowak@example.com'
);

INSERT INTO customers
VALUES (
    3,
    'Anna',
    'Wisniewska',
    '95071045678',
    '505555666',
    'anna.wisniewska@example.com'
);


-- EMPLOYEES

INSERT INTO employees
VALUES (
    1,
    'Ewelina',
    'Bak',
    'ewelina.bak@carrental.example',
    'Customer Service Advisor'
);

INSERT INTO employees
VALUES (
    2,
    'Pawel',
    'Lis',
    'pawel.lis@carrental.example',
    'Shift Manager'
);


-- VEHICLE TYPES

INSERT INTO vehicle_types
VALUES (1, 'SUV');

INSERT INTO vehicle_types
VALUES (2, 'Sedan');

INSERT INTO vehicle_types
VALUES (3, 'Estate');


-- VEHICLE STATUSES

INSERT INTO vehicle_statuses
VALUES (1, 'AVAILABLE');

INSERT INTO vehicle_statuses
VALUES (2, 'RENTED');

INSERT INTO vehicle_statuses
VALUES (3, 'MAINTENANCE');


-- VEHICLES

INSERT INTO vehicles
VALUES (
    1,
    'Toyota',
    'Corolla',
    2023,
    'GD1234A',
    'JTDBR32E720123456',
    2,
    1,
    180.00
);

INSERT INTO vehicles
VALUES (
    2,
    'BMW',
    'X3',
    2022,
    'GD5678B',
    'WBAWX31020L123456',
    1,
    2,
    320.00
);

INSERT INTO vehicles
VALUES (
    3,
    'Skoda',
    'Octavia',
    2021,
    'GD9012C',
    'TMBJG7NE5M0123456',
    3,
    1,
    210.00
);


-- INSURANCE POLICIES

INSERT INTO insurance_policies
VALUES (
    1,
    1,
    'LIABILITY',
    'PZU',
    DATE '2026-01-01',
    DATE '2027-01-01'
);

INSERT INTO insurance_policies
VALUES (
    2,
    2,
    'LIABILITY',
    'Allianz',
    DATE '2026-02-01',
    DATE '2027-02-01'
);

INSERT INTO insurance_policies
VALUES (
    3,
    2,
    'COMPREHENSIVE',
    'Allianz',
    DATE '2026-02-01',
    DATE '2027-02-01'
);

INSERT INTO insurance_policies
VALUES (
    4,
    3,
    'LIABILITY',
    'Warta',
    DATE '2026-03-01',
    DATE '2027-03-01'
);


-- ============================================================
-- SAMPLE RENTALS
-- ============================================================

INSERT INTO rentals
VALUES (
    1,
    1,
    1,
    DATE '2026-07-01',
    DATE '2026-07-05',
    'COMPLETED'
);

INSERT INTO rentals
VALUES (
    2,
    2,
    2,
    DATE '2026-08-20',
    DATE '2026-08-27',
    'ACTIVE'
);


-- RENTAL VEHICLES

INSERT INTO rental_vehicles
VALUES (
    1,
    1,
    180.00
);

INSERT INTO rental_vehicles
VALUES (
    2,
    2,
    320.00
);


-- RENTAL_RETURNS

INSERT INTO rental_returns
VALUES (
    1,
    DATE '2026-07-05',
    45210,
    'Vehicle returned without damage'
);


-- PAYMENTS

INSERT INTO payments
VALUES (
    1,
    1,
    DATE '2026-07-05',
    720.00,
    'CARD'
);

INSERT INTO payments
VALUES (
    2,
    2,
    DATE '2026-08-20',
    2240.00,
    'TRANSFER'
);


COMMIT;


-- ============================================================
-- VIEW: RENTAL SUMMARY
-- ============================================================

CREATE OR REPLACE VIEW rental_summary AS
SELECT
    r.rental_id,
    c.first_name || ' ' || c.last_name AS customer,
    v.brand || ' ' || v.model AS vehicle,
    r.rental_date,
    r.planned_return_date,
    r.rental_status,
    rv.agreed_daily_rate
FROM rentals r
JOIN customers c
    ON c.customer_id = r.customer_id
JOIN rental_vehicles rv
    ON rv.rental_id = r.rental_id
JOIN vehicles v
    ON v.vehicle_id = rv.vehicle_id;


-- ============================================================
-- EXAMPLE QUERIES
-- ============================================================

-- All rental contracts with customer and vehicle information

SELECT *
FROM rental_summary
ORDER BY rental_date DESC;


-- Available vehicles

SELECT
    brand,
    model,
    registration_number,
    daily_rate
FROM vehicles v
JOIN vehicle_statuses s
    ON s.status_id = v.status_id
WHERE s.status_name = 'AVAILABLE'
ORDER BY daily_rate;


-- Total payments per rental

SELECT
    rental_id,
    SUM(amount) AS total_paid
FROM payments
GROUP BY rental_id
ORDER BY rental_id;


-- Vehicles with insurance expiring first

SELECT
    v.brand,
    v.model,
    i.insurance_type,
    i.provider,
    i.valid_until
FROM insurance_policies i
JOIN vehicles v
    ON v.vehicle_id = i.vehicle_id
ORDER BY i.valid_until;
