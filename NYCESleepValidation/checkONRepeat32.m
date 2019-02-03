repeats =[];
for i = 2:length(bedroomEvents)
    if bedroomEvents(i) == 32 & bedroomEvents(i-1) == 32
        disp('Repeated 32')
        repeats = [repeats i-1 i];
    end
end