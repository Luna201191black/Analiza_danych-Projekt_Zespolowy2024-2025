# Wczytamy plik
file_path <- file.choose()

# Sprawdzamy, czy plik istnieje, ponieważ zmienione urządzenie dla pracy nad projektem w moim przypadku
if (!file.exists(file_path)) {
  stop("Wybrany plik nie istnieje!")
}

# Wczytamy zawartośc tego pliku
rmd_content <- readLines(file_path)

# Dodajemy sekcje z opisem autorów projekta 
yaml_header <- c(
  "---",
  'title: "Raport Analizy Danych - Projekt Zespołowy 2024-2025"',
  'author: ',
  '  - "Yuliya Sharkova"',
  '  - "Michał Owczarek"',
  '  - "Aleksander Urbański"',
  "---",
  ""
)

if (!grepl("^---", rmd_content[1])) {
  rmd_content <- c(yaml_header, rmd_content)
} else {
  rmd_content <- gsub(
    pattern = "^title:.*",
    replacement = 'title: "Raport Analizy Danych - Projekt Zespołowy 2024-2025"',
    x = rmd_content
  )
  rmd_content <- gsub(
    pattern = "^author:.*",
    replacement = 'author: \n  - "Yuliya Sharkova"\n  - "Michał Owczarek"\n  - "Aleksander Urbański"',
    x = rmd_content
  )
}

# Usuwamy powtórzenia lub błedne treści
rmd_content <- rmd_content[!rmd_content %in% c("---", "🎯 Dodany przez Yuliya Sharkova")]

# Zmiana tytułu sekcji na potrzebne zgodnie z opisem projektu
start_section <- grep("^⭐ 2. Proces analizy i oczyszczania danych", rmd_content)
if (length(start_section) == 0) {
  stop("Sekcja '⭐ 2. Proces analizy i oczyszczania danych' nie została znaleziona!")
}
rmd_content[start_section] <- "⭐ 2. Data Cleansing. Wrangling"

# Usuwamy dużą ilość działań przy etapach naprawy danych
lines_to_keep <- !(grepl("Aktualizacja po zmianach w NAME_", rmd_content) |
                     grepl("Dane zapisano w nowym pliku:", rmd_content) |
                     grepl("Plik wyjściowy: `previous_application_cleaned.csv`", rmd_content))
rmd_content <- rmd_content[lines_to_keep]

# Dodawamy treści sekcji 2
cleansing_summary <- c(
  "",
  "### 2.1. Analiza braków",
  "- Zidentyfikowano brakujące dane w kilku kolumnach, uwzględniając ich liczbę i procent.",
  "- Skupiono się na kolumnach z największą liczbą braków.",
  "",
  "### 2.2. Usuwanie kolumn z dużą liczbą braków",
  "- Usunięto kolumny z brakami danych przekraczającymi 90%.",
  "- Lista usuniętych kolumn została zarchiwizowana.",
  "",
  "### 2.3. Naprawa braków w danych",
  "- Braki w danych liczbowych uzupełniono medianą.",
  "- Braki w danych kategorycznych uzupełniono trybem.",
  "",
  "### 2.4. Walidacja danych",
  "- Wszystkie kolumny zostały zweryfikowane jako kompletne.",
  "- Walidacja potwierdziła brak brakujących danych.",
  "",
  "### 2.5. Zapis oczyszczonych danych",
  "Ostateczne dane zapisano w pliku: `previous_application_cleaned_finished.csv`."
)
start_section <- grep("^⭐ 2. Data Cleansing. Wrangling", rmd_content)
rmd_content <- append(rmd_content, cleansing_summary, after = start_section)

# Dodamy nowe sekcji zgodnie z opisem projektu
new_sections <- c(
  "",
  "⭐ 3. Wizualizacja Danych",
  "- W tej sekcji znajdą się wykresy i wizualizacje wspierające analizę projektu.",
  "",
  "⭐ 4. Analiza Opisowa",
  "- Sekcja zawiera podstawowe statystyki opisowe dla kluczowych zmiennych.",
  "",
  "⭐ 5. Wnioskowanie (testy statystyczne)",
  "- Omówione zostaną wyniki testów statystycznych wspierających wnioskowanie.",
  "",
  "⭐ 6. Podsumowanie i wnioski końcowe",
  "- Podsumowanie głównych wyników i proponowane wnioski końcowe."
)
rmd_content <- c(rmd_content, new_sections)

# Zapisujemy plik po zmianach
writeLines(rmd_content, file_path)

cat("Raport został zaktualizowany i zapisany pod ścieżką:\n", file_path, "\n")



# Wybiramy plik 
file_path <- file.choose()

# Sprawdzamy, czy istneje
if (!file.exists(file_path)) {
  stop("Wybrany plik nie istnieje!")
}

# Wczytamy zawartosć pliku
rmd_content <- readLines(file_path)

