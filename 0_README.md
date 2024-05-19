Data_analysis_project
Projekt analizy danych na podstawie oferty pracy w IT na pracuj.pl
Projekt ma na celu pokazanie umiejętności w 4 etapach:

1. Scrapowanie danych odnośnie ogłoszeń It ze strony pracuj.pl przy pomocy specjalnie napisanego w pythonie skryptu z użyciem biblioteki bs4.

2. Czyszczenie danych w MySQL.

3. Przeanalizowanie danych w MySQL odpowiedź na pytania:
   - Na jakie specjalizacje jest najwięcej ogłoszeń?
   - W jakich specjalizacjach jest największe zapotrzebowanie na Juniorów?
   - Jak wygląda rozkład wymiarów pracy?
   - Jak wygląda rozkład poziomu stanowisk?
   - Jak wygląda rozkład typów umowy
   - Dotyczące tylko specjalizacji Data Science / BI:
       - W jakich lokalizacjach jest największe zapotrzebowanie?
       - Jak wygląda podział na tryb pracy?
       - Jak wygląda podział na poziomy stanowisk?
       - Jak wygląda podział na wymiary pracy?
       - Jak wygląda podział na typy umów?

4. Wizualizacja przy pomocy Power BI Desktop.

W repozytorium znajdują się następujące pliki:
- Screeny z queries odpowiadających na zadane wyżej pytania
- Kod scrapera danych w pythonie
- Stworzony przez skrypt plik csv ze wszystkimi ogłoszeniami IT z pracuj.pl
- Pliki SQL z queries których użyłem osobno do czyszczenia jak i przeanalizowania uzyskanych danych
- plik Power BI z dwoma pageami, pierwszy to wizualizacja analizy ogółu ogłoszeń, druga konkretnie dla ogłoszeń w obrębie specjalizacji Data Science / BI

