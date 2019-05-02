import time
import os
import random
import sys
import requests

weather_key = "28dd40d6ef0e1812703cd49b302132e2"
location = "35.8114816,-78.7988816"

weather = "clear"

if len(sys.argv) == 1:
    try:
        l = location.split(',')
        url = url = "https://api.openweathermap.org/data/2.5/weather?lat={}&lon={}&appid={}".format(l[0],l[1],weather_key)
        r = requests.get(url)
        w = r.json()["weather"][0]["main"].lower()
        if w in ["clear", "clouds"]:
            weather = "clear"
        else:
            weather = "rain"
    except:
        pass
    
dayInterval = [8, 20] # 8am to 8pm (20:00)
    
bg = "~/resources/backgrounds/"
weeb = bg+"weeb/"
moss = weeb+"moss/"

def m(i):
    return "{}{}.jpg".format(moss, i)

papers = {
        "clear":{
            "night":[
                weeb+"nightskyline1.jpg",
                weeb+"nightskyline2.jpg",
                weeb+"nightskyline3.jpg",
                m(79),
                m(98)],
            "day":[
                weeb+"apartment.png",
                weeb+"forest.jpg",
                weeb+"sakura.jpg",
                m(5),
                m(7),
                m(8),
                m(68),
                m(83),
                m(87),
                m(89)]
            },
        "rain":{
            "night":[
                weeb+"rain.jpg"],
            "day":[
                bg+"ayaforest.jpg",
                bg+"lillies.png"]
            }
        }

if not len(sys.argv) > 1:
    currentHour = time.localtime().tm_hour

    s = papers[weather]["day" if currentHour in range(dayInterval[0], dayInterval[1]) else "night"]

    darkpapers = papers["clear"]["night"]
    lightpapers = papers["clear"]["day"]

    nightThemePaper = random.choice(darkpapers)
    dayThemePaper = random.choice(lightpapers)

    paper = dayThemePaper if currentHour in range(dayInterval[0], dayInterval[1]) else nightThemePaper

    paper = random.choice(s)
else:
    paper = sys.argv[1]

os.system("wal -i {}".format(paper))
os.system("~/resources/run_all_pywal.sh")
