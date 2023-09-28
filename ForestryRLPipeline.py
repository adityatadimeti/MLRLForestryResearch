import math
import random
import matplotlib.pyplot as plt
import os
import pandas as pd
import subprocess
from tqdm import tqdm
import re

def simulation_setup(keyFilePath, year, num_cycles, simulation_series):
    sim_dict = {"unthinned" : "UNTHINNED CONTROL", "thin" : "THINDBH"}
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
    keyFile.write('simulation type: ' + " ".join(simulation_series) + ', start year: ' + str(year) + ', cycles = ' + str(num_cycles) + '\n')
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
            keyFile.write('THINDBH   ' + str(((index) * 10) + year) + '.     ' + '5.        '+ '20.       ' + '1.        ' + 'ALL       ' + '10.       0.' + '\n')
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



        DBH = '    ' if pd.isna(row['DBH']) else str(math.trunc(10 * round(row['DBH'], 1))) + (' ' * (4 - len(str(math.trunc(10 * round(row['DBH'], 1))))))
        DBHincrement = '   '
        TotalHeight = '   ' if pd.isna(row['TotalHt']) else str(math.trunc(round(row['TotalHt'], 0))) + (' ' * (3 - len(str(math.trunc(round(row['TotalHt'], 0))))))
        
        TopKill = '   '
        HeightIncrement = '    '

        # If cratio doesn't exist in row, set it blank
        CrownRatioCode = ' ' if pd.isna(row['Cratio']) else str(min(9, math.trunc(int(row['Cratio']) / 10 + 1)))
        inputString = ''
        inputString += (Plot + TreeID + TreeCount + TreeHistory + Species + DBH + DBHincrement + TotalHeight + TopKill + HeightIncrement + CrownRatioCode + '  0 0 0 0 0 011\n')
        keyFile.write(inputString)

    keyFile.write('-999\n')
    keyFile.write('ECHOSUM\n')
    keyFile.write('PROCESS\n')
    keyFile.write('STOP\n')
    keyFile.close()

    makefile = open('makefile', 'w')
    makefile.write('all : cat01\n')
    makefile.write('cat01 : \n')

    makefile.write('\t' + './ForestVegetationSimulator-FS2023.1/bin/FVSca --keywordfile=testKey.key\n')

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
               "After Treatment BA", "After Treatment SDI", "After Treatment CCF", "After Treatment Top Height", "After Treatment RES QMD",
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

keyFile = simulation_setup('testKey.key', 2018, 6, [])
run_simulation('/Users/adityatadimeti/Desktop/Datasets/Redwoods.csv', keyFile)
df = process_results('testKey.sum')
print(df.head())


ALPHA = 0.1  # learning rate
GAMMA = 0.9  # discount factor
EPSILON = 0.2  # exploration factor

# State is represented as (Cubic feet rounded to nearest 1000 ft, Time interval, [List of harvesting actions to arrive at this state])


#                                 SUMMARY STATISTICS (PER ACRE OR STAND BASED ON TOTAL STAND AREA)
# --------------------------------------------------------------------------------------------------------------------------------------
#                START OF SIMULATION PERIOD                     REMOVALS             AFTER TREATMENT    GROWTH THIS PERIOD
#          --------------------------------------------- ----------------------- ---------------------  ------------------   MAI  ------
#          NO OF              TOP      TOTAL MERCH MERCH NO OF TOTAL MERCH MERCH              TOP  RES  PERIOD ACCRE MORT   MERCH FOR SS
# YEAR AGE TREES  BA  SDI CCF HT  QMD  CU FT CU FT BD FT TREES CU FT CU FT BD FT  BA  SDI CCF HT   QMD  YEARS   PER  YEAR   CU FT TYP ZT
# ---- --- ----- --- ---- --- --- ---- ----- ----- ----- ----- ----- ----- ----- --- ---- --- --- ----  ------ ---- -----   ----- ------
# 2018   0   467 306  488 165  49 11.0  5240  4248 20889   275  4206  3434 16633  92  134  48  43  9.4      10   51     4     0.0 341 12
# 2028  10   785 126  214 104  56  5.4  1504  1104  5987    71   298   132   658 107  176  86  50  5.2      10  120     6     0.0 341 14
# 2038  20   725 199  361 167  60  7.1  2344  1286  7409   586   929    40   199  97  128  41  50 11.3      10   53     6     0.0 341 23
# 2048  30   692 132  206  94  61  5.9  1881  1558  9404    91   169    26   139 114  166  74  53  5.9      10  111     7     0.0 341 14
# 2058  40   625 196  330 147  63  7.6  2753  1881 11775   460   665    24   123 116  148  48  58 11.4      10   64     6     0.0 341 23
# 2068  50   584 151  221  94  68  6.9  2662  2255 14619   116   214    25   138 129  171  68  60  7.1      10  106     9     0.0 341 14
# 2078  60   538 194  301 128  70  8.1  3421  2668 17719     0     0     0     0 194  301 128  70  8.1       0    0     0     0.0 341 13


