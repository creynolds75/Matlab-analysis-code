

for n = 1 : length(dn)
    hrs = hour(dn(n));
mins = minute(dn(n));
secs = second(dn(n));
    militarytime{n} = [num2str(hrs) ':' num2str(mins) ':' num2str(secs)];
end
militarytime = militarytime';