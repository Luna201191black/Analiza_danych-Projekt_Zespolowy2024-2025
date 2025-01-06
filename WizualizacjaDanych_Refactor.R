# 1. Instalacja i ładowanie potrzebnych pakietów
 

# Komunikat
cat("Instalacja i ładowanie pakietów...\n")

# Instalacja pakietów 
install.packages("ggplot2") # Do wizualizacji danych. 
install.packages("tidyverse") # Do pracy nad danymi.
install.packages("RColorBrewer")# Dostarcza zestawy kolorów przydatne do wizualizacji danych
install.packages("ggrepel") # Dla klarownego efektu rozmieszczania etykiet na wykresach
install.packages("gridExtra") # Do układania wielu wykresów lub tabel w siatce
install.packages("reshape2") # Do przekształcania danych
install.packages("corrplot") #Do łatwiejszej wizualizacji korelacji
install.packages("here") # Do ustalenia sciezki

#  Ładowanie pakietów 
library(ggplot2)
library(tidyverse)
library(RColorBrewer)
library(ggrepel)
library(gridExtra)
library(reshape2)
library(corrplot)
library(here)

# Komunikat
cat("Pakiety zostały poprawnie załadowane.\n")


 
# 2. Wczytanie danych z pliku CSV


# Komunikat
cat("Używamy pakietu 'here' do obsługi ścieżek względnych...\n")
dane <- here("previous_application_cleaned_finished.csv")

# Wczytanie danych z pliku CSV
data <- read.csv(dane, stringsAsFactors = FALSE)

# Komunikat
cat("Dane wczytane. Liczba wierszy i kolumn:\n")

# Wyświetlenie liczby wierszy i kolumn
print(dim(data))

# Wyświetlenie podstawowych informacji o strukturze danych
str(data)


 
# 3. Wizualizacja wstępna (rozkłady zmiennych liczbowych)
 

cat("\nRozkłady zmiennych liczbowych...\n")

 
# 3.1 Wnioskowana kwota
 
ggplot(data, aes(x = wnioskowana_kwota)) +
  geom_histogram(bins = 30, fill = "green", alpha = 0.7, color = "black") +
  labs(
    title = "Rozkład wnioskowanej kwoty",
    x = "Wnioskowana kwota",
    y = "Liczba wniosków"
  ) +
  theme_minimal() +
  scale_x_continuous(
    labels = scales::comma,
    limits = c(0, 3000000),
    breaks = seq(0, 3000000, by = 500000)
  ) +
  scale_y_continuous(
    labels = scales::comma,
    limits = c(0, 3000),
    breaks = seq(0, 3000, by = 500)
  )

# Interpretacja:
# Większość wniosków dotyczy niewielkich kwot, co widać po wysokim słupku w przedziale poniżej 500 000.
# Liczba wniosków maleje wraz ze wzrostem wnioskowanej kwoty.
# Rozkład jest prawostronnie skośny i zdarzają się sporadyczne wnioski powyżej 2 000 000.

 
# 3.2 Kwota kredytu
 
ggplot(data, aes(x = kwota_kredytu)) +
  geom_histogram(bins = 30, fill = "red", alpha = 0.7, color = "black") +
  labs(
    title = "Rozkład kwoty kredytu",
    x = "Kwota kredytu",
    y = "Liczba wniosków"
  ) +
  theme_minimal() +
  scale_x_continuous(
    labels = scales::comma,
    limits = c(0, 3000000),
    breaks = seq(0, 3000000, by = 500000)
  ) +
  scale_y_continuous(
    labels = scales::comma,
    limits = c(0, 3000),
    breaks = seq(0, 3000, by = 500)
  )

# Interpretacja:
# Rozkład podobny do wnioskowanej kwoty – większość wniosków na niewielkie kwoty (poniżej 500 000),
# a następnie wykładniczo malejąca liczba wniosków przy wyższych kwotach.
# Rozkład prawostronnie asymetryczny z nielicznymi bardzo wysokimi kwotami (powyżej 2 000 000).

 
# 3.3 Wkład własny
 
ggplot(data, aes(x = wklad_wlasny)) +
  geom_histogram(bins = 30, fill = "blue", alpha = 0.7, color = "black") +
  labs(
    title = "Rozkład wkładu własnego",
    x = "Wkład własny",
    y = "Liczba wniosków"
  ) +
  theme_minimal() +
  scale_x_continuous(
    labels = scales::comma,
    limits = c(0, 100000),
    breaks = seq(0, 100000, by = 10000)
  ) +
  scale_y_continuous(
    labels = scales::comma,
    limits = c(0, 2500),
    breaks = seq(0, 2500, by = 500)
  )

