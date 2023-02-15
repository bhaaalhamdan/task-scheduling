

%  EESARRlD    Energy-Efficient Scheduling Algorithm with Reliability goal  based on level Deadline partition technology  :

                                        


function [R_req,total_relability,total_number_of_replica,num,frequency_result_matrix,final_replica_relability_matrix ,R,total_dynmic_power_consumed, result_replica_power,task_power_consumed,execution_time] = EESARRlD_algorithm()
format long;

%call R_list input function for sorting the task by using ranku_function
%function

[number_of_tasks,R_req,number_of_processors,W,M,C,lambda_max,d] = input_function( );

    

%Deadline of the all application
Deadline=210;

%number of tasks
n=number_of_tasks;

%call power input function
[~,Pk_ind,Cef,mk,fk_max,fk_low,fr_u] = power_input_function(number_of_processors);

% row and colum for processor frequency matrix fr_u
   [~,fr_u_colum]=size(fr_u);
   
  tic; 
  
  
  
  
  
  
  
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% task rearange and blocks
   block_number_for_task=zeros(1,n);
   task_status =zeros(1,n);
   counter =0;
   while( counter < n)
   for i=1:1:n
       max_level=1;
      if(sum(M(:,i))==0 &&  task_status(i)==0)
              block_number_for_task(i)=1;
              task_status(i)=1;
               counter =  counter + 1;
               disp('task level for task');
                   disp(i);
                   disp('is');
                   disp( block_number_for_task(i));
             
      else
          task_can_be_assigned =1;
          for j=1:1:n
             if (M(j,i)==1 && block_number_for_task(j)== 0 &&  task_status(j)==0)  
              task_can_be_assigned =0;
             end
          end 
         if (task_can_be_assigned == 1 && task_status(i)==0)
          for j=1:1:n
             if (M(j,i)==1 && block_number_for_task(j)~= 0 &&  task_status(j)==1 )
                 x= block_number_for_task(j)+1;
                 if x > max_level
                      max_level = x; 
                 end
                     block_number_for_task(i) = max_level;
                  
                    
             end 
             
          end
          task_status(i)=1;
                   counter =  counter + 1;
                   disp('task level for task');
                   disp(i);
                   disp('is');
                   disp( block_number_for_task(i));
                   %disp('counter is');
                   %disp(counter);
         end
          
                    
      end
      
                    
                   
                    
                    
   end
   end 
   
                     
   
   disp('level number for task');
   disp(block_number_for_task);
  
  number_of_blocks=max(block_number_for_task);
 % disp(' number_of_level');
  %disp( number_of_blocks);
  
  %%%%%%%%%%%%%%%%% resort tasks%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  number_of_task_in_block=zeros(1,number_of_blocks);
  
  for i=1:1:n
      for j=1:1:number_of_blocks
      if (block_number_for_task(i)== j)
          number_of_task_in_block(j)=number_of_task_in_block(j)+1;
      end
      end
  end
  
 % disp(' number_of_task_in_level');
  %disp( number_of_task_in_block);
  
   Begining_index_of_block=zeros(1,number_of_blocks);
  for d=1:1:number_of_blocks
      if(d==1)
          Begining_index_of_block(d)=1;
      else
       Begining_index_of_block(d)= Begining_index_of_block(d-1)+number_of_task_in_block(d-1);
      end
  end
  
  
  
  %disp('Begining_index_of_level')
  %disp(Begining_index_of_block)
  %%%%%%% vector to sort task
  
  sort_of_tasks=zeros(1,n);
  
   %%%%%%% vector to know if task assgined or not, equal 1 mean assigned
   task_assigned=zeros(1,n);
   
   s=1;
     for d=1:1:number_of_blocks    
      var1=1;
         while (var1 <= number_of_task_in_block(d))
            max_suss_message=0;
           for i=1:1:n
                 if (block_number_for_task(i)== d && task_assigned(i)==0)
                     for j=1:1:n
                       if (C(i,j)> max_suss_message)
                         max_suss_message=C(i,j);
                         task_index=i;
                       else
                           if (number_of_task_in_block(d)==1)
                            task_index=i;
                           end
                       end
                     end
                 end
           end
         
           
          sort_of_tasks(s)= task_index;
          task_assigned(task_index)=1;
          s=s+1;
          var1=var1+1;
         end
     end
   
 % disp('sort_of_tasks');
  %disp( sort_of_tasks);
  
  % matrix to sort W matrix
