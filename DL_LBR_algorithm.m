function [total_number_of_replica,total_relability,R,processor_available,num,replica_matrix, sub_deadline,est,drt,aft,processor_avail] = DL_LBR_algorithm()
format long;
%call ProrityList function for sorting the task by using ranku_function
%function
[~,number_of_tasks,R_req,number_of_processors,W,M,C,lambda_max,~] = ProrityList( );

% R_req : relability goal/ W: WECT/M: messages between nodes in DAG/C: WCRT
% lambda_max is failure rate constant 




%Deadline of the all application
Deadline=1;

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


%processor_available is vector represents the state of the processor
   % if replica of task is executed on prcessor become unavailable
   % 0 mean available and 1 is not available
   processor_available=zeros(n,number_of_processors);
   
%replica_matrix
replica_matrix=zeros(n,number_of_processors);




  tic;   
     % vector contain the the sub deadline for each task 
     sub_deadline=zeros(1,n);
     for s=n:-1:1
         sum_c=0;
         for j=1:1:n
           sum_c=sum_c+ C(s,j);
         end
         
         max_var1=Deadline;
         if (sum_c==0)
               sub_deadline(s)= Deadline; 
         else
             for i=1:1:n 
                     if((M(s,i)==1))
                         max_WCET=0;
                           for j=1:1:number_of_processors
                               if W(i,j)> max_WCET
                                  max_WCET = W(i,j);    
                               end 
                           end
                         var1 = sub_deadline(i)-(max_WCET + C(s,i));
                        var1=abs(var1);
                        if var1 < max_var1
                         max_var1=var1;
                         sub_deadline(s)= max_var1;
                        end
                     end
             end
          end
         
     end
     
     disp('sub_deadline')
     disp(sub_deadline)
 
 
     
     
   % vector of earleast start time of all tasks on every processor
      est=zeros(number_of_tasks,number_of_processors);
      % vector of instances of task i recive all data from all preceddors on every processor
      drt=zeros(number_of_tasks,number_of_processors);
      % vector of actual finish time of all tasks on every processor
      aft=zeros(number_of_tasks,number_of_processors);  
     % vector represent the state of all processor, is it available?
       processor_avail=zeros(1,number_of_processors);
     
     
     
     
     
