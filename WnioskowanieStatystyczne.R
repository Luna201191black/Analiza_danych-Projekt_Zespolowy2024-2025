# ********************************************************
# 1.Musimy zainstalować oraz załadować potrzebne pakiety.
# ********************************************************
# Instalacja pakietów.

# Komunikat
cat("Instalacja i ładowanie pakietów...\n")
# Do statystyk opisowych.
install.packages("reporttools")
install.packages("skimr")
install.packages("R3port")
# Do wizualizacji różnic.
install.packages("ggstatsplot")
install.packages("here")
# Ładujemy pakiety.
library(reporttools)
library(skimr)
library(R3port)
library(ggstatsplot)
library(here)
# Komunikat
cat("Pakiety zostały poprawnie załadowane.\n")
# Komunikat
cat("Wczytywanie danych z pliku danych CSV...\n")

# Ścieżka do pliku.
dane <- here("previous_application_cleaned_finished.csv")

# Wczytanie danych z pliku CSV
data <- read.csv(dane, stringsAsFactors = FALSE)

#komunikat
cat("Dane wczytane. Liczba wierszy i kolumn:\n")

# Wyświetlenie liczby wierszy i kolumn
print(dim(data)) 

# Wyświetlamy strukturę danych
str(data)

# ********************************************************
# 3.Wnioskowanie statystyczne (uzupełnionych o braki) danych.
# ********************************************************

# 1. Test t-studenta dla średnich kwot kredytu dla 2 celów: Home renovation i Vacation
# H0: Średnia kwota kredytu jest taka sama w obydwu grupach.
# HA: Średnia kwota kredytu różni się między grupami.
group1 <- subset(data, cel_kredytu == "Home Renovation")$kwota_kredytu
group2 <- subset(data, cel_kredytu == "Vacation")$kwota_kredytu
t_test <- t.test(group1, group2, var.equal = TRUE)
print(t_test)

# Brak podstaw do odrzucenia hipotezy zerowej, co oznacza, że nie ma statystycznie istotnych
# różnic między średnimi kwotami kredytu w grupach "Home renovation" i "Vacation"
# Wskazuje na to wysoka wartość p (0,347) oraz niska wartość statystyki t (-0,941).

srednia_kwota_homerenovation <- mean(data$kwota_kredytu[data$cel_kredytu == "Home Renovation"], na.rm = TRUE)
print(srednia_kwota_homerenovation)

srednia_kwota_vacation <- mean(data$kwota_kredytu[data$cel_kredytu == "Vacation"], na.rm = TRUE)
print(srednia_kwota_vacation)

# Po sprawdzeniu średnich dla obydwu badanych zmiennych,należy zauważyć ich zbliżony poziom (odpowiednio 126444,4 i 131327,5),
# co byłoby zgodne z wynikiem przeprowadzonego testu statystycznego.

data_plot <- data.frame(
  grupa = c(rep("Home Renovation", length(group1)), rep("Vacation", length(group2))),
  kwota_kredytu = c(group1, group2)
)


ggplot(data_plot, aes(x = grupa, y = kwota_kredytu, fill = grupa)) +
  geom_boxplot() +
  labs(title = "Porównanie kwot kredytu dla Home Renovation i Vacation",
       x = "Cel kredytu",
       y = "Kwota kredytu") +
  theme_minimal() +
  scale_fill_brewer(palette = "Set3") +
  theme(legend.position = "none")+
ggsave("t_student.png")

# Dodatkowe uwagi
shapiro.test(group1)
shapiro.test(group2)
# Wyniki testu Shapiro-Wilka wskazują na to, że dane w obu grupach nie mają rozkładu normalnego
# Ponieważ dane nie są normalnie rozkładowe, test t-Studenta (który zakłada normalność danych) może nie być właściwy

mann_whitney_test <- wilcox.test(group1, group2)
print(mann_whitney_test)

# Brak podstaw do odrzucenia hipotezy zerowej (H₀).
# Oznacza to, że nie ma statystycznie istotnych różnic w medianach kwoty kredytu między grupami "Home Renovation" i "Vacation"
# Wartość p (0,6004) jest znacznie większa od progu istotności

# ********************************************************

# 2.Regresja liniowa dla liczby rat oraz kwoty kredytu
# H0: Liczba rat i kwota kredytu nie są ze sobą skorelowane
# HA: Liczba rat i kwota kredytu są ze sobą skorelowane
linear_model <- lm(kwota_kredytu ~ liczba_rat, data = data)
summary(linear_model)
# Równanie modelu regresji: kwota_kredytu = -25826,45 + 2545,53 * liczba_rat
# Gdy liczba rat wynosi 0, przewidywana kwota kredytu wynosi -25826,45
# Przy każdej dodatkowej racie, przewidywana kwota kredytu zwiększa się średnio o 2545,53 jednostek.
# Wartość p dla liczby rat jest znacznie mniejsza niż 0,05, co oznacza, że liczba rat jest statystycznie istotną determinantą kwoty kredytu.

