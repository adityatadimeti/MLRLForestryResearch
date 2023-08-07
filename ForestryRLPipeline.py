import os
from tqdm import tqdm

tree_widths = []
for j in range(8):
    for i in range(7):
        tree_widths.append(10 + j * 5)
growth_vals = []

print(tree_widths)

import pandas as pd
    

trees_dataframe = pd.read_excel('/Users/adityatadimeti/forest-project/trees.csv')
total = len(trees_dataframe)

invalid_indices = [54,55,59,60,61,200]

increment = 0


keyFile = open('/Users/adityatadimeti/forest-project/testKey.key', 'w')
keyFile.write('SCREEN\n')
keyFile.write('STATS\n')
keyFile.write('STDIDENT\n')
keyFile.write('S248112  UNTHINNED CONTROL.\n')
# keyFile.write('DESIGN                                               1.0\n')
keyFile.write('DESIGN                                               \n')

keyFile.write('STDINFO\n')
keyFile.write('INVYEAR        2018.0\n')
keyFile.write('NUMCYCLE        6.0\n')
keyFile.write('TREEFMT\n')
keyFile.write('(I4,T1,I7,F6.0,I1,A3,F4.1,F3.1,2F3.0,F4.1,I1,\n')
keyFile.write('6I2,2I1,I2,2I3,2I1,F3.0) \n')

keyFile.write('TREEDATA  15.0\n')
# for index, row in tqdm(trees_dataframe.iloc[0: stopping].iterrows(), total=total):
# for index, row in trees_dataframe.iloc[0: 1].iterrows():

#print unique entries in row column

uniquePlots = []
# for width in 
# width_vals = [10, 15, 20, 25, 30, 35, 40, 45, 50]
width_vals = [50]
for width in width_vals:
    print('SIMULATION; WIDTH = ', width)
    for index, row in trees_dataframe.iterrows():
        if index > 2950:
            break

        import math
        # print(trees_dataframe.columns)

        if int(row['Plot']) not in uniquePlots:
            uniquePlots.append(int(row['Plot']))

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

        # if cratio doesn't exist in row, set it blank

        CrownRatioCode = ' ' if pd.isna(row['Cratio']) else str(min(9, math.trunc(int(row['Cratio']) / 10 + 1)))
        inputString = ''
        inputString += (Plot + TreeID + TreeCount + TreeHistory + Species + DBH + DBHincrement + TotalHeight + TopKill + HeightIncrement + CrownRatioCode + '  0 0 0 0 0 011\n')
        # print(inputString)
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

    makefile.write('\t' + './ForestVegetationSimulator-FS2023.1/bin/FVSca --keywordfile=/Users/adityatadimeti/forest-project/testKey.key\n')

    makefile.close()

    import subprocess

    # output = subprocess.Popen("make -f makefile", shell=True, stdout=subprocess.PIPE).communicate()[0]
    subprocess.Popen("make -f makefile", shell=True)





# keyFile.write('-999\n')
# keyFile.write('ECHOSUM\n')
# keyFile.write('PROCESS\n')
# keyFile.write('STOP\n')
# keyFile.close()

# makefile = open('makefile', 'w')
# print(makefile.name)
# makefile.write('all : cat01\n')
# makefile.write('cat01 : \n')

# makefile.write('\t' + './ForestVegetationSimulator-FS2023.1/bin/FVSca --keywordfile=/Users/adityatadimeti/forest-project/testKey.key\n')

# makefile.close()

# import subprocess

# output = subprocess.Popen("make -f makefile", shell=True, stdout=subprocess.PIPE).communicate()[0]
# print(len(output))

# if len(output) == 110:
#     print(index)
#     invalid_indices.append(index)

# print(invalid_indices)
    # print(len(output)) # length will be 110 if there's an error


    # print(output)

    # outputFile = open('/Users/adityatadimeti/forest-project/testKey.sum', 'rb')


    # import pandas as pd
    # import math
    # import matplotlib.pyplot as plt

    # Read the tree data from the CSV file
    # trees_dataframe = pd.read_excel('/Users/adityatadimeti/forest-project/trees.csv')

    # Create empty lists to store the tree widths and growth values

#     increment = 0
#     with outputFile as file:
#         for line in file:
#             if increment == 0:
#                 increment += 1
#                 continue
#             growthVal = int(str(line)[40:45].strip().replace(' ', ''))
#             growth_vals.append(growthVal)




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


# import pandas as pd
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