#                                 SUMMARY STATISTICS (PER ACRE OR STAND BASED ON TOTAL STAND AREA)
# --------------------------------------------------------------------------------------------------------------------------------------
#                START OF SIMULATION PERIOD                     REMOVALS             AFTER TREATMENT    GROWTH THIS PERIOD
#          --------------------------------------------- ----------------------- ---------------------  ------------------   MAI  ------
#          NO OF              TOP      TOTAL MERCH MERCH NO OF TOTAL MERCH MERCH              TOP  RES  PERIOD ACCRE MORT   MERCH FOR SS
# YEAR AGE TREES  BA  SDI CCF HT  QMD  CU FT CU FT BD FT TREES CU FT CU FT BD FT  BA  SDI CCF HT   QMD  YEARS   PER  YEAR   CU FT TYP ZT
# ---- --- ----- --- ---- --- --- ---- ----- ----- ----- ----- ----- ----- ----- --- ---- --- --- ----  ------ ---- -----   ----- ------
# 2018   0   467 306  488 165  49 11.0  5240  4248 20889     0     0     0     0 306  488 165  49 11.0      10  195     1     0.0 341 12
# 2028  10   465 372  582 191  65 12.1  7173  5898 29857     0     0     0     0 372  582 191  65 12.1      10  207    38     0.0 341 12
# 2038  20   425 414  628 199  79 13.4  8863  7434 38835     0     0     0     0 414  628 199  79 13.4      10  220    39     0.0 341 11
# 2048  30   394 454  667 204  90 14.5 10665  9145 49310     0     0     0     0 454  667 204  90 14.5      10  228    47     0.0 341 11
# 2058  40   365 488  697 208 100 15.7 12472 10900 60410     0     0     0     0 488  697 208 100 15.7      10  224   126     0.0 341 11
# 2068  50   303 488  674 195 110 17.2 13448 11961 68637     0     0     0     0 488  674 195 110 17.2      10  226   131     0.0 341 11
# 2078  60   255 488  652 184 119 18.7 14399 13002 76659     0     0     0     0 488  652 184 119 18.7       0    0     0     0.0 341 11

class ForestryRL:
    def __init__(self):
        self.initial_state = self.get_initial_state()
        self.Q = {}  # Q-table for state-action pairs

    def get_initial_state(self):
        # Start with the initial total cubic feet and time interval 0
        initial_cubic_feet = float(df["Start Total CU Ft"].iloc[0])  # get the first entry from your data
        return (round(initial_cubic_feet, -3) , 0, ())

    def simulate(self, state, action, years):
        # Simulate series of harvesting actions via FVS and return the next state and reward
        new_simulation_actions = list(state[2])[:]
        new_simulation_actions.append(action)


        # run FVS simulation here. get cubic feet
        keyFile = simulation_setup('testKey.key', 2018, 6, tuple(new_simulation_actions))
        run_simulation('/Users/adityatadimeti/Desktop/Datasets/Redwoods.csv', keyFile)
        df = process_results('testKey.sum')
        reward = 0
        new_cubic_feet = 0
        if action == "thin":
            removal = float(df["Removals Merch CU Ft"].iloc[len(new_simulation_actions) - 1])
            initial_feet = float(df["Start Merch CU Ft"].iloc[len(new_simulation_actions) - 1])
            new_cubic_feet = float(df["Start Merch CU Ft"].iloc[len(new_simulation_actions)])
            reward = removal + new_cubic_feet - (initial_feet - removal) # Removal + growth after removal

            #just do removal, not removal + growth after. terminal state regardless is what you have left, we care about the beginning states
            # hence the total reward is the discounted sum of future rewards. 
        else:
            initial_feet = float(df["Start Merch CU Ft"].iloc[len(new_simulation_actions) - 1])
            new_cubic_feet = float(df["Start Merch CU Ft"].iloc[len(new_simulation_actions)])
            reward = new_cubic_feet - initial_feet # Growth without removal
            
            # last state, reweard is the merchantbility you ended at (like as if you sold all of it). at each time step, the reward 
            # you have is 0. 
        # print(df.head)
        # print(tuple(new_simulation_actions), type(tuple(new_simulation_actions)))
        next_state = (round(new_cubic_feet, -3), state[1] + years, tuple(new_simulation_actions))
        return next_state, reward

    def q_value(self, state, action):
        # Get the Q value for the state-action pair
        return self.Q.get((state, action), 0)

    def update_q_value(self, state, action, reward, next_state):
        max_next_q = max([self.q_value(next_state, a) for a in self.available_actions(next_state)])
        self.Q[(state, action)] = self.q_value(state, action) + ALPHA * (reward + GAMMA * max_next_q - self.q_value(state, action))

    def available_actions(self, state):
        # Available actions 
        # Here, we're allowing actions of either thinning or doing nothing
        return ["thin", "leave"]

    # will have to run this below function numerous times. 
    def learn_from_simulation(self, years):
        state = self.initial_state
        for t in tqdm(range(0, 60, years)):
            action = self.select_action(state)
            next_state, reward = self.simulate(state, action, years)
            self.update_q_value(state, action, reward, next_state)
            state = next_state

    def select_action(self, state):
        # Epsilon-greedy strategy for action selection
        if random.uniform(0, 1) < EPSILON:
            return random.choice(self.available_actions(state))
        else:
            q_values = {action: self.q_value(state, action) for action in self.available_actions(state)}
            return max(q_values, key=q_values.get)

# Instantiate the class and start learning
model = ForestryRL()

for episode in tqdm(range(10)):
    model.learn_from_simulation(10)  # Learning over 10-year intervals
    for entry in model.Q:
        print("Cubic feet", str(entry[0][0]), "Year:", str(entry[0][1] + 2018), "Previous actions:", str(entry[0][2]), "Optimal Action:", str(entry[1]), "Reward:",  str(model.Q[entry]))
# print(model.Q)
# Then inspect the Q-values and derive a policy based on this (?).



# linear reward in terms of volume of cubic feet
# also linear reward in amount being harvested


# process_results('testKey.sum')

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



