%                                       EEERRM_algorithm (first prposed
%                                       algoritm ) work after LBR algoritm

function [new_total_relability,new_total_number_of_replica,new_num,frequency_result_matrix_after_ERRM,new_processor_available, result_relability_matrix,R,total_dynmic_power_consumed, result_replica_power,task_power_consumed] =  EEERRM_algorithm()
format long;
tic;
%call ProrityList input function for sorting the task by using ranku_function
%function
[~,number_of_tasks,R_req,number_of_processors,W,~,~,lambda_max,~] = ProrityList( );

%number of tasks
n=number_of_tasks;

%call power input function
[Pk_s,Pk_ind,Cef,mk,fk_max,fk_low,fr_u] = power_input_function(number_of_processors );

% row and colum for processor frequency matrix fr_u
   [fr_u_row,fr_u_colum]=size(fr_u);
   
%%% we call LBR algoritm in the first
 [total_number_of_replica,total_relability,R,result_matrix,processor_available,num,replica_matrix ] = LBR_algorithm();

% initlize the new relability we reach for each task , must equal the 0
   % in the first
   R_new =ones(1,n);
   
   %processor_execute_new_replica is vector contain the processor 
   %that excuted the new replica((max relability) for each tasks
   processor_execute_new_replica=processor_available;
   
   %frequency_execute_new_replica is vector contain the processor frequency  
   %that excuted the new replica(max relability) for each tasks
   frequency_execute_new_replica=result_matrix;

   %result_matrix_after_ERRM the new result matrix
   frequency_result_matrix_after_ERRM =result_matrix;

   %new_total_relability is relability after add relability from new
   %replica in first equal to relability we reach from LBR algorithm
   new_total_relability=total_relability;
   
   % the enhanced application relability after replicated task i
   enhanced_app_relability= zeros(1,n);
   
   %new_total_number_of_replica
   new_total_number_of_replica=total_number_of_replica;
   
   %new_num is vector contains new number of replica for each task
   new_num=num;
   % new matrix for prosessor avaliable 
   new_processor_available=processor_available;
   
   % replica_relability_matrix
   replica_relability_matrix=replica_matrix;
   
   %result_relability_matrix
   result_relability_matrix=replica_matrix;
   
   flag_we_reach_relability_goal=0;
   

 while(new_total_relability < R_req && flag_we_reach_relability_goal==0) 
     
   for i=1:1:n
        %max_replica_relability is the max replica relability for each task in
         %the new calculation
        max_replica_relability=0;
        
        for j=1:1:number_of_processors
            
            % the task can repicaed if there is avalabile processor for
            % this task
            if (new_processor_available(i,j)==0 && flag_we_reach_relability_goal==0)
                
                % we want to passage to every frequencey that processor
                % spourted
                for v=1:1:fr_u_colum
                 % task replica relability calculation from eq (6) in notebook
                var1= power(10,(fk_max(j)-fr_u(j,v))/(fk_max(j)-fk_low(j)));
                var2=(W(i,j)*fk_max(j))/fr_u(j,v);
                replica_relability= exp((-lambda_max(j)*var1*var2));
                
                if (replica_relability > max_replica_relability )
                max_replica_relability=replica_relability;
                processor_execute_new_replica(i)=j;
                frequency_execute_new_replica(i)=fr_u(j,v);
                end
                end    
            end
        
        end
        
       
       replica_relability_matrix(i,processor_execute_new_replica(i))= max_replica_relability;
        
       %calculate R_new(i)becuse new replica(max replica for i)
       var=1;
       
         for j=1:1:number_of_processors
          var=var *(1-replica_relability_matrix(i,j));  
         end
       
       R_new(i)=1-var;
       
        
       %calculate enhanced_app_relability(i)
      var5=1;
       for f=1:1:n
           if(f ~= i)
               var5= var5 * R(f);
           end
       end
       enhanced_app_relability(i)=R_new(i)*var5; 
   end 
   
 
    % we want to chose the max enhanced relability to determine the
    % processor and task and frequency for relicated task
if( flag_we_reach_relability_goal==0 && new_total_relability < R_req)    
flag_max=0;
flag_processor=1;
flag_frequency=0;
flag_index=1; 
flag_just_enhanced=1;

for i=1:1:n
    for j=1:1:number_of_processors
      if (enhanced_app_relability(i)> flag_max && new_processor_available(i,j) == 0 ) 
       flag_max=enhanced_app_relability(i);
        flag_just_enhanced=R_new(i);
         flag_index=i;
          flag_processor=processor_execute_new_replica(i);
          flag_frequency=frequency_execute_new_replica(i);
      end
    end 
end    

% new relability after rxecuted new replica(max replica)
R(flag_index)=flag_just_enhanced;

new_total_relability=prod(R);

disp('new_total_relability');
disp(new_total_relability);
% increase the total number of replica after chisoe new replica
%disp('new_total_relability')
%disp(new_total_relability)

if( new_total_relability >= R_req)
   flag_we_reach_relability_goal=1;
end
 new_total_number_of_replica= new_total_number_of_replica + 1;
% increase the number of replica for task we choise to replicated
 new_num(flag_index)=new_num(flag_index)+1;
 
 result_relability_matrix(flag_index,flag_processor)=replica_relability_matrix(flag_index,flag_processor);
 % the frequnency we chose for task we replicated
 frequency_result_matrix_after_ERRM(flag_index,flag_processor)=flag_frequency;
% the relica we chose in not avaliable on the same processor after
% replicated
new_processor_available(flag_index,flag_processor)=1;
 end
 if new_total_relability > R_req && flag_we_reach_relability_goal==0
     flag_we_reach_relability_goal=1;
 end

end






[total_dynmic_power_consumed, result_replica_power,task_power_consumed] = app_dynmic_power_calculation(frequency_result_matrix_after_ERRM,W );
execution_time=toc;
   
   
disp('relability requiment =')
   disp(R_req )
disp('total_relability =')
   disp(new_total_relability)
   disp('total_dynmic_power_consumed')
    disp(total_dynmic_power_consumed)
    disp('total_number_of_replica=')
    disp(new_total_number_of_replica)
   disp('execution_time')
   disp(execution_time)
   
    
    disp('number of replica for each task')
    disp(new_num)
    disp('final replica relability matrix')
    disp(result_relability_matrix)
    disp('frequency_result_matrix')
    disp(frequency_result_matrix_after_ERRM)
    disp('relability for each task')
    disp(R)
    
    disp('result_replica_power')
    disp(result_replica_power)
    disp('task_power_consumed')  
    disp(task_power_consumed)
%}
     
end