import math
import random
import matplotlib.pyplot as plt
import os
import pandas as pd
import subprocess
from tqdm import tqdm
import re


def simulation_setup(keyFilePath, year, num_cycles, simulation_series):
    sim_dict = {"unthinned": "UNTHINNED CONTROL", "thin": "THINDBH"}
    num_cycles = str(int(num_cycles) * 1.0)
    keyFile = open(keyFilePath, 'w')
    keyFile.write('SCREEN\n')
    keyFile.write('STATS\n')

    # The STDIDENT keyword record allows you to assign an identification code to a stand.
    # None of the keyword parameter fields are used, but one supplemental data record is
    # required. This supplemental record contains the stand identification (such as S248112
    # shown below) in columns l-26. This ID appears with every output table in the main
    # output file. The remainder of the columns, up through column 80 can be used to transmit
    # a “title” which will also be reproduced at the beginning of each output table.
    keyFile.write('STDIDENT\n')
    keyFile.write(
        'simulation type: ' + " ".join(simulation_series) + ', start year: ' + str(year) + ', cycles = ' + str(
            num_cycles) + '\n')
    keyFile.write('DESIGN                                               \n')
    #     # Location Code       Location
    # `   # 505                 Klamath National Forest
    #     # 506                 Lassen National Forest
    #     # 508                 Mendocino National Forest
    #     # 511                 Plumas National Forest
    #     # 514                 Shasta-Trinity National Forest
    #     # 610                 Rogue River National Forest
    #     # 611                 Siskiyou National Forest
    #     # 518                 Trinity National Forest (mapped to 514)
    #     # 710                 BLM Roseburg ADU
    #     # 711                 BLM Medford ADU
    #     # 712                 BLM Coos Bay ADU`
    keyFile.write('STDINFO     508\n')
    keyFile.write('INVYEAR        ' + str(year) + '\n')
    keyFile.write('NUMCYCLE        ' + str(num_cycles) + '\n')
    for index, simulation in enumerate(simulation_series):
        if simulation == "thin":
            keyFile.write('THINDBH   ' + str(((
                                                  index) * 10) + year) + '.     ' + '5.        ' + '20.       ' + '1.        ' + 'ALL       ' + '10.       0.' + '\n')
    # if simulation_series == "thin":
    #     #In year 2038, the first THINDBH would leave 10 trees per acre of whatever species are in the stand which are greater than, or equal to, 5.0 inches in diameter and less than 20.0 inches in diameter.
    #     keyFile.write('THINDBH   ' + '2038.     ' + '5.        '+ '20.       ' + '1.        ' + 'ALL       ' + '10.       0.' + '\n')
    keyFile.write('TREEFMT\n')

    # Below is FORTRAN code that specifices the format which the keyfile takes. In particular,
    # I4: Integer format with 4 characters.
    # T1: A space (tab) format with 1 character.
    # I7: Integer format with 7 characters.
    # F6.0: Floating-point format with 6 characters and 0 decimal places (essentially an integer format).
    # I1: Integer format with 1 character.
    # A3: Alphanumeric format with 3 characters (used for strings).
    # F4.1: Floating-point format with 4 characters and 1 decimal place.
    # F3.1: Floating-point format with 3 characters and 1 decimal place.
    # 2F3.0: Two floating-point values, each with 3 characters and 0 decimal places.
    # F4.1: Floating-point format with 4 characters and 1 decimal place.
    # I1: Integer format with 1 character.
    # 6I2: Six integer values, each with 2 characters.
    # 2I1: Two integer values, each with 1 character.
    # I2: Integer format with 2 characters.
    # 2I3: Two integer values, each with 3 characters.
    # 2I1: Two integer values, each with 1 character.
    # F3.0: Floating-point format with 3 characters and 0 decimal places.

    keyFile.write('(I4,T1,I7,F6.0,I1,A3,F4.1,F3.1,2F3.0,F4.1,I1,\n')
    keyFile.write('6I2,2I1,I2,2I3,2I1,F3.0) \n')

    # From FVS Documentation:
    # One option is to enter the tree records as supplemental data records for the TREEDATA
    # keyword record. In this case, the dataset reference number (field 1) should be assigned
    # the logical unit number for record input at the computer installation (logical unit 15 on
    # most systems) and a special record containing the data value –999 must be added to the
    # end of the tree record file.
    keyFile.write('TREEDATA  15.0\n')

    # Note that we are not closing keyFile since we append to it later.
    return keyFile


