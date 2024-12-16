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
### 4.13. Aktualizacja po zmianach w DAYS_LAST_DUE i DAYS_TERMINATION

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
