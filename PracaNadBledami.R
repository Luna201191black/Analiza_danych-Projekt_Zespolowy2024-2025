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

