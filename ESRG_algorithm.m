%                                       ESRG_algorithm from article 11


function [Rlb_req,total_relability,total_number_of_replica,frequency_result_matrix,final_replica_relability_matrix ,R,total_dynmic_power_consumed,result_replica_power,task_power_consumed] = ESRG_algorithm()
format long;

%call R_list input function for sorting the task by using ranku_function
%function
[~,number_of_tasks,R_req,number_of_processors,W,~,~,lambda_max,~] = ProrityList( );


%number of tasks
n=number_of_tasks;

%call power input function
[~,Pk_ind,Cef,mk,fk_max,fk_low,fr_u] = power_input_function(number_of_processors);

% row and colum for processor frequency matrix fr_u
   [~,fr_u_colum]=size(fr_u);
   
   
   
    processor_available=zeros(n,number_of_processors);
   
   
   % R is a vector contains relability value we get for each task
   R=zeros(1,n);
   
   % the final result for the tasks and replica relability
   final_replica_relability_matrix=zeros(n,number_of_processors);
   
   % the final result for the tasks and replica frequencecy 
   frequency_result_matrix=zeros(n,number_of_processors);
   
   %num is vector for number of replica for each task
   num=zeros(1,n);
   
   % sub relability requmients for each task
   Rlb_req=zeros(1,n);
   
  tic; 
   for i=1:1:n
     %relability_requiment fron each task
     %ÏÇáÉ ÇáÌÐÑ Çáäæäí ÈÇáãÇÊáÇÈ
     %nthroot(x,N) ÍíË x åæ ÇáÚÏÏ
     % ÃÃãÇ n åæ ÇáÃÓ
     
      Rlb_req(i)=nthroot(R_req, number_of_tasks);
  
   
   % boolean variable equal=0 if we dont reach the relability requiment
   % from each task,equal=1 we reach relability requiment from the task
   flag_task_relability=0;
   
   % processor and frequence execute the one replica that reach relability
   % requiment for the task
   flag_one_replica_processor=0;
   flag_one_replica_frequency=0;
   
   flag_min_replica_frequency=1;
   
   
   
   % ÇáãÑÍáÉ ÇáÃæáì ÍÓÇÈ ßá ÇáÇÍÊãÇáÇÊ ÇáããßäÉ ãÚÇáÌ/ÊÑÏÏ æÞíãÉ ÇáãæËæÞíÉ
   % ÇáäÇÊÌÉ Úä ßá ãäåÇ ááãåÉ i
 
        for j=1:1:number_of_processors
       
              for v=1:1:fr_u_colum
                 % task replica relability calculation from eq (6) in notebook
                var1= power(10,(fk_max(j)-fr_u(j,v))/(fk_max(j)-fk_low(j)));
                var2=(W(i,j)*fk_max(j))/fr_u(j,v);
                replica_relability= exp((-lambda_max(j)*var1*var2));
                % we want  replica relability reach relability requiment
                % with min frequency
                   if (replica_relability >= Rlb_req(i)&& flag_min_replica_frequency > fr_u(j,v))
                      R(i)=replica_relability;
                      flag_task_relability=1;
                      flag_one_replica_processor=j;
                      flag_one_replica_frequency=fr_u(j,v);
                    end
                    
              end 
                
        end           
   
        
       if (flag_task_relability == 1)
          final_replica_relability_matrix(i,flag_one_replica_processor)=R(i);
          frequency_result_matrix(i,flag_one_replica_processor)=flag_one_replica_frequency;
           num(i)=num(i)+1; 
           processor_available(i,flag_one_replica_processor)=1;
       end
       
       if(flag_task_relability == 0)
            flag_we_reach_relability_requiment=0;
          while (R(i) < Rlb_req(i) && flag_task_relability==0 )
              max_replica=0;
              flag_max_replica_processor=1;
              
              for j=1:1:number_of_processors
                     if (processor_available(i,j)==0 && flag_task_relability==0)
                         for v=1:1:fr_u_colum
                             var1= power(10,(fk_max(j)-fr_u(j,v))/(fk_max(j)-fk_low(j)));
                             var2=(W(i,j)*fk_max(j))/fr_u(j,v);
                             replica_relability= exp((-lambda_max(j)*var1*var2));
                             if(replica_relability > max_replica && flag_task_relability==0)
                                   max_replica= replica_relability;
                                   flag_max_replica_processor=j;
                                   flag_max_replica_frequency=fr_u(j,v);
                                   
                                   var6=1;
                                   for k=1:1:number_of_processors
                                    var6= var6 *(1-final_replica_relability_matrix(i,k));                 
                                   end 
                                  replica_we_reach=1-(var6*(1-replica_relability));
                                  if (replica_we_reach >= Rlb_req(i))
                                     flag_we_reach_relability_requiment=1;
                                     flag_task_relability=1;
                                     R(i)= replica_we_reach;
                                     final_replica_relability_matrix(i,flag_max_replica_processor)= max_replica;
                                      frequency_result_matrix(i,flag_max_replica_processor)=flag_max_replica_frequency;
                                      processor_available(i,flag_max_replica_processor)=1;
                                       num(i)=num(i)+1;
                                     break;
                                  end
                              end
                         end 
                     end 
               end
              
              
                if (flag_we_reach_relability_requiment==0)           
               final_replica_relability_matrix(i,flag_max_replica_processor)= max_replica;
               frequency_result_matrix(i,flag_max_replica_processor)=flag_max_replica_frequency;
               processor_available(i,flag_max_replica_processor)=1;
               num(i)=num(i)+1;
                end
                        
          end 
          
      end
       
   end 
   
  % the total relability of the application and total number of replica
    total_relability= prod(R);
    total_number_of_replica=sum(num);
    [total_dynmic_power_consumed, result_replica_power,task_power_consumed] = app_dynmic_power_calculation(frequency_result_matrix,W );
     execution_time=toc;
   
   
   
   
   
   disp('total_relability =')
   disp(total_relability)
   
   disp('total_dynmic_power_consumed')
    disp(total_dynmic_power_consumed)
    
    disp('total_number_of_replica=')
    disp(total_number_of_replica)
    
    disp('execution_time')
   disp(execution_time)
    
    
     disp(' ralability goal')
     disp(R_req)
     
  %{   
    disp('Rlb_req=')
    disp(Rlb_req)
    disp('number of replica for each task')
    disp(num)
    disp('final replica relability matrix')
    disp(final_replica_relability_matrix)
    disp('frequency_result_matrix')
    disp(frequency_result_matrix)
    disp('relability for each task')
    disp(R)
    
    disp('result_replica_power')
    disp(result_replica_power)
    disp('task_power_consumed')
    disp(task_power_consumed)
    %}
end