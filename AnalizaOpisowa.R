# 1. PODSTAWOWE INFORMACJE O ZBIORZE DANYCH

# 1.1 Liczba wierszy i kolumn
cat("Liczba wierszy i kolumn:\n")
print(dim(data))

# 1.2 Szybki przegląd struktur zmiennych
cat("\nStruktura zbioru danych:\n")
str(data)

# 1.3 Pierwsze wiersze danych (podgląd)
cat("\nPodgląd pierwszych 5 wierszy:\n")
head(data, 5)

# WNIOSKI:
# Dzięki powyższym krokom możemy zorientować się, ile rekordów zawiera zbiór danych,
# jakie mamy kolumny, jakiego są typu (numeryczne, kategoryczne, tekstowe) oraz
# przejrzeć przykładowe wiersze w celu wykrycia ewentualnych niespójności.



# 2. STATYSTYKI OPISOWE DLA ZMIENNYCH NUMERYCZNYCH


# 2.1 Podstawowe miary statystyczne dla całego zbioru (funkcja summary)
cat("\nPodstawowe statystyki opisowe (summary) dla wszystkich kolumn:\n")
summary(data)

# 2.2 Możemy skupić się tylko na kolumnach numerycznych
#   (zakładając, że 'wnioskowana_kwota', 'kwota_kredytu', 'wklad_wlasny', 'cena_towaru',
#   'roczna_rata' itp. są liczbami):
library(dplyr)

numeric_data <- data %>%
 select_if(is.numeric)

cat("\nPodstawowe statystyki opisowe (summary) dla zmiennych numerycznych:\n")
summary(numeric_data)

# 2.3 Bardziej szczegółowe miary
cat("\nŚrednia, odchylenie standardowe i mediana dla wybranych zmiennych:\n")

cat("\n-> wnioskowana_kwota\n")
mean_wk  <- mean(data$wnioskowana_kwota, na.rm = TRUE)
sd_wk   <- sd(data$wnioskowana_kwota, na.rm = TRUE)
median_wk <- median(data$wnioskowana_kwota, na.rm = TRUE)

cat("  Średnia: ", mean_wk, "\n")
cat("  Odchylenie standardowe: ", sd_wk, "\n")
cat("  Mediana: ", median_wk, "\n")

cat("\n-> kwota_kredytu\n")
mean_kred <- mean(data$kwota_kredytu, na.rm = TRUE)
sd_kred  <- sd(data$kwota_kredytu, na.rm = TRUE)
median_kred <- median(data$kwota_kredytu, na.rm = TRUE)

cat("  Średnia: ", mean_kred, "\n")
cat("  Odchylenie standardowe: ", sd_kred, "\n")
cat("  Mediana: ", median_kred, "\n")

# WNIOSKI (przykłady):
# Porównanie średniej z medianą pozwala ocenić, czy rozkład jest silnie asymetryczny.
# Duża różnica między średnią a medianą może sugerować istnienie wartości odstających (outliers).



# 3. ROZKŁAD ZMIENNYCH KATEGORYCZNYCH (CZĘSTOŚĆ, PROPORCJE)


# Zakładamy, że 'typ_umowy', 'stan_umowy' i 'rodzaj_klienta' to zmienne kategoryczne.

cat("\nRozkład typ_umowy (liczności i proporcje):\n")
print(table(data$typ_umowy))
print(prop.table(table(data$typ_umowy)) * 100) # procentowo

cat("\nRozkład stan_umowy:\n")
print(table(data$stan_umowy))
print(prop.table(table(data$stan_umowy)) * 100)

cat("\nRozkład rodzaj_klienta:\n")
print(table(data$rodzaj_klienta))
print(prop.table(table(data$rodzaj_klienta)) * 100)

# WNIOSKI:
# Pozwala to zauważyć, czy mamy zrównoważone dane w poszczególnych kategoriach, 
# czy np. jedna kategoria dominuje (np. 80% stanów umów to 'aktywna').

# 4. TABELE KRZYŻOWE DLA ZMIENNYCH KATEGORYCZNYCH

