-- ===================================================
-- PROJEKT BAZY DANYCH: WYPOŻYCZALNIA SAMOCHODÓW
-- TECHNOLOGIA: ORACLE SQL
-- ===================================================

-- ===============================
-- TABELA: KLIENT
-- ===============================
CREATE TABLE KLIENT (
    id_klienta NUMBER(6) PRIMARY KEY,
    imie VARCHAR2(30) NOT NULL,
    nazwisko VARCHAR2(50) NOT NULL,
    pesel CHAR(11) NOT NULL UNIQUE,
    telefon VARCHAR2(15),
    email VARCHAR2(100)
);

COMMENT ON TABLE KLIENT IS 'Tabela przechowuje dane klientów wypożyczalni samochodów.';
COMMENT ON COLUMN KLIENT.id_klienta IS 'Klucz główny klienta';
COMMENT ON COLUMN KLIENT.pesel IS 'Unikalny numer PESEL klienta';

-- ===============================
-- TABELA: PRACOWNIK
-- ===============================
CREATE TABLE PRACOWNIK (
    id_pracownika NUMBER(6) PRIMARY KEY,
    imie VARCHAR2(30) NOT NULL,
    nazwisko VARCHAR2(50) NOT NULL,
    email VARCHAR2(100),
    stanowisko VARCHAR2(40)
);

COMMENT ON TABLE PRACOWNIK IS 'Tabela zawiera dane pracowników wypożyczalni samochodów.';

-- ===============================
-- TABELA: TYP_SPRZETU
-- ===============================
CREATE TABLE TYP_SPRZETU (
    id_typu NUMBER(3) PRIMARY KEY,
    nazwa_typu VARCHAR2(30) NOT NULL
);

COMMENT ON TABLE TYP_SPRZETU IS 'Typy dostępnych samochodów (np. SUV, sedan, kombi).';

-- ===============================
-- TABELA: STAN_SPRZETU
-- ===============================
CREATE TABLE STAN_SPRZETU (
    id_stanu NUMBER(3) PRIMARY KEY,
    opis_stanu VARCHAR2(50) NOT NULL
);

COMMENT ON TABLE STAN_SPRZETU IS 'Stany techniczne samochodów.';

-- ===============================
-- TABELA: SPRZET
-- ===============================
CREATE TABLE SPRZET (
    id_sprzetu NUMBER(6) PRIMARY KEY,
    nazwa VARCHAR2(50) NOT NULL,
    id_typu NUMBER(3) NOT NULL,
    id_stanu NUMBER(3) NOT NULL,
    numer_seryjny VARCHAR2(20) NOT NULL UNIQUE,
    FOREIGN KEY (id_typu) REFERENCES TYP_SPRZETU(id_typu),
    FOREIGN KEY (id_stanu) REFERENCES STAN_SPRZETU(id_stanu)
);

COMMENT ON TABLE SPRZET IS 'Tabela zawiera szczegóły wszystkich samochodów dostępnych do wypożyczenia.';

-- ===============================
-- TABELA: WYPOZYCZENIE (dynamiczna)
-- ===============================
CREATE TABLE WYPOZYCZENIE (
    id_wypozyczenia NUMBER(6) PRIMARY KEY,
    id_klienta NUMBER(6) NOT NULL,
    id_pracownika NUMBER(6) NOT NULL,
    data_wypozyczenia DATE DEFAULT SYSDATE NOT NULL,
    data_planowanego_zwrotu DATE NOT NULL,
    FOREIGN KEY (id_klienta) REFERENCES KLIENT(id_klienta),
    FOREIGN KEY (id_pracownika) REFERENCES PRACOWNIK(id_pracownika)
);

COMMENT ON TABLE WYPOZYCZENIE IS 'Dynamiczna tabela zawierająca informacje o wypożyczeniach samochodów.';

-- ===============================
-- TABELA: SZCZEGOLY_WYPOZYCZENIA
-- ===============================
CREATE TABLE SZCZEGOLY_WYPOZYCZENIA (
    id_wypozyczenia NUMBER(6) NOT NULL,
    id_sprzetu NUMBER(6) NOT NULL,
    PRIMARY KEY (id_wypozyczenia, id_sprzetu),
    FOREIGN KEY (id_wypozyczenia) REFERENCES WYPOZYCZENIE(id_wypozyczenia),
    FOREIGN KEY (id_sprzetu) REFERENCES SPRZET(id_sprzetu)
);

COMMENT ON TABLE SZCZEGOLY_WYPOZYCZENIA IS 'Tabela łącznikowa wypożyczenia z konkretnymi samochodami.';