sortW=zeros(n,number_of_processors);
     for i=1:1:n
         k= sort_of_tasks(i);
         for j=1:1:number_of_processors
            sortW(i,j)=W(k,j);  
         end
     end

W=sortW;

% matrix to sort M,C matrix
sortM=zeros(n,n);
sortC=zeros(n,n);

     for i=1:1:n
         k= sort_of_tasks(i);
         for j=1:1:n
            sortM(i,j)=M(k,j);
            sortC(i,j)=C(k,j);
         end
     end   
M= sortM;
C=sortC;

 
   
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% est and eft for each block and tasks
   est=zeros(number_of_tasks,number_of_processors);
      % erleast start time for every task
   eft=zeros(number_of_tasks,number_of_processors);
      % % erleast finish time for every task
  % vector of instances of task i recive all data from all preceddors on every processor
      drt=zeros(number_of_tasks,number_of_processors);
  % vector of actual finish time of all tasks on every processor
      aft=zeros(number_of_tasks,number_of_processors);
   % vector represent the state of all processor, is it available?
       processor_avail=zeros(1,number_of_processors);
                                                                                                                                                                                                                                                                                                        
                                                                                                                                                                                                                                                                                                       if number_of_processors == 3
                                                                                                                                                                                                                                                                                                         lambda_max=[0.0023,0.0024,0.0027];  
                                                                                                                                                                                                                                                                                                       else
                                                                                                                                                                                                                                                                                                          lambda_max=[0.0005,0.0005,0.0008 0.0005,0.0005,0.0005 0.0010,0.0015,0.0018 0.00010]; 
                                                                                                                                                                                                                                                                                                       end

  % if processor avaliable for task equal=0 else =1
   processor_available=zeros(n,number_of_processors);
   % vector represent the state of all processor, is it available?
       processor_busy_inanothertask=zeros(1,number_of_processors);
       
    for i=1:1:n
        
        W_sum=0;
        %clalcuate WCET mean for the task
        for j=1:1:number_of_processors
               W_sum=W_sum + W(i,j);
        end 
           
        W_mean=  W_sum/number_of_processors;
            
   %calculate est(i),drt,
     if(sum(M(:,i))==0)
    %i is entry node 
           est(i,:)= 0;
           for j=1:1:number_of_processors
            processor_busy_inanothertask(j)= W_mean;
            eft(i,j)= W_mean;
           end
           
     else
       
         number_of_proceddor=0;
         for d=1:1:number_of_tasks
             if((M(d,i)==1)) % if the task d is proceddor of the i task
                number_of_proceddor=number_of_proceddor+1;     
              end
         end
         
         flag_max_drt=0;
         for d=1:1:number_of_tasks
             if((M(d,i)==1)) % if the task d is proceddor of the i task
               var1=eft(d,:)+ C(d,i);
                 if(flag_max_drt < var1)
                   flag_max_drt= var1;
                 end
             end
         end
          
          
         for j=1:1:number_of_proceddor
             % the est is the max betwwen drt and processor avail
            est(i,:)=max( flag_max_drt,processor_busy_inanothertask(j));
            processor_busy_inanothertask(j)= est(i,j)+W_mean;
             eft(i,:)= est(i,j)+ W_mean;
         end

     end
  
    end
    
   

  
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
     % vector contain the the sub deadline for each task 
     sub_deadline=zeros(1,n);
     
     % laxity parameter calculation
     laxity_parameter = (Deadline-eft(n,1))/eft(n,1);
     
     
     
       disp('laxity_parameter');
     disp(laxity_parameter);
     
      for i=1:1:number_of_tasks
        sub_deadline(i)=eft(i,1)+ (eft(i,1)*laxity_parameter);
      end 
      
      % disp('sub_deadline');
     %disp(sub_deadline);
     
     
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%calculate sub relability for each block

%R_block is a vector contains relability value we get for each block

