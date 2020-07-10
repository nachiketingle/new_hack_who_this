import json

with open('../words_original.json') as json_file:
    data = json.load(json_file)
    f= open("worlds.json", "a")
    f.write(json.dumps(list(data.keys())))
    f.close()
