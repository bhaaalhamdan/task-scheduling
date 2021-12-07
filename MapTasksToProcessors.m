function [ makespan, processor_avail,est,drt,aft,eft ] = MapTasksToProcessors( x , makespan, est, drt, aft, eft, processor_avail )
%DRB-FTSA-E maps all tasks to appropriate processors in pre-allocated way
%and calculates the makespan

[R_list,number_of_tasks,R_req,number_of_processors,W,M,C,lambda_max,d] = ProrityList( );
 
% processor execute the minimum eft
  flag_min_eft_processor=0;
  
  
  
  
  
 % test the task if is an entry task
 % ���� ����� �� ������ ���� ���� ������� ������� ��� ��� ���� ������ �� 0
if(sum(M(:,x))==0)
    %��� ��� ����� ���� ����� �� 0
           est(x,:)=processor_avail(:)+0;
           flag_min_eft=1000;
           for j=1:1:number_of_processors
               % ��� ����� ������� �� ��� ��� ������� �������� ��� ���
               % ������� ��� ���� ����� ��� ������� 0
             eft(x,j)= est(x,j)+W(x,j);
             % ��� ���� ���� ��� ����� ��� ����� �� ��� ����� ������
             % ������� ���� ������
             if eft(x,j)< flag_min_eft
                 flag_min_eft=eft(x,j);
                 flag_min_eft_processor=j;  
             end
           end
           % ��� ������� ������ �� ��� ����� ������� ������ 
            aft(x,flag_min_eft_processor)= flag_min_eft;
            processor_avail(flag_min_eft_processor)=flag_min_eft;
           
else % the task not an entery task
    

    flag_max_drt=0;
    
         for i=1:1:number_of_tasks
             if((M(i,x)==1)) % if the task is proceddor of the x task
                  flag_processor_execute_task_i=1;
                  % ����� ������� ���� ��� ������������� ������ x
               for j=1:1:number_of_processors
                   if (aft(i,j)~=0)
                    flag_processor_execute_task_i= j;
                   end
               end
                 
                    for j=1:1:number_of_processors
                        if  flag_processor_execute_task_i==j;
                        % ������ i �� ���� ����� ������ x  
                        % drt ���� ��� ���� �������� �� ������ �������
                        % ������ i 
                           drt(x,j)= aft(i,flag_processor_execute_task_i);
                        else
                            
                           drt(x,j)= aft(i,flag_processor_execute_task_i)+C(i,x); 
                        end
                      % ��� ���� �������� ����� ������ ������� ��� ����
                      % ����� ������
                          if(drt(x,j)>flag_max_drt)
                            flag_max_drt=drt(x,j);
                          end 
                    end
              end
         end
         
         flag_min_eft=1000;
         flag_min_eft_processor=0;
         % calculate est and eft and choice the minimum eft
         for j=1:1:number_of_processors
             % ��� ����� ����� ������ �� ���� ���� �� ��� ��� ���� ��������
             % �� ������ ������ ������ ������� ������� ���� ���� ����
             % ������� ����
            est(x,j)=max(drt(x,j),processor_avail(j));
            % ���� ��� ������ ����� ������ �� ��� ����� ������ ������ ����
            % ��� ����� ������
            eft(x,j)=est(x,j)+ W(x,j);
            % ��� ���� ��� ����� ������� ������ ������ �� ��� �� ���������
            if eft(x,j)<flag_min_eft
               flag_min_eft=eft(x,j);
               flag_min_eft_processor=j;
            end
         end
         % ����� ������ ������ ������ �� ���� ��� ����� ���
         aft(x,flag_min_eft_processor)= flag_min_eft;
         % ���� ����� ������ ���� ������� ����� ��� ���� ����� ���� ����
         % ����
         processor_avail(flag_min_eft_processor)=flag_min_eft;

         
end

% ������ ������ �� ���� ��� ����� ��� ��������� ������ ��� ���� ��� �����
% ������� ����� ������ �������� �� ������ ������ ���� ����� ���������
  if  makespan < aft(x,flag_min_eft_processor)
      makespan = aft(x,flag_min_eft_processor);   
  end

%disp('est')
%disp(est)
%disp('eft')
%disp(eft)
%disp('aft')
%disp(aft)
%disp('processor_avail')
%disp(processor_avail)

end

