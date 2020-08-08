import autotheme
import urllib.request
from bs4 import BeautifulSoup
import requests
import re
import random

wallpaper_search_base_url = "https://wallpaperscraft.com/catalog"
wallpaper_download_base_url = "https://images.wallpaperscraft.com/image"

def get_paper_from_id(id, resolution=(1920, 1080), filename="paper.jpg"):
    url = f"{wallpaper_download_base_url}/{id}_{resolution[0]}x{resolution[1]}.jpg"
    # download into temp file
    urllib.request.urlretrieve(url, filename)

def run_themer_wallpaper(filename):
    autotheme.run(filename)

def find_wallpaper_ids_tag(tag, resolution=(1920, 1080), page=1):
    url = f"{wallpaper_search_base_url}/{tag}/{resolution[0]}x{resolution[1]}/page{page}"
    r = requests.get(url)
    data = r.text
    soup = BeautifulSoup(data, 'lxml')
    image_html = soup.findAll("img", {"class": "wallpapers__image"})
    ids = []
    for image in image_html:
        # extract the id from the url
        regex = r"_(?P<id>\d+)_"
        match = re.search(regex, image['src'])
        ids.append(match.group('id'))
    return ids

if __name__ == '__main__':
    max_page = 500
    page = random.randint(1, max_page)
    ids = find_wallpaper_ids_tag("nature", page=page, resolution=(2560, 1440))
    get_paper_from_id(random.choice(ids), filename="/home/reimu/resources/themer/paper.jpg")
    run_themer_wallpaper("/home/reimu/resources/themer/paper.jpg")
