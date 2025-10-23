#!/usr/bin/env python3
import json
import sys
from playwright.sync_api import sync_playwright
import requests

FORM_DATA = {
    "familiya": "Никонов",
    "imya": "Никита",
    "otchestvo": "Николаевич",
    "email": "someone@nixos.org",
    "company": "",
    "position": "",
    "phone": "+31 71 452 5670",
    "user_id": "",
    "utm_source": "",
    "utm_medium": "",
    "utm_campaign": "",
    "utm_term": "",
    "utm_content": "",
    "client_referrer": "https://www.google.com/",
    "status-field": "Студент",
    "os-field": "Linux",
    "privacy_policy": "1",
}

def extract_cookies_from_playwright(context):
    """Преобразует куки из формата Playwright в dict для requests"""
    cookies = {}
    for cookie in context.cookies():
        cookies[cookie["name"]] = cookie["value"]
    return cookies

def get_download_url():
    with sync_playwright() as p:
        browser = p.chromium.launch(headless=True)
        context = browser.new_context()
        page = context.new_page()

        # 1. Заходим на страницу загрузки
        page.goto("https://loginom.ru/download")
        page.wait_for_timeout(2000)

        # 2. Получаем secret2
        secret2 = page.evaluate("() => window.secret2")
        if not secret2 or secret2 == "undefined":
            el = page.query_selector('input[name="secret2"]')
            if el:
                secret2 = el.get_attribute("value")
        if not secret2:
            print("❌ Не удалось извлечь secret2", file=sys.stderr)
            browser.close()
            sys.exit(1)
        
        secret1 = page.evaluate("() => window.secret1")
        if not secret2 or secret2 == "undefined":
            el = page.query_selector('input[name="secret1"]')
            if el:
                secret1 = el.get_attribute("value")
        if not secret1:
            print("❌ Не удалось извлечь secret1", file=sys.stderr)
            browser.close()
            sys.exit(1)

        versiya_loginomce = page.evaluate("() => window.versiya_loginomce")
        if not versiya_loginomce or versiya_loginomce == "undefined":
            el = page.query_selector('input[name="versiya_loginomce"]')
            if el:
                versiya_loginomce = el.get_attribute("value")
        if not versiya_loginomce:
            print("❌ Не удалось извлечь версию Loginom CE", file=sys.stderr)
            browser.close()
            sys.exit(1)

        # 3. Извлекаем куки сессии
        cookies = extract_cookies_from_playwright(context)
        browser.close()

    # 4. Создаём сессию requests с куками
    session = requests.Session()
    session.cookies.update(cookies)
    session.headers.update({
        "User-Agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0 Safari/537.36",
        "Referer": "https://loginom.ru/download"
    })

    # 5. Получаем CSRF-токен
    token_resp = session.get("https://loginom.ru/session/token")
    if token_resp.status_code != 200:
        print(f"❌ Не удалось получить CSRF-токен: {token_resp.status_code}", file=sys.stderr)
        sys.exit(1)

    csrf_token = token_resp.text.strip()
    if not csrf_token:
        print("❌ Пустой CSRF-токен", file=sys.stderr)
        sys.exit(1)

    # 6. Подготавливаем данные формы
    form_data = FORM_DATA.copy()
    form_data["secret2"] = secret2
    form_data["secret1"] = secret1
    form_data["versiya_loginomce"] = versiya_loginomce

    # 7. Отправляем запрос на получение ссылки
    resp = session.post(
        "https://loginom.ru/proxy-api/freedownload-request",
        json=form_data,
        headers={
            "X-CSRF-Token": csrf_token,
            "Content-Type": "application/json"
        }
    )

    if resp.status_code not in (200, 102):
        print(f"❌ Ошибка: {resp.status_code} {resp.text}", file=sys.stderr)
        sys.exit(1)
    
    data = resp.json()
    if data.get("code") not in (200, 201):
        print(f"❌ Логическая ошибка API: {data}", file=sys.stderr)
        sys.exit(1)
        
    url_linux = data.get("data", {}).get("loginom_ce_linux")
    url_windows = data.get("data", {}).get("loginom_ce_windows")
    version = versiya_loginomce
    if not url_linux:
        print("❌ Не найдена ссылка на Linux-версию", file=sys.stderr)
        sys.exit(1)

    return url_linux, version, url_windows

def main():
    url_linux, version, url_windows = get_download_url()
    if "--json" in sys.argv:
        print(json.dumps({"linux": url_linux, "windows": url_windows, "version": version}))
    else:
        if "--windows" in sys.argv:
            print(url_windows)
        elif "--linux" in sys.argv:
            print(url_linux)
        else:
            print(f"{url_linux}\n{url_windows}")

if __name__ == "__main__":
    main()