-- ===============================
-- TABELA: ZWROT
-- ===============================
CREATE TABLE ZWROT (
    id_wypozyczenia NUMBER(6) PRIMARY KEY,
    data_zwrotu DATE,
    uwagi VARCHAR2(200),
    FOREIGN KEY (id_wypozyczenia) REFERENCES WYPOZYCZENIE(id_wypozyczenia)
);

COMMENT ON TABLE ZWROT IS 'Informacje o zwrotach wypożyczeń samochodów.';

-- ===============================
-- TABELA: PLATNOSC
-- ===============================
CREATE TABLE PLATNOSC (
    id_platnosci NUMBER(6) PRIMARY KEY,
    id_wypozyczenia NUMBER(6) NOT NULL,
    data_platnosci DATE DEFAULT SYSDATE NOT NULL,
    kwota NUMBER(8,2) NOT NULL,
    metoda VARCHAR2(20) NOT NULL,
    FOREIGN KEY (id_wypozyczenia) REFERENCES WYPOZYCZENIE(id_wypozyczenia)
);

COMMENT ON TABLE PLATNOSC IS 'Tabela przechowuje informacje o płatnościach związanych z wypożyczeniem samochodów.';

-- ===============================
-- TABELA: UBEZPIECZENIE
-- ===============================
CREATE TABLE UBEZPIECZENIE (
    id_ubezpieczenia NUMBER(6) PRIMARY KEY,
    id_sprzetu NUMBER(6) NOT NULL,
    rodzaj VARCHAR2(20) NOT NULL,
    firma VARCHAR2(50),
    data_od DATE NOT NULL,
    data_do DATE NOT NULL,
    FOREIGN KEY (id_sprzetu) REFERENCES SPRZET(id_sprzetu)
);

COMMENT ON TABLE UBEZPIECZENIE IS 'Tabela zawiera dane o ubezpieczeniach samochodów.';

-- ===============================
-- DALSZA CZĘŚĆ SKRYPTU BEZ ZMIAN (widoki, procedury itd.)
-- ===============================

-- ===============================
-- DANE TESTOWE
-- ===============================

-- KLIENCI
INSERT INTO KLIENT VALUES (1, 'Marek', 'Kowalski', '89010112345', '505111222', 'marek.kowalski@example.com');
INSERT INTO KLIENT VALUES (2, 'Katarzyna', 'Nowak', '92030598765', '505333444', 'kasia.nowak@example.com');

-- PRACOWNICY
INSERT INTO PRACOWNIK VALUES (1, 'Ewelina', 'Bąk', 'ewelina.bak@wypozyczalnia.pl', 'Doradca klienta');
INSERT INTO PRACOWNIK VALUES (2, 'Paweł', 'Lis', 'pawel.lis@wypozyczalnia.pl', 'Kierownik zmiany');

-- TYPY SAMOCHODÓW
INSERT INTO TYP_SPRZETU VALUES (1, 'SUV');
INSERT INTO TYP_SPRZETU VALUES (2, 'Sedan');
INSERT INTO TYP_SPRZETU VALUES (3, 'Kombi');

-- STANY TECHNICZNE
INSERT INTO STAN_SPRZETU VALUES (1, 'Nowy');
INSERT INTO STAN_SPRZETU VALUES (2, 'Bardzo dobry');
INSERT INTO STAN_SPRZETU VALUES (3, 'Do przeglądu');

-- SAMOCHODY
INSERT INTO SPRZET VALUES (1, 'Toyota Corolla', 2, 1, 'VIN-TC-001');
INSERT INTO SPRZET VALUES (2, 'BMW X3', 1, 1, 'VIN-BX3-002');
INSERT INTO SPRZET VALUES (3, 'Skoda Octavia', 3, 2, 'VIN-SO-003');

-- UBEZPIECZENIA
INSERT INTO UBEZPIECZENIE VALUES (1, 1, 'OC', 'PZU', TO_DATE('2024-01-01', 'YYYY-MM-DD'), TO_DATE('2025-01-01', 'YYYY-MM-DD'));
INSERT INTO UBEZPIECZENIE VALUES (2, 2, 'OC', 'Allianz', TO_DATE('2024-02-01', 'YYYY-MM-DD'), TO_DATE('2025-02-01', 'YYYY-MM-DD'));
INSERT INTO UBEZPIECZENIE VALUES (3, 2, 'AC', 'Allianz', TO_DATE('2024-02-01', 'YYYY-MM-DD'), TO_DATE('2025-02-01', 'YYYY-MM-DD'));
INSERT INTO UBEZPIECZENIE VALUES (4, 3, 'OC', 'Warta', TO_DATE('2024-03-01', 'YYYY-MM-DD'), TO_DATE('2025-03-01', 'YYYY-MM-DD'));
