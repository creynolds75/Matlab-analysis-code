for s = 1 : length(SubjectID)     
    page = 1;
mousedate = '20171';
if ~isnan(SubjectID(s))
        urltext=['https://juno.orcatech.org/php/healthforms/loadFormsUserInputBySubjIdSurveyIdYearMonth.php?s=' ...
            num2str(SubjectID(s)) '&ym=' mousedate '&p=' num2str(page) '&sv=8wEcKa486I0Jenj']
        rawdata = urlread(urltext)
end
end