% Loop through the 128 study OACD numbers
for n  = 1 : length(oadc)
    %look for matches
    for m = 1 : length(oadc1)
        if oadc(n) == oadc1(m)
            disp(['got it ' num2str(n)])
            ages(n) = VSTage(m);
            MMSE(n) = vstMMSE(m);
            sex(n) = Rsex(m);
            education(n) = Ryrschool(m);
            %mcitype 0 - intact
            %mcitype 1 - amnestic
            %mcitype 2 - nonamnestic
            if mci(n) == 0
                mcitype(n) = 0;
            else
                if amci(n) == 1
                    mcitype(n) = 1;
                else
                    mcitype(n) = 2;
                end
            end
        end
    end
end

m = 0; f = 0;
for n = 1 : length(sex)
    if sex(n) == 1
        m = m + 1;
    else
        f = f + 1;
    end
end

% find values for mcitype = 0
i = find(mcitype == 0);
intactages = ages(i);
intactsex = sex(i);
intacted = education(i);
intactMMSE = MMSE(i);

intactm = 0; intactf = 0;
for n = 1 : length(intactsex)
    if intactsex(n) == 1
        intactm = intactm + 1;
    else
        intactf = intactf + 1;
    end
end

% find values for mcitype = 1
i = find(mcitype == 1);
aMCIages = ages(i);
aMCIsex = sex(i);
aMCIed = education(i);
aMCIMMSE = MMSE(i);

aMCIm = 0; aMCIf = 0;
for n = 1 : length(aMCIsex)
    if sex(n) == 1
        aMCIm = aMCIm + 1;
    else
        aMCIf = aMCIf + 1;
    end
end

% find values for mcitype = 2
i = find(mcitype == 2);
naMCIages = ages(i);
naMCIsex = sex(i);
naMCIed = education(i);
naMCIMMSE = MMSE(i);

naMCIm = 0; naMCIf = 0;
for n = 1 : length(naMCIsex)
    if naMCIsex(n) == 1
        naMCIm = naMCIm + 1;
    else
        naMCIf = naMCIf + 1;
    end
end

        