# Szukamy sekcję  "1. Wprowadzenie"
start_intro <- grep("^⭐ 1. Wprowadzenie", rmd_content)

if (length(start_intro) == 0) {
  stop("Sekcja '⭐ 1. Wprowadzenie' nie została znaleziona!")
}

# Dodjemy treść do tej sekcji
introduction <- c(
  "",
  "Analiza danych odgrywa fundamentalną rolę w realizacji projektów opartych na danych.",
  "",
  "Niniejszy raport koncentruje się na obróbce historycznych danych dotyczących wniosków kredytowych. Proces ten obejmuje ich:",
  "- oczyszczanie,",
  "- analizę,",
  "- wizualizację.",
  "",
  "Dzięki odpowiedniemu przetwarzaniu danych możliwe jest nie tylko eliminowanie nieścisłości, ale również ich przekształcenie, co pozwala na:",
  "- formułowanie wartościowych wniosków,",
  "- podejmowanie bardziej świadomych decyzji strategicznych.",
  "",
  "Celem projektu jest:",
  "1. Przedstawienie kompleksowego podejścia do analizy danych.",
  "2. Zaprezentowanie etapów od przygotowania danych aż po ich interpretację.",
  "",
  "Szczególny nacisk położono na:",
  "- identyfikację braków,",
  "- weryfikację spójności,",
  "- transformację kluczowych informacji.",
  "",
  "Te etapy stanowią fundament dla zaawansowanych metod analitycznych, takich jak:",
  "- wnioskowanie statystyczne,",
  "- odkrywanie ukrytych wzorców w danych.",
  ""
)

rmd_content <- append(rmd_content, introduction, after = start_intro)
# Zapisujemy
writeLines(rmd_content, file_path)

cat("Sformatowane wprowadzenie zostało dodane i zapisane pod ścieżką:\n", file_path, "\n")

# Wybór pliku do edycji
file_path <- file.choose()

# Sprawdzenie, czy plik istnieje
if (!file.exists(file_path)) {
  stop("Wybrany plik nie istnieje!")
}

# Wczytanie zawartości pliku
rmd_content <- readLines(file_path)

# Znalezienie sekcji "2. Data Cleansing. Wrangling"
start_section <- grep("^⭐ 2. Data Cleansing. Wrangling", rmd_content)
end_section <- grep("^⭐ 3. Wizualizacja Danych", rmd_content)

if (length(start_section) == 0 || length(end_section) == 0) {
  stop("Nie znaleziono sekcji '⭐ 2. Data Cleansing. Wrangling' lub jej zakończenia!")
}

# Dodamy podsumowanie do sekcji 2
summary_text <- c(
  "",
  "> Proces przetwarzania i czyszczenia danych był kluczowym krokiem w przygotowaniu informacji do dalszej analizy.",
  "",
  "- **Eliminacja kolumn:** Usunięto kolumny z dużą liczbą braków, co pozwoliło na poprawę spójności danych.",
  "- **Uzupełnienie braków:** Braki w zmiennych liczbowych uzupełniono medianą, natomiast w zmiennych kategorycznych trybem.",
  "",
  "> Dzięki tym operacjom uzyskano zestaw danych:",
  "- kompletny,",
  "- zgodny ze standardami analitycznymi,",
  "- gotowy do dalszego przetwarzania.",
  "",
  "> **Weryfikacja danych:**",
  "- Walidacja pozwoliła zidentyfikować i wyeliminować potencjalne rozbieżności.",
  "- Potwierdzono integralność i spójność przekształconych danych.",
  "",
  "> Oczyszczone dane stanowią solidną podstawę dla kolejnych etapów projektu, takich jak:",
  "- wizualizacja danych,",
  "- analiza opisowa,",
  "- testy statystyczne.",
  "",
  "> Finalny plik z przetworzonymi danymi został zapisany pod ścieżką:",
  "`C:/Users/user/Documents/GIT projekts/Analiza_danych-Projekt_Zespolowy2024-2025/previous_application_cleaned_finished.csv`",
  ""
)

rmd_content <- append(rmd_content, summary_text, after = end_section - 1)

# Zapisujemy plik po zmianach
writeLines(rmd_content, file_path)

cat("Sformatowane podsumowanie zostało dodane na końcu sekcji '2. Data Cleansing. Wrangling' i zapisane pod ścieżką:\n", file_path, "\n")




file_path <- file.choose()


if (!file.exists(file_path)) {
  stop("Wybrany plik nie istnieje!")
}

# Wczytamy plik raportu
rmd_content <- readLines(file_path)

