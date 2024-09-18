import sys
from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC

# Check if the URL was passed as an argument
if len(sys.argv) != 2:
    print("Usage: python3 xss_execution_check.py <url_with_payload>")
    sys.exit(1)

# The URL with the payload
test_url = sys.argv[1]
# Set up the ChromeDriver path
chrome_service = Service('/usr/bin/chromedriver')  # Adjust this path as needed

# Set up Chrome options for headless operation
chrome_options = Options()
chrome_options.add_argument("--headless")
chrome_options.add_argument("--disable-gpu")
chrome_options.add_argument("--no-sandbox")

# Create the WebDriver instance
driver = webdriver.Chrome(service=chrome_service, options=chrome_options)

# Test if the payload executes in the browser
try:
    driver.get(test_url)

    # Wait for the alert to be present
    try:
        WebDriverWait(driver, 5).until(EC.alert_is_present())
        alert = driver.switch_to.alert
        print(f"XSS Payload executed: {test_url}")
        alert.accept()  # Close the alert
    except Exception as e:
        pass

finally:
    driver.quit()  # Close the browser instance