# Interpretacja:
# Najliczniejsza grupa wniosków dotyczy wkładu własnego w przedziale 40 000–50 000.
# Rozkład jest dość symetryczny, choć są wnioski o bardzo niskim wkładzie (poniżej 20 000)
# i wysokim (powyżej 60 000), ale nie jest ich wiele.

 
# 3.4 Cena towaru
 
ggplot(data, aes(x = cena_towaru)) +
  geom_histogram(bins = 30, fill = "yellow", alpha = 0.7, color = "black") +
  labs(
    title = "Rozkład cen towarów",
    x = "Cena towaru",
    y = "Liczba wniosków"
  ) +
  theme_minimal() +
  scale_x_continuous(
    labels = scales::comma,
    limits = c(0, 3000000),
    breaks = seq(0, 3000000, by = 500000)
  ) +
  scale_y_continuous(
    labels = scales::comma,
    limits = c(0, 3000),
    breaks = seq(0, 3000, by = 500)
  )

# Interpretacja:
# Większość towarów wyceniana jest na mniej niż 500 000.
# Podobnie jak w poprzednich przypadkach rozkład jest prawostronnie skośny,
# z niewielką liczbą wniosków na bardzo drogie towary (powyżej 2 000 000).

 
# 3.5 Roczna rata
 
ggplot(data, aes(x = roczna_rata)) +
  geom_histogram(bins = 30, fill = "lightblue", alpha = 0.7, color = "black") +
  labs(
    title = "Rozkład rocznej raty",
    x = "Roczna rata",
    y = "Liczba wniosków"
  ) +
  theme_minimal() +
  scale_x_continuous(
    labels = scales::comma,
    limits = c(0, 250000),
    breaks = seq(0, 250000, by = 50000)
  ) +
  scale_y_continuous(
    labels = scales::comma,
    limits = c(0, 10000),
    breaks = seq(0, 10000, by = 1000)
  )

# Interpretacja:
# Dominuje przedział rat do 50 000 (wysoki słupek z lewej strony).
# Rozkład prawostronnie asymetryczny, nieliczne wnioski wskazują na raty powyżej 150 000.


 
# 4. Porównanie rozkładów danych liczbowych w grupach
 

cat("\nPorównanie histogramów danych liczbowych w grupach...\n")

 
# 4.1 Wnioskowana kwota a typ umowy (bez nakładania słupków)
 
ggplot(data, aes(x = wnioskowana_kwota, fill = typ_umowy)) +
  geom_histogram(bins = 30, alpha = 0.7, position = "dodge") +
  labs(
    title = "Rozkład wnioskowanej kwoty w podziale na typ umowy",
    x = "Wnioskowana kwota",
    y = "Liczba wniosków",
    fill = "Typ umowy"
  ) +
  theme_minimal() +
  scale_x_continuous(
    labels = scales::comma,
    limits = c(0, 250000),
    breaks = seq(0, 250000, by = 50000)
  ) +
  scale_y_continuous(
    labels = scales::comma,
    limits = c(0, 5000),
    breaks = seq(0, 5000, by = 500)
  ) +
  scale_fill_brewer(palette = "Set2")

# Interpretacja:
# Widać, że kredyty gotówkowe najczęściej pojawiają się w przedziale ~100 000,
# natomiast kredyty konsumenckie i odnawialne gromadzą się głównie w przedziale poniżej 50 000.
# Rozkłady są asymetryczne, większość wniosków dotyczy raczej niższych kwot.

 
# 4.2 Cena towarów a kategoria portfela (z nakładaniem słupków)
 
ggplot(data, aes(x = cena_towaru, fill = kategoria_portfela)) +
  geom_histogram(bins = 30, alpha = 0.7, position = "identity") +
  scale_fill_manual(values = colorRampPalette(brewer.pal(12, "Set3"))(27)) +
  labs(
    title = "Rozkład cen towarów w podziale na kategorie portfela",
    x = "Cena towaru",
    y = "Liczba wniosków",
    fill = "Kategoria portfela"
  ) +
  theme_minimal() +
  scale_x_continuous(
    labels = scales::comma,
    limits = c(0, 2500000),
    breaks = seq(0, 2500000, by = 500000)
  ) +
  scale_y_continuous(
    labels = scales::comma,
    limits = c(0, 2000),
    breaks = seq(0, 5000, by = 500)
  )

# Interpretacja:
# Większość wniosków (niezależnie od kategorii portfela) dotyczy cen poniżej 500 000.
# Ponieważ słupki nakładają się (position = "identity"), czasami trudno jest rozróżnić 
# szczegóły, zwłaszcza przy wyższych kwotach.


 
# 5. Zależności między zmiennymi (punktowe, kategoryczne)
 

