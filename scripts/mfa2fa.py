import sys

def parse_fasta(file_path):
    sequences = {}
    current_header = None
    current_sequence = ""
    num = 0
    with open(file_path, "r") as f:
        for line in f:
            line = line.strip()
            if line.startswith(">"):
                num += 1
                if current_header is not None:
                    sequences[current_header] = current_sequence
                current_header = "SAMPLE_" + line[1:].strip()
                current_sequence = ""
            else:
                current_sequence += line

    if current_header is not None:
        sequences[current_header] = current_sequence
    try:
        if len(list(sequences.keys())) != 8:
            raise Exception('The number of sequences does not match the number of IAV segments (eight).')
        else:
            return sequences
    except Exception as e:
        print(f'ERROR: {e}')

#print(parse_fasta("multifasta.fa"))

def write_fasta(sequence, output_file):
    with open(output_file, "w") as f:
        for header, seq in sequence.items():
            f.write(">" + str(header) + "\n")
            f.write(seq + "\n")


def split_multifasta(input_file):
    sequences = parse_fasta(input_file)
    keys = list(sequences.keys())
    l = ["_1.PB2", "_2.PB1", "_3.PA", "_4.HA", "_5.NP", "_6.NA", "_7.M1M2", "_8.NS1"]
    for i in range(len(keys)):
        output_file = "SAMPLE_"+input_file.split("/")[-1].split(".")[0]+l[i] + ".fa"

        write_fasta({keys[i]: sequences[keys[i]]}, output_file)

def main():
    multifasta = sys.argv[1]
    split_multifasta(multifasta)

if __name__ == "__main__":
    main()
