
calculated = zeros(20,20,20,2);
parsedData = zeros(20,20,20,4);
%temp = [R, C, A, B, C1, D, Readings, (((R-1)*400)+ ((C-1).*20) + Readings)];
%temp = [R, C, A, B, C1, D, Readings, (((R-1)*400)+ ((C-1).*20) + transpose(repmat((1:20),1,400)))]
for r = 1:20
    for c = 1 : 20
        k = (1:20) + ((r-1)*400 + (c-1)*20);
        res = table2array(AllData(int64(k),(3:6)));
        parsedData(r,c,:,:) = res;
        calculated(r,c,:,:) = table2array(AllData(int64(k),(7:8)));
    end
end

Ashort = parsedData(:,:,:,1);
Bshort = parsedData(:,:,:,2);
Cshort = parsedData(:,:,:,3);
Dshort = parsedData(:,:,:,4);