cat("\nZależności między poszczególnymi zmiennymi...\n")

 
# 5.1 Wnioskowana kwota a kwota otrzymanego kredytu
 
ggplot(data, aes(x = wnioskowana_kwota, y = kwota_kredytu, color = typ_umowy)) +
  geom_point(alpha = 0.6) +
  labs(
    title = "Zależność między wnioskowaną kwotą a kwotą kredytu",
    x = "Wnioskowana kwota",
    y = "Kwota kredytu"
  ) +
  theme_minimal() +
  scale_color_brewer(palette = "Set1")

# Interpretacja:
# Dzięki temu wykresowi można zobaczyć, jak kwota faktycznie przyznanego kredytu
# ma się do kwoty wnioskowanej w zależności od rodzaju umowy.

 
# 5.2 Procent kredytu a wkład własny (kolor = status_ubezpieczenia)
 
ggplot(data, aes(x = procent_kredytu, y = wklad_wlasny, color = status_ubezpieczenia)) +
  geom_point(alpha = 0.6) +
  labs(
    title = "Zależność między procentem kredytu a wkładem własnym",
    x = "Procent kredytu",
    y = "Wkład własny",
    color = "Status ubezpieczenia"
  ) +
  theme_minimal() +
  scale_y_continuous(labels = scales::comma) +
  scale_color_gradient(low = "blue", high = "red")

# Interpretacja:
# Pozwala na wgląd w to, czy np. wyższy wkład własny wiąże się
# z określonym statusem ubezpieczenia i jaki jest udział procentu kredytu.


 
# 6. Dane kategoryczne (liczba, udział, rozkład)
 

cat("\nDane kategoryczne...\n")

 
# 6.1 Rozkład celów kredytów
 
ggplot(data, aes(x = cel_kredytu)) +
  geom_bar(fill = "orange", color = "black") +
  labs(
    title = "Rozkład celów kredytów",
    x = "Cel kredytu",
    y = "Liczba wniosków"
  ) +
  theme_minimal() +
  coord_flip()

# Interpretacja:
# Dzięki temu widać, które cele kredytów są najpopularniejsze.
# Użycie coord_flip() odwraca oś X i Y, co bywa wygodniejsze dla dłuższych etykiet.

 
# 6.2 Stan umowy a rodzaj klienta
 
ggplot(data, aes(x = stan_umowy, fill = rodzaj_klienta)) +
  geom_bar(position = "fill", alpha = 0.8) +
  labs(
    title = "Stan umowy w zależności od rodzaju klienta",
    x = "Stan umowy",
    y = "Udział",
    fill = "Rodzaj klienta"
  ) +
  theme_minimal() +
  scale_fill_brewer(palette = "Set2")

# Interpretacja:
# Wykres pokazuje proporcje (position = "fill") stanów umów 
# w kontekście różnych rodzajów klientów.


 
# 7. Dane czasowe
 

cat("\nDane czasowe...\n")

 
# 7.1 Rozkład liczby wniosków (godzina vs dzień tygodnia)
 
ggplot(data, aes(x = dzien_tygodnia_procesu, y = godzina_rozpoczecia_procesu)) +
  stat_bin2d(aes(fill = after_stat(count)), bins = 10) +
  labs(
    title = "Rozkład liczby wniosków w czasie",
    x = "Dzień tygodnia",
    y = "Godzina rozpoczęcia procesu",
    fill = "Liczba wniosków"
  ) +
  theme_minimal() +
  scale_fill_gradient(low = "white", high = "orange")

# Interpretacja:
# Pokazuje, w które dni tygodnia i o jakich godzinach rozpoczyna się najwięcej procesów.
# Ciemniejsze (lub bardziej intensywne) pola oznaczają większe zagęszczenie wniosków.

 
# 7.2 Liczba wniosków w czasie (dzien_decyzji)
 
ggplot(data, aes(x = dzien_decyzji)) +
  geom_line(stat = "count", color = "red") +
  labs(
    title = "Liczba wniosków w czasie (dzien_decyzji)",
    x = "Dzień decyzji",
    y = "Liczba wniosków"
  ) +
  theme_minimal()

# Interpretacja:
# Linia pokazuje, jak zmienia się liczba wniosków w kolejnych dniach decyzyjnych.


 
# 8. Specyficzne przypadki (boxplot, violin plot)
 

cat("\nSpecyficzne przypadki...\n")

 
# 8.1 Kwota kredytu a cel kredytu (boxplot)
 
