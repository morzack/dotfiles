import os
import re
import random
import sys
import json
import time

def get_papers_in_dir(path):
    paper_regex = r"[\w\W]*\.j*pn*g" # shitty and should be made better
    files = [f for f in os.listdir(path) if os.path.isfile(os.path.join(path, f))]
    return [path+"/"+f for f in files if re.match(paper_regex, f) != None]
    
def get_currently_day(day_start, day_end):
    current_hour = time.localtime().tm_hour
    return current_hour in range(day_start, day_end)

def prune_candidates(candidates, pruning):
    return [i for i in candidates if i.split("/")[-1] not in pruning]

with open("/home/reimu/resources/themer/config.json", 'r') as f:
    config_data = json.load(f)
    path = config_data["papers-path"]
    day_interval = [config_data["day-start"], config_data["day-end"]]
    time_enabled = config_data["time-enabled"]
    day_path = path + config_data["day-dir"]
    night_path = path + config_data["night-dir"]
    excluding = []
    excluding.extend(config_data["day-papers-excluding"])
    excluding.extend(config_data["night-papers-excluding"])

def run(wallpaper_file=""):
    # pick paper
    if wallpaper_file == "":
        paper = ""
        if len(sys.argv) > 1:
            paper = sys.argv[1]
        else:
            paper_candidates = []
            if time_enabled:
                paper_candidates = get_papers_in_dir(day_path if get_currently_day(day_interval[0], day_interval[1]) else night_path)
            else:
                paper_candidates = get_papers_in_dir(day_path)
                paper_candidates.extend(get_papers_in_dir(night_path))
            paper_candidates = prune_candidates(paper_candidates, excluding)
            paper = random.choice(paper_candidates)
    else:
        paper = wallpaper_file

    os.system("wal -c")
    os.system(f"wal -i '{paper}' -b#111111 --saturate 0.8")
    os.system("~/resources/run_all_pywal.sh")

if __name__ == '__main__':
    run()
