import math
import matplotlib.pyplot as plt
import os
import pandas as pd
import subprocess
from tqdm import tqdm

def simulation_setup(filepath, year, num_cycles, simulation_type):
    sim_dict = {"unthinned" : "UNTHINNED CONTROL", "thin" : "THINDBH"}
    num_cycles = str(int(num_cycles) * 1.0)
    keyFile = open(filepath, 'w')
    keyFile.write('SCREEN\n')
    keyFile.write('STATS\n')

    # The STDIDENT keyword record allows you to assign an identification code to a stand.
    # None of the keyword parameter fields are used, but one supplemental data record is
    # required. This supplemental record contains the stand identification (such as S248112
    # shown below) in columns l-26. This ID appears with every output table in the main 
    # output file. The remainder of the columns, up through column 80 can be used to transmit
    # a “title” which will also be reproduced at the beginning of each output table. 
    keyFile.write('STDIDENT\n')
    keyFile.write('S248112  ' + sim_dict[simulation_type] + '2048. 5. 20. 1. ALL 70. 0.\n')
    keyFile.write('DESIGN                                               \n')
    keyFile.write('THINBTA' + '        2048.        80.\n')
    keyFile.write('STDINFO\n')
    keyFile.write('INVYEAR        ' + str(year) + '\n')
    keyFile.write('NUMCYCLE        ' + str(num_cycles) + '\n')
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
    # 
    # One option is to enter the tree records as supplemental data records for the TREEDATA
    # keyword record. In this case, the dataset reference number (field 1) should be assigned
    # the logical unit number for record input at the computer installation (logical unit 15 on
    # most systems) and a special record containing the data value –999 must be added to the
    # end of the tree record file. 
    keyFile.write('TREEDATA  15.0\n')

    # Note that we are not closing keyFile since we append to it later.
    return keyFile

tree_widths = []
for j in range(8):
    for i in range(7):
        tree_widths.append(10 + j * 5)
growth_vals = []

print(tree_widths)


trees_dataframe = pd.read_excel('Datasets/Redwoods.csv')
total = len(trees_dataframe)


increment = 0


keyFile = simulation_setup('testKey.key', '2018', 10, 'thin')

uniquePlots = []
width_vals = [50]
for width in width_vals:
    print('SIMULATION; WIDTH = ', width)
    for index, row in trees_dataframe.iterrows():
        if index > 2998:
            break

        if int(row['Plot']) not in uniquePlots:
            uniquePlots.append(int(row['Plot']))
        if index == 2998:
            print(len(uniquePlots))

        Plot = '    ' if pd.isna(row['Plot']) else str(row['Plot']) + (' ' * (4 - len(str(row['Plot']))))
        TreeID = '   ' if pd.isna(row['TreeID']) else str(row['TreeID']) + (' ' * (3 - len(str(row['TreeID']))))
        TreeCount = str(1) + (' ' * 5)
        TreeHistory = ' '
        Species = str(row['FieldSP']) + (' ' * (3 - len(str(row['FieldSP']))))

        #DBH = '    ' if pd.isna(row['DBH']) else str(math.trunc(10 * round(row['DBH'], 1))) + (' ' * (4 - len(str(math.trunc(10 * round(row['DBH'], 1))))))
        DBH = '    ' if pd.isna(row['DBH']) else str(width) + (' ' * (2))
        DBHincrement = '   '
        TotalHeight = '   ' if pd.isna(row['TotalHt']) else str(math.trunc(round(row['TotalHt'], 0))) + (' ' * (3 - len(str(math.trunc(round(row['TotalHt'], 0))))))
        
        TopKill = '   '
        HeightIncrement = '    '

        # If cratio doesn't exist in row, set it blank
        CrownRatioCode = ' ' if pd.isna(row['Cratio']) else str(min(9, math.trunc(int(row['Cratio']) / 10 + 1)))
        inputString = ''
        inputString += (Plot + TreeID + TreeCount + TreeHistory + Species + DBH + DBHincrement + TotalHeight + TopKill + HeightIncrement + CrownRatioCode + '  0 0 0 0 0 011\n')
        keyFile.write(inputString)

# print(len(uniquePlots))

    keyFile.write('-999\n')
    keyFile.write('ECHOSUM\n')
    keyFile.write('PROCESS\n')
    keyFile.write('STOP\n')
    keyFile.close()

    makefile = open('makefile', 'w')
    # print(makefile.name)
    makefile.write('all : cat01\n')
    makefile.write('cat01 : \n')

    makefile.write('\t' + './ForestVegetationSimulator-FS2023.1/bin/FVSca --keywordfile=testKey.key\n')

    makefile.close()

    subprocess.Popen("make -f makefile", shell=True)






# print(tree_widths)
# print(growth_vals)
# plt.xlabel('Tree Width')
# plt.ylabel('Total Growth')
# plt.title('Growth Variation with Tree Width over 60 Years')
# plt.grid(True)
# plt.scatter(tree_widths, growth_vals)
# plt.show()


# outputFile = open('/Users/adityatadimeti/forest-project/testKey.sum', 'rb')
# outputFile = open('testKey.sum', 'rb')


#     # Read the tree data from the CSV file
# trees_dataframe = pd.read_excel('/Users/adityatadimeti/forest-project/trees.csv')

    # Create empty lists to store the tree widths and growth values

# increment = 0
# with outputFile as file:
#     for line in file:
#         if increment == 0:
#             increment += 1
#             continue
#         # growthVal = int(str(line)[112:115].strip().replace(' ', ''))
#         # print(str(line)[:].strip().replace(' ', ''))
#         print(str(line)[40:45])