# dodajemy nową część do sekcji w raporcie
new_section_3 <- c(
  "⭐ 3. Wizualizacja Danych",
  "",
  "W tej sekcji przedstawiono kluczowe wizualizacje danych przygotowanych na podstawie wcześniejszej analizy. Każdy wykres został zapisany i opisany poniżej.",
  "",
  "### Rozkład Wnioskowanej Kwoty",
  "![](Rozklad_wnioskowanej_kwoty.png)",
  "- Większość wniosków dotyczy niewielkich kwot poniżej 500 000.",
  "- Rozkład jest prawostronnie skośny.",
  "",
  "### Rozkład Kwoty Kredytu",
  "![](Rozklad_kwoty_kredytu.png)",
  "- Zdecydowana większość wniosków dotyczy niskich kwot kredytu (poniżej 500 000).",
  "- Pojawiają się nieliczne przypadki wysokich kwot kredytu (powyżej 2 000 000).",
  "",
  "### Rozkład Wkładu Własnego",
  "![](Rozklad_wkladu_wlasnego.png)",
  "- Największa liczba wniosków dotyczy wkładu własnego w przedziale 40 000–50 000.",
  "- Rozkład jest symetryczny z niewielką liczbą wartości skrajnych.",
  "",
  "### Rozkład Cen Towarów",
  "![](Rozklad_cen_towarow.png)",
  "- Dominują towary o cenie poniżej 500 000.",
  "- Rozkład wskazuje na prawostronną skośność.",
  "",
  "### Rozkład Rocznej Raty",
  "![](Rozklad_rocznej_raty.png)",
  "- Większość wniosków dotyczy rat rocznych poniżej 50 000.",
  "- Nieliczne przypadki wskazują na wysokie raty powyżej 150 000.",
  "",
  "### Rozkład Wnioskowanej Kwoty w Podziale na Typ Umowy",
  "![](Rozklad_wnioskowanej_kwoty_typ_umowy.png)",
  "- Kredyty gotówkowe najczęściej mieszczą się w przedziale 100 000–150 000.",
  "- Inne typy kredytów skupiają się w niższych przedziałach kwotowych.",
  "",
  "### Rozkład Cen Towarów w Podziale na Kategorie Portfela",
  "![](Rozklad_cen_towarow_kategoria_portfela.png)",
  "- Towary o niskich cenach (poniżej 500 000) dominują niezależnie od kategorii portfela.",
  "",
  "### Zależność Między Wnioskowaną Kwotą a Kwotą Kredytu",
  "![](Zaleznosc_wnioskowana_kwota_kwota_kredytu.png)",
  "- Widoczna jest liniowa zależność między wnioskowaną kwotą a przyznanym kredytem.",
  "",
  "### Zależność Między Procentem Kredytu a Wkładem Własnym",
  "![](Zaleznosc_procent_kredytu_wklad_wlasny.png)",
  "- Wysoki wkład własny częściej występuje przy niższym procencie kredytu.",
  "",
  "### Rozkład Celów Kredytów",
  "![](Rozklad_celow_kredytow.png)",
  "- Dominują kredyty przeznaczone na remonty, inwestycje i bieżące wydatki.",
  "",
  "### Stan Umowy w Zależności od Rodzaju Klienta",
  "![](Stan_umowy_a_rodzaj_klienta.png)",
  "- Proporcje stanów umowy różnią się w zależności od rodzaju klienta.",
  "",
  "### Rozkład Liczby Wniosków w Czasie",
  "![](Rozklad_liczby_wnioskow_w_czasie.png)",
  "- Najwięcej wniosków jest składanych w godzinach popołudniowych.",
  "",
  "### Liczba Wniosków w Czasie (Dzień Decyzji)",
  "![](Liczba_wnioskow_w_czasie.png)",
  "- Liczba wniosków zmienia się w zależności od dnia, wskazując na różnorodne trendy.",
  "",
  "### Kwota Kredytu w Zależności od Celu Kredytu",
  "![](Kwota_kredytu_w_zaleznosci_od_celu_kredytu.png)",
  "- Kredyty na budowę domu lub zakup nieruchomości charakteryzują się najwyższymi kwotami.",
  "",
  "### Rozkład Liczby Rat w Podziale na Kategorię Produktu",
  "![](Rozklad_liczby_rat_kategoria_produktu.png)",
  "- Liczba rat różni się w zależności od kategorii produktu. Najwięcej rat przypada na produkty hipoteczne.",
  "",
  "Każda wizualizacja została zapisana w formacie `.png` i może być wykorzystywana do dalszej analizy i prezentacji wyników."
)


start_line <- grep("⭐ 3\\. Wizualizacja Danych", rmd_content)
end_line <- grep("⭐ 4\\.", rmd_content) - 1


if (length(start_line) > 0 && length(end_line) > 0) {
  rmd_content <- c(
    rmd_content[1:(start_line - 1)],
    new_section_3,
    rmd_content[(end_line + 1):length(rmd_content)]
  )
}

# Zapisujemy plik
writeLines(rmd_content, file_path)

