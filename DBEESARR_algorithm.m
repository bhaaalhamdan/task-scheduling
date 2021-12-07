

%     DBEESARR_algorithm deadline-based energy-efficient scheduling
%     algorithm with Relability requiment
                                        


function [R_req,total_relability,total_number_of_replica,num,frequency_result_matrix,final_replica_relability_matrix ,R,total_dynmic_power_consumed, result_replica_power,task_power_consumed] = DBEESARR_algorithm()
format long;

%call R_list input function for sorting the task by using ranku_function
%function

[number_of_tasks,R_req,number_of_processors,W,M,C,lambda_max,d] = input_function( );

    

%Deadline of the all application
Deadline=150;

%number of tasks
n=number_of_tasks;

%call power input function
[~,Pk_ind,Cef,mk,fk_max,fk_low,fr_u] = power_input_function(number_of_processors);

% row and colum for processor frequency matrix fr_u
   [~,fr_u_colum]=size(fr_u);
   
  tic;   
     % vector contain the the sub deadline for each task 
     sub_deadline=zeros(1,n);
     for s=n:-1:1
         sum_c=0;
         for j=1:1:n
           sum_c=sum_c+C(s,j);
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
     
     [R_list,number_of_tasks,R_req,number_of_processors,W,M,C,lambda_max,d] = ProrityList( );
      % vector of earleast start time of all tasks on every processor
      est=zeros(number_of_tasks,number_of_processors);
      % vector of instances of task i recive all data from all preceddors on every processor
      drt=zeros(number_of_tasks,number_of_processors);
      % vector of actual finish time of all tasks on every processor
      aft=zeros(number_of_tasks,number_of_processors);
      
      % vector represent the state of all processor, is it available?
       processor_avail=zeros(1,number_of_processors);
      
     
     
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
   
   Rlb_req =zeros(1,n);
   
   %upper bound requiment vector =nthroot(Rreq,n)
   R_up_req=zeros(1,n);
   for s=1:1:n
   R_up_req(s)=nthroot(R_req, number_of_tasks);
   end
   
   %calculate the sub deadline for each task in the application
   for i=1:1:n
     %relability_requiment fron each task
     %ÏÇáÉ ÇáÌÐÑ Çáäæäí ÈÇáãÇÊáÇÈ
     %nthroot(x,N) ÍíË x åæ ÇáÚÏÏ
     % ÃÃãÇ n åæ ÇáÃÓ
     %ÇáÞÇäæä ÇáÑíÇÖí ãä ÇáãÞÇáÉ 24
       variable_product_relability_before_task=1;
       variable_product_relability_after_task=1;
     if(n==1)
        Rlb_req(1)=nthroot(R_req, n);
     else
         
         for x=1:1:i-1
           variable_product_relability_before_task=variable_product_relability_before_task* R(x);  
         end
         for y=i+1:1:n
           variable_product_relability_after_task=variable_product_relability_after_task * R_up_req(y);  
         end
         Rlb_req(i)=R_req /(variable_product_relability_before_task * variable_product_relability_after_task); 
     end
       
     %calculate est(i),drt,
     if(sum(M(:,i))==0)
    %i is entry node 
           est(i,:)= 0;
     else
       flag_max_drt=0;
       flag_processor_execute_task_d=zeros(1,number_of_processors);
    
         for d=1:1:number_of_tasks
             if((M(d,i)==1)) % if the task d is proceddor of the i task 
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
                            % the task and the proceddor are executed on
                            % same processor and C(d,i)=0

                           drt(i,j)= aft(d,flag_processor_execute_task_d(j));
                        else
                            % the task and the proceddor are executed on
                            %diffrent processor and C(d,i)!=0
                           drt(i,j)= aft(d,flag_processor_execute_task_d(j))+C(d,i); 
                        end
                      % we chose the max drt between the processor
                     
                          if(drt(i,j)> flag_max_drt)
                            flag_max_drt=drt(i,j);
                          end
                        end
                    end
              end
         end
         
         for j=1:1:number_of_processors
             % the est is the max betwwen drt and processor avail
            est(i,j)=max(drt(i,j),processor_avail(j));
         end

     end
     
       
   % replica_matrix_for_task is relability matrix for each relability
   % for each processor and every frequency can be calculate and this
   % matrix private for each task
   replica_matrix_for_task=zeros(number_of_processors,fr_u_colum);
   
    %  eft_matrix_for_task is eft matrix for each replica
   % for each processor and every frequency can be calculate and this
   % matrix private for each task
    eft_matrix_for_task= zeros(number_of_processors,fr_u_colum);
   % boolean variable equal=0 if we dont reach the relability requiment
   % from each task,equal=1 we reach relability requiment from the task
   flag_task_relability=0;
   % boolean variable for max and min replica
   min_energy_replica_consmption=10000000000000000000000000;
   max_replica=0;
   % processor and frequence execute max replica
   flag_max_replica_processor=1;
   flag_max_replica_frequency=1;
   %
   flag_previous_energy=0;
   var4=1;
   % processor and frequence execute the one replica that reach relability
   % requiment for the task
   flag_one_replica_processor=0;
   flag_one_replica_frequency=0;
   % the tow processors and frequence execute min replica
   flag_min_replica_processor=zeros(1,2);
   flag_min_replica_frequency=zeros(1,2); 
   flag_replica_eft=zeros(1,2);
   
   %earlest finish time of the tow replica
   replica_one_eft= 0;
   replica_tow_eft= 0;
   
   %the earleast finish time of the replica
   flag_one_replica_eft=0;
   
   
   
    max_replica_eft=0;
   % ÇáãÑÍáÉ ÇáÃæáì ÍÓÇÈ ßá ÇáÇÍÊãÇáÇÊ ÇáããßäÉ ãÚÇáÌ/ÊÑÏÏ æÞíãÉ ÇáãæËæÞíÉ
   % ÇáäÇÊÌÉ Úä ßá ãäåÇ ááãåÉ i
 
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
                %here every replica relability value saved to matrix
                %private for each task
                replica_matrix_for_task(j,v)=replica_relability;
                %we must calculate the eft for no miss deadline
                % WECT is calculate by the used frequency
                flag_eft = est(i,j)+((W(i,j)*fk_max(j))/fr_u(j,v));
                
                eft_matrix_for_task(j,v)=flag_eft;
                % we want min replica energy consumption and replica relability reach relability requiment
                 if (replica_relability >= Rlb_req(i)&& replica_energy_consumption <  min_energy_replica_consmption &&  flag_eft <= sub_deadline(i))
                     % save the relability we reach becuse one replica reach the relability requment
                   R(i)=replica_relability;
                   min_energy_replica_consmption= replica_energy_consumption;
                   % the relability requmiment is ontained (we reach)
                   flag_task_relability=1;
                   % save the processor and frequency the execute the one replica
                   flag_one_replica_processor=j;
                   flag_one_replica_frequency=fr_u(j,v);
                   flag_one_replica_eft=flag_eft;
                 end
              end         
        end
        %ØÇáãÇ æÕáäÇ áÞíãÉ ÇáãæËæÞíÉ ÇáãØáæÈÉ äÞæã ÈÊËÈíÊ ÞíãÉ ÇáãæËæÞíÉ
        %æÇáãÚÇáÌ ÇáÐí íäÝÐ ÇáäÓÎÉ æÇáÊÑÏÏ æäÒíÏ ÚÏÏ ÇáäÓÎ ÈãÞÏÇÑ 1
       if (flag_task_relability == 1)
          final_replica_relability_matrix(i,flag_one_replica_processor)=R(i);
          frequency_result_matrix(i,flag_one_replica_processor)=flag_one_replica_frequency;
          aft(i,flag_one_replica_processor)=flag_one_replica_eft;
          processor_avail(flag_one_replica_processor)=flag_one_replica_eft;
          num(i)=num(i)+1; 
       end
       
       % if no one replica can reach the relability requiment
      if(flag_task_relability == 0)
          while (R(i) < Rlb_req(i))
             for j=1:1:number_of_processors-1
                 if (processor_available(i,j)==0)
                 for v1=1:1:fr_u_colum
                    for k=j+1:1:number_of_processors
                        if (processor_available(i,k)==0)
                        for v2=1:1:fr_u_colum
                           %calculate the relability of the tow replica with previous replica relability if exists(var4)
                           var3=1-((1-replica_matrix_for_task(j,v1))*(1-replica_matrix_for_task(k,v2))* var4);
                           %calculate the enery consumption
                           % the fist replica
                           var1=(Pk_ind(j)+(Cef(j)*power(fr_u(j,v1),mk(j))));
                           var2=(fk_max(j)/fr_u(j,v1));
                           replica_energy_consumption1 =var1*W(i,j)*var2;
                           % the second replica
                           var1=(Pk_ind(k)+(Cef(k)*power(fr_u(k,v2),mk(k))));
                           var2=(fk_max(k)/fr_u(k,v2));
                           replica_energy_consumption2 =var1*W(i,k)*var2;
                           % the total energy is the first replica energy consumption + the second replica energy consumption
                           replica_energy_consumption= flag_previous_energy + replica_energy_consumption1+replica_energy_consumption2;
                           %we must calculate the eft of the tow relplica for no miss deadline
                          % WECT is calculate by the used frequency
                           replica_one_eft= est(i,j)+((W(i,j)*fk_max(j))/fr_u(j,v1));
                           replica_tow_eft= est(i,k)+((W(i,k)*fk_max(k))/fr_u(k,v2));
                
                          if(var3 >= Rlb_req(i) && replica_energy_consumption < min_energy_replica_consmption && replica_one_eft <= sub_deadline(i)&& replica_tow_eft <= sub_deadline(i))
                           R(i)=var3;
                           min_energy_replica_consmption= replica_energy_consumption;
                           flag_task_relability =1;
                           flag_min_replica_processor(1)=j;
                           flag_min_replica_processor(2)=k;
                           processor_available(i,j)=1;
                           processor_available(i,k)=1;
                           flag_min_replica_frequency(1)=fr_u(j,v1);
                           flag_min_replica_frequency(2)=fr_u(k,v2);
                           flag_half_replica_relability(1)=replica_matrix_for_task(j,v1);
                           flag_half_replica_relability(2)=replica_matrix_for_task(k,v2);
                           flag_replica_eft(1)=replica_one_eft;
                           flag_replica_eft(2)=replica_tow_eft;
                           
                          else if ((replica_matrix_for_task(j,v1))> max_replica && processor_available(i,j)==0 && eft_matrix_for_task(j,v1)<= sub_deadline(i))
                                max_replica = replica_matrix_for_task(j,v1);
                                flag_max_replica_processor=j;
                                flag_max_replica_frequency=fr_u(j,v1);
                                max_replica_eft=eft_matrix_for_task(j,v1);
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
                 aft(i,flag_min_replica_processor(1))=flag_replica_eft(1);
                 aft(i,flag_min_replica_processor(2))=flag_replica_eft(2);
                 processor_avail(flag_min_replica_processor(1))=flag_replica_eft(1);
                 processor_avail(flag_min_replica_processor(2))=flag_replica_eft(2);
                 num(i)=num(i)+2; 
             else if (flag_task_relability == 0)
                    var4=var4 *(1-max_replica);
                    final_replica_relability_matrix(i,flag_max_replica_processor)= max_replica;
                    frequency_result_matrix(i,flag_max_replica_processor)=flag_max_replica_frequency;
                    processor_available(i,flag_max_replica_processor)=1;
                    aft(i,flag_max_replica_processor)=max_replica_eft;
                    % calculate the max_replica energy consumption
                           var1=(Pk_ind(flag_max_replica_processor)+(Cef(flag_max_replica_processor)*power(fr_u(flag_max_replica_processor,flag_max_replica_frequency),mk(flag_max_replica_processor))));
                           var2=(fk_max(flag_max_replica_processor)/fr_u(flag_max_replica_processor,flag_max_replica_frequency));
                           max_replica_energy =var1*W(i,flag_max_replica_processor)*var2;
                           flag_previous_energy=flag_previous_energy+ max_replica_energy;
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
   
   
   disp('relability requiment =')
   disp(R_req )
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
    disp('relability requiment from each task =')
    disp(Rlb_req)
    
    disp('final replica relability matrix')
    disp(final_replica_relability_matrix)
    
    disp('relability for each task')
    disp(R)
    
    disp('result_replica_power')
    disp(result_replica_power)
    disp('task_power_consumed')  
    disp(task_power_consumed)
    disp('time parameters')
    disp('############################################################')
       disp('est')
        disp(est)
        disp('aft')
        disp(aft)
       
   %}
end