# Dzięki nim poznajemy relacje między dwiema cechami kategorycznymi.
# Przykład: 'typ_umowy' vs. 'stan_umowy'.

cat("\nTabela krzyżowa: typ_umowy vs. stan_umowy\n")
tab_typ_stan <- table(data$typ_umowy, data$stan_umowy)
print(tab_typ_stan)

cat("\nTa sama tabela w procentach (względem całości):\n")
print(prop.table(tab_typ_stan) * 100)

# Alternatywnie w 'dplyr':
data %>%
 group_by(typ_umowy, stan_umowy) %>%
 summarise(liczba = n()) %>%
 mutate(procent = 100 * liczba / sum(liczba)) %>%
 ungroup() %>%
 arrange(desc(liczba)) # posortowanie malejąco po liczbie


# WNIOSKI:
# Sprawdzamy, jak często dla danej kombinacji (np. 'gotówkowa' i 'aktywny') występuje rekord.
# Możemy wykryć, że np. większość umów gotówkowych jest 'aktywnych', a umowy odnawialne dominują w stanie 'wypowiedziany'.

#5. Boxplot z użyciem skali logarytmicznej (log10)


# 1. Załadowanie potrzebnych pakietów
library(ggplot2)  # do tworzenia wykresów
library(scales)   # dla funkcji comma (formatowanie osi)

# 2. Zakładamy, że mamy ramkę danych 'data', a kolumna 'wnioskowana_kwota' jest liczbowa

# 3. Tworzymy boxplot na skali logarytmicznej
# Załadowanie potrzebnych bibliotek
library(ggplot2)
library(scales)

# Tworzenie wykresu i przypisanie go do zmiennej
boxplot_plot <- ggplot(data, aes(x = "", y = wnioskowana_kwota)) +
  geom_boxplot(fill = "lightblue") +
  
  # Ustawienie skali log10 na osi Y:
  scale_y_log10(labels = comma) +
  
  # Opisy osi i tytuł wykresu
  labs(
    title = "Boxplot: Wnioskowana Kwota (skala log10)",
    x = "",
    y = "Wnioskowana Kwota (log10)"
  ) +
  
  # Minimalistyczny wygląd wykresu
  theme_minimal()
ggsave(
  filename = "Boxplot_Wnioskowana_Kwota_Log10.png", 
  plot = boxplot_plot,                            
  width = 8,                                       
  height = 6,                                      
  dpi = 300                                       
)


# 5.2 Możemy obliczyć IQR i wyznaczyć przedziały, by zidentyfikować outliers

Q1 <- quantile(data$wnioskowana_kwota, 0.25, na.rm = TRUE)
Q3 <- quantile(data$wnioskowana_kwota, 0.75, na.rm = TRUE)
IQR_val <- Q3 - Q1

lower_bound <- Q1 - 1.5 * IQR_val
upper_bound <- Q3 + 1.5 * IQR_val

cat("\nDolna granica outliers:", lower_bound, 
  "Górna granica outliers:", upper_bound, "\n")

# Wybieramy wiersze uznane za odstające
outliers_data <- data %>%
 filter(wnioskowana_kwota < lower_bound | wnioskowana_kwota > upper_bound)

cat("Liczba wierszy uznanych za outliers:", nrow(outliers_data), "\n")

# WNIOSKI:
# Boxplot i obliczenia IQR pozwalają zidentyfikować, czy w zbiorze 
#  istnieje duża liczba wartości bardzo odbiegających od reszty.
# W praktyce można zdecydować, czy wartości odstające usuwać, 
#  transformować, czy pozostawić (w zależności od kontekstu analizy).



# 6. ZALEŻNOŚCI MIĘDZY ZMIENNYMI NUMERYCZNYMI (KORELACJE)


if (!require("corrplot")) install.packages("corrplot")
if (!require("ggplot2")) install.packages("ggplot2")
if (!require("reshape2")) install.packages("reshape2")


library(corrplot)
library(ggplot2)
library(reshape2)

# Wyświetlamy komunikatu
cat("\nMacierz korelacji dla zmiennych numerycznych\n")

# Wybieramy  kolumny numeryczne
num_cols <- data %>% select_if(is.numeric)

