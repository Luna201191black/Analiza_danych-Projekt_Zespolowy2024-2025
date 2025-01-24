# Instalacja i załadowanie wymaganych bibliotek
install.packages("ggstatsplot", dependencies = TRUE)
library(ggstatsplot)

# Wczytanie danych

data <- read.csv("./previous_application_cleaned_finished.csv")
#1. - Porównanie wnioskowanej kwoty w zależności od stanu umowy.

# Czyszczenie danych: usunięcie zbędnych wartości
data_cleaned <- na.omit(data[, c("wnioskowana_kwota", "stan_umowy")])

# Wizualizacja i testy statystyczne
ggbetweenstats(
  data = data_cleaned,
  x = stan_umowy,          # Zmienna grupująca
  y = wnioskowana_kwota,   # Zmienna zależna
  pairwise.comparisons = TRUE,  # Porównania parami
  pairwise.display = "significant", # Wyświetlanie istotnych porównań
  title = "Porównanie wnioskowanej kwoty w zależności od stanu umowy",
  xlab = "Stan umowy",
  ylab = "Wnioskowana kwota",
  effsize.type = "eta",    # Wielkość efektu (eta squared)
  messages = FALSE         # Wyłączenie komunikatów
)

#2. Test korelacji między wnioskowaną kwotą a kwotą kredytu

data_cleaned2 <- na.omit(data[, c("wnioskowana_kwota", "kwota_kredytu")])

ggscatterstats(
  data = data_cleaned2,
  x = wnioskowana_kwota,  # Pierwsza zmienna (wnioskowana kwota)
  y = kwota_kredytu,      # Druga zmienna (kwota kredytu)
  type = "parametric",    # Typ testu: parametryczny (Pearson)
  title = "Korelacja między wnioskowaną kwotą a kwotą kredytu",
  xlab = "Wnioskowana kwota",
  ylab = "Kwota kredytu",
  bf.message = FALSE      # Ukryj wiadomość Bayesowską
)

#3.  Analiza zależności między stanem umowy a celem kredytu

library(readr)
library(ggplot2)

# Sprawdzenie struktury danych
str(data)

# Analiza zależności między "stan_umowy" a "cel_kredytu" za pomocą ggstatsplot.
ggstatsplot::ggbarstats(
  data = data,
  x = stan_umowy,        # Zmienna kategoryczna na osi x
  y = cel_kredytu,       # Zmienna kategoryczna na osi y
  title = "Analiza zależności między stanem umowy a celem kredytu",
  xlab = "Cel Kredytu",
  ylab = "Procentowy udział w kategorii kredytu",
  messages = FALSE
) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  coord_flip()

#4. Porównanie procentu wkładu własnego w zależności odstanu umowy

library(dplyr)

# Sprawdzenie liczności grup
group_counts <- data %>%
  group_by(stan_umowy) %>%
  summarise(n = n())


# Filtracja grup z licznością < 3
data_filtered <- data %>%
  group_by(stan_umowy) %>%
  filter(n() >= 3)

# Sprawdzenie normalności rozkładu "procent_wkladu_wlasny" w poszczególnych grupach "stan_umowy"
shapiro_results <- data_filtered %>%
  group_by(stan_umowy) %>%
  summarise(p_value = ifelse(n() <= 5000, shapiro.test(procent_wkladu_wlasny)$p.value, NA))


# Wybór odpowirdniego testu
if (all(shapiro_results$p_value > 0.05, na.rm = TRUE)) {
  # Jeśli normalność jest spełniona, wykonaj test ANOVA
  test_result <- ggstatsplot::ggbetweenstats(
    data = data_filtered,
    x = stan_umowy,
    y = procent_wkladu_wlasny,
    type = "parametric", # ANOVA
    pairwise.comparisons = TRUE,
    pairwise.display = "significant",
    title = "Porównanie procentu wkładu własnego w zależności od stanu umowy",
    xlab = "Stan umowy",
    ylab = "Procent wkładu własnego"
  )
} else {
  test_result <- ggstatsplot::ggbetweenstats(
    data = data_filtered,
    x = stan_umowy,
    y = procent_wkladu_wlasny,
    type = "nonparametric", # Kruskal-Wallis
    pairwise.comparisons = TRUE,
    pairwise.display = "significant",
    title = "Porównanie procentu wkładu własnego w zależności od stanu umowy",
    xlab = "Stan umowy",
    ylab = "Procent wkładu własnego"
  )
}

test_result

#5. Analiza różnic w stosunku kwoty kredytu w zależności od typu umowy

# Sprawdzenie liczności grup
group_counts2 <- data %>%
  group_by(typ_umowy) %>%
  summarise(n = n())



# Analiza różnic w stosunku kwoty kredytu w zależności od typu umowy
test_result <- ggstatsplot::ggbetweenstats(
  data = data,
  x = typ_umowy,
  y = stosunek_kwoty_kredytu,
  type = "nonparametric",
  pairwise.comparisons = TRUE,
  pairwise.display = "significant",
  title = "Różnice w stosunku kwoty kredytu w zależności od typu umowy",
  xlab = "Typ umowy",
  ylab = "Stosunek kwoty kredytu"
)

# Wyświetlenie wyników
test_result
