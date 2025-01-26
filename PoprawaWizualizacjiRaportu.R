# Wybieramy plik README
file_path <- file.choose() 

# Wczytamy ten plik README.md
readme_content <- readLines(file_path)

# Dodamy stylizowane sekcje do Markdown, library rmarkdown
library(rmarkdown)

# Dodamy style kolorowe i sekcje do Markdown
modified_content <- c(
  "<!-- Poprawa stylizacji naszego raportu -->",
  "<style>",
  "h1 { color: purple; font-size: 28px; font-weight: bold; }",
  "h2 { color: purple; font-size: 24px; font-weight: bold; }",
  "h3 { color: darkgreen; font-size: 20px; font-weight: bold; }",
  "p { color: black; font-size: 16px; }",
  "span.red { color: purple; font-weight: bold; }",
  "span.teal { color: darkgreen; font-style: italic; }",
  "</style>",
  "",
  "# Raport: <span class='teal'>Projekt zespołowy. Analiza bazy informacji kredytowej.</span>",
  "",
  "## <span style='color:darkgreen;'>Autorzy:</span>",
  "",
  "- <span class='darkgreen'>Yuliya Sharkova</span>",
  "- <span class='darkgreen'>Michał Owczarek</span>",
  "- <span class='darkgreen'>Aleksander Urbański</span>",
  "",
  "## 1. Wprowadzenie",
  "",
  "Analiza danych odgrywa fundamentalną rolę w realizacji projektów opartych na danych.",
  "",
  "Niniejszy raport koncentruje się na obróbce historycznych danych dotyczących wniosków kredytowych.",
  "",
  "Proces ten obejmuje:",
  "- <span style='color:green;'>oczyszczanie</span>",
  "- <span style='color:purple;'>analizę</span>",
  "- <span style='color:orange;'>wizualizację</span>",
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
  "## 2. Data Cleansing. Wrangling",
  "",
  "### 2.1. Analiza braków",
  "",
  "- Zidentyfikowano brakujące dane w kilku kolumnach, uwzględniając ich liczbę i procent.",
  "- Skupiono się na kolumnach z największą liczbą braków.",
  "",
  "### 2.2. Naprawa braków w danych",
  "",
  "- Braki w danych liczbowych uzupełniono medianą.",
  "- Braki w danych kategorycznych uzupełniono trybem.",
  "",
  "### 2.3. Walidacja danych",
  "",
  "- Walidacja potwierdziła brak brakujących danych.",
  "",
  "## 3. Wizualizacja Danych",
  "",
  "### Rozkład Wnioskowanej Kwoty",
  "",
  "![Wykres](Rozklad_wnioskowanej_kwoty.png)",
  "",
  "### Rozkład Kwoty Kredytu",
  "",
  "![Wykres](Rozklad_kwoty_kredytu.png)",
  "",
  "### Zależność Między Wnioskowaną Kwotą a Kwotą Kredytu",
  "",
  "![Wykres](Zaleznosc_wnioskowana_kwota_kwota_kredytu.png)",
  "",
  "## 4. Analiza Opisowa",
  "",
  "Poniżej przedstawiono kluczowe obserwacje na podstawie analizy danych:",
  "- Większość wniosków dotyczy umiarkowanych kwot, ale widoczne są wartości odstające.",
  "- Silne korelacje między zmiennymi mogą sugerować istotne relacje w danych.",
  "",
  "## 5. Wnioski Końcowe",
  "",
  "- Kredyty gotówkowe dominują w przypadku mniejszych wniosków.",
  "- Kredyty konsumenckie są częściej używane do większych inwestycji.",
  "",
  "### Potencjalne działania",
  "",
  "- Skupić się na analizie przyczyn odrzucania wniosków kredytowych.",
  "- Ocenić efektywność polityki banku w kontekście klientów i celów kredytowych.",
  "",
  readme_content 
)

#Nowa nazwa pliku z raportem
new_file_path <- "README_short_colored.md"

# Zapisujemy zmodyfikowaną zawartość do nowego pliku
writeLines(modified_content, new_file_path)

# Komunikat
cat("Zapisano zmodyfikowany plik jako:", new_file_path)

