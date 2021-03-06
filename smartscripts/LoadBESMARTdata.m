%% Import data from text file.
% Script for importing data from the following text file:
%
%    C:\Users\dunch\Documents\MATLAB\besmart\BESMART_FebOnly.csv
%
% To extend the code to different selected data or a different text file,
% generate a function instead of a script.

% Auto-generated by MATLAB on 2017/03/06 10:33:45

%% Initialize variables.
filename = 'C:\Users\dunch\Documents\MATLAB\besmart\BESMART_FebOnly.csv';
delimiter = ',';
startRow = 3;

%% Format string for each line of text:
%   column1: text (%q)
%	column2: text (%q)
%   column3: text (%q)
%	column4: text (%q)
%   column5: text (%q)
%	column6: text (%q)
%   column7: double (%f)
%	column8: text (%q)
%   column9: text (%q)
%	column10: double (%f)
%   column11: double (%f)
%	column12: double (%f)
%   column13: double (%f)
%	column14: double (%f)
%   column15: text (%q)
%	column16: text (%q)
%   column17: text (%q)
%	column18: double (%f)
%   column19: double (%f)
%	column20: double (%f)
%   column21: double (%f)
%	column22: text (%q)
%   column23: text (%q)
%	column24: text (%q)
%   column25: text (%q)
%	column26: text (%q)
%   column27: double (%f)
%	column28: text (%q)
%   column29: text (%q)
%	column30: double (%f)
%   column31: double (%f)
%	column32: double (%f)
%   column33: double (%f)
%	column34: text (%q)
%   column35: text (%q)
%	column36: text (%q)
%   column37: text (%q)
%	column38: double (%f)
%   column39: double (%f)
%	column40: double (%f)
%   column41: double (%f)
%	column42: double (%f)
%   column43: double (%f)
%	column44: double (%f)
%   column45: double (%f)
%	column46: double (%f)
%   column47: text (%q)
%	column48: double (%f)
%   column49: double (%f)
%	column50: double (%f)
%   column51: double (%f)
%	column52: text (%q)
%   column53: text (%q)
%	column54: text (%q)
%   column55: text (%q)
%	column56: text (%q)
%   column57: double (%f)
%	column58: double (%f)
%   column59: double (%f)
%	column60: double (%f)
%   column61: text (%q)
%	column62: text (%q)
%   column63: text (%q)
%	column64: text (%q)
%   column65: text (%q)
%	column66: double (%f)
%   column67: double (%f)
%	column68: double (%f)
%   column69: double (%f)
%	column70: text (%q)
%   column71: text (%q)
%	column72: text (%q)
%   column73: text (%q)
%	column74: text (%q)
%   column75: double (%f)
%	column76: double (%f)
%   column77: double (%f)
%	column78: double (%f)
%   column79: text (%q)
%	column80: text (%q)
%   column81: text (%q)
%	column82: text (%q)
%   column83: text (%q)
%	column84: double (%f)
%   column85: double (%f)
%	column86: double (%f)
%   column87: double (%f)
%	column88: text (%q)
%   column89: text (%q)
%	column90: text (%q)
%   column91: text (%q)
%	column92: text (%q)
%   column93: double (%f)
%	column94: double (%f)
%   column95: double (%f)
%	column96: double (%f)
%   column97: text (%q)
%	column98: text (%q)
%   column99: text (%q)
%	column100: text (%q)
%   column101: text (%q)
%	column102: double (%f)
%   column103: double (%f)
%	column104: double (%f)
%   column105: double (%f)
%	column106: text (%q)
%   column107: text (%q)
%	column108: text (%q)
%   column109: text (%q)
%	column110: text (%q)
%   column111: double (%f)
%	column112: double (%f)
%   column113: double (%f)
%	column114: double (%f)
%   column115: text (%q)
%	column116: text (%q)
%   column117: text (%q)
%	column118: text (%q)
%   column119: text (%q)
%	column120: double (%f)
%   column121: double (%f)
%	column122: double (%f)
%   column123: double (%f)
%	column124: text (%q)
%   column125: text (%q)
%	column126: text (%q)
%   column127: text (%q)
%	column128: text (%q)
%   column129: double (%f)
%	column130: double (%f)
%   column131: double (%f)
%	column132: double (%f)
%   column133: text (%q)
%	column134: text (%q)
%   column135: text (%q)
%	column136: text (%q)
%   column137: double (%f)
%	column138: double (%f)
%   column139: double (%f)
%	column140: double (%f)
%   column141: text (%q)
%	column142: text (%q)
%   column143: text (%q)
%	column144: text (%q)
%   column145: text (%q)
%	column146: text (%q)
%   column147: text (%q)
%	column148: text (%q)
%   column149: text (%q)
%	column150: text (%q)
%   column151: text (%q)
%	column152: text (%q)
%   column153: text (%q)
%	column154: double (%f)
%   column155: double (%f)
%	column156: double (%f)
%   column157: double (%f)
%	column158: double (%f)
%   column159: double (%f)
%	column160: double (%f)
%   column161: double (%f)
%	column162: double (%f)
%   column163: double (%f)
%	column164: double (%f)
%   column165: double (%f)
%	column166: double (%f)
%   column167: double (%f)
%	column168: double (%f)
%   column169: double (%f)
%	column170: double (%f)
%   column171: double (%f)
%	column172: double (%f)
%   column173: double (%f)
%	column174: double (%f)
%   column175: double (%f)
%	column176: double (%f)
%   column177: double (%f)
%	column178: double (%f)
%   column179: double (%f)
%	column180: double (%f)
%   column181: double (%f)
%	column182: double (%f)
%   column183: double (%f)
%	column184: double (%f)
%   column185: double (%f)
%	column186: double (%f)
%   column187: double (%f)
%	column188: double (%f)
%   column189: double (%f)
%	column190: double (%f)
%   column191: double (%f)
%	column192: double (%f)
%   column193: double (%f)
%	column194: double (%f)
%   column195: double (%f)
%	column196: double (%f)
%   column197: double (%f)
%	column198: double (%f)
%   column199: double (%f)
%	column200: double (%f)
%   column201: double (%f)
%	column202: double (%f)
%   column203: double (%f)
%	column204: double (%f)
%   column205: double (%f)
%	column206: double (%f)
%   column207: text (%q)
%	column208: text (%q)
%   column209: text (%q)
%	column210: text (%q)
%   column211: text (%q)
%	column212: double (%f)
%   column213: double (%f)
%	column214: double (%f)
%   column215: double (%f)
%	column216: double (%f)
%   column217: double (%f)
%	column218: double (%f)
%   column219: double (%f)
%	column220: double (%f)
%   column221: double (%f)
%	column222: double (%f)
%   column223: double (%f)
%	column224: double (%f)
%   column225: double (%f)
%	column226: double (%f)
%   column227: double (%f)
%	column228: text (%q)
%   column229: text (%q)
%	column230: text (%q)
% For more information, see the TEXTSCAN documentation.
formatSpec = '%q%q%q%q%q%q%f%q%q%f%f%f%f%f%q%q%q%f%f%f%f%q%q%q%q%q%f%q%q%f%f%f%f%q%q%q%q%f%f%f%f%f%f%f%f%f%q%f%f%f%f%q%q%q%q%q%f%f%f%f%q%q%q%q%q%f%f%f%f%q%q%q%q%q%f%f%f%f%q%q%q%q%q%f%f%f%f%q%q%q%q%q%f%f%f%f%q%q%q%q%q%f%f%f%f%q%q%q%q%q%f%f%f%f%q%q%q%q%q%f%f%f%f%q%q%q%q%q%f%f%f%f%q%q%q%q%f%f%f%f%q%q%q%q%q%q%q%q%q%q%q%q%q%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%q%q%q%q%q%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%q%q%q%[^\n\r]';

