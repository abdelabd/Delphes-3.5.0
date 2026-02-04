import os
import uproot
import matplotlib.pyplot as plt
import numpy as np
import os

def main():
    # Define the path to the ROOT file
    fpath = "./HZZ4l_1k_benchmark.root"
    root_file = uproot.open(fpath)
    tree = root_file["Delphes;1"]
    print(f"tree.keys(): {tree.keys()}")




if __name__ == "__main__":
    main()