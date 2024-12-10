
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