cat("Sekcja 3 została zaktualizowana i zapisano zmodyfikowany plik Rmd.")




file_path <- file.choose()


if (!file.exists(file_path)) {
  stop("Wybrany plik nie istnieje!")
}

rmd_content <- readLines(file_path)

#Wpisujemy sekcje 4
new_section_4 <- c(
  "⭐ 4. Analiza Opisowa",
  "",
  "W tej sekcji przedstawiono analizę danych w oparciu o różne zmienne opisowe i ilościowe.",
  "",
  "### 4.1 Boxplot: Wnioskowana Kwota (log10)",
  "",
  "Poniżej przedstawiono boxplot dla wnioskowanej kwoty z wykorzystaniem skali logarytmicznej.",
  "",
  "![Boxplot Wnioskowana Kwota](Boxplot_Wnioskowana_Kwota_Log10.png)",
  "- Wykres przedstawia rozkład wnioskowanej kwoty w skali logarytmicznej.",
  "- Widoczna jest obecność wartości odstających w górnym zakresie kwot.",
  "",
  "### 4.2 Macierz Korelacji",
  "",
  "Wykres przedstawia macierz korelacji pomiędzy zmiennymi numerycznymi w zbiorze danych.",
  "",
  "![Macierz Korelacji](Macierz_Korelacji_ggplot.png)",
  "- Wykres pokazuje relacje między zmiennymi numerycznymi w danych.",
  "- Silne korelacje mogą sugerować redundancję zmiennych lub istotne relacje.",
  "",
  "### 4.3 Obserwacje na Podstawie Analizy Opisowej",
  "",
  "- **Macierz Korelacji**: Wskazuje na potencjalne powiązania między zmiennymi, które mogą być istotne dla dalszych analiz.",
  "- **Boxplot Wnioskowanej Kwoty**: Rozkład wskazuje na obecność wartości odstających w górnym zakresie, co może mieć wpływ na analizy statystyczne.",
  "",
  "### 4.4 Wnioski i Sugestie",
  "",
  "- Większość wniosków dotyczy umiarkowanych kwot, ale widoczne są wartości odstające w górnym zakresie.",
  "- Silne korelacje między zmiennymi numerycznymi mogą sugerować redundancję lub istotne relacje, które należy uwzględnić w dalszych analizach.",
  ""
)


start_line <- grep("⭐ 4\\. Analiza Opisowa", rmd_content)
end_line <- grep("⭐ 5\\.", rmd_content) - 1


if (length(start_line) > 0 && length(end_line) > 0) {
  rmd_content <- c(
    rmd_content[1:(start_line - 1)],
    new_section_4,
    rmd_content[(end_line + 1):length(rmd_content)]
  )
} else {
 
  rmd_content <- c(rmd_content, new_section_4)
}

# Zapisujemy
writeLines(rmd_content, file_path)

cat("Sekcja 4 została zaktualizowana i zapisano zmodyfikowany plik Rmd.")



file_path <- file.choose()


if (!file.exists(file_path)) {
  stop("Wybrany plik nie istnieje!")
}

# Wczytamy dane z raportu
rmd_content <- readLines(file_path)


yaml_start <- grep("^---", rmd_content)[1]
yaml_end <- grep("^---", rmd_content)[2]

if (is.na(yaml_start) || is.na(yaml_end)) {
  stop("Nagłówek YAML nie został znaleziony!")
}


yaml_content <- rmd_content[(yaml_start + 1):(yaml_end - 1)]


yaml_content <- sub("^title:.*", "title: \"<h1 style='font-size:40px;'>Raport Analizy Danych - Projekt Zespołowy 2024-2025</h1>\"", yaml_content)
yaml_content <- sub("^author:.*", "author:", yaml_content)
author_lines <- grep("^  - .*", yaml_content)

# Aktualizacja autorów
if (length(author_lines) > 0) {
  yaml_content <- yaml_content[-author_lines]
}
new_authors <- c(
  "  - \"<h2 style='font-size:30px;'>Yuliya Sharkova</h2>\"",
  "  - \"<h2 style='font-size:30px;'>Michał Owczarek</h2>\"",
  "  - \"<h2 style='font-size:30px;'>Aleksander Urbański</h2>\""
)
yaml_content <- append(yaml_content, new_authors, after = grep("^author:.*", yaml_content))


new_yaml <- c("---", yaml_content, "---")

rmd_content <- c(new_yaml, rmd_content[(yaml_end + 1):length(rmd_content)])

# Zapisujemy
writeLines(rmd_content, file_path)

cat("Nagłówek YAML został zmieniony w pliku:", file_path, "\n")





# Renderowanie raportu do HTML i otwarcie w przeglądarce
install.packages("rmarkdown") 
library(rmarkdown)

output_file <- render(file_path, output_format = "html_document")
browseURL(output_file)
