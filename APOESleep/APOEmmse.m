mmse22 = []; 
mmse23 = [];
mmse24 = [];
mmse33 = [];
mmse34 = [];

for n = 1 : length(intactOADC)
   if strcmp(intactAPOE{n}, '2,2')
       mmse22 = [mmse22 intactMMSE(n)];
   elseif strcmp(intactAPOE{n}, '2,3')
       mmse23 = [mmse23 intactMMSE(n)];
   elseif strcmp(intactAPOE{n}, '2,4')
       mmse24 = [mmse24 intactMMSE(n)];
   elseif strcmp(intactAPOE{n}, '3,3')
       mmse33 = [mmse33 intactMMSE(n)];
   else
       mmse34 = [mmse34 intactMMSE(n)];
   end
end

disp(['2,2: ' num2str(mean(mmse22, 'omitnan'))]);
disp(['2,3: ' num2str(mean(mmse23, 'omitnan'))]);
disp(['2,4: ' num2str(mean(mmse24, 'omitnan'))]);
disp(['3,3: ' num2str(mean(mmse33, 'omitnan'))]);
disp(['3,4: ' num2str(mean(mmse34, 'omitnan'))]);