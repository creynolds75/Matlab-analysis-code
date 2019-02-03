clear all

%% Import data from text file.
% Script for importing data from the following text file:
%
%    C:\Users\dunch\Documents\MATLAB\besmart\BESMART_Brain_Engagement_Survey_for_Memory_Attention_Responding_and_Thinking (8).csv
%
% To extend the code to different selected data or a different text file,
% generate a function instead of a script.


%% Initialize variables.
[inputfile, inputpath] = uigetfile('*.csv', 'Select Qualtrics output file');
inputfilename = fullfile(inputpath, inputfile);

delimiter = ',';
startRow = 3;

%% Read columns of data as strings:
% For more information, see the TEXTSCAN documentation.
formatSpec = '%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%[^\n\r]';

%% Open the text file.
fileID = fopen(inputfilename,'r','n','UTF-8');
% Skip the BOM (Byte Order Mark).
fseek(fileID, 3, 'bof');

%% Read columns of data according to format string.
% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'HeaderLines' ,startRow-1, 'ReturnOnError', false);

%% Close the text file.
fclose(fileID);

%% Convert the contents of columns containing numeric strings to numbers.
% Replace non-numeric strings with NaN.
raw = repmat({''},length(dataArray{1}),length(dataArray)-1);
for col=1:length(dataArray)-1
    raw(1:length(dataArray{col}),col) = dataArray{col};
end
numericData = NaN(size(dataArray{1},1),size(dataArray,2));

for col=[7,10,11,12,13,14,18,19,20,21,24,27,30,31,32,33,39,40,41,42,48,49,50,51,57,58,59,60,66,67,68,69,75,76,77,78,84,85,86,87,93,94,95,96,102,103,104,105,111,112,113,114,120,121,122,123,129,130,131,132,147,148,154,155,156,157,158,159,160,161,162,163,164,165,170,171,172,173,174,175,176,177,178,179,180,181,212,213,214,215,216,217,218,219,220,221,222,223]
    % Converts strings in the input cell array to numbers. Replaced non-numeric
    % strings with NaN.
    rawData = dataArray{col};
    for row=1:size(rawData, 1);
        % Create a regular expression to detect and remove non-numeric prefixes and
        % suffixes.
        regexstr = '(?<prefix>.*?)(?<numbers>([-]*(\d+[\,]*)+[\.]{0,1}\d*[eEdD]{0,1}[-+]*\d*[i]{0,1})|([-]*(\d+[\,]*)*[\.]{1,1}\d+[eEdD]{0,1}[-+]*\d*[i]{0,1}))(?<suffix>.*)';
        try
            result = regexp(rawData{row}, regexstr, 'names');
            numbers = result.numbers;
            
            % Detected commas in non-thousand locations.
            invalidThousandsSeparator = false;
            if any(numbers==',');
                thousandsRegExp = '^\d+?(\,\d{3})*\.{0,1}\d*$';
                if isempty(regexp(numbers, thousandsRegExp, 'once'));
                    numbers = NaN;
                    invalidThousandsSeparator = true;
                end
            end
            % Convert numeric strings to numbers.
            if ~invalidThousandsSeparator;
                numbers = textscan(strrep(numbers, ',', ''), '%f');
                numericData(row, col) = numbers{1};
                raw{row, col} = numbers{1};
            end
        catch me
        end
    end
end


%% Split data into numeric and cell columns.
rawNumericColumns = raw(:, [7,10,11,12,13,14,18,19,20,21,24,27,30,31,32,33,39,40,41,42,48,49,50,51,57,58,59,60,66,67,68,69,75,76,77,78,84,85,86,87,93,94,95,96,102,103,104,105,111,112,113,114,120,121,122,123,129,130,131,132,147,148,154,155,156,157,158,159,160,161,162,163,164,165,170,171,172,173,174,175,176,177,178,179,180,181,212,213,214,215,216,217,218,219,220,221,222,223]);
rawCellColumns = raw(:, [1,2,3,4,5,6,8,9,15,16,17,22,23,25,26,28,29,34,35,36,37,38,43,44,45,46,47,52,53,54,55,56,61,62,63,64,65,70,71,72,73,74,79,80,81,82,83,88,89,90,91,92,97,98,99,100,101,106,107,108,109,110,115,116,117,118,119,124,125,126,127,128,133,134,135,136,137,138,139,140,141,142,143,144,145,146,149,150,151,152,153,166,167,168,169,182,183,184,185,186,187,188,189,190,191,192,193,194,195,196,197,198,199,200,201,202,203,204,205,206,207,208,209,210,211,224,225,226]);


%% Replace non-numeric cells with NaN
R = cellfun(@(x) ~isnumeric(x) && ~islogical(x),rawNumericColumns); % Find non-numeric cells
rawNumericColumns(R) = {NaN}; % Replace non-numeric cells

