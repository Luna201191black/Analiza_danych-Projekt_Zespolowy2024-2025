# ********************************************************
# 1.Musimy zainstalować oraz załadować potrzebne pakiety.
# ********************************************************
# Instalacja pakietów.

# Komunikat
cat("Instalacja i ładowanie pakietów...\n")
# Do wizualizacji danych.
install.packages("ggplot2")
# Ponadto warto zainstalować.
# Do pracy nad danymi.
install.packages('tidyverse')
# W celu dostarczenia zestawu kolorów przydatnych do wizualizacji danych.
install.packages('RColorBrewer')
# Dla klarownego efektu rozmieszczania etykiet na wykresach.
install.packages('ggrepel')
# Do układania wielu wykresów lub tabel w siatce.
install.packages('gridExtra')
# Do przekształcania danych.
install.packages("reshape2")

# Ładujemy pakiety.
library(ggplot2)
library(tidyverse)
library(RColorBrewer)
library(ggrepel)
library(gridExtra)
library(reshape2)

# Komunikat
cat("Pakiety zostały poprawnie załadowane.\n")

# ********************************************************
# 2.Wczytujemy dane z pliku.
# ********************************************************

# Komunikat
cat("Wczytywanie danych z pliku danych CSV...\n")

# Ścieżka do pliku.
dane <- "C:/Users/micha/Documents/Analiza_danych-Projekt_Zespolowy2024-2025/previous_application_cleaned_finished.csv"

# Wczytanie danych z pliku CSV
data <- read.csv(dane, stringsAsFactors = FALSE)

#komunikat
cat("Dane wczytane. Liczba wierszy i kolumn:\n")
# Wyświetlenie liczby wierszy i kolumn
print(dim(data)) 

# Wyświetlamy strukturę danych
str(data)

# ********************************************************
# 3.Wizualizacja (uzupełnionych o braki) danych i ich wczesna interpretacja.
# ********************************************************

# Komunikat
cat("Rozkłady zmiennych liczbowych...\n")


# Wnioskowana kwota - histogram.
ggplot(data, aes(x = wnioskowana_kwota)) +
  geom_histogram(bins = 30, fill = "green", alpha = 0.7, color = "black") +
                   labs(title = "Rozkład wnioskowanej kwoty", x = "Wnioskowana kwota", y = "Liczba wniosków") +
                   theme_minimal() +
  scale_x_continuous(labels = scales::comma, limits = c(0, 3000000), breaks = seq(0, 3000000, by = 500000)) +
  scale_y_continuous(labels = scales::comma, limits = c(0, 3000), breaks = seq(0, 3000, by = 500))

# Interpretacja:
# Większość wniosków dotyczy niewielkich kwot, co jest zauważalne po wysokim słupku w przedziale poniżej 500 000,
# gdy w tym samym czasie liczba wniosków znacząco maleje wraz ze wzrostem wnioskowanej kwoty.
# Rozkład jest prawostronnie skośny, przy czym sporadyczne wnioski dotyczą dużych kwot powyżej 2 000 000.


# Kwota kredytu - histogram.
ggplot(data, aes(x = kwota_kredytu)) +
  geom_histogram(bins = 30, fill = "red", alpha = 0.7, color = "black") +
  labs(title = "Rozkład kwoty kredytu", x = "Kwota kredytu", y = "Liczba wniosków") +
  theme_minimal() +
  scale_x_continuous(labels = scales::comma, limits = c(0, 3000000), breaks = seq(0, 3000000, by = 500000)) +
  scale_y_continuous(labels = scales::comma, limits = c(0, 3000), breaks = seq(0, 3000, by = 500))

# Interpretacja:
# Zdecydowana większość wniosków dotyczy niskich kwot, co jest zauważalne po wysokim słupku w przedziale poniżej 500 000,
# gdy w tym samym czasie liczba wniosków znacząco maleje wraz ze wzrostem kwoty kredytu.
# Rozkład jest prawostronnie asymetryczny, przy czym sporadyczne wnioski dotyczą dużych kwot powyżej 2 000 000.



# Wkład własny - histogram.
ggplot(data, aes(x = wklad_wlasny)) +
  geom_histogram(bins = 30, fill = "blue", alpha = 0.7, color = "black") +
  labs(title = "Rozkład wkładu własnego", x = "Wkład własny", y = "Liczba wniosków") +
  theme_minimal() +
  scale_x_continuous(labels = scales::comma, limits = c(0, 100000), breaks = seq(0, 100000, by = 10000)) +
  scale_y_continuous(labels = scales::comma, limits = c(0, 2500), breaks = seq(0, 2500, by = 500))