if(laxity_parameter >= 0)
    
   R_block=zeros(1,number_of_blocks);
   
   
   Rlb_req_for_block =zeros(1,number_of_blocks);
   
   %upper bound requiment vector =nthroot(Rreq,n)
   R_up_req=zeros(1,number_of_blocks);
   for s=1:1:number_of_blocks
   R_up_req(s)=nthroot(R_req, number_of_blocks);
   end
   
   
   % R is a vector contains relability value we get for each task
   R=zeros(1,n);
   % the final result for the tasks and replica relability
   final_replica_relability_matrix=zeros(n,number_of_processors);
   
   % the final result for the tasks and replica frequencecy 
   frequency_result_matrix=zeros(n,number_of_processors);
   
   %num is vector for number of replica for each task
   num=zeros(1,n);
 
   
   
   for d=1:1:number_of_blocks
       
       
   %calculate the sub Relability requiments for each block in the application    
       variable_product_relability_before_block=1;
       variable_product_relability_after_block=1;
     if(d==1)
       Rlb_req_for_block(1)=nthroot(R_req,number_of_blocks);
     else
         for x=1:1:d-1
           variable_product_relability_before_block=variable_product_relability_before_block * R_block(x);  
         end
         for y=d+1:1:number_of_blocks
           variable_product_relability_after_block=variable_product_relability_after_block * R_up_req(y);  
         end
        Rlb_req_for_block(d)=R_req /(variable_product_relability_before_block * variable_product_relability_after_block); 
     end
  
  
   

   % relability we reach for this block
    relability_we_reach_for_this_block =1;
    
   for i= Begining_index_of_block(d):1:(number_of_task_in_block(d)+Begining_index_of_block(d)-1)
       
      % processor and frequence execute the one replica that reach relability
       % requiment for the task
        flag_one_replica_processor=1;
        flag_one_replica_frequency=1;
        
         flag_relability=1;
          flag_relability_condition=0;
       
        % the min replica energy consumption
         min_energy_replica_consmption=10000000000000000000000000;   
          %the actual finish time of the replica
           flag_one_replica_aft=1;
           flag_max_replica_aft=1;
 
        for j=1:1:number_of_processors
       
              for v=1:1:fr_u_colum
                 % task replica relability calculation from eq (6) in notebook
                 var1= power(10,(fk_max(j)-fr_u(j,v))/(fk_max(j)-fk_low(j)));
                 var2=(W(i,j)*fk_max(j))/fr_u(j,v);
                 replica_relability= exp((-lambda_max(j)*var1*var2));
                % calculate the energy consumption by the replica
                var1=(Pk_ind(j)+(Cef(j)*power(fr_u(j,v),mk(j))));
                var2=(fk_max(j)/fr_u(j,v));
                replica_energy_consumption =var1*W(i,j)*var2;
                
                %calculate the est for the replica debending on aft for
                %preceddor tasks and processor avalible
                 if(sum(M(:,i))==0)
                    %i is entry node 
                      est(i,:)= 0;
                 else
                            flag_max_drt=0;
                            flag_processor_execute_task_d=zeros(1,number_of_processors);
    
                          for dd=1:1:number_of_tasks
                              if((M(dd,i)==1)) % if the task d is proceddor of the i task 
                                   for jj=1:1:number_of_processors
                                    % determine the processrors that execute task d
                                    % where d is proceddor of task i
                                   if (aft(dd,jj)~=0)
                                       flag_processor_execute_task_d(jj)= jj;
                                   end
                                   end
               
                 
                                  for jj=1:1:number_of_processors
                                     if flag_processor_execute_task_d(jj)~=0
                                        if  flag_processor_execute_task_d(jj)==jj;
                                            % the task and the proceddor are executed on
                                            % same processor and C(d,i)=0

                                             drt(i,jj)= aft(dd,flag_processor_execute_task_d(jj));
                                        else 
                                           % the task and the proceddor are executed on
                                           %diffrent processor and C(d,i)!=0
                                           drt(i,jj)= aft(dd,flag_processor_execute_task_d(jj))+C(dd,i); 
                                        end 
                                       % we chose the max drt between the processor
                     
                                      if(drt(i,jj)> flag_max_drt)
                                       flag_max_drt=drt(i,jj);
                                      end 
                                     end 
                                  end 
                              end 
         
                          end          
         
                       for jj=1:1:number_of_processors
                        % the est is the max betwwen drt and processor avail
                           est(i,jj)=max(drt(i,jj),processor_avail(jj));
                       end 

                 end 
                 
                                                
                %we must calculate the eft for no miss deadline
                % WECT is calculate by the used frequency
                flag_aft = est(i,j)+((W(i,j)*fk_max(j))/fr_u(j,v));
                
                
                
                                                   %eft_matrix_for_task(j,v)=flag_eft;
                % we want min replica energy consumption and this replica
                % no miss his deadline
                 if (replica_relability >= R_req && replica_energy_consumption <  min_energy_replica_consmption &&  flag_aft <= sub_deadline(i))
                     % save the relability we reach becuse one replica we
                     % want
                   min_energy_replica_consmption= replica_energy_consumption;
                     
                   flag_relability=replica_relability;
                   % save the processor and frequency the execute the one replica
                   flag_one_replica_processor=j;
                   flag_one_replica_frequency=fr_u(j,v);
                   flag_one_replica_aft=flag_aft;
                   flag_relability_condition=1;
                 end
              end         
        end
        % we must save this replica becuse this replica have min energy
        % consumption and no miss deadline
        
        if( flag_relability_condition==1)

          final_replica_relability_matrix(i,flag_one_replica_processor)=flag_relability;
          relability_we_reach_for_this_block=relability_we_reach_for_this_block * flag_relability;
          R_block(d)= relability_we_reach_for_this_block;
          frequency_result_matrix(i,flag_one_replica_processor)=flag_one_replica_frequency;
          aft(i,flag_one_replica_processor)=flag_one_replica_aft;
          processor_available(i,flag_one_replica_processor)= 1;
          processor_avail(flag_one_replica_processor)=flag_one_replica_aft;
          num(i)=num(i)+1; 
          R(i)=flag_relability;
        
        else
  
         while(flag_relability_condition==0 )
          
          max_replica = 0;
         
          
         for j=1:1:number_of_processors
          % the processor must be avaliable to calculate relability of the
          % replica on him
          if (processor_available(i,j)==0 && flag_relability_condition==0 )
              %for fr_u matrix
              
            for v=1:1:fr_u_colum
                 if (processor_available(i,j)==0 && flag_relability_condition ==0 )
                  % task replica relability calculation from eq (6) in notebook
                    var1= power(10,(fk_max(j)-fr_u(j,v))/(fk_max(j)-fk_low(j)));
                     var2=(W(i,j)*fk_max(j))/fr_u(j,v);
                      replica_relability= exp((-lambda_max(j)*var1*var2));
                      
                        if( replica_relability >= max_replica && flag_relability_condition==0 )
                          max_replica=replica_relability;
                          flag_max_replica_aft=flag_aft;
                           var3=j;
                           var4=fr_u(j,v);
                           relability_we_have_for_this_replica=1-((1-R(i))*(1-max_replica));
                              if( relability_we_have_for_this_replica >= R_req)
                                 flag_relability_condition =1;
                        
                               
                              end
                        end 
                 end  
              
            end  
      
          end   
          
    
         end 
         
         if(flag_relability_condition ==0)
         R(i)= 1-((1-R(i))*(1-max_replica));
         final_replica_relability_matrix(i,var3)=max_replica;
         relability_we_reach_for_this_block=relability_we_reach_for_this_block * max_replica;
          R_block(d)= relability_we_reach_for_this_block;
          aft(i,var3)=flag_max_replica_aft;
         processor_available(i,var3)=1;
         frequency_result_matrix(i,var3)=var4;
         num(i)= num(i)+1;
          processor_avail(var3)=flag_max_replica_aft;
         else
             R(i)= relability_we_have_for_this_replica;
              final_replica_relability_matrix(i,var3)=max_replica;
              processor_available(i,var3)=1;
               frequency_result_matrix(i,var3)=var4;
              num(i)= num(i)+1;
               processor_avail(var3)=flag_max_replica_aft;
               aft(i,var3)=flag_max_replica_aft;
               relability_we_reach_for_this_block=relability_we_reach_for_this_block * max_replica;
                R_block(d)= relability_we_reach_for_this_block;
         end
     
         end
         end 
       
 
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        end

      
   
   
   

       
%%%%%%%%%%%%%%%%% the second step %%% to reach block relability requiment%%


     
          while ( R_block(d) <  Rlb_req_for_block(d))
              max_R_block_help=0;
              max_replica_relability=0;
              R_block_req_is_reatched=0;
              R_block_help_from_max_replica=0;
               
              for i= Begining_index_of_block(d):1:(number_of_task_in_block(d)+Begining_index_of_block(d)-1)
                  for j=1:1:number_of_processors
                     if (processor_available(i,j)==0 &&  R_block_req_is_reatched==0)
                        for v=1:1:fr_u_colum
                            if (R_block_req_is_reatched==0)
                             % task replica relability calculation from eq (6) in notebook
                          var1= power(10,(fk_max(j)-fr_u(j,v))/(fk_max(j)-fk_low(j)));
                            var2=(W(i,j)*fk_max(j))/fr_u(j,v);
                              replica_relability= exp((-lambda_max(j)*var1*var2));
                              
                              flag_aft = est(i,j)+((W(i,j)*fk_max(j))/fr_u(j,v));
                              
                             
                                var1=1;
                                for jj=1:1:number_of_processors
                                   if(final_replica_relability_matrix(i,jj) ~=0)
                                     var1=var1*(1-final_replica_relability_matrix(i,jj));
                                   end 
                                end
                                   R_help =1-((var1)*(1-replica_relability));
                                   
                                   var5=1;
                                     for f=Begining_index_of_block(d):1:(number_of_task_in_block(d)+Begining_index_of_block(d)-1)
                                         if(f ~= i)
                                            var5= var5 * R(f);
                                         end
                                     end
                                     R_block_help=R_help*var5; 

                                     if(R_block_help >=  Rlb_req_for_block(d) && R_block_req_is_reatched ==0)
                                      R_block_req_is_reatched=1;
                                      engh_replica_relability=replica_relability;
                                      flag_engh_replica_task_index=i;
                                      flag_engh_replica_processor=j;
                                      flag_engh_replica_frequency=fr_u(j,v);
                                      flag_engh_replica_aft=flag_aft;
                                      R(i)=R_help;
                                      R_block(d)= R_block_help;
                                     break;
                                
                                     else
                                     
                                             if(max_replica_relability < replica_relability && flag_aft <= sub_deadline(i)&& R_block_req_is_reatched==0)
                                             
                                                 flag_max_replica_task_index=i;
                                                     flag_max_replica_processor=j;
                                                       flag_max_replica_frequency=fr_u(j,v);
                                                           flag_max_replica_aft=flag_aft;
                                                              
                                                                 max_replica_relability= replica_relability;
                                                                 R_block_help_from_max_replica=R_block_help;
                                             end
                                     end
                            end
                        
                        end
                     
                     end
                  
                  end
              
              end
              
              
              if(R_block_req_is_reatched ==1)
              final_replica_relability_matrix(flag_engh_replica_task_index,flag_engh_replica_processor)= engh_replica_relability;
              frequency_result_matrix(flag_engh_replica_task_index,flag_engh_replica_processor)= flag_engh_replica_frequency;
              aft(flag_engh_replica_task_index,flag_engh_replica_processor)=flag_engh_replica_aft;
               processor_avail(flag_engh_replica_processor)=flag_engh_replica_aft;
               num(flag_engh_replica_task_index)=num(flag_engh_replica_task_index)+1;
               processor_available(flag_engh_replica_task_index,flag_engh_replica_processor)=1;
               
               else
               final_replica_relability_matrix(flag_max_replica_task_index,flag_max_replica_processor)= max_replica_relability;
               frequency_result_matrix(flag_max_replica_task_index,flag_max_replica_processor)= flag_max_replica_frequency;
               aft(flag_max_replica_task_index,flag_max_replica_processor)=flag_max_replica_aft;
               processor_avail(flag_max_replica_processor)=flag_max_replica_aft;
               num(flag_max_replica_task_index)=num(flag_max_replica_task_index)+1;
               processor_available(flag_max_replica_task_index,flag_max_replica_processor)=1;
               R(flag_max_replica_task_index)=R_help;
               R_block(d)=R_block_help_from_max_replica;
               end
               
               
      
       
          end
    

   end
   
   
