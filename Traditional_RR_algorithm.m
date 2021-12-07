%                                      Traditional_RR_algorithm


function [Rlb_req,total_relability,total_number_of_replica,num,frequency_result_matrix,final_replica_relability_matrix ,R,total_dynmic_power_consumed, result_replica_power,task_power_consumed] =  Traditional_RR_algorithm()
format long;
%call R_list input function for sorting the task by using ranku_function
%function
[R_list,number_of_tasks,R_req,number_of_processors,W,M,C,lambda_max,d] = Rlist( );


%number of tasks
n=number_of_tasks;

%call power input function
[Pk_s,Pk_ind,Cef,mk,fk_max,fk_low,fr_u] = power_input_function(number_of_processors);


   % the total relability of the application and total number of replica
   total_relability = 0;
   total_number_of_replica =0;
   % R is a vector contains relability value we get for each task
   R=zeros(1,n);
   
   % if processor avaliable for task equal=0 else =1
   processor_available=zeros(n,number_of_processors);
   
   % the final result for the tasks and replica relability
   final_replica_relability_matrix=zeros(n,number_of_processors);
   
   % the final result for the tasks and replica frequencecy 
   frequency_result_matrix=zeros(n,number_of_processors);
   
   %num is vector for number of replica for each task
   num=zeros(1,n);
   
   % sub relability requmients for each task
   Rlb_req=zeros(1,n);
   
   %the matrix for save every replica for the task
    replica_matrix =zeros(n,number_of_processors);
   
   for i=1:1:n
    
       
       variable_product_relability=1;
     if(n==1)
        Rlb_req(i)=nthroot(R_req, number_of_tasks);
     else
         Exponential=n -i +1;
         for x=1:1:i-1
           variable_product_relability=variable_product_relability* R(x);  
         end
         basis=R_req /variable_product_relability; 
         Rlb_req(i)=nthroot(basis, Exponential);
       
     end 

   % boolean variable equal=0 if we dont reach the relability requiment
   % from each task,equal=1 we reach relability requiment from the task
   flag_task_relability=0;
   
   % boolean variable for max replica
   max_replica=0;
   
   % processor execute max replica
   flag_max_replica_processor=0;
   

   % processor and frequence execute the one replica that reach relability
   % requiment for the task
   flag_one_replica_processor=0;
   
  
 
        for j=1:1:number_of_processors
       
              replica_relability= exp((-lambda_max(j)*W(i,j)));
                %here every replica relability value saved to matrix
                %private for each task
                
                replica_matrix(i,j)=replica_relability;
                
                
                 if (replica_relability > max_replica )
                     max_replica = replica_relability;
                     flag_max_replica_processor = j;
                % we want max replica relability 
                            if (max_replica >= Rlb_req(i))
                               R(i)= max_replica;
                               flag_task_relability=1;
                               flag_one_replica_processor=j;
                               
                            end
                 end
                
        end            
   
       
       if (flag_task_relability == 1)
          final_replica_relability_matrix(i,flag_one_replica_processor)=R(i);
          frequency_result_matrix(i,flag_one_replica_processor)=1;
          num(i)=num(i)+1;
          processor_available(i,j)=1;
       end
       
      if(flag_task_relability == 0)
          while (R(i) < Rlb_req(i))
             
              max_replica=0;
              for j=1:1:number_of_processors
                     if (processor_available(i,j)==0)
                       if(replica_matrix(i,j)> max_replica)
                           max_replica= replica_matrix(i,j);
                           flag_max_replica_processor=j;    
                       end
                     end
               end
              
                           
               final_replica_relability_matrix(i,flag_max_replica_processor)= max_replica;
               frequency_result_matrix(i,flag_max_replica_processor)=1;
                processor_available(i,flag_max_replica_processor)=1;
                 num(i)=num(i)+1;
                for j=1:1:number_of_processors
                    var1=final_replica_relability_matrix(i,j);
                    R(i)=1-((1-R(i))*(1-var1));          
                           
                end          
                           
          end 
          
      end
   end                       
            
    total_relability= prod(R);
    total_number_of_replica=sum(num);
   [total_dynmic_power_consumed, result_replica_power,task_power_consumed] = app_dynmic_power_calculation(frequency_result_matrix,W );
   
   
   
   disp('total_relability =')
   disp(total_relability)
    disp('total_number_of_replica=')
    disp(total_number_of_replica)
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
    disp('total_dynmic_power_consumed')
    disp(total_dynmic_power_consumed)
    disp('result_replica_power')
    disp(result_replica_power)
    disp('task_power_consumed')  
    disp(task_power_consumed)
 end