ggplot(data, aes(x = cel_kredytu, y = kwota_kredytu)) +
  geom_boxplot(fill = "cyan", alpha = 0.7) +
  labs(
    title = "Kwota kredytu w zależności od celu kredytu",
    x = "Cel kredytu",
    y = "Kwota kredytu"
  ) +
  theme_minimal() +
  scale_y_continuous(labels = scales::comma) +
  coord_flip()

# Interpretacja:
# Pozwala zobaczyć rozkład kwot kredytów w zależności od celu (np. remont, zakup auta itp.).
# Boxplot prezentuje medianę, kwartyle oraz ewentualne wartości odstające.

 
# 8.2 Rozkład liczby rat w podziale na kategorię produktu (violin)
 
dane <- as.data.frame(data)
ggplot(dane, aes(x = kategoria_produktu, y = liczba_rat)) +
  geom_violin(fill = "purple", alpha = 0.7) +
  labs(
    title = "Rozkład liczby rat w podziale na kategorię produktu",
    x = "Kategoria produktu",
    y = "Liczba rat"
  ) +
  theme_minimal() +
  coord_flip()

# Interpretacja:
# Violin plot pokazuje rozkład liczby rat (gęstość) dla różnych kategorii produktu.
# Pozwala szybko porównać rozrzut i kształt rozkładu w każdej kategorii.


 
# 9. Analiza korelacji
 

cat("\nAnaliza korelacji między zmiennymi liczbowymi...\n")

 
# 9.1 Macierz korelacji i jej wizualizacja
 
num_cols <- data %>% select_if(is.numeric)
cor_matrix <- cor(num_cols, use = "complete.obs")

# Wizualizacja korelacji
corrplot(cor_matrix, method = "circle", type = "lower", tl.cex = 0.7)

# Interpretacja:
# Pozwala zidentyfikować istotne dodatnie/ujemne korelacje między zmiennymi liczbowymi.
# Im bliżej 1 lub -1, tym silniejsza korelacja (dodatnia lub ujemna).


 
# 10. Trendy czasowe
 

cat("\nTrend liczby wniosków w czasie (dzien_decyzji)...\n")

 
# 10.1 Trend na podstawie dzien_decyzji
 
ggplot(data, aes(x = dzien_decyzji)) +
  geom_line(stat = "count", color = "blue") +
  labs(
    title = "Liczba wniosków w czasie (trend dzien_decyzji)",
    x = "Dzień decyzji",
    y = "Liczba wniosków"
  ) +
  theme_minimal()

# Interpretacja:
# Można wychwycić ewentualne wzrosty lub spadki popularności wniosków w pozsczególnych dniach.


 
# 11. Wykresy złożone / porównawcze
 

cat("\nWykresy złożone - porównanie liczby wniosków w różnych kategoriach...\n")

 
# 11.1 Typ umowy a stan umowy (bar chart z dodge)
 
ggplot(data, aes(x = typ_umowy, fill = stan_umowy)) +
  geom_bar(position = "dodge") +
  labs(
    title = "Typ umowy a stan umowy",
    x = "Typ umowy",
    y = "Liczba wniosków"
  ) +
  theme_minimal()

# Interpretacja:
# Umożliwia porównanie, jak często występuje określony stan umowy (np. aktywna, wypowiedziana)
# w poszczególnych rodzajach umów.


 
# 12. Zaawansowane zależności
 

cat("\nZależność zmiennych liczbowych w kontekście zmiennych kategorycznych...\n")

 
# 12.1 Procent kredytu vs wkład własny z podziałem na typ_umowy
 
ggplot(data, aes(x = procent_kredytu, y = wklad_wlasny, color = typ_umowy)) +
  geom_point(alpha = 0.6) +
  labs(
    title = "Procent kredytu vs wkład własny w zależności od typu umowy",
    x = "Procent kredytu",
    y = "Wkład własny"
  ) +
  theme_minimal()

# Interpretacja:
# Pomaga określić, czy np. w kredytach gotówkowych typowy procent finansowania 
# i wkład własny różnią się znacząco od innych typów umów.


# 13. Klasyfikacja klientów (przykładowa wizualizacja)
 

cat("\nKlasyfikacja klientów - różnice między klientami...\n")

 
# 13.1 Stan umowy vs rodzaj klienta
 
ggplot(data, aes(x = stan_umowy, fill = rodzaj_klienta)) +
  geom_bar(position = "fill") +
  labs(
    title = "Stan umowy w zależności od rodzaju klienta",
    x = "Stan umowy",
    y = "Proporcja"
  ) +
  theme_minimal()

# Interpretacja:
# Dzięki parametrowi position = "fill" widzimy proporcje stanu umowy w kontekście rodzaju klienta.
# Można sprawdzić, czy np. klienci "indywidualni" mają inny rozkład stanów umów niż "firmowi".

