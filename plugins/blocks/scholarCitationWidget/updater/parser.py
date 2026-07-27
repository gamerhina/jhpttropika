import re
import time
import requests
from bs4 import BeautifulSoup

def parse_with_bs4(scholar_id):
    url = f"https://scholar.google.com/citations?user={scholar_id}&hl=en"
    headers = {
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/115.0.0.0 Safari/537.36"
    }
    
    response = requests.get(url, headers=headers, timeout=15)
    if response.status_code != 200:
        raise Exception(f"Failed to fetch Google Scholar page. Status code: {response.status_code}")
        
    soup = BeautifulSoup(response.text, "html.parser")
    
    # 1. Profile Name
    name_el = soup.find(id="gsc_prf_in")
    if not name_el:
        raise Exception("Invalid Scholar ID or profile page format.")
    name = name_el.text.strip()
    
    # 2. Stats Table (Citations, h-index, i10-index)
    stats_table = soup.find(id="gsc_rsb_st")
    if not stats_table:
        raise Exception("Stats table not found.")
        
    stds = stats_table.find_all(class_="gsc_rsb_std")
    if len(stds) < 6:
        raise Exception("Could not parse stats table columns.")
        
    citations = int(stds[0].text.replace(",", "").strip())
    h_index = int(stds[2].text.strip())
    i10_index = int(stds[4].text.strip())
    
    # 3. Chart History
    chart = []
    # Years are inside elements with class gsc_g_t
    years_el = soup.find_all(class_="gsc_g_t")
    # Values are inside elements with class gsc_g_a
    values_el = soup.find_all(class_="gsc_g_a")
    
    # Google Scholar matches years and values by style index or position.
    # Often, gsc_g_a has a style 'z-index: X' which maps to the index of gsc_g_t.
    # Let's map them carefully.
    years = [int(y.text.strip()) for y in years_el]
    
    # Initialize all parsed years with 0 citations
    year_map = {year: 0 for year in years}
    
    for val_el in values_el:
        # Check style attribute for index e.g., z-index: 9
        style = val_el.get("style", "")
        z_index_match = re.search(r"z-index\s*:\s*(\d+)", style)
        val_span = val_el.find(class_="gsc_g_al") or val_el.find("span")
        
        if z_index_match and val_span:
            idx = len(years) - int(z_index_match.group(1))
            if 0 <= idx < len(years):
                val_text = val_span.text.strip()
                if val_text.isdigit():
                    year_map[years[idx]] = int(val_text)
                    
    # Format chart output sorted by year
    for y in sorted(year_map.keys()):
        chart.append({
            "year": y,
            "citations": year_map[y]
        })
        
    return {
        "profile": {
            "name": name,
            "scholarId": scholar_id,
            "url": url
        },
        "metrics": {
            "citations": citations,
            "hindex": h_index,
            "i10index": i10_index
        },
        "chart": chart
    }

def parse_with_selenium(scholar_id):
    # Fallback method using Selenium
    from selenium import webdriver
    from selenium.webdriver.chrome.options import Options
    from selenium.webdriver.chrome.service import Service
    from webdriver_manager.chrome import ChromeDriverManager
    
    url = f"https://scholar.google.com/citations?user={scholar_id}&hl=en"
    
    chrome_options = Options()
    chrome_options.add_argument("--headless")
    chrome_options.add_argument("--disable-gpu")
    chrome_options.add_argument("--no-sandbox")
    chrome_options.add_argument("--window-size=1920,1080")
    chrome_options.add_argument("user-agent=Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/115.0.0.0 Safari/537.36")
    
    driver = webdriver.Chrome(service=Service(ChromeDriverManager().install()), options=chrome_options)
    
    try:
        driver.get(url)
        time.sleep(3) # Wait for page load
        
        html = driver.page_source
        soup = BeautifulSoup(html, "html.parser")
        
        name_el = soup.find(id="gsc_prf_in")
        if not name_el:
            raise Exception("Invalid Scholar ID or profile page format.")
        name = name_el.text.strip()
        
        stats_table = soup.find(id="gsc_rsb_st")
        if not stats_table:
            raise Exception("Stats table not found.")
            
        stds = stats_table.find_all(class_="gsc_rsb_std")
        citations = int(stds[0].text.replace(",", "").strip())
        h_index = int(stds[2].text.strip())
        i10_index = int(stds[4].text.strip())
        
        chart = []
        years_el = soup.find_all(class_="gsc_g_t")
        values_el = soup.find_all(class_="gsc_g_a")
        
        years = [int(y.text.strip()) for y in years_el]
        year_map = {year: 0 for year in years}
        
        for val_el in values_el:
            style = val_el.get("style", "")
            z_index_match = re.search(r"z-index\s*:\s*(\d+)", style)
            val_span = val_el.find(class_="gsc_g_al") or val_el.find("span")
            
            if z_index_match and val_span:
                idx = len(years) - int(z_index_match.group(1))
                if 0 <= idx < len(years):
                    val_text = val_span.text.strip()
                    if val_text.isdigit():
                        year_map[years[idx]] = int(val_text)
                        
        for y in sorted(year_map.keys()):
            chart.append({
                "year": y,
                "citations": year_map[y]
            })
            
        return {
            "profile": {
                "name": name,
                "scholarId": scholar_id,
                "url": url
            },
            "metrics": {
                "citations": citations,
                "hindex": h_index,
                "i10index": i10_index
            },
            "chart": chart
        }
    finally:
        driver.quit()