%% Allocate imported array to column variable names
V1 = rawCellColumns(:, 1);
V2 = rawCellColumns(:, 2);
V3 = rawCellColumns(:, 3);
V4 = rawCellColumns(:, 4);
V5 = rawCellColumns(:, 5);
V6 = rawCellColumns(:, 6);
V7 = cell2mat(rawNumericColumns(:, 1));
V8 = rawCellColumns(:, 7);
V9 = rawCellColumns(:, 8);
V10 = cell2mat(rawNumericColumns(:, 2));
SC0_0 = cell2mat(rawNumericColumns(:, 3));
SC0_1 = cell2mat(rawNumericColumns(:, 4));
SC0_2 = cell2mat(rawNumericColumns(:, 5));
SubjectID = cell2mat(rawNumericColumns(:, 6));
RecipientFirstName = rawCellColumns(:, 9);
RecipientLastName = rawCellColumns(:, 10);
Source = rawCellColumns(:, 11);
Month = cell2mat(rawNumericColumns(:, 7));
Year = cell2mat(rawNumericColumns(:, 8));
ImageSet = cell2mat(rawNumericColumns(:, 9));
instructions = cell2mat(rawNumericColumns(:, 10));
meta_1_TEXT = rawCellColumns(:, 12);
meta_2_TEXT = rawCellColumns(:, 13);
meta_3_TEXT = cell2mat(rawNumericColumns(:, 11));
meta_4_TEXT = rawCellColumns(:, 14);
meta_5_TEXT = rawCellColumns(:, 15);
meta_6_TEXT = cell2mat(rawNumericColumns(:, 12));
meta_7_TEXT = rawCellColumns(:, 16);
pd_instructions = rawCellColumns(:, 17);
compass1 = cell2mat(rawNumericColumns(:, 13));
compass2 = cell2mat(rawNumericColumns(:, 14));
compass3 = cell2mat(rawNumericColumns(:, 15));
compass4 = cell2mat(rawNumericColumns(:, 16));
Q873_1 = rawCellColumns(:, 18);
Q873_2 = rawCellColumns(:, 19);
Q873_3 = rawCellColumns(:, 20);
Q873_4 = rawCellColumns(:, 21);
pd_timing = rawCellColumns(:, 22);
coin1 = cell2mat(rawNumericColumns(:, 17));
coin2 = cell2mat(rawNumericColumns(:, 18));
coin3 = cell2mat(rawNumericColumns(:, 19));
coin4 = cell2mat(rawNumericColumns(:, 20));
pd_timing_1 = rawCellColumns(:, 23);
pd_timing_2 = rawCellColumns(:, 24);
pd_timing_3 = rawCellColumns(:, 25);
pd_timing_4 = rawCellColumns(:, 26);
pd_instructions1 = rawCellColumns(:, 27);
egg1 = cell2mat(rawNumericColumns(:, 21));
egg2 = cell2mat(rawNumericColumns(:, 22));
egg3 = cell2mat(rawNumericColumns(:, 23));
egg4 = cell2mat(rawNumericColumns(:, 24));
pd_timing_5 = rawCellColumns(:, 28);
pd_timing_6 = rawCellColumns(:, 29);
pd_timing_7 = rawCellColumns(:, 30);
pd_timing_8 = rawCellColumns(:, 31);
pd_instructions2 = rawCellColumns(:, 32);
grater1 = cell2mat(rawNumericColumns(:, 25));
grater2 = cell2mat(rawNumericColumns(:, 26));
grater3 = cell2mat(rawNumericColumns(:, 27));
grater4 = cell2mat(rawNumericColumns(:, 28));
pd_timing_9 = rawCellColumns(:, 33);
pd_timing_10 = rawCellColumns(:, 34);
pd_timing_11 = rawCellColumns(:, 35);
pd_timing_12 = rawCellColumns(:, 36);
pd_instructions3 = rawCellColumns(:, 37);
feather1 = cell2mat(rawNumericColumns(:, 29));
feather2 = cell2mat(rawNumericColumns(:, 30));
feather3 = cell2mat(rawNumericColumns(:, 31));
feather4 = cell2mat(rawNumericColumns(:, 32));
pd_timing_13 = rawCellColumns(:, 38);
pd_timing_14 = rawCellColumns(:, 39);
pd_timing_15 = rawCellColumns(:, 40);
pd_timing_16 = rawCellColumns(:, 41);
pd_instructions4 = rawCellColumns(:, 42);
camera1 = cell2mat(rawNumericColumns(:, 33));
camera2 = cell2mat(rawNumericColumns(:, 34));
camera3 = cell2mat(rawNumericColumns(:, 35));
camera4 = cell2mat(rawNumericColumns(:, 36));
pd_timing_17 = rawCellColumns(:, 43);
pd_timing_18 = rawCellColumns(:, 44);
pd_timing_19 = rawCellColumns(:, 45);
pd_timing_20 = rawCellColumns(:, 46);
pd_instructions5 = rawCellColumns(:, 47);
dolls1 = cell2mat(rawNumericColumns(:, 37));
dolls2 = cell2mat(rawNumericColumns(:, 38));
dolls3 = cell2mat(rawNumericColumns(:, 39));
dolls4 = cell2mat(rawNumericColumns(:, 40));
pd_timing_21 = rawCellColumns(:, 48);
pd_timing_22 = rawCellColumns(:, 49);
pd_timing_23 = rawCellColumns(:, 50);
pd_timing_24 = rawCellColumns(:, 51);
pd_instructions6 = rawCellColumns(:, 52);
bear1 = cell2mat(rawNumericColumns(:, 41));
bear2 = cell2mat(rawNumericColumns(:, 42));
bear3 = cell2mat(rawNumericColumns(:, 43));
bear4 = cell2mat(rawNumericColumns(:, 44));
pd_timing_25 = rawCellColumns(:, 53);
pd_timing_26 = rawCellColumns(:, 54);
pd_timing_27 = rawCellColumns(:, 55);
pd_timing_28 = rawCellColumns(:, 56);
pd_instructions7 = rawCellColumns(:, 57);
box1 = cell2mat(rawNumericColumns(:, 45));
box2 = cell2mat(rawNumericColumns(:, 46));
box3 = cell2mat(rawNumericColumns(:, 47));
box4 = cell2mat(rawNumericColumns(:, 48));
pd_timing_29 = rawCellColumns(:, 58);
pd_timing_30 = rawCellColumns(:, 59);
pd_timing_31 = rawCellColumns(:, 60);
pd_timing_32 = rawCellColumns(:, 61);
pd_Instructions = rawCellColumns(:, 62);
typewriter1 = cell2mat(rawNumericColumns(:, 49));
typewriter2 = cell2mat(rawNumericColumns(:, 50));
typewriter3 = cell2mat(rawNumericColumns(:, 51));
typewriter4 = cell2mat(rawNumericColumns(:, 52));
pd_timing_33 = rawCellColumns(:, 63);
pd_timing_34 = rawCellColumns(:, 64);
pd_timing_35 = rawCellColumns(:, 65);
pd_timing_36 = rawCellColumns(:, 66);
pd_instructions8 = rawCellColumns(:, 67);
skate1 = cell2mat(rawNumericColumns(:, 53));
skate2 = cell2mat(rawNumericColumns(:, 54));
skate3 = cell2mat(rawNumericColumns(:, 55));
skate4 = cell2mat(rawNumericColumns(:, 56));
pd_timing_37 = rawCellColumns(:, 68);
pd_timing_38 = rawCellColumns(:, 69);
pd_timing_39 = rawCellColumns(:, 70);
pd_timing_40 = rawCellColumns(:, 71);
pd_instructions9 = rawCellColumns(:, 72);
basket1 = cell2mat(rawNumericColumns(:, 57));
basket2 = cell2mat(rawNumericColumns(:, 58));
basket3 = cell2mat(rawNumericColumns(:, 59));
basket4 = cell2mat(rawNumericColumns(:, 60));
pd_timing_41 = rawCellColumns(:, 73);
pd_timing_42 = rawCellColumns(:, 74);
pd_timing_43 = rawCellColumns(:, 75);
pd_timing_44 = rawCellColumns(:, 76);
motor_timing_1 = rawCellColumns(:, 77);
motor_timing_2 = rawCellColumns(:, 78);
motor_timing_3 = rawCellColumns(:, 79);
motor_timing_4 = rawCellColumns(:, 80);
motor_instructions = rawCellColumns(:, 81);
motor1 = rawCellColumns(:, 82);
motor2 = rawCellColumns(:, 83);
motor3 = rawCellColumns(:, 84);
motor4 = rawCellColumns(:, 85);
motor5 = rawCellColumns(:, 86);
trails_timing_1 = cell2mat(rawNumericColumns(:, 61));
trails_timing_2 = cell2mat(rawNumericColumns(:, 62));
trails_timing_3 = rawCellColumns(:, 87);
trails_timing_4 = rawCellColumns(:, 88);
trails_instructions = rawCellColumns(:, 89);
trails = rawCellColumns(:, 90);
ws_inst = rawCellColumns(:, 91);
ws_img_1 = cell2mat(rawNumericColumns(:, 63));
ws_img_2 = cell2mat(rawNumericColumns(:, 64));
ws_img_3 = cell2mat(rawNumericColumns(:, 65));
ws_img_4 = cell2mat(rawNumericColumns(:, 66));
ws_img_5 = cell2mat(rawNumericColumns(:, 67));
ws_img_6 = cell2mat(rawNumericColumns(:, 68));
ws_img_7 = cell2mat(rawNumericColumns(:, 69));
ws_img_8 = cell2mat(rawNumericColumns(:, 70));
ws_img_9 = cell2mat(rawNumericColumns(:, 71));
ws_img_10 = cell2mat(rawNumericColumns(:, 72));
ws_img_11 = cell2mat(rawNumericColumns(:, 73));
ws_img_12 = cell2mat(rawNumericColumns(:, 74));
ws_img_timing_1 = rawCellColumns(:, 92);
ws_img_timing_2 = rawCellColumns(:, 93);
ws_img_timing_3 = rawCellColumns(:, 94);
ws_img_timing_4 = rawCellColumns(:, 95);
ws_ans_1 = cell2mat(rawNumericColumns(:, 75));
ws_ans_2 = cell2mat(rawNumericColumns(:, 76));
ws_ans_3 = cell2mat(rawNumericColumns(:, 77));
ws_ans_4 = cell2mat(rawNumericColumns(:, 78));
ws_ans_5 = cell2mat(rawNumericColumns(:, 79));
ws_ans_6 = cell2mat(rawNumericColumns(:, 80));
ws_ans_7 = cell2mat(rawNumericColumns(:, 81));
ws_ans_8 = cell2mat(rawNumericColumns(:, 82));
ws_ans_9 = cell2mat(rawNumericColumns(:, 83));
ws_ans_10 = cell2mat(rawNumericColumns(:, 84));
ws_ans_11 = cell2mat(rawNumericColumns(:, 85));
ws_ans_12 = cell2mat(rawNumericColumns(:, 86));
ws_ans_timing_1 = rawCellColumns(:, 96);
ws_ans_timing_2 = rawCellColumns(:, 97);
ws_ans_timing_3 = rawCellColumns(:, 98);
ws_ans_timing_4 = rawCellColumns(:, 99);
ws_1_solution = rawCellColumns(:, 100);
ws_2_solution = rawCellColumns(:, 101);
ws_3_solution = rawCellColumns(:, 102);
ws_4_solution = rawCellColumns(:, 103);
ws_5_solution = rawCellColumns(:, 104);
ws_6_solution = rawCellColumns(:, 105);
ws_7_solution = rawCellColumns(:, 106);
ws_8_solution = rawCellColumns(:, 107);
ws_9_solution = rawCellColumns(:, 108);
ws_10_solution = rawCellColumns(:, 109);
ws_11_solution = rawCellColumns(:, 110);
ws_12_solutoin = rawCellColumns(:, 111);
motor_timing_2_1 = rawCellColumns(:, 112);
motor_timing_2_2 = rawCellColumns(:, 113);
motor_timing_2_3 = rawCellColumns(:, 114);
motor_timing_2_4 = rawCellColumns(:, 115);
motor_instructions1 = rawCellColumns(:, 116);
motor6 = rawCellColumns(:, 117);
motor7 = rawCellColumns(:, 118);
motor8 = rawCellColumns(:, 119);
motor9 = rawCellColumns(:, 120);
motor10 = rawCellColumns(:, 121);
pr_timing_1 = rawCellColumns(:, 122);
pr_timing_2 = rawCellColumns(:, 123);
pr_timing_3 = rawCellColumns(:, 124);
pr_timing_4 = rawCellColumns(:, 125);
box_recall = cell2mat(rawNumericColumns(:, 87));
typewriter_recall = cell2mat(rawNumericColumns(:, 88));
skate_recall = cell2mat(rawNumericColumns(:, 89));
basket_recall = cell2mat(rawNumericColumns(:, 90));
bear_recall = cell2mat(rawNumericColumns(:, 91));
dolls_recall = cell2mat(rawNumericColumns(:, 92));
camera_recall = cell2mat(rawNumericColumns(:, 93));
feather_recall = cell2mat(rawNumericColumns(:, 94));
grater_recall = cell2mat(rawNumericColumns(:, 95));
egg_recall = cell2mat(rawNumericColumns(:, 96));
coin_recall = cell2mat(rawNumericColumns(:, 97));
compass_recall = cell2mat(rawNumericColumns(:, 98));
LocationLatitude = rawCellColumns(:, 126);
LocationLongitude = rawCellColumns(:, 127);
LocationAccuracy = rawCellColumns(:, 128);


