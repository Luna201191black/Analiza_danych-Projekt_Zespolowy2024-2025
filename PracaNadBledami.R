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

# Zapisanie raportu do pliku README.md
writeLines(readme_content, con = readme_path)

cat(paste("Raport zapisano do pliku:", readme_path, "\n"))



