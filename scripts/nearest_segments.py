import sys


def get_names(ind):
    with open(ind, 'r') as ind:
        names = set()
        lines = ind.readlines()
        for line in lines:
            name = line.split("=")[4]
            names.add(name)
        return sorted(names)


def get_nearest_fasta(refs, ids, cons, out_name):
    out = []
    with open(refs, 'r') as ref:

        lines = ref.readlines()
        for j in range(len(lines)):
            ind_names = get_names(ids)
            for i in ind_names:
                if i in lines[j]:
                    out.append(lines[j].replace('=', '_'))
                    out.append(lines[j + 1].upper())
    with open(cons, "r") as c:
        l = c.readlines()
        for k in l:
            out.append(k)
    with open(out_name, "w") as outfile:
        outfile.writelines(out)
    return out



def main():
    reference = sys.argv[1]
    ids = sys.argv[2]
    cons = sys.argv[3]
    out_name = sys.argv[4]
    get_nearest_fasta(reference, ids, cons,out_name)


if __name__ == "__main__":
    main()
