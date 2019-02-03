for n =1:length(startSpans)
    plot([startSpans(n) startSpans(n)], [0 15], 'r')
end

for n = 1 : length(endSpans)
    plot([endSpans(n) endSpans(n)], [0 15], 'g')
end