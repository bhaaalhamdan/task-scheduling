function [total_dynmic_power_consumed, result_replica_power,task_power_consumed] = app_dynmic_power_calculation(frequency_result_matrix,W )
%this function calcutate the dynmic power consumed by the replica

[number_of_tasks,number_of_processors]=size(frequency_result_matrix);

task_power_consumed=zeros(1,number_of_tasks);

result_replica_power=zeros(number_of_tasks,number_of_processors);

% in the first we call power input function
[Pk_s,Pk_ind,Cef,mk,fk_max,fk_low,fr_u] = power_input_function(number_of_processors);
%Pk_s,Pk_ind,Cef,mk,fk_max,fk_low in matrix one row an the colum is equal
%to number of processors
%fr_u is matrix rows is equal to number of processors and colums is equal
%to frequencey the processor suported
%processor=j;
% frequency = frequency_result_matrix(i,j) the frequency used to execute replica
% w is WCET matrix

for i=1:1:number_of_tasks
    for j=1:1:number_of_processors
        if(frequency_result_matrix(i,j)~=0)
            var1=(Pk_ind(j)+(Cef(j)*power(frequency_result_matrix(i,j),mk(j))));
            var2=(fk_max(j)/frequency_result_matrix(i,j));
            result_replica_power(i,j) =var1*W(i,j)*var2;
             task_power_consumed(i)=task_power_consumed(i)+result_replica_power(i,j);
    
        end
    end
end


total_dynmic_power_consumed=sum(task_power_consumed);

end

