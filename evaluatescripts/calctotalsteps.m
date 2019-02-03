dt = datetime( stampunix, 'ConvertFrom', 'posixtime' );

flooruniquedt = unique(floor(datenum(dt)));
floordt = floor(datenum(dt));

totalsteps = zeros(size(flooruniquedt));

for n = 1 : length(flooruniquedt)
    i = find(floordt == flooruniquedt(n));
    totalsteps(n) = sum(steps(i));
end




