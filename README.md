# Car Rental Database (Oracle SQL)

Relational database project for a car rental system implemented in **Oracle SQL**.

The database models customers, employees, vehicles, rental contracts, returns, payments and insurance policies. It includes relational constraints, sample data, a reporting view and example SQL queries.

## Features

- Relational database schema for a car rental company
- Primary and foreign key relationships
- One-to-many and many-to-many relationships
- `CHECK`, `UNIQUE` and `NOT NULL` constraints
- Sample customers, employees and vehicles
- Sample rental contracts, returns and payments
- Vehicle status and category management
- Insurance policy tracking
- Rental summary view
- Example analytical queries

## Database Structure

The project contains the following main tables:

- `customers` – customer information
- `employees` – employees responsible for rentals
- `vehicle_types` – vehicle categories
- `vehicle_statuses` – vehicle availability and operational status
- `vehicles` – rental fleet
- `rentals` – rental contracts
- `rental_vehicles` – vehicles assigned to rental contracts
- `rental_returns` – completed rental return information
- `payments` – payments associated with rentals
- `insurance_policies` – vehicle insurance information

## Relationships

Examples of relationships implemented in the schema:

- Customer → Rentals
- Employee → Rentals
- Vehicle Type → Vehicles
- Vehicle Status → Vehicles
- Rentals ↔ Vehicles through `rental_vehicles`
- Rental → Return
- Rental → Payments
- Vehicle → Insurance Policies

## Data Integrity

The schema uses database constraints to enforce data consistency, including:

- unique VIN and registration numbers
- unique customer and employee email addresses
- positive rental and payment amounts
- valid vehicle production years
- valid rental status values
- valid payment methods
- return dates that cannot precede rental dates
- insurance expiration dates later than their start dates

## Reporting View

The project includes the `rental_summary` view.

It combines rental, customer and vehicle information into a single result containing:

- rental ID
- customer name
- vehicle
- rental date
- planned return date
- rental status
- agreed daily rate

## Example Queries

The SQL script contains example queries demonstrating:

- displaying rental contracts with customer and vehicle information
- finding currently available vehicles
- calculating total payments per rental
- listing vehicle insurance policies by expiration date

## Technologies

- Oracle SQL
- Relational database design
- SQL constraints
- SQL joins
- Views
- Aggregate queries

## Project File

The complete database schema, sample data, view and example queries are contained in:

```text
car_rental_database.sql
```

## How to Run

### Requirements

- Oracle Database
- Oracle SQL Developer or another Oracle-compatible SQL client

Clone the repository:

```bash
git clone https://github.com/radoslaw-witkowski/CarRental-Database-SQL.git
cd CarRental-Database-SQL
```

Run:

```text
car_rental_database.sql
```

The script creates the database objects, inserts sample data, creates the reporting view and executes example queries.

## Author

Radosław Witkowski
