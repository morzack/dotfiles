import os

this_file = "renamer.py"

for f in [f for f in os.listdir() if os.path.isfile(os.path.join("", f))]:
    if f != this_file:
        n = f.split(" - ")
        print("mv {} {}".format(f, n[0]+".jpg"))
        os.system("mv '{}' '{}'".format(f, n[0]+".jpg"))
