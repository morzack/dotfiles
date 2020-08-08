import requests
import json
import time

class Song:
    def __init__(self):
        '''you really need to use "get_current_song"'''
        self.title = ""
        self.artist = ""
        self.circle = ""
        self.album = ""
        self.year = ""
        self.art_url = ""
        self.rating = 0
        self.start_time = 0
        self.end_time = 0
    
    def get_times(self):
        '''get important time data (duration, current_position, time_remaining)'''
        current_time = time.time()
        return (self.end_time-self.start_time, int(current_time-self.start_time), self.end_time-current_time)
    
    def __str__(self):
        duration, current_time, _ = self.get_times()
        return f"{self.title} | {self.artist} | {self.album} ... 0s -> {current_time}s -> {duration}s ... {self.rating}*"

def get_mins_seconds(time_in):
    '''get (minutes, seconds) from a given number of seconds'''
    return (time_in//60, time_in%60)

def get_current_song():
    response = requests.get("https://gensokyoradio.net/json/")
    if response.status_code != 200:
        # heck
        return Song()
    json_data = json.loads(response.content)

    song = Song()

    get_if_present = lambda arr, field, default: arr[field] if field in arr else default
    
    if "SONGINFO" in json_data:
        song_info = json_data["SONGINFO"]
        song.title = get_if_present(song_info, "TITLE", "")
        song.artist = get_if_present(song_info, "ARTIST", "")
        song.circle = get_if_present(song_info, "CIRCLE", "")
        song.album = get_if_present(song_info, "ALBUM", "")
        song.year = get_if_present(song_info, "YEAR", "")
    if "SONGTIMES" in json_data:
        song_times = json_data["SONGTIMES"]
        song.start_time = int(get_if_present(song_times, "SONGSTART", 0))
        song.end_time = int(get_if_present(song_times, "SONGEND", 0))
    if "SONGDATA" in json_data:
        song_data = json_data["SONGDATA"]
        song.rating = float(get_if_present(song_data, "RATING", 0))
    if "MISC" in json_data:
        misc_info = json_data["MISC"]
        song.art_url = get_if_present(misc_info, "ALBUMART", "")

    return song