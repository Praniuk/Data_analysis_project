import requests
from bs4 import BeautifulSoup
import csv

# URL of the page to scrape
base_url = 'https://it.pracuj.pl/praca'

# Send a GET request to the base URL
response = requests.get(base_url)

# Parse the HTML content using BeautifulSoup
soup = BeautifulSoup(response.content, 'html.parser')

# Find the maximum page number
max_page_number = int(soup.find('span', attrs={'data-test': 'top-pagination-max-page-number'}).text)



with open('counts.csv', 'w', newline='') as csvfile:
    writer = csv.writer(csvfile, delimiter=';')
    writer.writerow(['Location', 'Specializaion', 'Position_level', 'Contract_type', 'Work_schedule', 'Work_modes'])

# Iterate over each page
for page_number in range(1, max_page_number + 1):
    # Construct the URL for the current page
    url = f'{base_url}?pn={page_number}'

    print(f"Scraping page {page_number}...")

    # Send a GET request to the URL
    response = requests.get(url)

    # Parse the HTML content using BeautifulSoup
    soup = BeautifulSoup(response.content, 'html.parser')

    # Find all <a> tags with 'data-test' attribute equal to 'link-offer'
    offer_links = soup.find_all('a', attrs={'data-test': 'link-offer'})

    # Iterate over each offer link
    for link in offer_links:
        offer_url = link['href']

        # Send a GET request to the offer URL
        offer_response = requests.get(offer_url)

        # Parse the HTML content of the offer page
        offer_soup = BeautifulSoup(offer_response.content, 'html.parser')

        # Find the element with 'data-test' attribute equal to 'sections-benefit-contracts-text'
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