ggplot(data, aes(x = liczba_rat, y = kwota_kredytu)) +
  geom_point(alpha = 0.5, color = "blue") + 
  geom_smooth(method = "lm", color = "red", se = TRUE)+
  labs(title = "Regresja liniowa dla liczby rat oraz kwoty kredytu",
       x = "Liczba rat",
       y = "Kwota kredytu") +
  theme_minimal()+
  ggsave("regresja.png")

# ********************************************************

# 3.Test chi-kwadrat dla rodzaju płatności oraz stanu umowy
# H0: Rodzaj płatności i stan umowy są od siebie niezależne
# HA: Rodzaj płatności i stan umowy są od siebie zależne
contingency_table_payment_status <- table(data$rodzaj_platnosci, data$stan_umowy)
print(contingency_table_payment_status)
chi_square_test_payment <- chisq.test(contingency_table_payment_status)
print(chi_square_test_payment)
print(chi_square_test_payment$expected)
# Wartość p (<2,2e-16), czyli znacznie mniejsza niż 0,05
# Należy odrzucić hipotezę zerową, co oznacza, że istnieje statystycznie istotna zależność między rodzajem płatności a stanem umowy
# Cash through the bank ma bardzo wysokie wartości w kolumnie "Approved" (9702.29 oczekiwane), co sugeruje, że znaczna część zaakceptowanych umów jest związana z tą formą płatności
install.packages("ggplot2")
install.packages("ggmosaic")

library(ggplot2)
library(ggmosaic)

ggplot(data = data) +
  geom_mosaic(aes(x = product(rodzaj_platnosci, stan_umowy), 
                  fill = stan_umowy)) +
  labs(title = "Zależnośc rodzaju płatności i stanu umowy",
       x = "Rodzaj Płatności",
       y = "Proporcje") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  scale_fill_brewer(palette = "Set3", name = "Stan Umowy")+
  ggsave("chi-kwadrat1.png")

# ********************************************************

# 4.Test chi-kwadrat dla cel kredytu i stanu umowy
# H0: Cel kredytu i stan umowy są od siebie niezależne
# HA: Cel kredytu i stan umowy są od siebie zależne
contingency_table <- table(data$cel_kredytu, data$stan_umowy)
print(contingency_table)
chi_square_test <- chisq.test(contingency_table)
print(chi_square_test)
print(chi_square_test$expected)
# Wartość p (<2,2e-16), czyli znacznie mniejsza niż 0,05
# Należy odrzucić hipotezę zerową, co oznacza, że istnieje statystycznie istotna zależność między celem kredytu a stanem umowy
# Education i Vacation mają wysokie wartości oczekiwane i duży wpływ na wynik testu.

install.packages("dplyr")
library(dplyr)
install.packages("ggplot2")
library(ggplot2)
data$cel_kredytu <- recode(data$cel_kredytu,
                         "Building a house or an annex" = "Build house",
                         "Buying a holiday home / land" = "Holiday home",
                         "Gasification / water supply" = "Gasification",
                         "Wedding / gift / holiday" = "Wedding")
ggplot(data = data) +
  geom_mosaic(aes(x = product(cel_kredytu, stan_umowy), fill = stan_umowy)) +
  labs(title = "Zależność między celem kredytu a stanem umowy",
       x = "Stan Umowy",
       y = "Cel Kredytu") +
  theme_minimal() +
  theme(axis.text.y = element_text(size = 5, hjust = 1)) +
  scale_fill_brewer(palette = "Set3", name = "Stan Umowy")+
  ggsave("chi_kwadrat2.png")

# ********************************************************

# 5. Test ANOVA w celu sprawdzenia czy średnia kwota kredytu różni się istonie między
# innymi celami kredytu
# H0: Średnia kwota kredytu jest taka sama dla wsyzstkich celów kredytu
# HA: Średnia kwota kredytu nie jest taka sama dla wszystkich celów kredytu

anova_test <- aov(kwota_kredytu ~ cel_kredytu, data = data)
summary(anova_test)

# Wartość p (0,252) jest większe niż poziom istnotności 0,05
# Brak podstaw do odrzucenia hipotezy zerowej, co oznacza, że średnia kwota kredytu nie różni się
# istotnie między poszczególnymi celami kredytu

ggplot(data, aes(x = cel_kredytu, y = kwota_kredytu, fill = cel_kredytu)) +
  geom_boxplot() +
  labs(title = "Porównanie kwoty kredytu dla różnych celów kredytu",
       x = "Cel kredytu",
       y = "Kwota kredytu") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  scale_fill_brewer(palette = "Set3", name = "Cel kredytu")+
ggsave("anova_plot.png")
