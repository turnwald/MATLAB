%%%Routh Hurwitz Automatically
clear
clc
close all

%%%%%%INPUT COEFFICIENTS OF CHARACTERISTIC POLYNOMIAL HERE%%%%%
%coeff = [1,-6,-7,-52];
%coeff = [1,2,1];
coeff = [1,6,11,6,200];
%syms K - hey if you have the symbolic toolbox try this
%coeff = [1,18,77,K]; 

%%%%Create the First Row of the Routh Table
routh_table = [];
first_row = [];
for idx = 1:2:length(coeff)
    first_row = [first_row,coeff(idx)];
end
while length(first_row) <= 2
    first_row = [first_row,0];
end
routh_table = [routh_table;first_row]
%%%%Create the second row of the Routh Table
second_row = [];
for idx = 2:2:length(coeff)
    second_row = [second_row,coeff(idx)];
end
while length(second_row) < length(first_row)
    second_row = [second_row,0];
end
routh_table = [routh_table;second_row];
routh_table_width = length(first_row);

%%%Now create the next rows
required_rows_to_compute = length(coeff)-2;

%%%Check and see if this is first order or smaller
if required_rows_to_compute < 0
    disp('Trivial Solution')
    return
end

for loop_row = 1:required_rows_to_compute
    row = [];
    %disp(['Computing Row ',num2str(loop_row+2)])
    divisor = routh_table(loop_row+1,1);
    for col = 1:routh_table_width
        %disp(['Computing Column ',num2str(col)])
        left_half_det = routh_table(loop_row:loop_row+1,col);
        if col == routh_table_width
            right_half_det = [0;0];
        else
            right_half_det = routh_table(loop_row:loop_row+1,col+1);
        end
        both_det = [left_half_det,right_half_det];
        value = -det(both_det)/divisor;
        row = [row,value];
    end
    routh_table = [routh_table;row];
end

%%%Check for stability
%%%Grab the first column
routh_table
first_column = routh_table(:,1)
s = sign(first_column(1));
unstable = 0;
for idx = 2:length(first_column)
    value = first_column(idx);
    if s ~= sign(value)
        disp('Unstable ')
        unstable = 1;
        break
    end
end
if ~unstable
    disp('System is Stable')
end

%%%%%%Check%%%%%
roots(coeff)