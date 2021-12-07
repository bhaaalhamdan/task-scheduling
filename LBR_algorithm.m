function [total_number_of_replica,total_relability,R,result_matrix,processor_available,num,replica_matrix ] = LBR_algorithm()
format long;
%call ProrityList function for sorting the task by using ranku_function
%function
[~,number_of_tasks,R_req,number_of_processors,W,~,~,lambda_max,~] = ProrityList( );

% R_req : relability goal/ W: WECT/M: messages between nodes in DAG/C: WCRT
% lambda_max is failure rate constant 

[Pk_s,Pk_ind,Cef,mk,fk_max,fk_low,fr_u] = power_input_function( number_of_processors);
%number of tasks
n=number_of_tasks;

%Rlb_req is vector contains the requment relability from each task 
Rlb_req=zeros(1,n);

%num is vector contains the replica number for each task
num=zeros(1,n);

% R is s vector contains the relability we have for each task
R=zeros(1,n);

% the total relability we reach
total_relability=1;

%the total number of replica we reach
total_number_of_replica=0 ;

%processor_available is vector represents the state of the processor
   % if replica of task is executed on prcessor become unavailable
   % 0 mean available and 1 is not available
   processor_available=zeros(n,number_of_processors);


% row and colum for processor frequency matrix fr_u
   [fr_u_row,fr_u_colum]=size(fr_u);
   
   %result_matrix contain processor execute replica and the frequency
   result_matrix=zeros(n,number_of_processors);
   
%replica_matrix
replica_matrix=zeros(n,number_of_processors);
 
 
for i=1:1:n
    % initlize the Rlb_req for each task , must equal the rgoal becuse 
    % the relability of application is product of relability of each task
    % in the application and if we have on value less than relablity goal
    % that mean the relablity of app less than relablity goal
    Rlb_req(i)= R_req;
    
   % initlize the number of replica for each task , must equal the 0
   % in the first
   num(i)=0;
   
   
   % initlize the relability we reach for each task , must equal the 0
   % in the first
   R(i)=0;
   
  
   
   % is a flag for exit form nested loop when we reach Rlb_req(i)
   flag_task=0;
   
 
   
   % min_frequency is the minimum frequency we have rach task relability
   % requiment
   min_frequency=1;
   
 if(R(i)<Rlb_req(i) && flag_task==0 )
      
       % the bigger relability we can have for the replica
   
   var3=1;
   var4=1;
   
      for j=1:1:number_of_processors
          % the processor must be avaliable to calculate relability of the
          % replica on him
          if (processor_available(i,j)==0 )
              %for fr_u matrix
            for v=1:1:fr_u_colum
                 if (processor_available(i,j)==0)
             % task replica relability calculation from eq (6) in notebook
                var1= power(10,(fk_max(j)-fr_u(j,v))/(fk_max(j)-fk_low(j)));
                var2=(W(i,j)*fk_max(j))/fr_u(j,v);
                replica_relability= exp((-lambda_max(j)*var1*var2));
                  if (replica_relability >= Rlb_req(i)&& min_frequency > fr_u(j,v))
                   min_frequency= fr_u(j,v);
                   var3=j;
                   var4=fr_u(j,v);
                   relability= replica_relability;
                   flag_task=1;
                  end
                 end
            end
          end
      end
       if( flag_task==1 ) 
                  replica_matrix(i,var3)=relability;
                   processor_available(i,var3)=1;
                   result_matrix(i,var3)=var4;
                   num(i)= num(i)+1;
                    R(i)=relability;
       
       end

        
       
      while(flag_task==0 )
          
          max_replica = 0;
         
          
         for j=1:1:number_of_processors
          % the processor must be avaliable to calculate relability of the
          % replica on him
          if (processor_available(i,j)==0 && flag_task==0 )
              %for fr_u matrix
              
            for v=1:1:fr_u_colum
                 if (processor_available(i,j)==0 && flag_task==0 )
                  % task replica relability calculation from eq (6) in notebook
                    var1= power(10,(fk_max(j)-fr_u(j,v))/(fk_max(j)-fk_low(j)));
                     var2=(W(i,j)*fk_max(j))/fr_u(j,v);
                      replica_relability= exp((-lambda_max(j)*var1*var2));
                      
                        if( replica_relability >= max_replica && flag_task==0 )
                          max_replica=replica_relability;
                          
                           var3=j;
                           var4=fr_u(j,v);
                           relability_we_have_for_this_replica=1-((1-R(i))*(1-max_replica));
                              if( relability_we_have_for_this_replica >= Rlb_req(i))
                                 flag_task=1;
                        
                               
                              end
                        end 
                 end  
              
            end  
      
          end   
          
    
         end 
         
         if(flag_task==0)
         R(i)= 1-((1-R(i))*(1-max_replica));
         replica_matrix(i,var3)=max_replica;
         processor_available(i,var3)=1;
         result_matrix(i,var3)=var4;
         num(i)= num(i)+1;
         else
             R(i)= relability_we_have_for_this_replica;
              replica_matrix(i,var3)=max_replica;
              processor_available(i,var3)=1;
              result_matrix(i,var3)=var4;
              num(i)= num(i)+1;
         end
     
      end
 end  




end  


total_number_of_replica =sum(num);
total_relability=prod(R);

disp('processor_available')
disp(processor_available)

 disp('total_number_of_replica from LBR')
disp(total_number_of_replica)
disp('total_relability from LBR')
disp(total_relability)
disp('actual relability for each task from LBR')
disp(R)
disp('result_matrix from LBR')
disp(result_matrix)
disp('replica_matrix from LBR')
disp(replica_matrix)
%}

end