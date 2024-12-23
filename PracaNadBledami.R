# ********************************************************
# 1.Musimy zainstalować oraz załadować potrzebne pakiety.
# ********************************************************
# Instalacja pakietów.

#komunikat
cat("Instalacja i ładowanie pakietów...\n")
# Do pracy nad danymi.
install.packages("dplyr") 
# Do wizualizacji danych.
install.packages("ggplot2")
#Paket do zaawansowanej analizy danych.
install.packages("VIM")       

# ładujemy pakety.
library(dplyr)
library(ggplot2)
library(VIM)

#komunikat
cat("Pakiety poprawne załadowane.\n")

# ********************************************************
# 2.Wcytamy dane z pliku.
# ********************************************************

#komunikat
cat("Wczytywanie danych z pliku danych CSV...\n")

# Ścieżka do pliku.
dane <- "C:/Users/user/Documents/GIT projekts/Analiza_danych-Projekt_Zespolowy2024-2025/previous_application_new.csv"

# Wczytanie danych z pliku CSV
data <- read.csv(dane, stringsAsFactors = FALSE)

#komunikat
cat("Dane wczytane. Liczba wierszy i kolumn:\n")
 # Wyświetlenie liczby wierszy i kolumn
print(dim(data)) 

# Wyświetlamy strukturę danych
str(data)

# ********************************************************
# 3.Analizujemy braki.
# ********************************************************

#komunikat
cat("Analiza braków danych...\n")

# Obliczamy liczbę braków w każdej kolumnie.
missing_summary <- colSums(is.na(data))

# Procent brakow w każdej kolumnie.
missing_percentage <- (missing_summary / nrow(data)) * 100

# Tworzenie podsumowania braków
missing_df <- data.frame(
  Column = names(missing_summary),  
  Missing = missing_summary,        
  Percentage = missing_percentage   
)

# Robimy sortowanie wyników od największej liczby braków
missing_df <- missing_df[order(-missing_df$Missing), ]
print(missing_df)

# Wizualizacja braków
ggplot(missing_df, aes(x = reorder(Column, -Percentage), y = Percentage)) +
  geom_bar(stat = "identity", fill = "red") +
  coord_flip() +
  labs(title = "Brakujące dane w kolumnach", x = "Kolumna", y = "Procent braków")

# ********************************************************
# 4: Usuwamy kolumny z dużą liczbą braków
# ********************************************************

#komunikat
cat("Usuwanie kolumn z ponad 90% braków...\n")

# Usuwamy kolumny z ponad 90% braków
columns_to_drop <- missing_df$Column[missing_df$Percentage > 90]
data_cleaned <- data[, !(names(data) %in% columns_to_drop)]

#komunikat
cat("Kolumny usunięte:\n")

# Wyświetlamy listę usuniętych kolumn
print(columns_to_drop)

# ********************************************************
# 5: Naprawa braków w pozostałych danych
# ********************************************************

#komunikat
cat("Naprawa braków w danych liczbowych i kategorycznych...\n")

# Wypełnianie medianą dla danych liczbowych
num_cols <- sapply(data_cleaned, is.numeric)  # Wybieramy kolumny numeryczne
data_cleaned[, num_cols] <- lapply(data_cleaned[, num_cols], function(x) {
  ifelse(is.na(x), median(x, na.rm = TRUE), x)  # Zamiana braków na medianę
})

#komunikat
cat("Braki w danych liczbowych uzupełnione medianą.\n")

# Funkcja dla obliczania trybu
Mode <- function(x) {
  ux <- unique(x)
  ux[which.max(tabulate(match(x, ux)))]
}

# Wypełnianie trybem dla danych kategorycznych
cat_cols <- sapply(data_cleaned, is.character)
data_cleaned[, cat_cols] <- lapply(data_cleaned[, cat_cols], function(x) {
  ifelse(is.na(x), as.character(Mode(x)), x)
})


#komunikat
cat("Braki w danych kategorycznych zostały uzupełnione trybem.\n")

# ********************************************************
# 6: Walidacja danych.
# ********************************************************

#komunikat
cat("Walidacja danych po naprawie...\n")


# Sprawdzenie braków po naprawie
missing_summary_after <- colSums(is.na(data_cleaned))
print(missing_summary_after)

# Walidacja: sprawdzamy, czy są jeszcze braki
if (all(missing_summary_after == 0)) {
  print("Wszystkie braki zostały naprawione!")
} else {
  print("Mamy braki jeszcze w danych.")
}

# ********************************************************
# 7: Zapisujemy dane.
# ********************************************************


#komunikat
cat("Zapisanie danych do pliku...\n")

# Zapisanie nowego pliku
output_file <- "C:/Users/user/Documents/GIT projekts/Analiza_danych-Projekt_Zespolowy2024-2025/previous_application_cleaned.csv"
write.csv(data_cleaned, output_file, row.names = FALSE)

print(paste("Oczyszczone dane zapisano do pliku:", output_file))


# ********************************************************
# 8: Tworzenie raportu w pliku README.md
# ********************************************************

#komunikat
cat("Tworzenie raportu z analizy danych...\n")

# Ścieżka do pliku README.md
readme_path <- "C:/Users/user/Documents/GIT projekts/Analiza_danych-Projekt_Zespolowy2024-2025/README.md"

