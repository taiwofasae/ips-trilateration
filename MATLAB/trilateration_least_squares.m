function result = trilateration_least_squares(data, validator_index)
% data: measurements 20-by-20-by-20-by-4
% method: trilateration method that takes in 1-by-4 and returns 1-by-2
% result: returns trilateration result 20-by-20-by-20-by-2

result = zeros(20,20,20,2);
for i=1:20
    for j=1:20
        for o=1:20
            obs = data(i,j,o,:);
            if(and(i == 20, j == 14))
                disp([])
            end
            res = least_squares_method(transpose(obs(:)),validator_index);
            result(i,j,o,:) = res;
        end
    end
end