%% Open the text file.
fileID = fopen(filename,'r','n','UTF-8');
% Skip the BOM (Byte Order Mark).
fseek(fileID, 3, 'bof');

%% Read columns of data according to format string.
% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'EmptyValue' ,NaN,'HeaderLines' ,startRow-1, 'ReturnOnError', false);

%% Close the text file.
fclose(fileID);

%% Post processing for unimportable data.
% No unimportable data rules were applied during the import, so no post
% processing code is included. To generate code which works for
% unimportable data, select unimportable cells in a file and regenerate the
% script.

%% Allocate imported array to column variable names
V1 = dataArray{:, 1};
V2 = dataArray{:, 2};
V3 = dataArray{:, 3};
V4 = dataArray{:, 4};
V5 = dataArray{:, 5};
V6 = dataArray{:, 6};
V7 = dataArray{:, 7};
V8 = dataArray{:, 8};
V9 = dataArray{:, 9};
V10 = dataArray{:, 10};
SC0_0 = dataArray{:, 11};
SC0_1 = dataArray{:, 12};
SC0_2 = dataArray{:, 13};
SubjectID = dataArray{:, 14};
RecipientFirstName = dataArray{:, 15};
RecipientLastName = dataArray{:, 16};
Source = dataArray{:, 17};
Month = dataArray{:, 18};
Year = dataArray{:, 19};
ImageSet = dataArray{:, 20};
instructions = dataArray{:, 21};
meta_1_TEXT = dataArray{:, 22};
meta_2_TEXT = dataArray{:, 23};
meta_3_TEXT = dataArray{:, 24};
meta_4_TEXT = dataArray{:, 25};
meta_5_TEXT = dataArray{:, 26};
meta_6_TEXT = dataArray{:, 27};
meta_7_TEXT = dataArray{:, 28};
pd_instructions = dataArray{:, 29};
compass1 = dataArray{:, 30};
compass2 = dataArray{:, 31};
compass3 = dataArray{:, 32};
compass4 = dataArray{:, 33};
Q873_1 = dataArray{:, 34};
Q873_2 = dataArray{:, 35};
Q873_3 = dataArray{:, 36};
Q873_4 = dataArray{:, 37};
pd_timing = dataArray{:, 38};
coin1 = dataArray{:, 39};
coin2 = dataArray{:, 40};
coin3 = dataArray{:, 41};
coin4 = dataArray{:, 42};
pd_timing_1 = dataArray{:, 43};
pd_timing_2 = dataArray{:, 44};
pd_timing_3 = dataArray{:, 45};
pd_timing_4 = dataArray{:, 46};
pd_instructions1 = dataArray{:, 47};
egg1 = dataArray{:, 48};
egg2 = dataArray{:, 49};
egg3 = dataArray{:, 50};
egg4 = dataArray{:, 51};
pd_timing_5 = dataArray{:, 52};
pd_timing_6 = dataArray{:, 53};
pd_timing_7 = dataArray{:, 54};
pd_timing_8 = dataArray{:, 55};
pd_instructions2 = dataArray{:, 56};
grater1 = dataArray{:, 57};
grater2 = dataArray{:, 58};
grater3 = dataArray{:, 59};
grater4 = dataArray{:, 60};
pd_timing_9 = dataArray{:, 61};
pd_timing_10 = dataArray{:, 62};
pd_timing_11 = dataArray{:, 63};
pd_timing_12 = dataArray{:, 64};
pd_instructions3 = dataArray{:, 65};
feather1 = dataArray{:, 66};
feather2 = dataArray{:, 67};
feather3 = dataArray{:, 68};
feather4 = dataArray{:, 69};
pd_timing_13 = dataArray{:, 70};
pd_timing_14 = dataArray{:, 71};
pd_timing_15 = dataArray{:, 72};
pd_timing_16 = dataArray{:, 73};
pd_instructions4 = dataArray{:, 74};
camera1 = dataArray{:, 75};
camera2 = dataArray{:, 76};
camera3 = dataArray{:, 77};
camera4 = dataArray{:, 78};
pd_timing_17 = dataArray{:, 79};
pd_timing_18 = dataArray{:, 80};
pd_timing_19 = dataArray{:, 81};
pd_timing_20 = dataArray{:, 82};
pd_instructions5 = dataArray{:, 83};
dolls1 = dataArray{:, 84};
dolls2 = dataArray{:, 85};
dolls3 = dataArray{:, 86};
dolls4 = dataArray{:, 87};
pd_timing_21 = dataArray{:, 88};
pd_timing_22 = dataArray{:, 89};
pd_timing_23 = dataArray{:, 90};
pd_timing_24 = dataArray{:, 91};
pd_instructions6 = dataArray{:, 92};
bear1 = dataArray{:, 93};
bear2 = dataArray{:, 94};
bear3 = dataArray{:, 95};
bear4 = dataArray{:, 96};
pd_timing_25 = dataArray{:, 97};
pd_timing_26 = dataArray{:, 98};
pd_timing_27 = dataArray{:, 99};
pd_timing_28 = dataArray{:, 100};
pd_instructions7 = dataArray{:, 101};
box1 = dataArray{:, 102};
box2 = dataArray{:, 103};
box3 = dataArray{:, 104};
box4 = dataArray{:, 105};
pd_timing_29 = dataArray{:, 106};
pd_timing_30 = dataArray{:, 107};
pd_timing_31 = dataArray{:, 108};
pd_timing_32 = dataArray{:, 109};
pd_Instructions = dataArray{:, 110};
typewriter1 = dataArray{:, 111};
typewriter2 = dataArray{:, 112};
typewriter3 = dataArray{:, 113};
typewriter4 = dataArray{:, 114};
pd_timing_33 = dataArray{:, 115};
pd_timing_34 = dataArray{:, 116};
pd_timing_35 = dataArray{:, 117};
pd_timing_36 = dataArray{:, 118};
pd_instructions8 = dataArray{:, 119};
skate1 = dataArray{:, 120};
skate2 = dataArray{:, 121};
skate3 = dataArray{:, 122};
skate4 = dataArray{:, 123};
pd_timing_37 = dataArray{:, 124};
pd_timing_38 = dataArray{:, 125};
pd_timing_39 = dataArray{:, 126};
pd_timing_40 = dataArray{:, 127};
pd_instructions9 = dataArray{:, 128};
basket1 = dataArray{:, 129};
basket2 = dataArray{:, 130};
basket3 = dataArray{:, 131};
basket4 = dataArray{:, 132};
pd_timing_41 = dataArray{:, 133};
pd_timing_42 = dataArray{:, 134};
pd_timing_43 = dataArray{:, 135};
pd_timing_44 = dataArray{:, 136};
motor_timing_1 = dataArray{:, 137};
motor_timing_2 = dataArray{:, 138};
motor_timing_3 = dataArray{:, 139};
motor_timing_4 = dataArray{:, 140};
motor_instructions = dataArray{:, 141};
motor1 = dataArray{:, 142};
motor2 = dataArray{:, 143};
motor3 = dataArray{:, 144};
motor4 = dataArray{:, 145};
motor5 = dataArray{:, 146};
trails_timing_1 = dataArray{:, 147};
trails_timing_2 = dataArray{:, 148};
trails_timing_3 = dataArray{:, 149};
trails_timing_4 = dataArray{:, 150};
trails_instructions = dataArray{:, 151};
trails = dataArray{:, 152};
ws_inst = dataArray{:, 153};
ws_img_1 = dataArray{:, 154};
ws_img_2 = dataArray{:, 155};
ws_img_3 = dataArray{:, 156};
ws_img_4 = dataArray{:, 157};
ws_img_5 = dataArray{:, 158};
ws_img_6 = dataArray{:, 159};
ws_img_7 = dataArray{:, 160};
ws_img_8 = dataArray{:, 161};
ws_img_9 = dataArray{:, 162};
ws_img_10 = dataArray{:, 163};
ws_img_11 = dataArray{:, 164};
ws_img_12 = dataArray{:, 165};
ws_img_timing_1 = dataArray{:, 166};
ws_img_timing_2 = dataArray{:, 167};
ws_img_timing_3 = dataArray{:, 168};
ws_img_timing_4 = dataArray{:, 169};
ws_ans_1 = dataArray{:, 170};
ws_ans_2 = dataArray{:, 171};
ws_ans_3 = dataArray{:, 172};
ws_ans_4 = dataArray{:, 173};
ws_ans_5 = dataArray{:, 174};
ws_ans_6 = dataArray{:, 175};
ws_ans_7 = dataArray{:, 176};
ws_ans_8 = dataArray{:, 177};
ws_ans_9 = dataArray{:, 178};
ws_ans_10 = dataArray{:, 179};
ws_ans_11 = dataArray{:, 180};
ws_ans_12 = dataArray{:, 181};
ws_ans_timing_1 = dataArray{:, 182};
ws_ans_timing_2 = dataArray{:, 183};
ws_ans_timing_3 = dataArray{:, 184};
ws_ans_timing_4 = dataArray{:, 185};
ws_1_solution = dataArray{:, 186};
ws_2_solution = dataArray{:, 187};
ws_3_solution = dataArray{:, 188};
ws_4_solution = dataArray{:, 189};
ws_5_solution = dataArray{:, 190};
ws_6_solution = dataArray{:, 191};
ws_7_solution = dataArray{:, 192};
ws_8_solution = dataArray{:, 193};
ws_9_solution = dataArray{:, 194};
ws_10_solution = dataArray{:, 195};
ws_11_solution = dataArray{:, 196};
ws_12_solution = dataArray{:, 197};
ws_solution_timing_1 = dataArray{:, 198};
ws_solution_timing_2 = dataArray{:, 199};
ws_solution_timing_3 = dataArray{:, 200};
ws_solution_timing_4 = dataArray{:, 201};
motor_timing_2_1 = dataArray{:, 202};
motor_timing_2_2 = dataArray{:, 203};
motor_timing_2_3 = dataArray{:, 204};
motor_timing_2_4 = dataArray{:, 205};
motor_instructions1 = dataArray{:, 206};
motor6 = dataArray{:, 207};
motor7 = dataArray{:, 208};
motor8 = dataArray{:, 209};
motor9 = dataArray{:, 210};
motor10 = dataArray{:, 211};
pr_timing_1 = dataArray{:, 212};
pr_timing_2 = dataArray{:, 213};
pr_timing_3 = dataArray{:, 214};
pr_timing_4 = dataArray{:, 215};
box_recall = dataArray{:, 216};
typewriter_recall = dataArray{:, 217};
skate_recall = dataArray{:, 218};
basket_recall = dataArray{:, 219};
bear_recall = dataArray{:, 220};
dolls_recall = dataArray{:, 221};
camera_recall = dataArray{:, 222};
feather_recall = dataArray{:, 223};
grater_recall = dataArray{:, 224};
egg_recall = dataArray{:, 225};
coin_recall = dataArray{:, 226};
compass_recall = dataArray{:, 227};
LocationLatitude = dataArray{:, 228};
LocationLongitude = dataArray{:, 229};
LocationAccuracy = dataArray{:, 230};

ResponseID = V1;
StartDate = V8;
EndDate = V9;

%% Clear temporary variables
clearvars filename delimiter startRow formatSpec fileID dataArray ans;