# Zawartość raportu
readme_content <- paste0("
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
")

# Ścieżka do istniejącego pliku README.md
readme_path <- "C:/Users/user/Documents/GIT projekts/Analiza_danych-Projekt_Zespolowy2024-2025/README.md"

# ********************************************************
# 9. Dopisywanie nowych analiz do README.md
# ********************************************************

# Komunikat
cat("Kontynuacja napraw braków w danych liczbowych i kategorycznych w 'data_cleaned'...\n")

# Wczytywanie danych z pliku CSV
cat("Wczytywanie danych z pliku CSV...\n")

# Ścieżka do pliku
input_path <- "C:/Users/user/Documents/GIT projekts/Analiza_danych-Projekt_Zespolowy2024-2025/previous_application_cleaned.csv"
data_cleaned <- read.csv(input_path, stringsAsFactors = FALSE)

# ********************************************************
# 10. Naprawa braków w 'data_cleaned' w kolumnie NAME_TYPE_SUITE
# ********************************************************

# Sprawdzenie unikalnych wartości
cat("Unikalne wartości w kolumnie NAME_TYPE_SUITE:\n")
unique_values <- unique(data_cleaned$NAME_TYPE_SUITE)
print(unique_values)

# Usuwanie NA z listy unikalnych wartości
existing_values <- na.omit(unique(data_cleaned$NAME_TYPE_SUITE))

# Zastępowanie NA losowymi wartościami
set.seed(123)
data_cleaned$NAME_TYPE_SUITE[is.na(data_cleaned$NAME_TYPE_SUITE)] <- sample(
  existing_values, 
  sum(is.na(data_cleaned$NAME_TYPE_SUITE)), 
  replace = TRUE
)

cat("Wszystkie wartości NA w kolumnie NAME_TYPE_SUITE zostały zastąpione losowymi wartościami z istniejącej listy.\n")

# ********************************************************
# 11. Zapisanie wyników po zmianach do nowego pliku
# ********************************************************

# Tworzenie unikalnej nazwy pliku na podstawie daty i godziny
timestamp <- format(Sys.time(), "%Y%m%d_%H%M%S")
output_path <- paste0("C:/Users/user/Documents/GIT projekts/Analiza_danych-Projekt_Zespolowy2024-2025/previous_application_cleaned2", timestamp, ".csv")

write.csv(data_cleaned, output_path, row.names = FALSE)

cat(paste("Zaktualizowane dane zapisano do nowego pliku:", output_path, "\n"))

# ********************************************************
# 12. Aktualizacja README.md
# ********************************************************

# Funkcja do dopisywania zawartości do README.md
append_to_readme <- function(content, path) {
  write(content, file = path, append = TRUE)
}

# Dopisanie nowej sekcji do README.md
new_content <- paste0("
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

Dane zapisano w nowym pliku: `", basename(output_path), "`.

---
")

append_to_readme(new_content, readme_path)

cat("Zmiany zostały dopisane do README.md.\n")



# Ścieżka do istniejącego pliku README.md
readme_path <- "C:/Users/user/Documents/GIT projekts/Analiza_danych-Projekt_Zespolowy2024-2025/README.md"

# ********************************************************
# 13 Dopisywanie nowych analiz do README.md
# ********************************************************

# Komunikat
cat("Kontynuacja napraw braków w danych liczbowych i kategorycznych w 'previous_application_cleaned220241210_115342.csv'...\n")

# Wczytywanie danych z pliku CSV
cat("Wczytywanie danych z pliku CSV...\n")

# Ścieżka do pliku
input_path <- "C:/Users/user/Documents/GIT projekts/Analiza_danych-Projekt_Zespolowy2024-2025/previous_application_cleaned220241210_115342.csv"
data_cleaned2 <- read.csv(input_path, stringsAsFactors = FALSE)

# ********************************************************
# 14. Naprawa braków w 'data_cleaned2' w kolumnie NAME_YIELD_GROUP
# ********************************************************

# Usuwanie 'XNA' z listy unikalnych wartości
existing_values <- unique(data_cleaned2$NAME_YIELD_GROUP[data_cleaned2$NAME_YIELD_GROUP != "XNA"])

# Zastępowanie 'XNA' losowymi wartościami
set.seed(123)
data_cleaned2$NAME_YIELD_GROUP[data_cleaned2$NAME_YIELD_GROUP == "XNA"] <- sample(
  existing_values, 
  sum(data_cleaned2$NAME_YIELD_GROUP == "XNA"), 
  replace = TRUE
)

cat("Wszystkie wartości XNA w kolumnie NAME_YIELD_GROUP zostały zastąpione losowymi wartościami z istniejącej listy.\n")

# ********************************************************
# 15. Zapisanie wyników po zmianach do nowego pliku
# ********************************************************

# Tworzenie unikalnej nazwy pliku
timestamp <- format(Sys.time(), "%Y%m%d_%H%M%S")
output_path <- paste0("C:/Users/user/Documents/GIT projekts/Analiza_danych-Projekt_Zespolowy2024-2025/previous_application_cleaned3_", timestamp, ".csv")

write.csv(data_cleaned2, output_path, row.names = FALSE)

cat(paste("Zaktualizowane dane zapisano do nowego pliku:", output_path, "\n"))

# ********************************************************
# 16. Aktualizacja README.md
# ********************************************************

# Dopisanie nowej sekcji do README.md
new_content <- paste0("
### 4.2. Aktualizacja po zmianach w NAME_YIELD_GROUP

Wartości `XNA` w kolumnie `NAME_YIELD_GROUP` zostały zastąpione losowymi wartościami z istniejących danych:
- middle
- high
- low_normal
- low_action

Po naprawie, liczba braków w tej kolumnie wynosi 0.

Dane zapisano w nowym pliku: `", basename(output_path), "`.

---
")

# Dopisanie do README.md
append_to_readme <- function(content, path) {
  write(content, file = path, append = TRUE)
}

append_to_readme(new_content, readme_path)

cat("Zmiany zostały dopisane do README.md.\n")



# Ścieżka do istniejącego pliku README.md
readme_path <- "C:/Users/user/Documents/GIT projekts/Analiza_danych-Projekt_Zespolowy2024-2025/README.md"

# ********************************************************
# 17 Dopisywanie nowych analiz do README.md
# ********************************************************

# Komunikat
cat("Kontynuacja napraw braków w danych liczbowych i kategorycznych w 'previous_application_cleaned3_20241210_123023.csv'...\n")

# Wczytywanie danych z pliku CSV
cat("Wczytywanie danych z pliku CSV...\n")

# Ścieżka do pliku
input_path <- "C:/Users/user/Documents/GIT projekts/Analiza_danych-Projekt_Zespolowy2024-2025/previous_application_cleaned3_20241210_123023.csv"


data_cleaned3<- read.csv(input_path, stringsAsFactors = FALSE)




# ********************************************************
# 18. Naprawa braków w 'data_cleaned2' w kolumnie NAME_CASH_LOAN_PURPOSE
# ********************************************************

# Definiowanie nowych propozycji wartości
new_proposals <- c("Investment", "Vacation", "Home Renovation", "Education", "Health Treatment", "Office Equipment")

# Zastąpienie 'XNA' i 'XAP' nowymi wartościami
set.seed(123)
data_cleaned3$NAME_CASH_LOAN_PURPOSE[data_cleaned3$NAME_CASH_LOAN_PURPOSE %in% c("XNA", "XAP")] <- sample(
  new_proposals, 
  sum(data_cleaned3$NAME_CASH_LOAN_PURPOSE %in% c("XNA", "XAP")), 
  replace = TRUE
)

cat("Wartości 'XNA' i 'XAP' w kolumnie NAME_CASH_LOAN_PURPOSE zostały zastąpione nowymi propozycjami.\n")

# ********************************************************
# 19. Zapisanie wyników po zmianach do nowego pliku
# ********************************************************

# Tworzenie unikalnej nazwy pliku
timestamp <- format(Sys.time(), "%Y%m%d_%H%M%S")
output_path <- paste0("C:/Users/user/Documents/GIT projekts/Analiza_danych-Projekt_Zespolowy2024-2025/previous_application_cleaned4_", timestamp, ".csv")

write.csv(data_cleaned3, output_path, row.names = FALSE)

cat(paste("Zaktualizowane dane zapisano do nowego pliku:", output_path, "\n"))

# ********************************************************
# 20. Aktualizacja README.md
# ********************************************************

# Dopisanie nowej sekcji do README.md
new_content <- paste0("
### 4.3. Aktualizacja po zmianach w NAME_CASH_LOAN_PURPOSE

Wartości `XNA` i `XAP` w kolumnie `NAME_CASH_LOAN_PURPOSE` zostały zastąpione nowymi propozycjami:
- Investment
- Vacation
- Home Renovation
- Education
- Health Treatment
- Office Equipment

Po naprawie, liczba braków w tej kolumnie wynosi 0.

Dane zapisano w nowym pliku: `", basename(output_path), "`.

---
")

# Dopisanie do README.md
append_to_readme <- function(content, path) {
  write(content, file = path, append = TRUE)
}

append_to_readme(new_content, readme_path)

cat("Zmiany zostały dopisane do README.md.\n")


# Ścieżka do istniejącego pliku README.md
readme_path <- "C:/Users/user/Documents/GIT projekts/Analiza_danych-Projekt_Zespolowy2024-2025/README.md"

# ********************************************************
# 21. Dopisywanie nowych analiz do README.md
# ********************************************************

# Komunikat
cat("Kontynuacja napraw braków w danych liczbowych i kategorycznych w 'previous_application_cleaned4_20241210_130020.csv'...\n")

# Wczytywanie danych z pliku CSV
cat("Wczytywanie danych z pliku CSV...\n")

# Ścieżka do pliku
input_path <- "C:/Users/user/Documents/GIT projekts/Analiza_danych-Projekt_Zespolowy2024-2025/previous_application_cleaned4_20241210_130020.csv"

data_cleaned4 <- read.csv(input_path, stringsAsFactors = FALSE)

# ********************************************************
# 22. Naprawa braków w 'data_cleaned4' w kolumnie NAME_PAYMENT_TYPE
# ********************************************************

# Definiowanie nowych propozycji wartości
new_payment_types <- c("Cryptocurrency", "Bonds", "Mobile Payment", "WBMoney")

# Zastąpienie 'XNA' nowymi wartościami
set.seed(123)
data_cleaned4$NAME_PAYMENT_TYPE[data_cleaned4$NAME_PAYMENT_TYPE == "XNA"] <- sample(
  new_payment_types, 
  sum(data_cleaned4$NAME_PAYMENT_TYPE == "XNA"), 
  replace = TRUE
)

cat("Wartości 'XNA' w kolumnie NAME_PAYMENT_TYPE zostały zastąpione nowymi propozycjami.\n")

# ********************************************************
# 23. Zapisanie wyników po zmianach do nowego pliku
# ********************************************************

# Tworzenie unikalnej nazwy pliku
timestamp <- format(Sys.time(), "%Y%m%d_%H%M%S")
output_path <- paste0("C:/Users/user/Documents/GIT projekts/Analiza_danych-Projekt_Zespolowy2024-2025/previous_application_cleaned5_", timestamp, ".csv")

write.csv(data_cleaned4, output_path, row.names = FALSE)

cat(paste("Zaktualizowane dane zapisano do nowego pliku:", output_path, "\n"))

# ********************************************************
# 24. Aktualizacja README.md
# ********************************************************

# Dopisanie nowej sekcji do README.md
new_content <- paste0("
### 4.4. Aktualizacja po zmianach w NAME_PAYMENT_TYPE

Wartości `XNA` w kolumnie `NAME_PAYMENT_TYPE` zostały zastąpione nowymi propozycjami:
- Cryptocurrency
- Bonds
- Mobile Payment
- WBMoney

Po naprawie, liczba braków w tej kolumnie wynosi 0.

Dane zapisano w nowym pliku: `", basename(output_path), "`.

---
")

# Dopisanie do README.md
append_to_readme <- function(content, path) {
  write(content, file = path, append = TRUE)
}

append_to_readme(new_content, readme_path)

cat("Zmiany zostały dopisane do README.md.\n")



# Ścieżka do istniejącego pliku README.md
readme_path <- "C:/Users/user/Documents/GIT projekts/Analiza_danych-Projekt_Zespolowy2024-2025/README.md"

# ********************************************************
# 25. Dopisywanie nowych analiz do README.md
# ********************************************************

# Komunikat
cat("Kontynuacja napraw braków w danych liczbowych i kategorycznych w 'previous_application_cleaned5_20241210_131100.csv'...\n")

# Wczytywanie danych z pliku CSV
cat("Wczytywanie danych z pliku CSV...\n")

# Ścieżka do pliku
input_path <- "C:/Users/user/Documents/GIT projekts/Analiza_danych-Projekt_Zespolowy2024-2025/previous_application_cleaned5_20241210_131100.csv"

data_cleaned5 <- read.csv(input_path, stringsAsFactors = FALSE)

# ********************************************************
# 26. Naprawa braków w 'data_cleaned5' w kolumnie CODE_REJECT_REASON
# ********************************************************

# Definiowanie nowych propozycji wartości
new_reject_reasons <- c("Fraud Risk", "Incomplete Documents", "Insufficient History", "Technical Error")

# Zastąpienie tylko wartości 'XNA' i 'XAP' nowymi propozycjami
set.seed(123)
data_cleaned5$CODE_REJECT_REASON[data_cleaned5$CODE_REJECT_REASON %in% c("XNA", "XAP")] <- sample(
  new_reject_reasons, 
  sum(data_cleaned5$CODE_REJECT_REASON %in% c("XNA", "XAP")), 
  replace = TRUE
)

cat("Wartości 'XNA' i 'XAP' w kolumnie CODE_REJECT_REASON zostały zastąpione nowymi propozycjami.\n")

# ********************************************************
# 27. Zapisanie wyników po zmianach do nowego pliku
# ********************************************************

# Tworzenie unikalnej nazwy pliku
timestamp <- format(Sys.time(), "%Y%m%d_%H%M%S")
output_path <- paste0("C:/Users/user/Documents/GIT projekts/Analiza_danych-Projekt_Zespolowy2024-2025/previous_application_cleaned6_", timestamp, ".csv")

write.csv(data_cleaned5, output_path, row.names = FALSE)

cat(paste("Zaktualizowane dane zapisano do nowego pliku:", output_path, "\n"))

# ********************************************************
# 28. Aktualizacja README.md
# ********************************************************

# Dopisanie nowej sekcji do README.md
new_content <- paste0("
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

Dane zapisano w nowym pliku: `", basename(output_path), "`.

---
")

# Dopisanie do README.md
append_to_readme <- function(content, path) {
  write(content, file = path, append = TRUE)
}

append_to_readme(new_content, readme_path)

cat("Zmiany zostały dopisane do README.md.\n")



# Ścieżka do istniejącego pliku README.md
readme_path <- "C:/Users/user/Documents/GIT projekts/Analiza_danych-Projekt_Zespolowy2024-2025/README.md"

# ********************************************************
# 29. Dopisywanie nowych analiz do README.md
# ********************************************************

# Komunikat
cat("Kontynuacja napraw braków w danych liczbowych i kategorycznych w 'previous_application_cleaned6_20241210_132916.csv'...\n")

# Wczytywanie danych z pliku CSV
cat("Wczytywanie danych z pliku CSV...\n")

# Ścieżka do pliku
input_path <- "C:/Users/user/Documents/GIT projekts/Analiza_danych-Projekt_Zespolowy2024-2025/previous_application_cleaned6_20241210_132916.csv"

data_cleaned6 <- read.csv(input_path, stringsAsFactors = FALSE)

# ********************************************************
# 30 Naprawa braków w 'data_cleaned6' w kolumnie NAME_GOODS_CATEGORY
# ********************************************************

# Lista istniejących wartości bez 'XNA'
existing_categories <- unique(data_cleaned6$NAME_GOODS_CATEGORY[data_cleaned6$NAME_GOODS_CATEGORY != "XNA"])

# Zastąpienie 'XNA' losowymi wartościami z istniejących kategorii
set.seed(123)
data_cleaned6$NAME_GOODS_CATEGORY[data_cleaned6$NAME_GOODS_CATEGORY == "XNA"] <- sample(
  existing_categories, 
  sum(data_cleaned6$NAME_GOODS_CATEGORY == "XNA"), 
  replace = TRUE
)

cat("Wartości 'XNA' w kolumnie NAME_GOODS_CATEGORY zostały zastąpione losowymi wartościami z istniejącej listy.\n")


# ********************************************************
# 31. Zapisanie wyników po zmianach do nowego pliku
# ********************************************************

# Tworzenie unikalnej nazwy pliku
timestamp <- format(Sys.time(), "%Y%m%d_%H%M%S")
output_path <- paste0("C:/Users/user/Documents/GIT projekts/Analiza_danych-Projekt_Zespolowy2024-2025/previous_application_cleaned7_", timestamp, ".csv")

# Zapisanie zaktualizowanego pliku
write.csv(data_cleaned6, output_path, row.names = FALSE)

cat(paste("Zaktualizowane dane zapisano do nowego pliku:", output_path, "\n"))

# ********************************************************
# 32. Aktualizacja README.md
# ********************************************************

# Dopisanie nowej sekcji do README.md
new_content <- paste0("
### 4.6. Aktualizacja po zmianach w NAME_GOODS_CATEGORY

Wartości `XNA` w kolumnie `NAME_GOODS_CATEGORY` zostały zastąpione losowymi wartościami z istniejących danych.

Po naprawie, liczba braków w tej kolumnie wynosi 0.

Dane zapisano w nowym pliku: `", basename(output_path), "`.

---
")

# Funkcja dopisująca nową sekcję do README.md
append_to_readme <- function(content, path) {
  write(content, file = path, append = TRUE)
}

# Aktualizacja README.md
append_to_readme(new_content, readme_path)

cat("Zmiany zostały dopisane do README.md.\n")



# Ścieżka do istniejącego pliku README.md
readme_path <- "C:/Users/user/Documents/GIT projekts/Analiza_danych-Projekt_Zespolowy2024-2025/README.md"

# ********************************************************
# 33. Dopisywanie nowych analiz do README.md
# ********************************************************

# Komunikat
cat("Kontynuacja napraw braków w danych liczbowych i kategorycznych w 'previous_application_cleaned7_20241210_134237'...\n")

# Wczytywanie danych z pliku CSV
cat("Wczytywanie danych z pliku CSV...\n")

# Ścieżka do pliku
input_path <- "C:/Users/user/Documents/GIT projekts/Analiza_danych-Projekt_Zespolowy2024-2025/previous_application_cleaned7_20241210_134237.csv"

data_cleaned7 <- read.csv(input_path, stringsAsFactors = FALSE)

# ********************************************************
# 34. Naprawa braków w 'data_cleaned7' w kolumnie NAME_PORTFOLIO
# ********************************************************

# Lista istniejących wartości bez 'XNA'
existing_categories <- unique(data_cleaned7$NAME_GOODS_CATEGORY[data_cleaned7$NAME_GOODS_CATEGORY != "XNA"])

# Zastąpienie 'XNA' losowymi wartościami z listy wszystkich kategorii
set.seed(123)
data_cleaned7$NAME_PORTFOLIO[data_cleaned7$NAME_PORTFOLIO == "XNA"] <- sample(
  existing_categories, 
  sum(data_cleaned7$NAME_PORTFOLIO == "XNA"), 
  replace = TRUE
)

cat("Wartości 'XNA' w kolumnie NAME_PORTFOLIO zostały zastąpione losowymi wartościami z poszerzonej listy kategorii.\n")

# ********************************************************
# 35. Zapisanie wyników po zmianach do nowego pliku
# ********************************************************

# Tworzenie unikalnej nazwy pliku
timestamp <- format(Sys.time(), "%Y%m%d_%H%M%S")
output_path <- paste0("C:/Users/user/Documents/GIT projekts/Analiza_danych-Projekt_Zespolowy2024-2025/previous_application_cleaned8_", timestamp, ".csv")

write.csv(data_cleaned7, output_path, row.names = FALSE)

cat(paste("Zaktualizowane dane zapisano do nowego pliku:", output_path, "\n"))

# ********************************************************
# 36. Aktualizacja README.md
# ********************************************************

# Dopisanie nowej sekcji do README.md
new_content <- paste0("
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

Dane zapisano w nowym pliku: `", basename(output_path), "`.

---
")

# Funkcja dopisująca do README.md
append_to_readme <- function(content, path) {
  write(content, file = path, append = TRUE)
}

append_to_readme(new_content, readme_path)

cat("Zmiany zostały dopisane do README.md.\n")



 
# ********************************************************
# 38. Naprawa braków w 'data_cleaned8' w kolumnie NAME_PRODUCT_TYPE
# ********************************************************

# Lista istniejących wartości w kolumnie 'NAME_PRODUCT_TYPE' bez 'XNA'
existing_product_types <- unique(data_cleaned8$NAME_PRODUCT_TYPE[data_cleaned8$NAME_PRODUCT_TYPE != "XNA"])

# Lista nowych wartości, które chcesz dodać
new_product_types <- c("Personal ", "Mortgage", "Business", "Education")

# Połączenie istniejących kategorii (bez 'XNA') z nowymi
product_types_pool <- c(existing_product_types, new_product_types)

# Zastąpienie 'XNA' losowymi wartościami z pełnej listy kategorii
set.seed(123)
data_cleaned8$NAME_PRODUCT_TYPE[data_cleaned8$NAME_PRODUCT_TYPE == "XNA"] <- sample(
  product_types_pool,
  sum(data_cleaned7$NAME_PRODUCT_TYPE == "XNA"),
  replace = TRUE
)

cat("Wartości 'XNA' w kolumnie NAME_PRODUCT_TYPE zostały zastąpione losowymi wartościami z pełnej listy typów produktów, w tym nowych.\n")

# ********************************************************
# 39. Zapisanie wyników po zmianach do nowego pliku
# ********************************************************

# Tworzenie unikalnej nazwy pliku
timestamp <- format(Sys.time(), "%Y%m%d_%H%M%S")
output_path <- paste0("C:/Users/user/Documents/GIT projekts/Analiza_danych-Projekt_Zespolowy2024-2025/previous_application_cleaned9_", timestamp, ".csv")

write.csv(data_cleaned8, output_path, row.names = FALSE)

cat(paste("Zaktualizowane dane zapisano do nowego pliku:", output_path, "\n"))

# ********************************************************
# 40. Aktualizacja README.md
# ********************************************************

# Dopisanie nowej sekcji do README.md
new_content <- paste0("
### 4.8. Aktualizacja po zmianach w NAME_PRODUCT_TYPE

Wartości `XNA` w kolumnie `NAME_PRODUCT_TYPE` zostały zastąpione losowymi wartościami z istniejących oraz nowych typów produktów:
- Personal 
- Mortgage
- Business 
- Education

Po naprawie, liczba braków w tej kolumnie wynosi 0.

Dane zapisano w nowym pliku: `", basename(output_path), "`.

---
")

# Funkcja dopisująca do README.md
append_to_readme <- function(content, path) {
  write(content, file = path, append = TRUE)
}

append_to_readme(new_content, readme_path)

cat("Zmiany zostały dopisane do README.md.\n")


# Ścieżka do istniejącego pliku README.md
readme_path <- "C:/Users/user/Documents/GIT projekts/Analiza_danych-Projekt_Zespolowy2024-2025/README.md"

# ********************************************************
# 42. Dopisywanie nowych analiz do README.md
# ********************************************************

# Komunikat
cat("Kontynuacja napraw braków w danych liczbowych i kategorycznych w 'previous_application_cleaned9_20241216_072521'...\n")

# Wczytywanie danych z pliku CSV
cat("Wczytywanie danych z pliku CSV...\n")

# Ścieżka do pliku
input_path <-"C:/Users/user/Documents/GIT projekts/Analiza_danych-Projekt_Zespolowy2024-2025/previous_application_cleaned9_20241216_072521.csv"

data_cleaned9 <- read.csv(input_path, stringsAsFactors = FALSE)



# ********************************************************
# 43. Naprawa braków w 'data_cleaned9' w kolumnie SELLERPLACE_AREA
# ********************************************************

# Lista istniejących wartości w kolumnie 'SELLERPLACE_AREA' (bez wartości <= 0)
existing_sellerplace_areas <- unique(data_cleaned9$SELLERPLACE_AREA[data_cleaned9$SELLERPLACE_AREA > 0])

# Zastąpienie wartości <= 0 losowymi istniejącymi wartościami
set.seed(123)
data_cleaned9$SELLERPLACE_AREA[data_cleaned9$SELLERPLACE_AREA <= 0] <- sample(
  existing_sellerplace_areas,
  sum(data_cleaned9$SELLERPLACE_AREA <= 0),
  replace = TRUE
)

cat("Wartości <= 0 w kolumnie SELLERPLACE_AREA zostały zastąpione losowymi istniejącymi wartościami.\n")

# ********************************************************
# 44. Zapisanie wyników po zmianach do nowego pliku
# ********************************************************

# Tworzenie unikalnej nazwy pliku
timestamp <- format(Sys.time(), "%Y%m%d_%H%M%S")
output_path <- paste0("C:/Users/user/Documents/GIT projekts/Analiza_danych-Projekt_Zespolowy2024-2025/previous_application_cleaned10_", timestamp, ".csv")

write.csv(data_cleaned9, output_path, row.names = FALSE)

cat(paste("Zaktualizowane dane zapisano do nowego pliku:", output_path, "\n"))

# ********************************************************
# 45. Aktualizacja README.md
# ********************************************************

# Dopisanie nowej sekcji do README.md
new_content <- paste0("
### 4.9. Aktualizacja po zmianach w SELLERPLACE_AREA

Wartości <= 0 w kolumnie `SELLERPLACE_AREA` zostały zastąpione losowymi istniejącymi wartościami, aby poprawić dane.

Po naprawie, liczba braków i nieprawidłowych wartości w tej kolumnie wynosi 0.

Dane zapisano w nowym pliku: `", basename(output_path), "`.

---
")

# Funkcja dopisująca do README.md
append_to_readme <- function(content, path) {
  write(content, file = path, append = TRUE)
}

append_to_readme(new_content, readme_path)

cat("Zmiany zostały dopisane do README.md.\n")


# Ścieżka do istniejącego pliku README.md
readme_path <- "C:/Users/user/Documents/GIT projekts/Analiza_danych-Projekt_Zespolowy2024-2025/README.md"

# ********************************************************
# 46. Dopisywanie nowych analiz do README.md
# ********************************************************

# Komunikat
cat("Kontynuacja napraw braków w danych liczbowych i kategorycznych w 'previous_application_cleaned10_20241216_074732'...\n")

# Wczytywanie danych z pliku CSV
cat("Wczytywanie danych z pliku CSV...\n")

# Ścieżka do pliku
input_path <-"C:/Users/user/Documents/GIT projekts/Analiza_danych-Projekt_Zespolowy2024-2025/previous_application_cleaned10_20241216_074732.csv"

data_cleaned10 <- read.csv(input_path, stringsAsFactors = FALSE)




# ********************************************************
# 47. Naprawa braków w 'data_cleaned10' w kolumnie NAME_SELLER_INDUSTRY
# ********************************************************

# Lista istniejących wartości w kolumnie 'NAME_SELLER_INDUSTRY' (bez 'XNA')
existing_seller_industries <- unique(data_cleaned10$NAME_SELLER_INDUSTRY[data_cleaned10$NAME_SELLER_INDUSTRY != "XNA"])

# Lista nowych wartości
new_seller_industries <- c("E-commerce", "Services", "Manufacturing", 
                           "Technology", "Automotive", "Healthcare", 
                           "Agriculture", "Construction" )

# Połączenie istniejących kategorii z nowymi
seller_industry_pool <- c(existing_seller_industries, new_seller_industries)

# Zastąpienie 'XNA' losowymi wartościami z pełnej listy kategorii
set.seed(123)
data_cleaned10$NAME_SELLER_INDUSTRY[data_cleaned10$NAME_SELLER_INDUSTRY == "XNA"] <- sample(
  seller_industry_pool,
  sum(data_cleaned10$NAME_SELLER_INDUSTRY == "XNA"),
  replace = TRUE
)

cat("Wartości 'XNA' w kolumnie NAME_SELLER_INDUSTRY zostały zastąpione losowymi wartościami z pełnej listy kategorii.\n")

# ********************************************************
# 48. Zapisanie wyników po zmianach do nowego pliku
# ********************************************************

# Tworzenie unikalnej nazwy pliku
timestamp <- format(Sys.time(), "%Y%m%d_%H%M%S")
output_path <- paste0("C:/Users/user/Documents/GIT projekts/Analiza_danych-Projekt_Zespolowy2024-2025/previous_application_cleaned11_", timestamp, ".csv")

write.csv(data_cleaned10, output_path, row.names = FALSE)

cat(paste("Zaktualizowane dane zapisano do nowego pliku:", output_path, "\n"))

# ********************************************************
# 49. Aktualizacja README.md
# ********************************************************

# Dopisanie nowej sekcji do README.md
new_content <- paste0("
### 4.10. Aktualizacja po zmianach w NAME_SELLER_INDUSTRY

Wartości `XNA` w kolumnie `NAME_SELLER_INDUSTRY` zostały zastąpione losowymi wartościami z istniejących oraz nowych kategorii:
-Services
-Manufacturing
-E-commerce
-Automotive
-Healthcare
-Agriculture
-Construction
-Technology


Po naprawie, liczba braków w tej kolumnie wynosi 0.

Dane zapisano w nowym pliku: `", basename(output_path), "`.

---
")

# Funkcja dopisująca do README.md
append_to_readme <- function(content, path) {
  write(content, file = path, append = TRUE)
}

append_to_readme(new_content, readme_path)

cat("Zmiany zostały dopisane do README.md.\n")



# Ścieżka do pliku README.md
readme_path <- "C:/Users/user/Documents/GIT projekts/Analiza_danych-Projekt_Zespolowy2024-2025/README.md"

cat("Kontynuacja napraw braków w danych liczbowych i kategorycznych w 'previous_application_cleaned11'...\n")

# ********************************************************
# 51. Wczytywanie danych
# ********************************************************
input_path <- "C:/Users/user/Documents/GIT projekts/Analiza_danych-Projekt_Zespolowy2024-2025/previous_application_cleaned11_20241216_081422.csv"


# ********************************************************
# 52. Naprawa kolumny DAYS_TERMINATION
# ********************************************************
cat("Przykładowe wartości DAYS_TERMINATION przed konwersją:\n")
print(head(data_cleaned11$DAYS_TERMINATION))

# Sprawdzamy,że kolumna jest numeryczna
data_cleaned11$DAYS_TERMINATION <- as.numeric(data_cleaned11$DAYS_TERMINATION)

# Zamiana 365243 oraz wartości ujemnych na NA
data_cleaned11 <- data_cleaned11 %>%
  mutate(DAYS_TERMINATION = ifelse(DAYS_TERMINATION == 365243 | DAYS_TERMINATION < 0, NA, DAYS_TERMINATION))

cat("Przykładowe wartości DAYS_TERMINATION po zamianie na NA:\n")
print(head(data_cleaned11$DAYS_TERMINATION))

# Definiowanie maksymalnej wartości
max_days <- 10950

# Generowanie losowych wartości dla braków
set.seed(123)

data_cleaned11 <- data_cleaned11 %>%
  mutate(
    DAYS_TERMINATION = ifelse(
      is.na(DAYS_TERMINATION), 
      sample(1:max_days, sum(is.na(DAYS_TERMINATION)), replace = TRUE),
      DAYS_TERMINATION
    ),
    DAYS_TERMINATION = pmin(DAYS_TERMINATION, max_days) 
  )

cat("Wartości w kolumnie DAYS_TERMINATION zostały poprawione.\n")
cat("Podsumowanie DAYS_TERMINATION:\n")
print(summary(data_cleaned11$DAYS_TERMINATION))

# ********************************************************
# 53. Zapisanie wyników do nowego pliku
# ********************************************************
timestamp <- format(Sys.time(), "%Y%m%d_%H%M%S")
output_path <- paste0("C:/Users/user/Documents/GIT projekts/Analiza_danych-Projekt_Zespolowy2024-2025/previous_application_cleaned12_", timestamp, ".csv")

write.csv(data_cleaned11, output_path, row.names = FALSE)
cat(paste("Zaktualizowane dane zapisano do nowego pliku:", output_path, "\n"))

# ********************************************************
# 54. Aktualizacja README.md
# ********************************************************
new_content <- paste0("
### 4.11. Aktualizacja po zmianach w DAYS_TERMINATION

W kolumnie `DAYS_TERMINATION` przeprowadzono następujące poprawki:
- Wartości brakujące oraz `365243` zostały zastąpione losowymi wartościami z przedziału od `1` do `", max_days, "`.
- Wartości ujemne zostały zastąpione losowymi wartościami.
- Ekstremalnie wysokie wartości zostały ograniczone do maksymalnej liczby dni: `", max_days, "`.

Dane zapisano w nowym pliku: `", basename(output_path), "`.

---
")

# Dopisywanie zmian do README.md
append_to_readme <- function(content, path) {
  write(content, file = path, append = TRUE, sep = "\n")
}

append_to_readme(new_content, readme_path)
cat("Zmiany zostały dopisane do README.md.\n")


# ********************************************************
# Ścieżka do pliku README.md
# ********************************************************
readme_path <- "C:/Users/user/Documents/GIT projekts/Analiza_danych-Projekt_Zespolowy2024-2025/README.md"

cat("Kontynuacja napraw braków w danych liczbowych i kategorycznych w 'previous_application_cleaned12'...\n")

# ********************************************************
# 55. Wczytywanie danych
# ********************************************************
input_path <- "C:/Users/user/Documents/GIT projekts/Analiza_danych-Projekt_Zespolowy2024-2025/previous_application_cleaned12_20241216_090807.csv"

# ********************************************************
# 56. Naprawa kolumny DAYS_LAST_DUE
# ********************************************************
cat("Przykładowe wartości DAYS_LAST_DUE przed konwersją:\n")
print(head(data_cleaned12$DAYS_LAST_DUE))

# Sprawdzamy, że kolumna jest numeryczna
data_cleaned12$DAYS_LAST_DUE <- as.numeric(data_cleaned12$DAYS_LAST_DUE)

# Zamiana 365243 oraz wartości ujemnych na NA
data_cleaned12 <- data_cleaned12 %>%
  mutate(DAYS_LAST_DUE = ifelse(DAYS_LAST_DUE == 365243 | DAYS_LAST_DUE < 0, NA, DAYS_LAST_DUE))

cat("Przykładowe wartości DAYS_LAST_DUE po zamianie na NA:\n")
print(head(data_cleaned12$DAYS_LAST_DUE))

# Definiowanie maksymalnej wartości
max_days <- 10950
set.seed(123)

data_cleaned12 <- data_cleaned12 %>%
  mutate(
    DAYS_LAST_DUE = ifelse(
      is.na(DAYS_LAST_DUE), 
      sample(1:max_days, sum(is.na(DAYS_LAST_DUE)), replace = TRUE),
      DAYS_LAST_DUE
    ),
    DAYS_LAST_DUE = pmin(DAYS_LAST_DUE, max_days)
  )

cat("Wartości w kolumnie DAYS_LAST_DUE zostały poprawione.\n")
cat("Podsumowanie DAYS_LAST_DUE:\n")
print(summary(data_cleaned12$DAYS_LAST_DUE))

# ********************************************************
# 57. Logiczna relacja między DAYS_LAST_DUE a DAYS_TERMINATION
# ********************************************************
set.seed(123)

data_cleaned12 <- data_cleaned12 %>%
  mutate(
    # Tworzenie losowej różnicy między 1 a 30 dni
    random_diff = sample(1:150, n(), replace = TRUE),
    
    # Modyfikacja DAYS_LAST_DUE, aby była mniejsza od DAYS_TERMINATION
    DAYS_LAST_DUE = ifelse(
      DAYS_LAST_DUE >= DAYS_TERMINATION,
      pmax(DAYS_TERMINATION - random_diff, 1),
      DAYS_LAST_DUE
    ),
    
    # Ograniczenie wartości DAYS_LAST_DUE, aby nie przekraczały DAYS_TERMINATION
    DAYS_LAST_DUE = pmin(DAYS_LAST_DUE, DAYS_TERMINATION)
  ) %>%
  select(-random_diff)

cat("Podsumowanie DAYS_LAST_DUE po poprawkach relacji:\n")
print(summary(data_cleaned12$DAYS_LAST_DUE))

# Weryfikacja logicznej relacji
cat("Sprawdzenie relacji między kolumnami DAYS_LAST_DUE i DAYS_TERMINATION:\n")
all(data_cleaned12$DAYS_LAST_DUE <= data_cleaned12$DAYS_TERMINATION)

# ********************************************************
# 58. Zapisanie wyników do nowego pliku
# ********************************************************
timestamp <- format(Sys.time(), "%Y%m%d_%H%M%S")
output_path <- paste0("C:/Users/user/Documents/GIT projekts/Analiza_danych-Projekt_Zespolowy2024-2025/previous_application_cleaned13_", timestamp, ".csv")

write.csv(data_cleaned12, output_path, row.names = FALSE)
cat(paste("Zaktualizowane dane zapisano do nowego pliku:", output_path, "\n"))

# ********************************************************
# 59. Aktualizacja README.md
# ********************************************************
new_content <- paste0("
### 4.12. Aktualizacja po zmianach w DAYS_LAST_DUE i DAYS_TERMINATION

W kolumnie `DAYS_LAST_DUE` przeprowadzono następujące poprawki:
- Wartości brakujące oraz `365243` zostały zastąpione losowymi wartościami z przedziału od `1` do `", max_days, "`.
- Wartości ujemne zostały zastąpione losowymi wartościami.
- Gdy wartości `DAYS_LAST_DUE` były większe lub równe `DAYS_TERMINATION`, zmniejszono `DAYS_LAST_DUE` o losową liczbę dni (1-150).
- Wszystkie wartości `DAYS_LAST_DUE` zostały ograniczone, aby nie przekraczały `DAYS_TERMINATION`.

Dane zapisano w nowym pliku: `", basename(output_path), "`.

---
")

# Dopisywanie zmian do README.md
append_to_readme <- function(content, path) {
  write(content, file = path, append = TRUE, sep = "\n")
}

append_to_readme(new_content, readme_path)
cat("Zmiany zostały dopisane do README.md.\n")



# ********************************************************
# Ścieżka do pliku README.md
# ********************************************************
readme_path <- "C:/Users/user/Documents/GIT projekts/Analiza_danych-Projekt_Zespolowy2024-2025/README.md"

cat("Rozpoczynanie przetwarzania danych i aktualizacji README.md...\n")

# ********************************************************
# 60. Wczytywanie danych
# ********************************************************
input_path <- "C:/Users/user/Documents/GIT projekts/Analiza_danych-Projekt_Zespolowy2024-2025/previous_application_cleaned14_20241216_110014.csv"
data_cleaned13 <- read.csv(input_path)

# ********************************************************
# 61. Poprawiamy kolumna: RATE_DOWN_PAYMENT
# ********************************************************
cat("Na razie sprobujemy przekształcać kolumnę RATE_DOWN_PAYMENT na wartości procentowe oraz ustawiamy limit 20% dla wpłacania środków osobistych...\n")
install.packages("dplyr")
library(dplyr)



data_cleaned13 <- data_cleaned13 %>%
  mutate(RATE_DOWN_PAYMENT = round(pmin(RATE_DOWN_PAYMENT, 0.2) * 100,2))

cat("Robimy podsumowanie kolumny RATE_DOWN_PAYMENT:\n")
print(summary(data_cleaned13$RATE_DOWN_PAYMENT))

# ********************************************************
# 62. Poprawiamy kolumne AMT_ANNUITY
# ********************************************************
cat("Sprobujemy zrobić uzupełnienie  brakujących wartości w kolumnie AMT_ANNUITY medianą...\n")
data_cleaned13 <- data_cleaned13 %>%
  mutate(AMT_ANNUITY = round(ifelse(is.na(AMT_ANNUITY), median(AMT_ANNUITY, na.rm = TRUE), AMT_ANNUITY),2))

cat("Podsumowanie AMT_ANNUITY:\n")
print(summary(data_cleaned13$AMT_ANNUITY))


# ********************************************************
# 63. Dodanie nowych zmiennych
# ********************************************************

cat("Dodawanie nowych zmiennych analitycznych...
")
data_cleaned13 <- data_cleaned13 %>%
  mutate(
    # Ustawienie minimalnej wartości dla AMT_CREDIT i AMT_ANNUITY na 2000
    AMT_CREDIT = round(pmax(AMT_CREDIT, 2000), 2),
    AMT_ANNUITY = round(pmax(AMT_ANNUITY, 2000), 2),
    # Obliczanie zmiennych analitycznych
    DOWN_PAYMENT_PERCENTAGE = round(pmin((AMT_DOWN_PAYMENT / AMT_CREDIT) * 100), 2),
    CREDIT_TO_ANNUITY_RATIO = round(AMT_CREDIT / AMT_ANNUITY, 2),
    GOODS_CREDIT_DIFFERENCE = round(AMT_GOODS_PRICE - AMT_CREDIT, 2),
    CREDIT_PERCENTAGE = round(pmin((AMT_CREDIT / AMT_GOODS_PRICE) * 100, 100), 2)
  ) %>%
  mutate(
    # Ograniczenie dużych różnic między ceną towaru a kredytem
    AMT_CREDIT = round(ifelse(GOODS_CREDIT_DIFFERENCE > 50000, AMT_GOODS_PRICE, AMT_CREDIT), 2),
    GOODS_CREDIT_DIFFERENCE = round(AMT_GOODS_PRICE - AMT_CREDIT, 2)
  )


cat("Podsumowanie nowych zmiennych:\n")
print(summary(data_cleaned13[, c("DOWN_PAYMENT_PERCENTAGE", "CREDIT_TO_ANNUITY_RATIO", "GOODS_CREDIT_DIFFERENCE", "CREDIT_PERCENTAGE")]))



# ********************************************************
# 64. Usuwanie kolumny DAYS_LAST_DUE_1ST_VERSION  i DAYS_TERMINATION
# ********************************************************

data_cleaned13 <- data_cleaned13 %>%
  select(-DAYS_LAST_DUE_1ST_VERSION,-DAYS_TERMINATION)



# ********************************************************
# 65 Naprawa relacji pomiędzy kolumnami związanami z dniami
# ********************************************************

cat("Naprawa relacji między kolumnami związanymi z dniami...\n")

data_cleaned13 <- data_cleaned13 %>%
  mutate(
    # DAYS_DECISION: Wartości losowe dla braków lub <= 0
    DAYS_DECISION = as.integer(ifelse(is.na(DAYS_DECISION) | DAYS_DECISION <= 0, sample(1:30, n(), replace = TRUE), DAYS_DECISION)),
    
    # DAYS_FIRST_DRAWING: Losowa wartość po DAYS_DECISION, ale ograniczona logicznie
    DAYS_FIRST_DRAWING = as.integer(ifelse(is.na(DAYS_FIRST_DRAWING) | DAYS_FIRST_DRAWING <= 0, 
                                           DAYS_DECISION + sample(1:30, n(), replace = TRUE), 
                                           pmin(DAYS_DECISION + sample(1:30, n(), replace = TRUE), DAYS_FIRST_DUE))),
    
    # DAYS_FIRST_DUE: Po DAYS_FIRST_DRAWING
    DAYS_FIRST_DUE = as.integer(ifelse(is.na(DAYS_FIRST_DUE) | DAYS_FIRST_DUE <= 0, 
                                       DAYS_FIRST_DRAWING + sample(1:30, n(), replace = TRUE), 
                                       DAYS_FIRST_DUE)),
    
    # DAYS_LAST_DUE: Po DAYS_FIRST_DUE
    DAYS_LAST_DUE = as.integer(ifelse(is.na(DAYS_LAST_DUE) | DAYS_LAST_DUE <= 0, 
                                      DAYS_FIRST_DUE + sample(30:365, n(), replace = TRUE), 
                                      DAYS_LAST_DUE)),
    
    # Relacje logiczne
    DAYS_FIRST_DRAWING = ifelse(DAYS_FIRST_DRAWING > DAYS_FIRST_DUE, DAYS_FIRST_DUE, DAYS_FIRST_DRAWING),
    DAYS_FIRST_DUE = ifelse(DAYS_FIRST_DUE > DAYS_LAST_DUE, DAYS_LAST_DUE, DAYS_FIRST_DUE),
    DAYS_DECISION = ifelse(DAYS_DECISION > DAYS_FIRST_DRAWING, DAYS_FIRST_DRAWING, DAYS_DECISION)
  )

cat("Relacje między kolumnami zostały poprawione. Podsumowanie:\n")
print(summary(data_cleaned13[, c("DAYS_DECISION", "DAYS_FIRST_DRAWING", "DAYS_FIRST_DUE", "DAYS_LAST_DUE")]))


# ********************************************************
# 66. Poprawa kolumny AMT_ANNUITY
# ********************************************************
cat("Uzupełniamy brakujące wartości w kolumnie AMT_ANNUITY medianą...\n")
data_cleaned13 <- data_cleaned13 %>%
  mutate(AMT_ANNUITY = round(ifelse(is.na(AMT_ANNUITY), median(AMT_ANNUITY, na.rm = TRUE), AMT_ANNUITY), 2))

cat("Podsumowanie AMT_ANNUITY:\n")
print(summary(data_cleaned13$AMT_ANNUITY))




# ********************************************************
# 67. Poprawa kolumn AMT_APPLICATION i AMT_ANNUITY
# ********************************************************
cat("Poprawa kolumn AMT_APPLICATION i AMT_ANNUITY...\n")
data_cleaned13 <- data_cleaned13 %>%
  mutate(
    AMT_APPLICATION = ifelse(is.na(AMT_APPLICATION) | AMT_APPLICATION <= 0,
                             AMT_CREDIT + AMT_DOWN_PAYMENT, 
                             AMT_APPLICATION),
    AMT_APPLICATION = pmax(AMT_APPLICATION, AMT_CREDIT + AMT_DOWN_PAYMENT)
  )


avg_annuity_period <- 12  
data_cleaned13 <- data_cleaned13 %>%
  mutate(
    AMT_ANNUITY = ifelse(is.na(AMT_ANNUITY) | AMT_ANNUITY <= 0,
                         round(AMT_CREDIT / avg_annuity_period, 2),
                         AMT_ANNUITY)
  )

cat("Podsumowanie AMT_APPLICATION i AMT_ANNUITY po poprawkach:\n")
print(summary(data_cleaned13[, c("AMT_APPLICATION", "AMT_ANNUITY")]))



# ********************************************************
# 68. Usunięcie kolumny GOODS_CREDIT_DIFFERENCE, poniważ była potrzebna tylko do sptraw technicznych
# ********************************************************

data_cleaned13 <- data_cleaned13 %>%
  select(-GOODS_CREDIT_DIFFERENCE)



# ********************************************************
# 69. Zmienimy nazwe kolumn na troche inne, żeby można było to zrozumieć oraz robic dalej analizę
# ********************************************************
cat("Zmiana nazw w kolumnach...\n")

data_cleaned13 <- data_cleaned13 %>%
  rename(id_poprzedniego_wniosku = SK_ID_PREV)
data_cleaned13 <- data_cleaned13 %>%
  rename(id_klienta_banka = SK_ID_CURR)
data_cleaned13 <- data_cleaned13 %>%
  rename(typ_umowy = NAME_CONTRACT_TYPE)
data_cleaned13 <- data_cleaned13 %>%
  rename(roczna_rata = AMT_ANNUITY)
data_cleaned13 <- data_cleaned13 %>%
  rename(wnioskowana_kwota = AMT_APPLICATION)


install.packages("dplyr")
library(dplyr)

data_cleaned13 <- data_cleaned13 %>%
  rename(kwota_kredytu = AMT_CREDIT)
data_cleaned13 <- data_cleaned13 %>%
  rename(wklad_wlasny = AMT_DOWN_PAYMENT)
data_cleaned13 <- data_cleaned13 %>%
  rename(cena_towaru = AMT_GOODS_PRICE)
data_cleaned13 <- data_cleaned13 %>%
  rename(dzien_tygodnia_procesu = WEEKDAY_APPR_PROCESS_START)
data_cleaned13 <- data_cleaned13 %>%
  rename(godzina_rozpoczecia_procesu = HOUR_APPR_PROCESS_START)
data_cleaned13 <- data_cleaned13 %>%
  rename(ostatni_wniosek_w_umowie = FLAG_LAST_APPL_PER_CONTRACT)
data_cleaned13 <- data_cleaned13 %>%
  rename(czy_ostatni_wniosek_tego_dnia = NFLAG_LAST_APPL_IN_DAY)
data_cleaned13 <- data_cleaned13 %>%
  rename(procent_wkladu_wlasnego = RATE_DOWN_PAYMENT)
data_cleaned13 <- data_cleaned13 %>%
  rename(cel_kredytu = NAME_CASH_LOAN_PURPOSE)
data_cleaned13 <- data_cleaned13 %>%
  rename(stan_umowy = NAME_CONTRACT_STATUS)
data_cleaned13 <- data_cleaned13 %>%
  rename(dzien_decyzji = DAYS_DECISION )
data_cleaned13 <- data_cleaned13 %>%
  rename(rodzaj_platnosci = NAME_PAYMENT_TYPE)
data_cleaned13 <- data_cleaned13 %>%
  rename(przyczyna_odrzucenia = CODE_REJECT_REASON)
data_cleaned13 <- data_cleaned13 %>%
  rename(stan_rodzinny = NAME_TYPE_SUITE)
data_cleaned13 <- data_cleaned13 %>%
  rename(rodzaj_klienta = NAME_CLIENT_TYPE)
data_cleaned13 <- data_cleaned13 %>%
  rename(typ_towaru = NAME_GOODS_CATEGORY)
data_cleaned13 <- data_cleaned13 %>%
  rename(kategoria_portfela = NAME_PORTFOLIO)
data_cleaned13 <- data_cleaned13 %>%
  rename(kategoria_produktu = NAME_PRODUCT_TYPE)
data_cleaned13 <- data_cleaned13 %>%
  rename(typ_kanalu = CHANNEL_TYPE)
data_cleaned13 <- data_cleaned13 %>%
  rename(lokalizacja_sprzedawcy = SELLERPLACE_AREA)
data_cleaned13 <- data_cleaned13 %>%
  rename(typ_branzy = NAME_SELLER_INDUSTRY)
data_cleaned13 <- data_cleaned13 %>%
  rename(liczba_rat = CNT_PAYMENT)
data_cleaned13 <- data_cleaned13 %>%
  rename(kategoria_zwrotu = NAME_YIELD_GROUP)
data_cleaned13 <- data_cleaned13 %>%
  rename(typ_kombinacji = PRODUCT_COMBINATION)
data_cleaned13 <- data_cleaned13 %>%
  rename(dzien_pierwszej_wyplaty = DAYS_FIRST_DRAWING)
data_cleaned13 <- data_cleaned13 %>%
  rename(dzien_pierwszej_raty = DAYS_FIRST_DUE)
data_cleaned13 <- data_cleaned13 %>%
  rename(dzien_ostatniej_raty = DAYS_LAST_DUE)
data_cleaned13 <- data_cleaned13 %>%
  rename(status_ubezpieczenia = NFLAG_INSURED_ON_APPROVAL)
data_cleaned13 <- data_cleaned13 %>%
  rename(procent_wkladu_wlasny = DOWN_PAYMENT_PERCENTAGE)
data_cleaned13 <- data_cleaned13 %>%
  rename(stosunek_kwoty_kredytu = CREDIT_TO_ANNUITY_RATIO)
data_cleaned13 <- data_cleaned13 %>%
  rename(procent_kredytu = CREDIT_PERCENTAGE)








cat("Podsumowanie zmian w kolumnach:\n")
print(names(data_cleaned13))

# ********************************************************
# 69.Zmiana wartości w kolumnie 'przyczyna_odrzucenia' na "nie dotyczy" tam, gdzie 'stan_umowy' jest inny niż "Refused"
# ********************************************************


data_cleaned13 <- data_cleaned13 %>%
  mutate(przyczyna_odrzucenia = ifelse(stan_umowy != "Refused", "nie dotyczy", przyczyna_odrzucenia))

head(data_cleaned13)



data_cleaned13 <- data_cleaned13 %>%
  select(-procent_wkladu_wlasnego)


print(names(data_cleaned13))


# ********************************************************
# 70. Zerowanie wartości w określonych kolumnach dla odpowiednich wierszy
# ********************************************************

set.seed(123)


kolumny_do_zerowania <- c("kwota_kredytu", "roczna_rata", "wklad_wlasny")
data_cleaned13 <- data_cleaned13 %>%
  mutate(
    procent_kredytu = ifelse(
      stan_umowy %in% c("Refused", "Canceled"), 
      0, 
      round(runif(n(), min = 2, max = 5), 2)  
    ),
   
    across(all_of(kolumny_do_zerowania), ~ ifelse(stan_umowy %in% c("Refused", "Canceled"), 0, .))
  )

head(data_cleaned13)




# ********************************************************
# 71. Modyfikujemy kolumny,kwota wnioskowana musi być powiązana z ceną towaru lub usługą oraz z procentem wkładu własnego,, 
# oraz wnioskowana kwota była więcej lub równa kwocie kredytu
# ********************************************************


data_cleaned13 <- data_cleaned13 %>%
  mutate(
    wklad_wlasny = ifelse(
      stan_umowy %in% c("Refused", "Canceled"), 
      0, 
      round(procent_wkladu_wlasny * cena_towaru, 2)
    ),
    
    
    wnioskowana_kwota = ifelse(
      stan_umowy %in% c("Refused", "Canceled"), 
      cena_towaru, 
      pmax(round(cena_towaru - wklad_wlasny, 2), kwota_kredytu)  
    ),
   
    kwota_kredytu = ifelse(
      stan_umowy %in% c("Refused", "Canceled"), 
      0, 
      kwota_kredytu
    )
  )

head(data_cleaned13)



# ********************************************************
# 72. Modyfikacja danych z uwzględnieniem 12 rat w roku, oraz ustawienie ustawienie odpowiednich liczb rat
# ********************************************************

data_cleaned13 <- data_cleaned13 %>%
  mutate(

    liczba_rat = ifelse(
      stan_umowy %in% c("Refused", "Canceled"), 
      0,  
      round(pmin(pmax(ceiling(kwota_kredytu / 10000) * 12, 12), 120))  
    ),
    dzien_ostatniej_raty = ifelse(
      liczba_rat == 0, 
      dzien_pierwszej_raty,  
      dzien_pierwszej_raty + liczba_rat * 30  
    ),
    
    roczna_rata = ifelse(
      liczba_rat == 0, 
      0, 
      round(kwota_kredytu / (liczba_rat / 12), 2) 
    )
  )


head(data_cleaned13)

data_cleaned13 <- data_cleaned13 %>%
  select(-procent_wkladu_wlasnego)



# ********************************************************
# 73.  Aktualizacja wartości w kolumnach dni dla Refused i Canceled
# ********************************************************

data_cleaned13 <- data_cleaned13 %>%
  mutate(
    dzien_pierwszej_wyplaty = ifelse(
      stan_umowy %in% c("Refused", "Canceled"), 
      0, 
      dzien_pierwszej_wyplaty
    ),
    dzien_pierwszej_raty = ifelse(
      stan_umowy %in% c("Refused", "Canceled"), 
      0, 
      dzien_pierwszej_raty
    ),
    dzien_ostatniej_raty = ifelse(
      stan_umowy %in% c("Refused", "Canceled"), 
      0, 
      dzien_ostatniej_raty
    )
  )


head(data_cleaned13)


# ********************************************************
# 74.  Aktualizacja wartości w kolumnie stosunek_kredytu dla Refused i Canceled
# ********************************************************

data_cleaned13 <- data_cleaned13 %>%
  mutate(
    stosunek_kwoty_kredytu = ifelse(
      stan_umowy %in% c("Refused", "Canceled"), 
      0,  
      round(kwota_kredytu / roczna_rata, 2)  
    )
  )


head(data_cleaned13$stosunek_kwoty_kredytu)







# ********************************************************
# 75. Zapisanie wyników do pliku jako 'finished'
# ********************************************************
output_path <- "C:/Users/user/Documents/GIT projekts/Analiza_danych-Projekt_Zespolowy2024-2025/previous_application_cleaned_finished.csv"

write.csv(data_cleaned13, output_path, row.names = FALSE)
cat(paste("Zaktualizowane dane zapisano do pliku:", output_path, "\n"))


# ********************************************************
# 76. Aktualizacja README.md
# ********************************************************
new_content <- paste0(
  "\n### 4.13. Zmiany w danych\n\n",
  "1. W kolumnie `RATE_DOWN_PAYMENT` przekształcono wartości na procentowe, ograniczając je do maksymalnie 20%.\n",
  "2. Brakujące wartości w kolumnie `AMT_ANNUITY` uzupełniono medianą.\n",
  "3. Dodano zmienne analityczne:\n",
  "   - `DOWN_PAYMENT_PERCENTAGE` (procentowy wkład własny).\n",
  "   - `CREDIT_TO_ANNUITY_RATIO` (stosunek kwoty kredytu do rocznej raty).\n",
  "   - `CREDIT_PERCENTAGE` (procent kredytu w stosunku do ceny towaru).\n",
  "4. Usunięto kolumny: `DAYS_LAST_DUE_1ST_VERSION` i `DAYS_TERMINATION`.\n",
  "5. Naprawiono relacje między kolumnami dotyczącymi dni, zapewniając logiczną spójność:\n",
  "   - `DAYS_DECISION`, `DAYS_FIRST_DRAWING`, `DAYS_FIRST_DUE`, `DAYS_LAST_DUE`.\n",
  "6. Kolumnę `AMT_APPLICATION` dostosowano, aby była zgodna z sumą `AMT_CREDIT` i `AMT_DOWN_PAYMENT`.\n",
  "7. Ustalono minimalne wartości `AMT_CREDIT` i `AMT_ANNUITY` na 2000.\n",
  "8. Wiersze z `stan_umowy` = 'Refused' lub 'Canceled':\n",
  "   - Ustawiono `kwota_kredytu`, `roczna_rata`, `wklad_wlasny` na 0.\n",
  "   - Wyzerowano wartości w kolumnach dniowych: `dzien_pierwszej_wyplaty`, `dzien_pierwszej_raty`, `dzien_ostatniej_raty`.\n",
  "9. Kolumny `liczba_rat` i `roczna_rata` dostosowano do założenia 12 rat w roku.\n",
  "10. Kolumna `stosunek_kwoty_kredytu` (stosunek kwoty kredytu do rocznej raty) ustawiona na 0 dla wierszy odrzuconych.\n",
  "11. Zmieniono nazwy kolumn na bardziej czytelne, m.in.:\n",
  "    - `SK_ID_PREV` → `id_poprzedniego_wniosku`\n",
  "    - `SK_ID_CURR` → `id_klienta_banka`\n",
  "    - `AMT_ANNUITY` → `roczna_rata`\n",
  "    - `AMT_APPLICATION` → `wnioskowana_kwota`\n",
  "    - `AMT_CREDIT` → `kwota_kredytu`\n",
  "    - `AMT_DOWN_PAYMENT` → `wklad_wlasny`\n",
  "    - `RATE_DOWN_PAYMENT` → `procent_wkladu_wlasnego`\n",
  "    - `NAME_CONTRACT_STATUS` → `stan_umowy`\n",
  "    - `DAYS_DECISION` → `dzien_decyzji`.\n",
  "12. Ostateczne dane zapisano w pliku: `", basename(output_path), "`.\n\n---\n"
)

append_to_readme <- function(content, path) {
  write(content, file = path, append = TRUE, sep = "\n")
}

append_to_readme(new_content, readme_path)
cat("Zmiany zostały dopisane do README.md.\n")


# Ścieżka do pliku README.md
readme_path <- "C:/Users/user/Documents/GIT projekts/Analiza_danych-Projekt_Zespolowy2024-2025/README.md"

# Funkcja do zmiany wyglądu w pliku README.md
update_readme_formatting <- function(path) {
  readme_content <- readLines(path)
  readme_content <- gsub("^# (.*)$", "# \\1\n---", readme_content)  
  readme_content <- gsub("^## (.*)$", "## \\1\n---", readme_content)  
  readme_content <- gsub("^\\s*-\\s(.*)$", "  - \\1", readme_content)  
  readme_content <- gsub("\\*\\*(.*)\\*\\*", "### \\1", readme_content)  
  readme_content <- gsub("^-{3,}$", "---", readme_content) 
  
 
  writeLines(readme_content, path)
  cat("Wygląd README.md został zaktualizowany.\n")
}


update_readme_formatting(readme_path)

add_emoji_to_readme <- function(path) {
  
  readme_content <- readLines(path)

  readme_content <- gsub("^# (.*)$", "🎯 \\1", readme_content)  
  readme_content <- gsub("^## (.*)$", "⭐ \\1", readme_content) 
  readme_content <- gsub("^-\\s", "- ✅ ", readme_content)  
  
  writeLines(readme_content, path)
  cat("Emoji zostały dodane do README.md.\n")
}


add_emoji_to_readme(readme_path)


