%                                      EESARRV1_algorithm


function [Rlb_req,total_relability,total_number_of_replica,num,frequency_result_matrix,final_replica_relability_matrix ,R,total_dynmic_power_consumed, result_replica_power,task_power_consumed] = EESARRV1_algorithm()
format long;

%call R_list input function for sorting the task by using ranku_function
%function
[~,number_of_tasks,R_req,number_of_processors,W,~,~,lambda_max,~] = ProrityList( );


%number of tasks
n=number_of_tasks;

%call power input function
[Pk_s,Pk_ind,Cef,mk,fk_max,fk_low,fr_u] = power_input_function(number_of_processors );

% row and colum for processor frequency matrix fr_u
   [fr_u_row,fr_u_colum]=size(fr_u);
   
   % matrix for execute the task ni on every processor on every frequency
   
   
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
   % 
   Rlb_req=zeros(1,n);
   
   
   
   
   tic;
   for i=1:1:n
     %relability_requiment fron each task
     %ÏÇáÉ ÇáÌÐÑ Çáäæäí ÈÇáãÇÊáÇÈ
     %nthroot(x,N) ÍíË x åæ ÇáÚÏÏ
     % ÃÃãÇ n åæ ÇáÃÓ
     %ÇáãåãÉ ÇáÃæáì ÝÞØ ÊÍÓÈ ÈäÝÓ ÇÓáæÈ ÎæÇÑÒãíÉ maxre ÃãÇ ÇáÈÇÞí ÊÍÓÈ ÈÍÓÈ
     %ÞÇäæä ÎæÇÑÒãíÉ RR ãä ÇáãÞÇáÉ 24
     
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
     
       % replica_matrix_ror_task is relability matrix for each relability
       % for each processor and every frequency can be calculate and this
       % matrix private for each task
       replica_matrix_for_task=zeros(number_of_processors,fr_u_colum);
  
   
   % boolean variable equal=0 if we dont reach the relability requiment
   % from each task,equal=1 we reach relability requiment from the task
   flag_task_relability=0;
   % boolean variable for max and min replica
   min_replica=1;
   max_replica=0;
   % processor and frequence execute max replica
   flag_max_replica_processor=0;
   flag_max_replica_frequency=0;
   %
   var4=1;
   % processor and frequence execute the one replica that reach relability
   % requiment for the task
   flag_one_replica_processor=0;
   flag_one_replica_frequency=0;
   % the tow processors and frequence execute min replica
   flag_min_replica_processor=zeros(1,2);
   flag_min_replica_frequency=zeros(1,2); 
   
   % ÇáãÑÍáÉ ÇáÃæáì ÍÓÇÈ ßá ÇáÇÍÊãÇáÇÊ ÇáããßäÉ ãÚÇáÌ/ÊÑÏÏ æÞíãÉ ÇáãæËæÞíÉ
   % ÇáäÇÊÌÉ Úä ßá ãäåÇ ááãåÉ i
 
        for j=1:1:number_of_processors
       
              for v=1:1:fr_u_colum
                 % task replica relability calculation from eq (6) in notebook
                var1= power(10,(fk_max(j)-fr_u(j,v))/(fk_max(j)-fk_low(j)));
                var2=(W(i,j)*fk_max(j))/fr_u(j,v);
                replica_relability= exp((-lambda_max(j)*var1*var2));
                %here every replica relability value saved to matrix
                %private for each task
                replica_matrix_for_task(j,v)=replica_relability;
                % we want min replica relability reach relability requiment
                 if (replica_relability >= Rlb_req(i)&& replica_relability < min_replica )
                   R(i)=replica_relability;
                   min_replica=replica_relability;
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
       end
       
        if(flag_task_relability == 0) 
          while (R(i) < Rlb_req(i))
             for j=1:1:number_of_processors-1
                 if (processor_available(i,j)==0)
                 for v1=1:1:fr_u_colum
                    for k=j+1:1:number_of_processors
                        if (processor_available(i,k)==0)
                        for v2=1:1:fr_u_colum
                           
                           var3=1-((1-replica_matrix_for_task(j,v1))*(1-replica_matrix_for_task(k,v2))* var4);
                
                          if(var3 >= Rlb_req(i) && ( var3 < min_replica))
                           R(i)=var3;
                           min_replica=var3;
                           flag_task_relability =1;
                           flag_min_replica_processor(1)=j;
                           flag_min_replica_processor(2)=k;
                           processor_available(i,j)=1;
                           processor_available(i,k)=1;
                           flag_min_replica_frequency(1)=fr_u(j,v1);
                           flag_min_replica_frequency(2)=fr_u(k,v2);
                           flag_half_replica_relability(1)=replica_matrix_for_task(j,v1);
                           flag_half_replica_relability(2)=replica_matrix_for_task(k,v2);
                          else if ((replica_matrix_for_task(j,v1))> max_replica && processor_available(i,j)==0)
                                max_replica = replica_matrix_for_task(j,v1);
                                flag_max_replica_processor=j;
                                flag_max_replica_frequency=fr_u(j,v1);
                                
                              end
                          end
                        end
                        end
                    end 
                 end
                 end
             end
             if(flag_task_relability == 1)
                 final_replica_relability_matrix(i,flag_min_replica_processor(1))=flag_half_replica_relability(1);
                 final_replica_relability_matrix(i,flag_min_replica_processor(2))=flag_half_replica_relability(2);
                 frequency_result_matrix(i,flag_min_replica_processor(1))=flag_min_replica_frequency(1);
                 frequency_result_matrix(i,flag_min_replica_processor(2))=flag_min_replica_frequency(2);
                 num(i)=num(i)+2; 
             else if (flag_task_relability == 0)
                    var4=var4 *(1-max_replica);
                    final_replica_relability_matrix(i,flag_max_replica_processor)= max_replica;
                    frequency_result_matrix(i,flag_max_replica_processor)=flag_max_replica_frequency;
                    processor_available(i,flag_max_replica_processor)=1;
                    num(i)=num(i)+1;
                  end
             end
          end 
       
         end  
       
   end
  
    total_relability= prod(R);
    total_number_of_replica=sum(num);
      [total_dynmic_power_consumed, result_replica_power,task_power_consumed] = app_dynmic_power_calculation(frequency_result_matrix,W );
      execution_time=toc;
   
      
   disp('1111111111111111111111111111') 
   disp('total_relability =')
   disp(total_relability)
   
    disp('2222222222222222222222222222222')
    disp('total_dynmic_power_consumed')
    disp(total_dynmic_power_consumed)
   
   
   
    disp('3333333333333333333333333333333')
    disp('total_number_of_replica=')
    disp(total_number_of_replica)
    
     disp('4444444444444444444444444444444444')
     disp('execution_time')
     disp(execution_time)
     
     
     
    
     
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