def run_simulation(dataframePath, keyFile):
    trees_dataframe = pd.read_excel(dataframePath)
    for index, row in trees_dataframe.head(2999).iterrows():
        Plot = '    ' if pd.isna(row['Plot']) else str(row['Plot']) + (' ' * (4 - len(str(row['Plot']))))
        TreeID = '   ' if pd.isna(row['TreeID']) else str(row['TreeID']) + (' ' * (3 - len(str(row['TreeID']))))
        TreeCount = str(1) + (' ' * 5)
        TreeHistory = ' '
        Species = str(row['FieldSP']) + (' ' * (3 - len(str(row['FieldSP'])))) + (' ' * (3 - len(str(row['FieldSP']))))

        DBH = '    ' if pd.isna(row['DBH']) else str(math.trunc(10 * round(row['DBH'], 1))) + (
                    ' ' * (4 - len(str(math.trunc(10 * round(row['DBH'], 1))))))
        DBHincrement = '   '
        TotalHeight = '   ' if pd.isna(row['TotalHt']) else str(math.trunc(round(row['TotalHt'], 0))) + (
                    ' ' * (3 - len(str(math.trunc(round(row['TotalHt'], 0))))))

        TopKill = '   '
        HeightIncrement = '    '

        # If cratio doesn't exist in row, set it blank
        CrownRatioCode = ' ' if pd.isna(row['Cratio']) else str(min(9, math.trunc(int(row['Cratio']) / 10 + 1)))
        inputString = ''
        inputString += (
                    Plot + TreeID + TreeCount + TreeHistory + Species + DBH + DBHincrement + TotalHeight + TopKill + HeightIncrement + CrownRatioCode + '  0 0 0 0 0 011\n')
        keyFile.write(inputString)

    keyFile.write('-999\n')
    keyFile.write('ECHOSUM\n')
    keyFile.write('PROCESS\n')
    keyFile.write('STOP\n')
    keyFile.close()

    makefile = open('makefile', 'w')
    makefile.write('all : cat01\n')
    makefile.write('cat01 : \n')

    makefile.write('\t' + './ForestVegetationSimulator-FS2023.1/bin/FVSca --keywordfile=GrowthSim.key\n')

    makefile.close()

    with open(os.devnull, 'w') as devnull:
        # subprocess.Popen("make -f makefile", shell=True)
        subprocess.Popen("make -f makefile", shell=True, stdout=devnull, stderr=devnull)


# create pandas dataframe from .sum file
def process_results(results_path):
    outputFile = open(results_path, 'rb')

    columns = ["Year", "Age", "Start Number of Trees",
               "Start BA", "Start SDI", "Start CCF", "Start Top Height",
               "Start QMD", "Start Total CU Ft", "Start Merch CU Ft", "Start Merch BD Ft",
               "Removals Number of Trees", "Removals Total CU Ft", "Removals Merch CU Ft", "Removals Merch BD Ft",
               "After Treatment BA", "After Treatment SDI", "After Treatment CCF", "After Treatment Top Height",
               "After Treatment RES QMD",
               "Growth Period Years", "Growth ACCRRE Per", "Growth Mort Year",
               "MAI Merch CU FT", "MAI FOR TYP", "MAI SS ZT"]
    data = []
    increment = 0
    with outputFile as file:
        for line in file:
            if increment == 0:
                increment += 1
                continue
            modified_line = re.sub(r'\s+', ' ', str(line)[2:-3].strip())

            values = modified_line.split(' ')  # Split the line into values using spaces
            data.append(values)
    df = pd.DataFrame(data, columns=columns)
    return df

keyFile = simulation_setup('GrowthSim.key', 2018, 20, [])
run_simulation('Redwoods.csv', keyFile)
df = process_results('GrowthSim.sum')
print(df)