#!/usr/bin/python3
import subprocess, os, random, glob, time, argparse, re

dirImages = [ ]
timeToWait = 60 * 15
nitrogenConf = './bg-saved.cfg'

def screens():
    output = [l for l in subprocess.check_output(["xrandr"]).decode("utf-8").splitlines()]
    return [l.split()[0] for l in output if " connected " in l]

def getRandomImage():
    folder = random.choice(dirImages)
    if not folder.endswith('/'):
        folder = folder + '/'
    files_list = []
    for root, dirs, files in os.walk(folder):
        for file in files:
            if file.endswith(".jpeg") or file.endswith(".png") or file.endswith(".jpg"):
                files_list.append(os.path.join(root, file))
    return random.choice(files_list)

parser = argparse.ArgumentParser(description="This script automate change wallpaper with nitrogen")
parser.add_argument('-d', '--dirs', action='append', default=dirImages, help="This is a list of all dirs has contains your backgrounds")
parser.add_argument('-t', '--time', default=timeToWait, help="This is a time of wait for next random image")
parser.add_argument('-c', '--config', default=nitrogenConf, help="This is a file path of backups file of nitrogen")

args = parser.parse_args()

if __name__ == '__main__':
    dirImages = args.dirs
    timeToWait = args.time
    nitrogenConf = args.config

    if len(dirImages) > 0:
        while True:
            i = 0
            txtContent = ""
            for screen in screens():
                rndImage = getRandomImage()
                txtContent += "[xin_" + str(i) + "]\n"
                txtContent = txtContent + "file=" + rndImage + "\n"
                txtContent = txtContent + "mode=5\nbgcolor=#6fc6ff\n\n"
                i = i + 1
            with open(nitrogenConf, 'w') as configFile:
                configFile.write(txtContent)
            subprocess.Popen([ 'nitrogen', '--restore' ], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
            time.sleep(timeToWait)
    else:
        parser.error("-d or --dirs is required")
