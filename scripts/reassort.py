import sys

def reassort(file1,file2, out_name):
    with open(file1, "r") as f:
        ha_set = set(f.readline().split(','))
    with open(file2, "r") as f2:
        na_set = set(f2.readline().split(','))

    res = list(ha_set & na_set)

    with open(out_name, "w") as outfile:
        outfile.write(str(res))

def main():
    file1 = sys.argv[1]
    file2 = sys.argv[2]
    out_name = sys.argv[3]
    reassort(file1,file2, out_name)

if __name__ == "__main__":
    main()