# Obliczamy  macierzy korelacji
cor_matrix <- cor(num_cols, use = "complete.obs")

# Wyświeamy macierz w konsoli
print(cor_matrix)

# Wizualizacja macierzy korelacji za pomocą corrplot
png(filename = "Macierz_Korelacji_Corrplot.png", width = 800, height = 800)
corrplot(cor_matrix, method = "circle", type = "lower", tl.cex = 0.7,
         main = "Macierz korelacji")
dev.off()

# Wizualizacja macierzy korelacji za pomocą ggplot2 ---

# Konwertowanie macierzy korelacji do formatu długiego
cor_melted <- melt(cor_matrix)

# Tworzenie wykresu macierzy korelacji
plot_cor <- ggplot(data = cor_melted, aes(x = Var1, y = Var2, fill = value)) +
  geom_tile(color = "white") +
  scale_fill_gradient2(low = "blue", high = "red", mid = "white", midpoint = 0,
                       limit = c(-1, 1), name = "Korelacja") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust = 1)) +
  labs(title = "Macierz Korelacji", x = "", y = "")

# Zapisujemy  wykres jako plik PNG
ggsave("Macierz_Korelacji_ggplot.png", plot = plot_cor, width = 10, height = 8, dpi = 300)

# WNIOSKI:
# Pozwala wykryć, czy np. 'wnioskowana_kwota' jest silnie skorelowana z 'kwota_kredytu' lub innymi zmiennymi.
# Silna korelacja (powyżej 0.7) może świadczyć o redundancji lub zależnościach, które trzeba uwzględnić w dalszych analizach.



# 7. ZMIENNE KATEGORYCZNE VS. ILOŚCIOWE

# Przykład: Zobaczmy, czy istnieją różnice w średniej kwocie wnioskowanej
#      w zależności od typu umowy.

cat("\nŚrednia i mediana wnioskowanej kwoty w zależności od typ_umowy:\n")
data %>%
 group_by(typ_umowy) %>%
 summarise(
  sr_kwota = mean(wnioskowana_kwota, na.rm = TRUE),
  med_kwota = median(wnioskowana_kwota, na.rm = TRUE),
  liczba = n()
 ) %>%
 arrange(desc(sr_kwota)) %>%
 print()

# WNIOSKI:
# Jeśli w jednej kategorii (np. 'gotówkowa') średnia jest znacznie wyższa od mediany, 
# może to sygnalizować dużą liczbę outlierów (wnioski o bardzo wysokich kwotach).
# Dzięki temu prostemu podsumowaniu można wykryć, czy np. typ umowy "hipoteczna" 
# ma wyraźnie wyższe kwoty od innych umów.



# 8. KRÓTKA INTERPRETACJA I OBSERWACJE

# Tutaj w raporcie (np. w R Markdown) możesz dodać:
# Komentarz, że większość wniosków oscyluje w okolicach X zł, mediana jest Y zł.
# Analizę, czy występują liczne braki (NA) w pewnych kolumnach.
# Ewentualnie sugestie, co robić z outlierami (czy usuwać, czy transformować).
# Wskazanie, że pewna grupa zmiennych jest silnie skorelowana (np. wnioskowana_kwota 
#  vs. kwota_kredytu), co może mieć znaczenie w dalszym modelowaniu.



# 9. PODSUMOWANIE ANALIZY OPISOWEJ

cat("\nPODSUMOWANIE:\n")
cat("1. Dane posiadają ", nrow(data), " wierszy i ", ncol(data), " kolumn.\n")
cat("2. Widać asymetryczne rozkłady wnioskowanych kwot i kwot kredytu,\n",
  "  co sugeruje obecność ekstremalnie wysokich wartości.\n")
cat("3. Kategorie typ_umowy czy stan_umowy są dość zróżnicowane, \n",
  "  ale część z nich (np. X) może dominować.\n")
cat("4. Korelacje wskazują, że wnioskowana_kwota i kwota_kredytu są silnie powiązane.\n")
cat("5. W kolejnym etapie można rozważyć testy statystyczne \n",
  "  (np. testy dla różnic średnich) czy budowę modelu.\n")
