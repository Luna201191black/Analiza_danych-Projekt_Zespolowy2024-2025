
# Raport Analizy Danych - Projekt Zespołowy 2024-2025
# Dodany przez Yuliya Sharkova

## 1. Wprowadzenie
Ten dokument zawiera podsumowanie procesu analizy i oczyszczania danych w projekcie zespołowym.

Plik wejściowy: `previous_application_new.csv`  
Plik wyjściowy: `previous_application_cleaned.csv`

---

## 2. Proces analizy i oczyszczania danych

### 2.1. Analiza braków
Liczba braków w kolumnach przed naprawą:

Procent braków w kolumnach:


---

### 2.2. Usuwanie kolumn z dużą liczbą braków
Usunięto kolumny z ponad 90% braków. Lista usuniętych kolumn:


---

### 2.3. Naprawa braków w pozostałych danych
Braki w danych liczbowych zostały uzupełnione medianą.  
Braki w danych kategorycznych zostały uzupełnione trybem.

---

### 2.4. Walidacja
Po oczyszczeniu danych nie ma braków w żadnej kolumnie.

Podsumowanie braków po naprawie:


---

## 3. Zapis danych
Oczyszczone dane zostały zapisane do pliku:

`C:/Users/user/Documents/GIT projekts/Analiza_danych-Projekt_Zespolowy2024-2025/previous_application_cleaned.csv`

---

## 4. Podsumowanie
Proces analizy danych został zakończony pomyślnie. Wyniki można znaleźć w pliku wyjściowym.


### 4.1. Aktualizacja po zmianach w NAME_TYPE_SUITE

Wartości `NA` w kolumnie `NAME_TYPE_SUITE` zostały zastąpione losowymi wartościami z istniejących danych:
- Unaccompanied
- Spouse, partner
- Family
- Children
- Other_B
- Other_A
- Group of people

Po naprawie, liczba braków w tej kolumnie wynosi 0.

Dane zapisano w nowym pliku: `previous_application_cleaned220241210_115342.csv`.

---


### 4.2. Aktualizacja po zmianach w NAME_YIELD_GROUP

Wartości `XNA` w kolumnie `NAME_YIELD_GROUP` zostały zastąpione losowymi wartościami z istniejących danych:
- middle
- high
- low_normal
- low_action

Po naprawie, liczba braków w tej kolumnie wynosi 0.

Dane zapisano w nowym pliku: `previous_application_cleaned3.csv`.

---


### 4.2. Aktualizacja po zmianach w NAME_YIELD_GROUP

Wartości `XNA` w kolumnie `NAME_YIELD_GROUP` zostały zastąpione losowymi wartościami z istniejących danych:
- middle
- high
- low_normal
- low_action

Po naprawie, liczba braków w tej kolumnie wynosi 0.

Dane zapisano w nowym pliku: `previous_application_cleaned3_20241210_123023.csv`.

---


### 4.3. Aktualizacja po zmianach w NAME_CASH_LOAN_PURPOSE

Wartości `XNA` i `XAP` w kolumnie `NAME_CASH_LOAN_PURPOSE` zostały zastąpione nowymi propozycjami:
- Investment
- Vacation
- Home Renovation
- Education
- Health Treatment
- Office Equipment

Po naprawie, liczba braków w tej kolumnie wynosi 0.

Dane zapisano w nowym pliku: `previous_application_cleaned4_20241210_130020.csv`.

---


### 4.4. Aktualizacja po zmianach w NAME_PAYMENT_TYPE

Wartości `XNA` w kolumnie `NAME_PAYMENT_TYPE` zostały zastąpione nowymi propozycjami:
- Cryptocurrency
- Bonds
- Mobile Payment
- WBMoney

Po naprawie, liczba braków w tej kolumnie wynosi 0.

Dane zapisano w nowym pliku: `previous_application_cleaned5_20241210_131100.csv`.

---



### 4.5. Aktualizacja po zmianach w CODE_REJECT_REASON

Wartości `XNA` i `XAP` w kolumnie `CODE_REJECT_REASON` zostały zastąpione nowymi propozycjami:
- Fraud Risk
- Incomplete Documents
- Insufficient History
- Technical Error

Wszystkie inne wartości zostały zachowane:
- HC
- LIMIT
- SCO
- CLIENT
- SCOFR
- VERIF
- SYSTEM

Po naprawie, liczba braków w tej kolumnie wynosi 0.

Dane zapisano w nowym pliku: `previous_application_cleaned6_20241210_132916.csv`.

---


### 4.6. Aktualizacja po zmianach w NAME_GOODS_CATEGORY

Wartości `XNA` w kolumnie `NAME_GOODS_CATEGORY` zostały zastąpione losowymi wartościami z istniejących danych.

Po naprawie, liczba braków w tej kolumnie wynosi 0.

Dane zapisano w nowym pliku: `previous_application_cleaned7_20241210_134237.csv`.

---


### 4.7. Aktualizacja po zmianach w NAME_PORTFOLIO

Wartości `XNA` w kolumnie `NAME_PORTFOLIO` zostały zastąpione losowymi wartościami z istniejących oraz nowych kategorii:
- POS
- Cash
- Cards
- Cars
- Savings
- Investments
- Insurance

Po naprawie, liczba braków w tej kolumnie wynosi 0.

Dane zapisano w nowym pliku: `previous_application_cleaned8_20241210_140142.csv`.

---


### 4.8. Aktualizacja po zmianach w NAME_PRODUCT_TYPE

Wartości `XNA` w kolumnie `NAME_PRODUCT_TYPE` zostały zastąpione losowymi wartościami z istniejących oraz nowych typów produktów:
- Personal 
- Mortgage
- Business 
- Education

Po naprawie, liczba braków w tej kolumnie wynosi 0.

Dane zapisano w nowym pliku: `previous_application_cleaned9_20241216_072521.csv`.

---


### 4.9. Aktualizacja po zmianach w SELLERPLACE_AREA

Wartości <= 0 w kolumnie `SELLERPLACE_AREA` zostały zastąpione losowymi istniejącymi wartościami, aby poprawić dane.

Po naprawie, liczba braków i nieprawidłowych wartości w tej kolumnie wynosi 0.

Dane zapisano w nowym pliku: `previous_application_cleaned10_20241216_074732.csv`.

---

