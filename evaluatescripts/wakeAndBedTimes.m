dt = datetime( stampunix, 'ConvertFrom', 'posixtime' );

sleepstates = [];
sleepdatetimes = [];
for n = 1 : length(sleep)
    if sleep(n) > 0
        d = (1:durations(n))/(60*24);
        sleepstates = [sleepstates sleep(n)*ones(size(d))];
        sleepdatetimes = [sleepdatetimes d+datetime(dt(n))];
    end
end





