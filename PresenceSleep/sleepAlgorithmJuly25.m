import Orcatech.Algorithms.Sleep
import Orcatech.Flags.Areas

%%% DETERMINE WHICH ROOM THE PERSON IS SLEEPING IN
% Get the data for a given homeid and a time period between 11 pm on a given
% date and 5 am the following day - we will assume the person is asleep
% between these times
year = 2017;
month = 5;
day = 11;
homeid = 1115;
startdate = datenum([year month day 11 0 0]);
enddate = datenum([year month day+1 5 0 0]);
[ stamp, itemidx_nyce, areaid_nyce, event] = Orcatech.Databases.SensorData.getPresenceSensorData(homeid, startdate, enddate);
areaid_nyce
% We'll look at which room has the greatest number of presence firings
% (event = 32)
% First, we'll get the indices of all the 32 firings
i = find(event == 32);
% next get the area ids that correspond to these 
roomsWithPresence = areaid_nyce(i);
listOfRoomsWithPresence = unique(roomsWithPresence);
% Loop through the list and count how many 32 firings were found for this
% particular areaid
maxPresenceFirings = 0;
sleepRoom = [];
for n = 1 : length(listOfRoomsWithPresence)
    areaid = listOfRoomsWithPresence(n)
    numFirings = length(find(roomsWithPresence == areaid))
    % keep track of the room with the maximum number of firings
    % we're going to disregard firings from the doors and the sensor line
    if numFirings > maxPresenceFirings & ~ismember(areaid, [56, 57, 63, 67]);
        maxPresenceFirings = numFirings;
        sleepRoom = areaid;
    end
end
 sleepRoom = 4;
%%% Now get data for the time period between 6 pm on a given day and noon
%%% the next day - we will assume falling asleep and waking up happen
%%% between these time points.
startdate = datenum([year month day 18 0 0]);
enddate = datenum([year month day+1 12 0 0]);
[ stamp, itemidx_nyce, areaid_nyce, event] = Orcatech.Databases.SensorData.getPresenceSensorData(homeid, startdate, enddate);

% We're going to disregard door sensors and walking line sensors, so remove
% these events from our data set
% we're also going to ignore bath room firings for now
del1 = find(areaid_nyce == 56);
del2 = find(areaid_nyce == 57);
del3 = find(areaid_nyce == 63);
del4 = find(areaid_nyce == 67);
del5 = find(areaid_nyce == 1);
del6 = find(areaid_nyce == 2);
del7 = find(areaid_nyce == 3);
del = [del1' del2' del3' del4' del5' del6' del7'];
stamp(del) = [];
event(del) = [];
areaid_nyce(del) = [];

% now find the stamps and events that occured in the sleeping room
sleepRoomIndices = find(areaid_nyce == sleepRoom);
sleepRoomStamps = stamp(sleepRoomIndices);
sleepRoomEvents = event(sleepRoomIndices);

% find firings which occur in any other room in the house
otherRoomIndices = find(areaid_nyce ~= sleepRoom);
otherRoomStamps = stamp(otherRoomIndices);
otherRoomEvents = event(otherRoomIndices);

% Find all the 32 firings in the sleep room which signify presence detected
presenceDetectedIndices = find(sleepRoomEvents == 32);

% Find the time stamps for these detections
presenceDetectedTimeStamps = sleepRoomStamps(presenceDetectedIndices);

% Convert this into hours since 6 pm - this gets us around the awkwardness
% that happens around midnight for calculating gaps in time between time
% stamps. MATLAB datenums are given in units of days so multiply by 24 to
% convert to hours
hoursSince6pm = (presenceDetectedTimeStamps - startdate) * 24;

% Calculate difference between time stamps
timeDiffBetweenFirings = diff(hoursSince6pm);

% Find gaps greater than 5 minutes - this represents periods in our
% sleeping room when the occupant was so still that they weren't detected
% by the sensor or the sleeping room was empty
gaps = find(timeDiffBetweenFirings > 5/60);

% Find the start and end of these gaps
startgaps = [];
endgaps = [];

totalsleeptime  = 0;
if ~isempty(gaps)
    for i = 1 : length(gaps)
        % We're going to look for gaps when no sensors fired in the other
        % rooms of the home
        otherfirings = false;
        startgap = presenceDetectedTimeStamps(gaps(i));
        endgap = presenceDetectedTimeStamps(gaps(i)+1);
        %did any other sensors fire during this time?
        otherRoomGapIndices = find(otherRoomStamps > startgap & otherRoomStamps < endgap);
        otherRoomGapEvents = otherRoomEvents(otherRoomGapIndices);
        if length(find(otherRoomGapEvents == 32)) > 0
            otherfirings = true;
        end
        if otherfirings == false
            totalsleeptime = totalsleeptime + (endgap - startgap);
            startgaps = [startgaps startgap];
            endgaps = [endgaps endgap];
        end
    end
end

% The bed time is the first value in our start gaps list. The wakening time
% is the last value in our endgaps list
bedtime = datestr(min(startgaps))
waketime = datestr(max(endgaps))