for i=1:1:n
    % initlize the Rlb_req for each task , must equal the rgoal becuse 
    % the relability of application is product of relability of each task
    % in the application and if we have on value less than relablity goal
    % that mean the relablity of app less than relablity goal
    Rlb_req(i)= R_req;
    
   % initlize the number of replica for each task , must equal the 0
   % in the first
   num(i)=0;
   
   % relability of each task
   relability=0;
   
   % initlize the relability we reach for each task , must equal the 0
   % in the first
   R(i)=0;
   

   
   % is a flag for exit form nested loop when we reach Rlb_req(i)
   flag_task=0;
   
   % flag_relability is a flag for who to calculate the task relability
   flag_relability=0;
   
    max_relability=0;
    
    %calculate est(i),drt,
     if(sum(M(:,i))==0)
    %“„‰ »œ¡  ‰›Ì– „Â„… «·œŒ· ÂÊ 0
           est(i,:)= 0;
     else
       flag_max_drt=0;
       flag_processor_execute_task_d=zeros(1,number_of_processors);
    
         for d=1:1:number_of_tasks
             if((M(d,i)==1)) % if the task d is proceddor of the x task 
                 for j=1:1:number_of_processors
                   % determine the processrors that execute task d
                   % where d is proceddor of task i
                   if (aft(d,j)~=0)
                    flag_processor_execute_task_d(j)= j;
                   end
                  end
               for j=1:1:number_of_processors
                   % determine the processrors that execute task d
                   % where d is proceddor of task i
                   if (aft(d,j)~=0)
                    flag_processor_execute_task_d(j)= j;
                   end
               end
                 
                    for j=1:1:number_of_processors
                       if flag_processor_execute_task_d(j)~=0
                        if  flag_processor_execute_task_d(j)==j;
                            % task d is pro

                           drt(i,j)= aft(d,flag_processor_execute_task_d(j));
                        else
                            
                           drt(i,j)= aft(d,flag_processor_execute_task_d(j))+C(d,i); 
                        end
                      % “„‰ Ê’Ê· «·»Ì«‰«  ·Ã„Ì⁄ «·„Â«„ «·”«»ﬁ… ‰Õ‰ ‰—Ìœ
                      % «·“„‰ «·√ﬂ»—
                          if(drt(i,j)> flag_max_drt)
                            flag_max_drt=drt(i,j);
                          end
                        end
                    end
              end
         end
         
          for j=1:1:number_of_processors
             % “„‰ »œ«Ì…  ‰›Ì– «·„Â„… ÂÊ √ﬂ»— ﬁÌ„… „« »Ì‰ “„‰ Ê’Ê· «·»Ì«‰« 
             % „‰ «·„Â«„ ·”«»ﬁ… ··„Â„… Ê«··ÕŸ… «·“„‰Ì… «· Ì ÌﬂÊ‰ ›ÌÂ«
             % «·„⁄«·Ã „ «Õ
            est(i,j)=max(drt(i,j),processor_avail(j));
         end

     end
    
  while(R(i)< Rlb_req(i) && flag_task==0 )
     
       flag_max_replica_eft=0;
        flag_one_replica_eft=0;
        max_replica=0;
        var3=1;
      for j=1:1:number_of_processors
          % the processor must be avaliable to calculate relability of the
          % replica on him
          
          if (processor_available(i,j)==0)
                replica_relability= exp((-lambda_max(j)*W(i,j)));
                flag_eft = est(i,j)+ W(i,j);
               
                  if (replica_relability >= Rlb_req(i)&& flag_eft <= sub_deadline(i) && max_relability < replica_relability)
                   max_relability= replica_relability;
                   var1=j;
                   relability= replica_relability;
                   flag_relability=1;
                   flag_one_replica_eft=flag_eft;
                   flag_task=1;
                   break;
                  else if(replica_relability < Rlb_req(i) && processor_available(i,j)==0 && replica_relability >= max_replica && flag_relability==0 && flag_eft <= sub_deadline(i))
                          max_replica=replica_relability;
                          var3=j;
                          flag_max_replica_eft=flag_eft;
                          
                      end
                  end
              
          end 
      
      end  
          
    
      
      
      %calculate R(ni)from eq (7)in notebook
      if(flag_relability==1)
      R(i)=relability;
      replica_matrix(i,var1)=relability;
      processor_available(i,var1)=1;
      aft(i,var1)=flag_one_replica_eft;
      processor_avail(var1)=flag_one_replica_eft;
      num(i)= num(i)+1;
      else
      R(i)=1-((1-R(i))*(1-max_replica));
      replica_matrix(i,var3)=max_replica;
      processor_available(i,var3)=1;
      aft(i,var3)=flag_max_replica_eft;
      processor_avail(var3)=flag_max_replica_eft;
      num(i)= num(i)+1;
      end
  end


total_relability=total_relability * R(i);

end

total_number_of_replica =sum(num);
[total_dynmic_power_consumed, result_replica_power,task_power_consumed] = app_dynmic_power_calculation(processor_available,W );




disp('total_number_of_replica from DL_LBR')
disp(total_number_of_replica)
disp('total_relability from DL_LBR')
disp(total_relability)
disp('actual relability for each task from DL_LBR')
disp(R)
disp('replica_matrix from DL_LBR')
disp(replica_matrix)
disp('processor_available from DL_LBR')
disp(processor_available)

disp('total_dynmic_power_consumed_ DL_LBR')
disp(total_dynmic_power_consumed)

disp('result_replica_power_ DL_LBR')
disp(result_replica_power)




%}

end