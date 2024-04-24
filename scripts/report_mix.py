import sys

def mix_finder(file, out_name):
    with open(file, "r") as f:
        lines = f.readlines()
        try:
            if len(lines) == 0:
                raise Exception('There is no IAV reads')
            else:
                viral_list = []
                for line in lines:
                    type = line.split('=')[5].split("_")[0]
                    if type != 'NA':
                        viral_list.append(type)
                with open(out_name, "w") as outfile:
                    for i in range(len(viral_list)):
                        if i == (len(viral_list)-1):
                            outfile.write(viral_list[i])
                        else:
                            outfile.write(viral_list[i] + ',')
        except:
            pass

def main():
    fasta = sys.argv[1]
    out_name = sys.argv[2]
    mix_finder(fasta, out_name)


if __name__ == "__main__":
    main()
