#!/bin/python

import argparse
import sys

import song_info

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument(
        '--name',
        help="return song name",
        action="store_true"
    )
    parser.add_argument(
        '--artist',
        help="return artist name",
        action="store_true"
    )
    parser.add_argument(
        '--album',
        help="return album name",
        action="store_true"
    )
    parser.add_argument(
        '--song_times',
        help="get time position in song",
        action="store_true"
    )
    
    args = parser.parse_args()

    song = song_info.get_current_song()

    output = ""

    if args.name:
        output += song.title + " | "
    if args.artist:
        output += song.artist + " | "
    if args.album:
        output += song.album + " | "
    if args.song_times:
        duration, current_time, _ = song.get_times()
        duration_m, duration_s = song_info.get_mins_seconds(duration)
        current_m, current_s = song_info.get_mins_seconds(current_time)
        output += f"{current_m}:{str(current_s).zfill(2)} -> {duration_m}:{str(duration_s).zfill(2)}" + " | "
    
    if output[-3:] == " | ":
        output = output[:-3]

    print(output)