import requests
from bs4 import BeautifulSoup
import csv


base_url = 'https://it.pracuj.pl/praca'
response = requests.get(base_url)
soup = BeautifulSoup(response.content, 'html.parser')
max_page_number = int(soup.find('span', attrs={'data-test': 'top-pagination-max-page-number'}).text)

with open('counts.csv', 'w', newline='') as csvfile:
    writer = csv.writer(csvfile, delimiter=';')
    writer.writerow(['Location', 'Specializaion', 'Position_level', 'Contract_type', 'Work_schedule', 'Work_modes'])

for page_number in range(1, max_page_number + 1):
   
    url = f'{base_url}?pn={page_number}'
    print(f"Scraping page {page_number}...")
    response = requests.get(url)
    soup = BeautifulSoup(response.content, 'html.parser')
    offer_links = soup.find_all('a', attrs={'data-test': 'link-offer'})

    for link in offer_links:
        offer_url = link['href']
        offer_response = requests.get(offer_url)
        offer_soup = BeautifulSoup(offer_response.content, 'html.parser')

        if offer_soup.find('div', attrs={'data-test': 'text-benefit'}) is None:
            benefit_location_text = ''
        else:
            benefit_location_text = offer_soup.find('div', attrs={'data-test': 'text-benefit'}).get_text()

        if offer_soup.find('div', attrs={'data-test': 'sections-benefit-contracts-text'}) is None:
            benefit_contracts_text = ''
        else:
            benefit_contracts_text = offer_soup.find('div', attrs={'data-test': 'sections-benefit-contracts-text'}).get_text()

        if offer_soup.find('div', attrs={'data-test': 'sections-benefit-work-schedule-text'}) is None:
            benefit_work_schedule_text = ''
        else:
            benefit_work_schedule_text = offer_soup.find('div', attrs={'data-test': 'sections-benefit-work-schedule-text'}).get_text()

        if offer_soup.find('div', attrs={'data-test': 'sections-benefit-employment-type-name-text'}) is None:
            benefit_position_level_text = ''
        else:
            benefit_position_level_text = offer_soup.find('div', attrs={'data-test': 'sections-benefit-employment-type-name-text'}).get_text()

        if offer_soup.find('div', attrs={'data-test': 'sections-benefit-work-modes-text'}) is None:
            benefit_work_modes_text = ''
        else:
            benefit_work_modes_text = offer_soup.find('div', attrs={'data-test': 'sections-benefit-work-modes-text'}).get_text()

        if offer_soup.find('li', attrs={'data-test': 'it-specializations'}) is None:
            it_specialization_text = ''
        else:
            it_specialization_text = offer_soup.find('li', attrs={'data-test': 'it-specializations'}).get_text()

        with open('counts.csv', 'a', newline='') as csvfile:
            writer = csv.writer(csvfile, delimiter=';')
            writer.writerow([benefit_location_text, it_specialization_text, benefit_position_level_text, benefit_contracts_text, benefit_work_schedule_text, benefit_work_modes_text])

    
print("data written to counts.csv file.")
