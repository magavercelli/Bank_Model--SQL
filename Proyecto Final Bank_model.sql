CREATE SCHEMA bank_model;
use bank_model;

-- CREACIÓN DE TABLAS (TABLE CREATION)--

CREATE TABLE banks (
id_bank INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
name_bank VARCHAR (50) NOT NULL,
country VARCHAR (50) NOT NULL
);


CREATE TABLE location (
id_location INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
state_name VARCHAR (40) NOT NULL,
city VARCHAR (30) NOT NULL,
address VARCHAR (50) NOT NULL
);


CREATE TABLE comunication (
id_comunication INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
phone VARCHAR (10) NOT NULL,
email VARCHAR (50) NOT NULL
);

CREATE TABLE bank_branch (
id_branch INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
number_branch VARCHAR (12) UNIQUE NOT NULL,
bank_id INT NOT NULL,
location_id INT NOT NULL,
comunication_id INT NOT NULL,
FOREIGN KEY (bank_id) REFERENCES banks (id_bank),
FOREIGN KEY (location_id) REFERENCES location (id_location),
FOREIGN KEY (comunication_id) REFERENCES comunication (id_comunication)
);


CREATE TABLE person (
id_person INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
first_name VARCHAR (20) NOT NULL,
last_name VARCHAR (20) NOT NULL,
national_identity_document VARCHAR (8) UNIQUE NOT NULL,
age INT CHECK (age >= 18),
location_id INT NOT NULL,
comunication_id INT NOT NULL,
FOREIGN KEY (location_id) REFERENCES location (id_location),
FOREIGN KEY (comunication_id) REFERENCES comunication (id_comunication)
);


CREATE TABLE company (
id_company INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
name_company VARCHAR (50) NOT NULL,
tax_id VARCHAR (11) UNIQUE NOT NULL,
industry VARCHAR (50) NOT NULL,
location_id INT NOT NULL,
comunication_id INT NOT NULL,
FOREIGN KEY (location_id) REFERENCES location (id_location),
FOREIGN KEY (comunication_id) REFERENCES comunication (id_comunication)
);


CREATE TABLE customer_type (
    id_customer_type INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    type_name VARCHAR(10) NOT NULL
);


CREATE TABLE customer (
    id_customer INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    customer_type_id INT NOT NULL,
    person_id INT NULL,
    company_id INT NULL,
    FOREIGN KEY (customer_type_id) REFERENCES customer_type(id_customer_type),
    FOREIGN KEY (person_id) REFERENCES person(id_person),
    FOREIGN KEY (company_id) REFERENCES company(id_company)
);

ALTER TABLE customer
ADD COLUMN branch_id INT,
ADD CONSTRAINT FK_customer_bank_branch
FOREIGN KEY (branch_id)
REFERENCES bank_branch(id_branch);


CREATE TABLE interest_rate (
  id_interest_rate INT NOT NULL PRIMARY KEY,
  nominal_annual_rate DECIMAL(5,2),
  effective_annual_rate DECIMAL(5,2),
  total_financing_cost DECIMAL(5,2),
  monthly_rate DECIMAL(5,3)
);


CREATE TABLE bank_loan (
    id_loan INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    loan_amount DECIMAL(15,2) NOT NULL,
    term_months INT,
    start_date DATE,
    end_date DATE DEFAULT NULL,
    monthly_payment DECIMAL(15,2) DEFAULT NULL,
    outstanding_balance DECIMAL(15,2) DEFAULT NULL,
    loan_status ENUM ('pending', 'overdue', 'complete'),
    total_amount_to_pay DECIMAL(20,2) DEFAULT NULL,
    amount_paid DECIMAL(15,2) DEFAULT NULL,
    interest_rate_id INT,
    customer_id INT,
    branch_id INT,
    FOREIGN KEY (interest_rate_id) REFERENCES interest_rate(id_interest_rate),
    FOREIGN KEY (customer_id) REFERENCES customer (id_customer),
    FOREIGN KEY (branch_id) REFERENCES bank_branch(id_branch) 
);



