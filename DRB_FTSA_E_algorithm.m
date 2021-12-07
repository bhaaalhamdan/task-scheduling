function [] = DRB_FTSA_E_algorithm()


[R_list,number_of_tasks,R_req,number_of_processors,W,M,C,lambda_max,d] = ProrityList( );

tic;
Deadline=5;
makespan=0;
% vector represent if the task are replicated or not
% the value=0 that mean the task not replicated,value=1 the task replicated


% vector of earleast start time of all tasks on every processor
est=zeros(number_of_tasks,number_of_processors);
% vector of instances of task i recive all data from all preceddors on every processor
drt=zeros(number_of_tasks,number_of_processors);
% vector of actual finish time of all tasks on every processor
aft=zeros(number_of_tasks,number_of_processors);
% vector of earlest finish time of all tasks on every processor
eft=zeros(number_of_tasks,number_of_processors);
% vector represent the state of all processor, is it available?
processor_avail=zeros(1,number_of_processors);



% row 3,4,5,6 in pesudo algorithm in paper 7 to caluclate the makespan
   for i=1:1:number_of_tasks
       x=R_list(i);
       % «”‰«œ «·„Â«„ «·„— »… Õ”» «·√Ê·ÊÌ… ≈·Ï «·„⁄«·Ã ÕÌÀ  ”‰œ «·„Â„… ≈·Ï
       % «·„⁄«·Ã «·–Ì Ì‰ ÂÌ „‰  ‰›Ì–Â« √Ê·«
       [makespan,processor_avail,est,drt,aft,eft] = MapTasksToProcessors(x,makespan,est,drt,aft,eft,processor_avail); 
   end
 %{  
disp('makesapn1')
disp(makespan)
disp('processor_avail')
 disp(processor_avail)
 disp('earleast start time')
  disp(est)
 disp('earleast fisish time')
 disp(eft)
 disp('actual finish time ')
 disp(aft)
   
   %}
  % call the function  FindRlist
[total_relability,total_dynmic_power_consumed,rlist,k,processor_execute_additional_replica,makespan ]=FindRlist( Deadline, makespan, processor_avail, est,drt,aft,eft);





% the total number of replica = number_of_tasks + the additional replica number(
% k)
 total_number_of_replica= number_of_tasks + k;
 
 execution_time=toc;
 
 
  disp('relability Requiment =')  
 disp(R_req)
 disp('Deadline')
 disp(Deadline)  
 disp('total_relability')  
 disp(total_relability)
 disp('total_dynmic_power_consumed')
 disp(total_dynmic_power_consumed)
  disp(' total_number_of_replica')
   disp(total_number_of_replica)
   disp('execution_time')
   disp(execution_time)
   
  

 
 %{
 disp('makesapn')
 disp(makespan)
 
 disp('rlist')
 disp(rlist)
 disp('k')
  disp(k)
 disp('processor_execute_additional_replica')
  disp(processor_execute_additional_replica)
  %} 
end