else 
    disp(' deadline in not enghoh');
end

   
   
   
  %disp('R(i)');
  %disp(R);
   total_relability=prod(R_block);
   total_number_of_replica=sum(num);
   [total_dynmic_power_consumed, result_replica_power,task_power_consumed] = app_dynmic_power_calculation(frequency_result_matrix,W );
    execution_time=toc;
   
   
   %disp('relability requiment =')
   %disp(R_req )
    disp(' Rlb_req_for_block')
    disp( Rlb_req_for_block )
   
  % disp('R_block');
   %disp(R_block)
   
   
   
   disp('Deadline =')
   disp(Deadline)
   disp('total_relability =')
   disp(total_relability)
   disp('number of replica for each task')
    disp(num)
   disp('total_dynmic_power_consumed')
   disp(total_dynmic_power_consumed)
   disp('execution_time')
   disp(execution_time)
   disp('frequency_result_matrix')
    disp(frequency_result_matrix)

    disp('total_number_of_replica=')
    disp(total_number_of_replica)
    
    
    disp('final replica relability matrix')
    disp(final_replica_relability_matrix)
    
    disp('relability for each task')
    disp(R)
    
    disp('result_replica_power')
    disp(result_replica_power)
    disp('task_power_consumed')  
    disp(task_power_consumed)
    
       
end