CREATE TABLE payments_record (
    id_payment INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    date_paid DATE,
    paid_per_months DECIMAL(15,2) DEFAULT NULL,
    loan_id INT,
    customer_id INT,
    interest_rate_id INT,
    FOREIGN KEY (loan_id) REFERENCES banK_loan(id_loan),
    FOREIGN KEY (customer_id) REFERENCES customer(id_customer),
    FOREIGN KEY (interest_rate_id) REFERENCES interest_rate(id_interest_rate)
);



CREATE TABLE external_account (
id_external_account INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
external_account_number VARCHAR (20) UNIQUE NOT NULL,
bank_id INT,
FOREIGN KEY (bank_id) REFERENCES banks (id_bank)
);


CREATE TABLE account_type (
id_account_type INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
account_type_name ENUM ("checking_account", "saving_account"),
branch_id INT NOT NULL,
FOREIGN KEY (branch_id) REFERENCES bank_branch (id_branch)
);


CREATE TABLE account (
id_account INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
account_number VARCHAR (22) UNIQUE NOT NULL,
account_type_id INT NOT NULL,
customer_id INT NOT NULL,
FOREIGN KEY (account_type_id) REFERENCES account_type(id_account_type),
FOREIGN KEY (customer_id) REFERENCES customer(id_customer)
);


CREATE TABLE checking_account (
    id_checking INT PRIMARY KEY AUTO_INCREMENT,
    checking_balance DECIMAL(10,2),
    overdraft_limit DECIMAL(10,2),
    customer_id INT NOT NULL,
    branch_id INT NOT NULL,
    account_id INT NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customer(id_customer), 
    FOREIGN KEY (branch_id) REFERENCES bank_branch(id_branch), 
    FOREIGN KEY (account_id) REFERENCES account(id_account) 
);


CREATE TABLE saving_account (
    id_savings INT PRIMARY KEY AUTO_INCREMENT,
    savings_balance DECIMAL(10,2),
    customer_id INT NOT NULL,
    branch_id INT NOT NULL,
    account_id INT NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customer(id_customer), 
    FOREIGN KEY (branch_id) REFERENCES bank_branch(id_branch), 
    FOREIGN KEY (account_id) REFERENCES account(id_account) 
);


CREATE TABLE transfers (
    id_transfer INT PRIMARY KEY AUTO_INCREMENT,
    transfer_datetime DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    origin_account VARCHAR(22) NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    transfer_state ENUM('pending', 'completed', 'rejected') NOT NULL DEFAULT 'pending',
    concept VARCHAR(50),
    account_id INT NOT NULL,
    customer_id INT NOT NULL,
    branch_id INT NOT NULL,
    external_account_id INT,
    bank_id INT NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customer(id_customer),
    FOREIGN KEY (branch_id) REFERENCES bank_branch(id_branch),
    FOREIGN KEY (external_account_id) REFERENCES external_account(id_external_account),
    FOREIGN KEY (account_id) REFERENCES account (id_account),
    FOREIGN KEY (bank_id) REFERENCES banks (id_bank)
);

ALTER TABLE transfers
RENAME COLUMN transfer_state TO transfer_status;

-- INSERCIÓN DE DATOS (Data insertion) --
#1 TABLA BANKS por archivo cvs
SELECT * FROM bank_model.banks;

#2 TABLA LOCATION por archivo cvs
SELECT * FROM bank_model.location;

#3 TABLA COMUNICATION por archivo cvs
SELECT * FROM bank_model.comunication;

#4 TABLA BANK_BRANCH por archivo cvs
SELECT * FROM bank_model.bank_branch;

#5 TABLA PERSON por archivo cvs
SELECT * FROM bank_model.person;

#6 TABLA COMPANY por archivo cvs
SELECT * FROM bank_model.company;

#7 TABLA CUSTOMER_TYPE por INSERT
INSERT INTO bank_model.customer_type (id_customer_type, type_name)
VALUES 
(1, 'person'),
(2, 'company');

#8 TABLA CUSTOMER por archivo cvs
SELECT * FROM bank_model.customer;

