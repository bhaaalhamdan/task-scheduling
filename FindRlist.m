function [total_relability, total_dynmic_power_consumed,rlist,k,processor_execute_additional_replica,makespan ] = FindRlist( D, makespan, processor_avail, est,drt,aft,eft)
%the goal of this function to find out the maximum number (denoted by
% K) of tasks that need to be fault-tolerant.
%
[R_list,number_of_tasks,R_req,number_of_processors,W,M,C,lambda_max,d] = ProrityList( );

%maximum number of tasks can be fault-tolerant. 
k=1;
% vector represent if the task are replicated or not
% the value=0 that mean the task not replicated,value=1 the task replicated
rlist=zeros(1,number_of_tasks);
% the processor execute the additional replica
processor_execute_additional_replica =zeros(1,number_of_tasks);

% the task (primary and backup ) relability
R=ones(1,number_of_tasks);
% the task primary relability
replica_relability=zeros(1,number_of_tasks);
% the task backup relability
replica_relability_additional=zeros(1,number_of_tasks);
% the task primary frequency 
frequency_result_matrix=zeros(number_of_tasks,number_of_processors);
% the task backup frequency
frequency_result_matrix__additional_replica=zeros(number_of_tasks,number_of_processors);
% the all total relability
total_relability= 0;

% ��� ���� ������ ��� ����� ���������� ������ ������� ��� ����� ������
%������� 
while makespan < D && k < number_of_tasks && total_relability < R_req
    
   % �� ������� ���� ������ ������ �������� ��� ��������� ����� ��� �����
   % ������ ������ ������� ���� ������ ����� ���
   
       x=R_list(k);
       [makespan,processor_avail,est,drt,aft,eft] = MapTasksToProcessors(x,makespan,est,drt,aft,eft,processor_avail); 
    
    
    flag_min_eft=D;
    flag_min_eft_processor=1;
  for j=1:1:number_of_processors
      % ��� eft ����� ������ i ��� ���� ���������
      var=processor_avail(j)+W(k,j);
      if(flag_min_eft > var )
          % ����� ������� ���� eft ������
         flag_min_eft =var;
         flag_min_eft_processor=j;
      end 
  end
  
 
%  processor_avail  ���� ������ ����
% ����� ���� �� ������� ����� �� ����� ������
      processor_avail(flag_min_eft_processor)= flag_min_eft;
      % ���� �� �� ������� ���� ��� ������ ������ �������� ��� ������� ����
      % ���� ��� eft
      processor_execute_additional_replica(k)=flag_min_eft_processor;
      % �� ���� ������ ��� ���� ������ �� �� ��� ���� ��� �� ��
      rlist(k)=1;
      % ���� ��� ����� ��������
      k=k+1;
      
      
      % ���� ������ ���� ������ ������ ��� ���� ���� ����� �����
      if(makespan < processor_avail(flag_min_eft_processor))
         makespan = processor_avail(flag_min_eft_processor); 
      end
      
      
      
      
    for i=1:1:number_of_tasks 
        flag_processor_execute_task_i=1;
        % ���� ������ ������� ���� ��� ������ ������ ��������
       for j=1:1:number_of_processors
              if (aft(i,j)~=0)
                  flag_processor_execute_task_i= j;
              end
              
       end 
       % ���� ��������� ������� �� ����� ������ ������ ��������
       replica_relability(i) = exp((-lambda_max(flag_processor_execute_task_i)*W(i,flag_processor_execute_task_i)));
       frequency_result_matrix(i,flag_processor_execute_task_i)=1;
       % �� ��� ���� ����� ����� ��� ���� ���� ���� �������� ������ i
       % �������� ��� ���� ��������� ������� �� ��� ������
       if rlist(i)==1
       replica_relability_additional(i) = exp((-lambda_max(processor_execute_additional_replica(i))*W(i,processor_execute_additional_replica(i))));
       frequency_result_matrix__additional_replica(i,processor_execute_additional_replica(i))=1;
       end
       % ����� ������� ������� ����� ��������� �� ��� ����� ���� �� ����
       R(i)=1-((1-replica_relability(i))*(1-replica_relability_additional(i)));
       % ��������� ������ �� ���� ���� ���� ��� ������� ������
       total_relability= prod(R);  
   end
end

   
% ���� ������ ��������� ����� ����� ������ ������� �� ���� ������ ���������
% ����� ����� ������ ���������� ������� ���� ��� ������ ������ ���������
% ����� ����� ������ (�������� �����������)
 [total_dynmic_power_consumed1] = app_dynmic_power_calculation(frequency_result_matrix,W );
 [total_dynmic_power_consumed2] = app_dynmic_power_calculation(frequency_result_matrix__additional_replica,W );
 total_dynmic_power_consumed=total_dynmic_power_consumed1 + total_dynmic_power_consumed2;

end