# Interpretacja:
# Największa liczba wniosków dotyczy wkładów własnych w przedziale od 40 000 do 50 000, wskazując na koncentrację danych w tym zakresie.
# Rozkład jest symetryczny, z niewielką liczbą wniosków dotyczących zarówno bardzo niskich (poniżej 20 000), jak i bardzo wysokich wkładów
# (powyżej 60 000).


# Cena towaru - histogram.
ggplot(data, aes(x = cena_towaru)) +
  geom_histogram(bins = 30, fill = "yellow", alpha = 0.7, color = "black") +
  labs(title = "Rozkład cen towarów", x = "Cena towaru", y = "Liczba wniosków") +
  theme_minimal() +
  scale_x_continuous(labels = scales::comma, limits = c(0, 3000000), breaks = seq(0, 3000000, by = 500000)) +
  scale_y_continuous(labels = scales::comma, limits = c(0, 3000), breaks = seq(0, 3000, by = 500))

# Interpretacja:
# Największa liczba wniosków dotyczy towarów o cenie poniżej 500 000, co jest zauważalne po wysokim słupku po lewej stronie,
# gdy w tym samym czasie liczba wniosków znacząco maleje wraz ze wzrostem ceny towaru.
# Rozkład jest prawostronnie skośny, a pojedyncze wnioski dotyczą towarów o bardzo wysokich cenach, przekraczających 2 000 000.

# Roczna rata - histogram
ggplot(data, aes(x = roczna_rata)) +
  geom_histogram(bins = 30, fill = "lightblue", alpha = 0.7, color = "black") +
  labs(title = "Rozkład rocznej raty", x = "Roczna rata", y = "Liczba wniosków") +
  theme_minimal() +
  scale_x_continuous(labels = scales::comma, limits = c(0, 250000), breaks = seq(0, 250000, by = 50000)) +
  scale_y_continuous(labels = scales::comma, limits = c(0, 10000), breaks = seq(0, 10000, by = 1000))
  
# Interpretacja:
# Dominują nieskie wartości, gdzie większość wniosków dotyczy rat poniżej 50 000, co jest zauważalne po wysokim słupku po lewej stronie,
# gdy w tym samym czasie liczba wniosków znacząco maleje wraz ze wzrostem wysokości raty.
# Rozkład jest prawostronnie asymetryczny, przy czym tylko niewielka liczba wniosków dotyczy bardzo wysokich rat, przekraczających 150 000.

# Komunikat
cat("Porównanie histogramów danych liczbowych w grupach...\n")

# Wnioskowana kwota a typ umowy.
ggplot(data, aes(x = wnioskowana_kwota, fill = typ_umowy)) +
  geom_histogram(bins = 30, alpha = 0.7, position = "identity") + 
  labs(title = "Rozkład wnioskowanej kwoty w podziale na typ umowy",
       x = "Wnioskowana kwota", y = "Liczba wniosków", fill = "Typ umowy") +
  theme_minimal() +
  scale_x_continuous(labels = scales::comma, limits = c(0, 250000), breaks = seq(0, 250000, by = 50000)) +
  scale_y_continuous(labels = scales::comma, limits = c(0, 5000), breaks = seq(0, 5000, by = 500))
  scale_fill_brewer(palette = "Set2")
  
# Interpretacja:
# Największa liczba wniosków dotyczy kredytów gotówkowych, szczególnie w przedziale około 100 000, gdy w tym samym czasie
# kredyty konsumenckie i odnawialne koncentrują się na niższych kwotach, poniżej 50 000.
# Rozkład dla wszystkich typów umów jest asymetryczny, gdzie większość wniosków dotyczy niskich kwot oraz sporadycznie występują także wysokie wartości.

# Cena towarów a kategoria portfela.
ggplot(data, aes(x = cena_towaru, fill = kategoria_portfela)) +
  geom_histogram(bins = 30, alpha = 0.7, position = "identity") +
  scale_fill_manual(values = colorRampPalette(brewer.pal(12, "Set3"))(27))+
  labs(title = "Rozkład cen towarów w podziale na kategorie portfela",
       x = "Cena towaru", y = "Liczba wniosków", fill = "Kategoria portfela") +
  theme_minimal() +
  scale_x_continuous(labels = scales::comma, limits = c(0, 2500000), breaks = seq(0, 2500000, by = 500000)) +
  scale_y_continuous(labels = scales::comma, limits = c(0, 2000), breaks = seq(0, 5000, by = 500))