#9 TABLA ACCOUNT_TYPE por archivo cvs
SELECT * FROM bank_model.account_type;

#10 TABLA ACCOUNT por archivo cvs
SELECT * FROM bank_model.account;

#11 TABLA CHECKING_ACCOUNT por archivo cvs
SELECT * FROM bank_model.checking_account;

#12 TABLA SAVING_ACCOUNT por archivo cvs
SELECT * FROM bank_model.saving_account;

#13- TABLA INTEREST_RATE por INSERT INTO
INSERT INTO bank_model.interest_rate (id_interest_rate, nominal_annual_rate, effective_annual_rate, total_financing_cost, monthly_rate)
VALUES (1, 0.33, 0.45, 0.55, 0.038);
SELECT * FROM bank_model.interest_rate;

#14 TABLA EXTERNAL_ACCOUNT por archivo cvs
SELECT * FROM bank_model.external_account;

#15 TABLA TRANSFERS por archivo cvs
SELECT * FROM bank_model.transfers;

#16 TABLA BANK_LOAN por archivo cvs
SELECT * FROM bank_model.bank_loan;

#17 TABLA PAYMENTS_RECORD por archivo cvs
SELECT * FROM bank_model.payments_record;

-- VISTAS --
# PRIMERA VISTA
-- utilizar la vista para calcular la primera y la segunda función --
CREATE VIEW loan_payment_details AS
SELECT 
    bl.id_loan,
    bl.loan_amount,
    bl.term_months,
    ir.monthly_rate,
    ir.effective_annual_rate
FROM 
    bank_loan bl
JOIN 
    interest_rate ir 
    ON bl.interest_rate_id = ir.id_interest_rate;
 -- ---------------------------------------------------------------------------------------------------------------------   

# SEGUNDA VISTA
-- Se recomienta usarla para poder ejecutar la función "calculate_amount_paid_for_customer"(la función sirve para calcular el total a pagar del préstamos) --
CREATE VIEW id_loan_for_customer AS
SELECT
	bl.id_loan,
	bl.customer_id
FROM
	bank_loan bl;
-- ---------------------------------------------------------------------------------------------------------------------

# TERCERA VISTA
CREATE VIEW view_all_customers AS
SELECT 
  ct.type_name AS tipo_cliente,
  COALESCE(p.first_name, com.name_company) AS name_customer,
  COALESCE(p.last_name, '') AS apellido,
   bb.number_branch,
   l.city
FROM 
  customer c
  INNER JOIN customer_type ct ON c.customer_type_id = ct.id_customer_type
  LEFT JOIN person p ON c.person_id = p.id_person
  LEFT JOIN company com ON c.company_id = com.id_company
  INNER JOIN location l ON COALESCE(p.location_id, com.location_id) = l.id_location
  INNER JOIN bank_branch bb ON c.branch_id = bb.id_branch
  INNER JOIN banks b ON bb.bank_id = b.id_bank
  WHERE b.id_bank = 1;
  
SELECT * FROM bank_model.view_all_customers;
-- ---------------------------------------------------------------------------------------------------------------------

# CUARTA VISTA
CREATE VIEW customer_with_checking_account AS
SELECT
    c.id_customer,
    COALESCE(p.first_name, com.name_company) AS customer_name,
    COALESCE(p.last_name, '') AS last_name,
    ca.checking_balance
FROM
    customer c
LEFT JOIN person p ON c.person_id = p.id_person
LEFT JOIN company com ON c.company_id = com.id_company
LEFT JOIN account a ON c.id_customer = a.customer_id
LEFT JOIN checking_account ca ON a.id_account = ca.id_checking
WHERE
    ca.id_checking IS NOT NULL;
  -- ---------------------------------------------------------------------------------------------------------------------
  
# QUINTA VISTA
CREATE VIEW customer_with_saving_account AS
SELECT
    c.id_customer,
    COALESCE(p.first_name, com.name_company) AS customer_name,
    COALESCE(p.last_name, '') AS last_name,
    sa.savings_balance
FROM
    customer c
