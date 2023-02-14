#!/usr/bin/env python3
'''This program downloads wallpaper'''
import argparse, asyncio, datetime, sys
import httpx
from pathlib import Path

TODAY = datetime.date.today()
SEARCH_URL = 'https://wallhaven.cc/api/v1/search'
WALLPAPER_PATH = Path.home() / 'Pictures' / 'wallpapers' / TODAY.strftime('%b_%d').lower()

async def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description='Wallpaper downloader')
    parser.add_argument('query', nargs='*', help='Wallpapers to search for')
    args = parser.parse_args(argv)

    wallpaper_links = get_wallpaper_links(' '.join(args.query))
    WALLPAPER_PATH.mkdir(parents=True, exist_ok=True)

    async with httpx.AsyncClient() as client:
        tasks = [ asyncio.create_task(download_wallpaper(client, link)) 
                for link in wallpaper_links ]

        await asyncio.gather(*tasks)

    return 0

def get_wallpaper_links(query: str) -> list[str]:
    params = { 'q': query }
    try: 
        response = httpx.get(SEARCH_URL, params=params)
        response.raise_for_status()
    except Exception as error:
        print('Could not request for wallpaper links', file=sys.stderr)
        print(error)
        sys.exit(1)

    response_json = response.json()
    return [ wallpaper['path'] for wallpaper in response_json['data'] ]

async def download_wallpaper(client: httpx.AsyncClient, link: str) -> None:
    try:
        response = await client.get(link)
        response.raise_for_status()
    except Exception as error:
        print(f'Could not download image from {link}', file=sys.stderr)
        print(error)
        return
    
    filename = Path(link).name
    print(f'Downloading file -> {filename}')
    with open(WALLPAPER_PATH / filename, 'wb') as f:
        f.write(response.content)

if __name__ == '__main__':
    raise SystemExit(asyncio.run(main()))