# Interpretacja:
# Większość wniosków dotyczy towarów o niskich cenach (poniżej 500 000) niezależnie od kategorii.
# Rozkład jest prawostronnie asymetryczny, gdzie dominują niskie wartości, a wyższe ceny (szczególnie powyżej 1 000 000)
# występują sporadycznie.

# Komunikat
cat("Zależności między poszczególnymi zmiennymi...\n")

# Zależność pomiędzy wnioskowaną kwotą a kwotą otrzymanego kredytu.
ggplot(data, aes(x = wnioskowana_kwota, y = kwota_kredytu, color = typ_umowy)) +
  geom_point(alpha = 0.6) +
  labs(title = "Zależność między wnioskowaną kwotą a kwotą kredytu",
       x = "Wnioskowana kwota", y = "Kwota kredytu") +
  theme_minimal() +
  scale_color_brewer(palette = "Set1")

# Zależność pomiędzy procentem kredytu a wkładem własnym.
ggplot(data, aes(x = procent_kredytu, y = wklad_wlasny, color = status_ubezpieczenia)) +
  geom_point(alpha = 0.6) +
  labs(title = "Zależność między procentem kredytu a wkładem własnym",
       x = "Procent kredytu", y = "Wkład własny", color = "Status ubezpieczenia") +
  theme_minimal() +
  scale_y_continuous(labels = scales::comma)+
  scale_color_gradient(low = "blue", high = "red")


# Komunikat
cat("Dane kategoryczne...\n")

# Rozkład celów kredytów.
ggplot(data, aes(x = cel_kredytu)) +
  geom_bar(fill = "orange", color = "black") +
  labs(title = "Rozkład celów kredytów", x = "Cel kredytu", y = "Liczba wniosków") +
  theme_minimal()  +
  coord_flip()

# Stan umowy w relacji do typu klienta.
ggplot(data, aes(x = stan_umowy, fill = rodzaj_klienta)) +
  geom_bar(position = "fill", alpha = 0.8) +
  labs(title = "Stan umowy w zależności od rodzaju klienta",
       x = "Stan umowy", y = "Udział", fill = "Rodzaj klienta") +
  theme_minimal() +
  scale_fill_brewer(palette = "Set2")


# Komunikat
cat("Dane czasowe...\n")

# Rozkład liczby wniosków obejmujący godziny i dni tygodnia.
ggplot(data, aes(x = dzien_tygodnia_procesu, y = godzina_rozpoczecia_procesu)) +
  stat_bin2d(aes(fill = after_stat(count)), bins = 10) +
  labs(title = "Rozkład liczby wniosków w czasie",
       x = "Dzień tygodnia", y = "Godzina rozpoczęcia procesu", fill = "Liczba wniosków") +
  theme_minimal() +
  scale_fill_gradient(low = "white", high = "orange")

# Liczba wniosków na przedstrzeni dni decyzyjnych.
ggplot(data, aes(x = dzien_decyzji)) +
  geom_line(stat = "count", color = "red") +
  labs(title = "Liczba wniosków w czasie", x = "Dzień decyzji", y = "Liczba wniosków") +
  theme_minimal()

# Komunikat
cat("Specyficzne przypadki...\n")

# Kwota kredytu w odniesieniu do jego celu.
ggplot(data, aes(x = cel_kredytu, y = kwota_kredytu)) +
  geom_boxplot(fill = "cyan", alpha = 0.7) +
  labs(title = "Kwota kredytu w zależności od celu kredytu",
       x = "Cel kredytu", y = "Kwota kredytu") +
  theme_minimal() +
  scale_y_continuous(labels = scales::comma) +
  coord_flip()

# Rozkład liczby rat dla każdej kategorii produktu z osobna.
dane <- as.data.frame(data)
ggplot(dane, aes(x = kategoria_produktu, y = liczba_rat)) +
  geom_violin(fill = "purple", alpha = 0.7) +
  labs(title = "Rozkład liczby rat w podziale na kategorię produktu",
       x = "Kategoria produktu", y = "Liczba rat") +
  theme_minimal() +
  coord_flip()