LEFT JOIN person p ON c.person_id = p.id_person
LEFT JOIN company com ON c.company_id = com.id_company
LEFT JOIN account a ON c.id_customer = a.customer_id
LEFT JOIN saving_account sa ON a.id_account = sa.id_savings
WHERE
    sa.id_savings IS NOT NULL;


-- ---------------------------------------------------------------------------------------------------------------------
-- FUNCIONES --

# PRIMERA FUNCIÓN
-- calcula el pago mensual (monthly_payment), teniendo en cuenta la tasa mensual de interes --
DELIMITER $$
CREATE FUNCTION calculate_monthly_payment(
    bl_loan_amount DECIMAL(15,2),
    bl_monthly_rate DECIMAL(5,3),
    bl_term_months INT
) RETURNS DECIMAL(15,2)
DETERMINISTIC
BEGIN
    DECLARE monthly_payment DECIMAL(15,2);
    SET monthly_payment = (bl_loan_amount * bl_monthly_rate) / (1 - POWER((1 + bl_monthly_rate), -bl_term_months));
    RETURN monthly_payment;
END$$

-- --------------------------------------------------------------------------------------------------------------------
 

-- STORE PROCEDURE --
# PRIMER STORE PROCEDURE
-- Calcula montos del monthly_payment (pago mensual) y el total_amount_to_pay(pago total del préstamo), aunque es una actualización gradual--
DELIMITER $$
CREATE PROCEDURE update_monthly_payment_total_to_pay(IN p_id_loan INT)
BEGIN
    UPDATE bank_loan bl
    JOIN interest_rate ir ON bl.interest_rate_id = ir.id_interest_rate
    SET bl.monthly_payment = (bl.loan_amount * ir.monthly_rate) / (1 - POWER(1 + ir.monthly_rate, -bl.term_months)),
        bl.total_amount_to_pay = bl.monthly_payment * bl.term_months
    WHERE bl.id_loan = p_id_loan;
END $$

-- actualización de la tabla bank_loan con el llamado al Primer Store --

CALL update_monthly_payment_total_to_pay(1);
CALL update_monthly_payment_total_to_pay(2);
CALL update_monthly_payment_total_to_pay(3);
CALL update_monthly_payment_total_to_pay(4);
CALL update_monthly_payment_total_to_pay(5);
CALL update_monthly_payment_total_to_pay(6);
CALL update_monthly_payment_total_to_pay(7);
CALL update_monthly_payment_total_to_pay(8);
CALL update_monthly_payment_total_to_pay(9);
CALL update_monthly_payment_total_to_pay(10);

SELECT id_loan, monthly_payment, total_amount_to_pay, end_date 
FROM bank_loan 
WHERE id_loan = 1;
-- --------------------------------------------------------------------------------------------------------------------


