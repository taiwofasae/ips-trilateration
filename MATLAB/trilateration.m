function result = trilateration(data, method)
% data: measurements 20-by-20-by-20-by-4
% method: trilateration method that takes in 1-by-4 and returns 1-by-2
% result: returns trilateration result 20-by-20-by-20-by-2

result = zeros(20,20,20,2);
for i=1:20
    for j=1:20
        for o=1:20
            obs = data(i,j,o,:);
            res = method(obs);
            result(i,j,o,:) = res;
        end
    end
end