%% Clear temporary variables
clearvars filename delimiter startRow formatSpec fileID dataArray ans raw col numericData rawData row regexstr result numbers invalidThousandsSeparator thousandsRegExp me rawNumericColumns rawCellColumns R;
% Rename some of the variables from Qualtrics defaults
ResponseID = V1;
StartDate = V8;
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% Word Search: parse the Qualtrics data to determine which word search was
% %% and determine if the correct answer was chosen
% 
% % Get the column names in the Qualtrics spreadsheet
% colnames = whos;
% 
% % Set up an array to hold the displayed words 
% displayed = zeros(size(ResponseID));
% % Loop through all the column names
% for c = 1 : numel(colnames)
%     % Look for columns that are associated with the displayed word search.
%     % They start with 'ws_img_' but skip ones that also include 'timing.'
%     % We just want the displayed word search 
%     if strfind(colnames(c).name, 'ws_img_') ...
%         & isempty(strfind(colnames(c).name, 'timing'))
%         % From the column name, get the number of the word search
%         % possibility (1 - 12)
%         wsnum = str2double(regexprep(colnames(c).name,'ws_img_',''));
%         % get the content of the current column
%         colvals = eval(colnames(c).name);
%         % replace any NaN's with 0
%         colvals(isnan(colvals)) = 0;
%         % loop through all the rows of the column. There will be one row
%         % for each survey response
%         for r = 1 : length(colvals)
%             % if that row number is 1, this word search was displayed for
%             % that particular survey response
%             if colvals(r) == 1
%                 displayed(r) = wsnum;
%             end
%         end
%     end
% end
% 
% % Now set up an array to hold the word search answers
% answers = zeros(size(ResponseID));
% % Again loop through all the columns
% for c = 1 : numel(colnames)
%     % Find columns comtaining 'ws_ans_' but not 'timing'
%     if strfind(colnames(c).name, 'ws_ans_') ...
%         & isempty(strfind(colnames(c).name, 'timing'))
%         % get all rows for this column
%         colvals = eval(colnames(c).name);
%         colvals(isnan(colvals)) = 0;
%         % sum up the column values. For most, this will be zero except for
%         % the column associated with the answer for the displayed word
%         % search. The answer will be either 0 (incorrect) or 1 (correct)
%         answers = answers + colvals;
%     end
% end
% % Create array to hold correct vs incorrect values
% correct = cell(size(ResponseID));
% % Detemine if the selected answer was correct or incorrect
% for a = 1:length(answers)
%     if answers(a) == 1
%         correct{a} = 'true';
%     else
%         correct{a} = 'false';
%     end
% end
% 
% % We determined the index value of the word displayed. Now match that up to
% % our list of possible words. 
% % Possible words that could be displayed in the word search
% words = {'CHERRY', 'PEAR', 'BEET', 'CARROT', 'LIGHTNING', 'WINDY', ...
%     'GORILLA', 'ORANGUTAN', 'ELEVATOR', 'BICYCLE', 'BIRCH', 'PLUM'};
% wordsDisplayed = cell(size(ResponseID));
% 
% for d = 1 : length(displayed)
%     if displayed(d) > 0
%         wordsDisplayed{d} = words{displayed(d)};
%     else
%         wordsDisplayed{d} = 'Survey not complete';
%     end
% end
% % Create a cell array of the subject IDs just to make xlswrite happy
% Subject = cell(size(ResponseID));
% for s = 1 : length(Subject)
%     Subject{s} = SubjectID(s);
% end
% % Now find the OADC numbers for each Subject ID
% import Orcatech.MySQL
% import Orcatech.IdArray
% import Orcatech.Databases.Subjects
% import Orcatech.Databases.AlgorithmResults
% 
% o = Orcatech.Interface('rileyt','feb=21');
% MySQL.connect(Subjects.SERVER);
% OADC = cell(size(ResponseID));
% dates = cell(size(ResponseID));
% for s = 1 : length(SubjectID);
%     subjectId = SubjectID(s); 
%     if isnan(subjectId)
%         OADC{s} = 0;
%     else
%         query = ['select OADC from subjects_new.subjects where idx = '  num2str(subjectId) ]; 
%         OADC{s} = mysql(query);
%     end
%     % Save dates in a cell array to make xlswrite happy
%     dates{s} = datestr(StartDate(s));
% end
% 
% mysql('close')
% 
% % Save all out output to a cell matrix for writing to a spreadsheet
% output = [OADC, Subject, ResponseID, dates, wordsDisplayed, correct];
% % Choose a filename to save to
% [file, path] = uiputfile('*.xlsx', 'Save file name');
% filename = fullfile(path, file);
% % Write to the first sheet of the spreadsheet
% sheet = 'Word Search';
% % Create column labels
% labels = {'OADC', 'SubjectID', 'ResponseID', 'Date', 'Word Displayed', 'Correct'};
% xlswrite(filename, labels, sheet, 'A1');
% % Write the data to the spreadsheet
% for r = 2 : length(output)+1
%     startCell = ['A' num2str(r)];
%     row = output(r-1, :);
%     xlswrite(filename, row, sheet, startCell);
% end
% disp('Word search data written')
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% Memory task: the memory task consists of a picture displayed at the beginning
% % of the survey and a question at the end of the survey asking the user to
% % choose the picture displayed from four possible choices
% 
% % Names of pictures that could possibly be displayed
% picturetypes = {'compass', 'coin', 'egg', 'grater', 'feather', 'camera', ...
%     'dolls', 'bear', 'box', 'typewriter', 'skate', 'basket'};
% % Set up an array to hold a code generated for each column of pictures
% numRows = length(ResponseID);
% picturedisplayed = {};
% displaycode = zeros(numRows,1);
% % Get names of columns from the spreadsheet
% colnames = whos;
% 
% % factor is used to generate a unique number for each column of pictures
% factor = 2;
% % Loop over all the possible pictures
% for p = 1 : length(picturetypes) 
%     % factor is used for generating unique code for each picture
%     factor = factor * 2;
%     for c = 1 : numel(colnames)
%         picturetype = picturetypes{p};
%         % find the column associated with this picture type
%         % since one of the picture types is 'box' we need to exclude
%         % columns containing 'textboxes
%         % we'll also exclude the 'recall' columns, of which there is one
%         % for each picture type to hold answerrs
%         if strfind(colnames(c).name, picturetype)
%             if isempty(strfind(colnames(c).name, 'recall')) ... 
%                     & isempty(strfind(colnames(c).name, 'textboxes'))
%                 % Each of the possible answers is numbered 1 - 4. Use these
%                 % numbers as part of generating a unique code for each
%                 % possible answer
%                 add = str2double(regexprep(colnames(c).name,picturetype,''));
%                 code = factor+add;
%                 % get all the rows for a given column
%                 colvals = eval(colnames(c).name);
%                 colvals(isnan(colvals)) = 0;
%                 displaypic{code} = colnames(c).name;
%                 % record the code for the image that wass displayed
%                 displaycode = displaycode + code*colvals;  
%             end
%         end  
%     end
% end
% 
% % figure out which was displayed
% clear displayed
% for n = 1 : length(displaycode)
%     if displaycode(n) > 0
%         displayed{n} = displaypic{displaycode(n)};
%     else
%         displayed{n} = displaypic{displaycode(1)};
%     end
% end
% % Check the 'recall' column to determine which picture was chosen out of
% % the four options
% chosen = cell(size(ResponseID));
% for p = 1 : length(picturetypes) 
%     for c = 1 : numel(colnames)
%         picturetype = picturetypes{p};
%         if strfind(colnames(c).name, [picturetype '_recall'])
%             colvals = eval(colnames(c).name);
%             for n = 1 : length(colvals)
%                 if ~isnan(colvals(n)) 
%                     if colvals(n) == 100
%                         chosen{n} = 'None of these';
%                     elseif colvals(n) == 101
%                         chosen{n} = 'I don''t remember seeing a picture';
%                     else
%                         chosen{n} = [picturetype num2str(colvals(n))];
%                     end
%                 end
%             end
%         end  
%     end
% end
% % Check if the chosen answer was correct or nott
% match = cell(size(ResponseID));
% for n = 1 : length(chosen)
%     if strcmp(chosen{n}, displayed{n})
%         match{n} = 'true';
%     else
%         match{n} = 'false';
%     end
% end
% 
% % Save subject IDs as a cell array to make xlswrite happy
% Subject = cell(size(ResponseID));
% for s = 1 : length(Subject)
%     Subject{s} = SubjectID(s);
% end
% 
% % Get an OADC number for each subject number
% import Orcatech.MySQL
% import Orcatech.IdArray
% import Orcatech.Databases.Subjects
% import Orcatech.Databases.AlgorithmResults
% 
% o = Orcatech.Interface('rileyt','feb=21');
% MySQL.connect(Subjects.SERVER);
% OADC = cell(size(ResponseID));
% dates = cell(size(ResponseID));
% for s = 1 : length(SubjectID);
%     subjectId = SubjectID(s); 
%     if isnan(subjectId)
%         OADC{s} = 0;
%     else
%         query = ['select OADC from subjects_new.subjects where idx = '  num2str(subjectId) ]; 
%         OADC{s} = mysql(query);
%     end
%     % Save date in a cell to make xlswrite happy
%     dates{s} = datestr(StartDate(s));
% end
% % Save data as a cell matrix to write to spreadsheet
% output = [OADC, Subject, ResponseID, dates, displayed', chosen, match];
% mysql('close')
% 
% % Write to the second sheet of the spreadsheet
% sheet = 'Memory Task';
% % Create column labels
% labels = {'OADC', 'SubjectID', 'ResponseID', 'Date', 'Picture Displayed', 'Picture Chosen', 'Correct'};
% xlswrite(filename, labels, sheet, 'A1');
% % Write the data to the spreadsheet
% 
% for r = 2 : length(output)+1
%     startCell = ['A' num2str(r)];
%     row = output(r-1, :);
%     xlswrite(filename, row, sheet, startCell);
% end
% disp('Memory task data written')
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% Trails Times
% % This sheet will be the total amount of time spent on the trails test task
% % loop through all the OADC numbers
% import Orcatech.MySQL
% import Orcatech.IdArray
% import Orcatech.Databases.Subjects
% import Orcatech.Databases.AlgorithmResults
% 
% o = Orcatech.Interface('rileyt','feb=21');
% MySQL.connect(Subjects.SERVER);
% % Set up cell arrays to make xlswrite happy
% OADC = cell(size(ResponseID));
% dates = cell(size(ResponseID));
% subjId = cell(size(ResponseID));
% trailtimes = cell(size(ResponseID));
% % subtract trails times from the Qualtrics raw daya to get the total time
% % spent on the trails task n
% trails_times = trails_timing_2 - trails_timing_1;
% % Loop through subject ids, getting OADC numbers and writing the rest of
% % the data in the cell arrays
% for s = 1 : length(SubjectID);
%     subjectId = SubjectID(s); 
%     if isnan(subjectId)
%         OADC{s} = 0;
%     else
%         query = ['select OADC from subjects_new.subjects where idx = '  num2str(subjectId) ]; 
%         OADC{s} = mysql(query);
%     end
%     dates{s} = datestr(StartDate(s));
%     subjId{s} = SubjectID(s);
%     trailtimes{s} = trails_times(s);
% end
% mysql('close')
% 
% % Write the data to a new sheet in the spreadsheet
% output = [OADC, subjId, ResponseID, dates, trailtimes];
% sheet = 'Trails Task Time';
% % Label the spreadsheet columns
% row = {'OADC', 'SubjectID', 'ResponseID', 'StartDate', 'TrailTimes'};
% xlswrite(filename, row, sheet, 'A1');
% for r = 1 : length(output)
%     startCell = ['A' num2str(r+1)];
%     row = output(r, :);
%     xlswrite(filename, row, sheet, startCell);
% end
% disp('Trails times data written');
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% Mouse metrics
% 
% clear output
% 
% % get OADC numbers 
% % loop through all the OADC numbers
% import Orcatech.MySQL
% import Orcatech.IdArray
% import Orcatech.Databases.Subjects
% import Orcatech.Databases.AlgorithmResults
% 
% o = Orcatech.Interface('rileyt','feb=21');
% MySQL.connect(Subjects.SERVER);
% 
% % Subject IDs are loaded from spreadsheet of survey results
% del = isnan(SubjectID);
% SubjectID(del) = [];
% StartDate(del) = [];
% subjectIds = unique(SubjectID);
% 
% index = 1;
% 
% % set up indices to hold total times for each subject's trails test
% trailsTimes = [];
% trailsOADC = [];
% trailsDate = [];
% 
% % loop through the subject ids
% for s = 1 : length(SubjectID);
%     subjectId = SubjectID(s); 
%     disp(['Subject ID ' num2str(subjectId)])
%     query = ['select OADC from subjects_new.subjects where idx = '  num2str(subjectId) ]; 
%     OADC = mysql(query);
%     date = StartDate(s);
%     disp(['OADC ' num2str(OADC)])
%     % Set up arrays to hold values
%     imagehovervalues = [];
%     mousex = [];
%     mousey = [];
%     mousebutton = [];
%     textboxactive = [];
%     stamp = [];
%     mousebuttondown = []; % this equals 0 when mouse button is released
%     textbox = [];
%     % the data is pulled down in 5,000 line pages. Keep pulling down data
%     % until the last page flag is true
%     page = 1;
%     lastpage = 0;
%     
%     while lastpage == 0
%         % Get a page of data
%         mousedate = '201612';
%         urltext=['https://juno.orcatech.org/php/healthforms/loadFormsUserInputBySubjIdSurveyIdYearMonth.php?s=' ...
%             num2str(subjectId) '&ym=' mousedate '&p=' num2str(page) '&sv=8wEcKa486I0Jenj'];
%         rawdata = urlread(urltext);
% 
%         % the raw data is formatted as a Matlab struct. Read the struct
%         try
%             structContents = eval(rawdata);
%         % occasionally the data is corrupted - toss cases that don't work
%         catch
%             disp([ num2str(subjectId) ' did not work'])
%             lastpage = 2;
%             continue;
%         end
%         % collect the data from the struct
%         for i = 1:length(structContents.data)
%             imagehovervalues = [imagehovervalues structContents.data(i).imagehover];
%             mousex = [mousex structContents.data(i).mousex];
%             mousey = [mousey structContents.data(i).mousey];
%             mousebutton = [mousebutton structContents.data(i).mousebutton];
%             mousebuttondown = [mousebuttondown structContents.data(i).mousebuttondown];
%             stamp = [stamp structContents.data(i).stamp];
%             % 1 when entering, 0 when leaving, otherwise -1
%             textboxactive = [textboxactive structContents.data(i).textboxactive];
%             % string when textbox active is one or zero
%             structContents.data(i).textboxactive;
%             if structContents.data(i).textboxactive > -1
%                 structContents.data(i).textbox;
%             end
%             textbox = [textbox structContents.data(i).textbox];
%         end
%         page = page + 1; 
%         lastpage = structContents.lastpage;
%     end
%     % find the indices of mouse clicks
%     clicks = find(mousebuttondown == 0);
% 
%     % find when the cursor enters then leaves the trails image
%     currentImOne = find(imagehovervalues == 1);
%     currentImZero = find(imagehovervalues == 0);
% 
%     if ~isempty(currentImOne) & ~isempty(currentImZero)
%         % the trails are marked by the first image hover value == 1 and the
%         % last value == 0
%         trails = currentImOne(1):currentImZero(end);
%         trailsClicks = intersect(trails, clicks);
%         % group the mouse positions into movements separated by clicks
%         totalTrailsTime = 0;
%         for c = 2:length(trailsClicks)
%             section = trailsClicks(c-1):trailsClicks(c);
%             %plot(mousex(section), mousey(section))
%             % does the mouse cursor info contain -1?
%             containsNegOne = 0;
%             if min(mousex(section)) == -1
%                 containsNegOne = 1;
%             end
%             if containsNegOne == 0
%                 % calculate statistics
%                 % straight line distance
%                 dx = mousex(section(end)) - mousex(section(1));
%                 dy = mousey(section(end)) - mousey(section(1));
%                 Delta = sqrt(dx^2 + dy^2);
%                 % actual distance traveled
%                 dx2 = diff(mousex(section));
%                 dy2 = diff(mousey(section));
%                 D = sum(sqrt(dx2.^2 + dy2.^2));
%                 % curvature
%                 K = Delta/D;
%                 % K = (straight line distance)/(actual distance traveled)
%                 % time elapsed
%                 T = stamp(section(end)) - stamp(section(1));
%                 
%                 % SUM UP MOUSE TIMES TO GET TOTAL TRAILS TIME
%                 totalTrailsTime = totalTrailsTime + T;
%                 
%                 if Delta > 0
%                 output(index).Delta = Delta;
%                 output(index).D = D;
%                 output(index).K = K;
%                 output(index).T = T;
%                 output(index).OADC = OADC;
%                 output(index).date = date;
%                 index = index+ 1;
%                 end
%                 % pause from the moment of the 
%                 pause = stamp(section(2)) - stamp(section(1));
%             end
%         end
%     end
% end
% 
% mysql('close')
% 
% sheet = 'Mouse Metrics';
% allD = [];
% allDelta = [];
% allK = [];
% allT = [];
% allOADC = [];
% row = {'OADC', 'Date', 'Delta', 'D', 'K', 'Time'};
% xlswrite(filename, row, sheet, 'A1');
% for n = 1 : length(output)
%     startCell = ['A' num2str(n+1)];
%     Delta = output(n).Delta;
%     D = output(n).D;
%     K = output(n).K;
%     T = output(n).T;
%     allD = [allD D];
%     allDelta = [allDelta Delta];
%     allK = [allK K];
%     allT = [allT T];
%     OADC = output(n).OADC;
%     allOADC = [allOADC OADC];
%     date = output(n).date;
%     row = {OADC, datestr(date), Delta, D, K, T};
%     xlswrite(filename, row, sheet, startCell);
% end
% disp('Mouse metrics written')
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% Typing errors
% answer1 = 'the sun rises in the east';
% answer2 = 'did you have a good time';
% answer3 = 'space is a high priority';
% answer4 = 'you are a wonderful example';
% answer5 = 'what you see is what you get';
% answer6 = 'do not say anything';
% answer7 = 'all work and no play';
% answer8 = 'hair gel is very greasy';
% answer9 = 'the dreamers of dreams';
% answer10 = 'all together in one big pile';
% 
% for n = 1 : length(motor1)
%     if isempty(motor1{n})
%         numErrors1(n) = NaN;
%     else
%         numErrors1(n) = MinimumStringDistance(answer1, motor1{n});
%     end
% end
% 
% for n = 1 : length(motor2)
%     if isempty(motor2{n})
%         numErrors2(n) = NaN;
%     else
%         numErrors2(n) = MinimumStringDistance(answer2, motor2{n});
%     end
% end
% 
% for n = 1 : length(motor3)
%     if isempty(motor3{n})
%         numErrors3(n) = NaN;
%     else
%         numErrors3(n) = MinimumStringDistance(answer3, motor3{n});
%     end
% end
% 
% for n = 1 : length(motor4)
%     if isempty(motor4{n})
%         numErrors4(n) = NaN;
%     else
%         numErrors4(n) = MinimumStringDistance(answer4, motor4{n});
%     end
% end
% 
% for n = 1 : length(motor5)
%     if isempty(motor5{n})
%         numErrors5(n) = NaN;
%     else
%         numErrors5(n) = MinimumStringDistance(answer5, motor5{n});
%     end
% end
% 
% for n = 1 : length(motor6)
%     if isempty(motor6{n})
%         numErrors6(n) = NaN;
%     else
%         numErrors6(n) = MinimumStringDistance(answer6, motor6{n});
%     end
% end
% 
% for n = 1 : length(motor7)
%     if isempty(motor7{n})
%         numErrors7(n) = NaN;
%     else
%         numErrors7(n) = MinimumStringDistance(answer7, motor7{n});
%     end
% end
% 
% for n = 1 : length(motor8)
%     if isempty(motor8{n})
%         numErrors8(n) = NaN;
%     else
%         numErrors8(n) = MinimumStringDistance(answer8, motor8{n});
%     end
% end
% 
% for n = 1 : length(motor9)
%     if isempty(motor9{n})
%         numErrors9(n) = NaN;
%     else
%         numErrors9(n) = MinimumStringDistance(answer9, motor9{n});
%     end
% end
% 
% for n = 1 : length(motor10)
%     if isempty(motor10{n})
%         numErrors10(n) = NaN;
%     else
%         numErrors10(n) = MinimumStringDistance(answer10, motor10{n});
%     end
% end
% 
% % loop through all the OADC numbers
% import Orcatech.MySQL
% import Orcatech.IdArray
% import Orcatech.Databases.Subjects
% import Orcatech.Databases.AlgorithmResults
% 
% o = Orcatech.Interface('rileyt','feb=21');
% MySQL.connect(Subjects.SERVER);
% OADC = cell(size(ResponseID));
% dates = cell(size(ResponseID));
% subjId = cell(size(ResponseID));
% err1 = cell(size(ResponseID));
% err2 = cell(size(ResponseID));
% err3 = cell(size(ResponseID));
% err4 = cell(size(ResponseID));
% err5 = cell(size(ResponseID));
% err6 = cell(size(ResponseID));
% err7 = cell(size(ResponseID));
% err8 = cell(size(ResponseID));
% err9 = cell(size(ResponseID));
% err10 = cell(size(ResponseID));
% for s = 1 : length(SubjectID);
%     subjectId = SubjectID(s); 
%     if isnan(subjectId)
%         OADC{s} = 0;
%     else
%         query = ['select OADC from subjects_new.subjects where idx = '  num2str(subjectId) ]; 
%         OADC{s} = mysql(query);
%     end
%     dates{s} = datestr(StartDate(s));
%     subjId{s} = SubjectID(s);
%     err1{s} = numErrors1(s);
%     err2{s} = numErrors2(s);
%     err3{s} = numErrors3(s);
%     err4{s} = numErrors4(s);
%     err5{s} = numErrors5(s);
%     err6{s} = numErrors6(s);
%     err7{s} = numErrors7(s);
%     err8{s} = numErrors8(s);
%     err9{s} = numErrors9(s);
%     err10{s} = numErrors10(s);
% end
% 
% mysql('close')
% 
% output = [OADC, subjId, ResponseID, dates, err1, err2, err3, err4, err5, ...
%     err6, err7, err8, err9, err10];
% 
% sheet = 'Typing Errors';
% row = {'OADC', 'SubjectID', 'ResponseID', 'StartDate', 'Motor1Err', 'Motor2Err', ...
%     'Motor3Err', 'Motor4Err', 'Motor5Err', 'Motor6Err', 'Motor7Err', 'Motor8Err', ...
%     'Motor9Err', 'Motor10Err'};
% xlswrite(filename, row, sheet, 'A1');
% for r = 1 : length(output)
%     startCell = ['A' num2str(r+1)];
%     row = output(r, :);
%     xlswrite(filename, row, sheet, startCell);
% end
% 
% disp('Typing errors written')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Typing times
del = isnan(SubjectID);
SubjectID(del) = [];
StartDate(del) = [];
%subjectIds = unique(SubjectID);

allT = [];
allSubject = [];
allDate = [];
allResponseID = [];
for s = 1 : length(SubjectID);
    subjectId = SubjectID(s);
    thisdate = StartDate(s);
    response = ResponseID(s);
    % set up arrays to hold textbox status and time stamp values
    stamp = [];
    textbox = [];
    t = 1;
    % the data is pulled down in 5,000 line pages. Keep pulling down data
    % until the last page flag is true
    page = 1;
    lastpage = 0;
    while lastpage == 0
        %urltext= ['https://juno.orcatech.org/php/healthforms/loadFormsUserInputBySubjIdSurveyIdYearMonth.php?s=' num2str(subjectId) '&ym=201611&p=' num2str(page) '&sv=8wEcKa486I0Jenj']
        urltext1= 'https://juno.orcatech.org/php/healthforms/loadFormsUserInputBySubjIdYearMonth.php?s=';
        urltext2 = [num2str(subjectId) '&ym=201611&p=' num2str(page)];
        urltext = [urltext1 urltext2];
        rawdata = urlread(urltext);
        
        % the raw data is formatted as a Matlab struct. Read the struct
        try
            structContents = eval(rawdata);
        catch
            disp([ num2str(subjectId) ' did not work'])
            lastpage = 2;
            continue
        end
        % collect the data from the struct
        for i = 1:length(structContents.data)
            stamp = [stamp structContents.data(i).stamp];
            textbox{t} = structContents.data(i).textbox;
            t = t + 1;
        end
        page = page + 1; 
        lastpage = structContents.lastpage;
    end
    % There are up to ten text boxes with start and stop times recorded
    % Set up an array to hold these possible values
    for i = 1 : 10
        textarray(i).times = 0;
    end
    
    % Loop through all the rows of data for this survey
    for i = 1 : length(textbox)
        % if a text box was active, the textbox value will not be equal to
        % -1. It will contain the label of the active text box, such as
        % 'motor1'
        
        if strcmp(textbox{i}, '-1') == 0
            textbox{i}
            index = str2double(strrep(textbox{i}, 'motor', ''));
            if ~isnan(index)
                textarray(index).times = [textarray(index).times stamp(i)];
            end
        end
    end
    
%     for n = 1 : length(textarray)
%         textarray(n).times
%     end
    % Loop through the array of collected time stamps
    for i = 1 : 10
        % get the collected time stamps for a certain text box
        times = textarray(i).times;
        % each list will have at least one value, since we seeded the array
        % with zeros before collecting values. Ideally, the box should then
        % three values - the zero, the start time and end time. If we have
        % the right number of values, calculate the typing time
        if length(times) >= 3
            textarray(i).typingtime = times(3) - times(2);
            disp(['Typing time for box ' num2str(i) ' and subject ' num2str(subjectId) ': ' num2str(times(3) - times(2))])
            allT = [allT times(3) - times(2)];
            allSubject = [allSubject subjectId];
            allDate = [allDate thisdate];
            allResponseID = [allResponseID response];
            % sometimes a value isn't captured for the start or end of typing.
        % In that case, save a NaN value for this text box.
        else
            textarray(i).typingtime = NaN;
        end
    end
end

import Orcatech.MySQL
import Orcatech.IdArray
import Orcatech.Databases.Subjects
import Orcatech.Databases.AlgorithmResults

o = Orcatech.Interface('rileyt','feb=21');
MySQL.connect(Subjects.SERVER);
OADC = cell(size(allSubject));

for s = 1 : length(allSubject);
    subjectId = allSubject(s); 
    if isnan(subjectId)
        OADC{s} = 0;
    else
        query = ['select OADC from subjects_new.subjects where idx = '  num2str(subjectId) ]; 
        OADC{s} = mysql(query);
    end
end

mysql('close')

sheet = 'Typing Times';
row = {'OADC', 'SubjectID', 'ResponseID', 'Typing Time', 'Date'};
xlswrite(filename, row, sheet, 'A1');
for t = 1 : length(allT)
    startCell = ['A' num2str(t+1)];
    row = {OADC{t}, allSubject(t), allResponseID(t), allT(t), allDate{t}};
    xlswrite(filename, row, sheet, startCell);
end

disp('Typing errors written')