-- FUNCIÓN --
# SEGUNDA FUNCIÓN
DELIMITER //
CREATE FUNCTION calculate_amount_paid_for_customer(p_loan_id INT, p_customer_id INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE total_paid DECIMAL(10,2);

    -- Sumar todos los pagos mensuales (paid_per_months) para el préstamo y cliente específicos
    SELECT SUM(paid_per_months)
    INTO total_paid
    FROM payments_record
    WHERE loan_id = p_loan_id
      AND customer_id = p_customer_id;

    -- Si no hay pagos, devolver 0
    IF total_paid IS NULL THEN
        SET total_paid = 0;
    END IF;

    RETURN total_paid;
END //


-- Verificación de que la suma de pagos esté correcta --
SELECT COUNT(*), SUM(paid_per_months) 
FROM payments_record
WHERE loan_id = 1
AND customer_id = 3;

-- --------------------------------------------------------------------------------------------------------------------

-- SEGUNDO PROCEDURE --
DELIMITER //
CREATE PROCEDURE update_loan_balance_by_id(IN loan_id INT, IN customer_id INT)
BEGIN
    -- Actualiza el amount_paid para un préstamo específico
    UPDATE bank_loan
    SET amount_paid = (
        SELECT bank_model.calculate_amount_paid_for_customer(loan_id, customer_id)
    )
    WHERE id_loan = loan_id;
    
    -- Actualiza el outstanding_balance en relación al total_amount_to_pay menos el amount_paid
    UPDATE bank_loan
    SET outstanding_balance = total_amount_to_pay - amount_paid
    WHERE id_loan = loan_id;
END //

-- se actualiza con id_loan e id_customer de la tabla payments_record --
CALL update_loan_balance_by_id(1,3);
CALL update_loan_balance_by_id(2,7);
CALL update_loan_balance_by_id(3,9);
CALL update_loan_balance_by_id(4,13);
CALL update_loan_balance_by_id(5,15);
CALL update_loan_balance_by_id(6,17);
CALL update_loan_balance_by_id(7,19);
CALL update_loan_balance_by_id(8,21);
CALL update_loan_balance_by_id(9,29);
CALL update_loan_balance_by_id(10,39);

-- --------------------------------------------------------------------------------------------------------------------

# TERCER STORE PROCEDURE
DELIMITER $$
CREATE PROCEDURE calculate_end_date(IN p_id_loan INT)
BEGIN
  UPDATE bank_loan
  SET end_date = DATE_ADD(start_date, INTERVAL term_months MONTH)
  WHERE id_loan = p_id_loan;
END $$

CALL calculate_end_date(1);
CALL calculate_end_date(2);
CALL calculate_end_date(3);
CALL calculate_end_date(4);
CALL calculate_end_date(5);
CALL calculate_end_date(6);
CALL calculate_end_date(7);
CALL calculate_end_date(8);
CALL calculate_end_date(9);
CALL calculate_end_date(10);


-- CREACIÓN DE TABLA AUDITS --
CREATE TABLE AUDITS (
id_log INT PRIMARY KEY auto_increment,
entity varchar(100),
entity_id int,
insert_dt datetime,
created_by varchar(100),
last_update_dt datetime,
last_updated_by varchar(100)
);

-- PRIMER TRIGGERS --
CREATE TRIGGER tr_insert_banks_audit
AFTER INSERT ON banks
FOR EACH ROW
INSERT INTO `audits` (entity, entity_id, insert_dt, created_by, last_update_dt, last_updated_by)
VALUES ('banks', NEW.id_bank, CURRENT_TIMESTAMP(), USER(), CURRENT_TIMESTAMP(), USER());

INSERT INTO banks (id_bank, name_bank, country)
VALUES (16, 'Banco Aruiazul', 'Argentina');
-- ---------------------------------------------------------------------------------------------------------------------

-- STORE PROCEDURE --
# CUARTO STORE
DELIMITER $$
CREATE PROCEDURE insert_location(
    p_state_name VARCHAR(40),
    p_city VARCHAR(30),
    p_address VARCHAR(50)
    )
BEGIN
    INSERT INTO location (
        state_name,
        city,
        address)
    VALUES (
        p_state_name,
        p_city,
        p_address
    );
    SET @new_id_location = LAST_INSERT_ID();
    SELECT @new_id_location AS id_location;
END$$

-- ---------------------------------------------------------------------------------------------------------------------
# QUINTO STORE
DELIMITER $$
CREATE PROCEDURE insert_comunication(
    p_phone VARCHAR(10),
    p_email VARCHAR(50)
)
BEGIN
    INSERT INTO comunication (
        phone,
        email
    )
    VALUES (
        p_phone,
        p_email);
    SET @new_id_comunication = LAST_INSERT_ID();
    SELECT @new_id_comunication AS id_comunication;
END$$
-- ---------------------------------------------------------------------------------------------------------------------


-- SEGUNDO TRIGGERS --
DELIMITER $$
CREATE TRIGGER after_insert_person
AFTER INSERT ON person
FOR EACH ROW
BEGIN
    INSERT INTO customer (customer_type_id, person_id, company_id)
    VALUES (1, NEW.id_person, NULL);
END$$

INSERT INTO person (first_name, last_name, national_identity_document, age, location_id, comunication_id)
VALUES ('Vilma', 'Chelsea', '35692401', 40, 70, 70);  
