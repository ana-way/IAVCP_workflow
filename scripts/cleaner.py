import os
files = os.listdir("./")

for item in files:
    if item.endswith(".fasta.uniqueseq.phy"):
        os.remove(item)
