import os
files = os.listdir("./")
print(files)

for item in files:
    if item.endswith(".fasta.uniqueseq.phy"):
        os.remove(item)
