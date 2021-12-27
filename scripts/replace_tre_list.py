import os

home = os.path.expanduser('~')
filename = home + '/volumes/zone/Core3/MMOCoreORB/bin/conf/config.lua'

def get_tre_list():
    with open('scripts/tre_list.lua') as f:
        return f.read()

def write_file(result):
    with open(filename, 'w') as f:
        f.write(result)

with open(filename) as f:
    text = f.read()

    part = text.split('\tTreFiles = {')[1]

    before = text.find("TreFiles = {")
    after = part.find('},')

    rest = before + after + 15

    final = text[0: before: 1] + get_tre_list() + text[rest::1]

    write_file(final)
