function [R_list,number_of_tasks,R_req,number_of_processors,W,M,C,lambda_max,d] = ProrityList( )

[number_of_tasks,R_req,number_of_processors,W,M,C,lambda_max,d] = input_function( );
% number of tasks
n=number_of_tasks;
% the sort list by decresing order of runku tasks values
R_list=zeros(1,n);

% the ranku value of all task
final_rank_u_values=zeros(1,n);
% the ranku value of all task but we can edit this list
 temp_rank_u_values=zeros(1,n);
 %for call the runku_function function
runk_u=zeros(1,n);
% call runku_function function for each task
for i=1:1:n
    final_rank_u_values(i)=runku_function(i,runk_u);
    temp_rank_u_values(i)=runku_function(i,runk_u);
end

% find the max value ranku and add it to rlist for sorting
for i=1:1:n
   flag_max_value=0;
   for k=1:1:n
       if( temp_rank_u_values(k)> flag_max_value)
        flag_max_value= temp_rank_u_values(k);
        % the task that have maxiumum ranku value
        flag_max_value_task=k;
       end
   end
   % edit  temp_rank_u_values vector ⁄‰œ «Œ Ì«— «ﬂ»— ﬁÌ„… ›Ì «·‘⁄«⁄ ÌÃ» ⁄œ„
   % Õ”«»Â« „—… √Œ—Ï
   temp_rank_u_values(flag_max_value_task)=0;
   % add the task that the have maxiumum ranku value
   R_list(i)= flag_max_value_task;
end

% matrix to sort W matrix
sortW=zeros(n,number_of_processors);
     for i=1:1:n
         k= R_list(i);
         for j=1:1:number_of_processors
            sortW(i,j)=W(k,j);  
         end
     end

W=sortW;

% matrix to sort M,C matrix
sortM=zeros(n,n);
sortC=zeros(n,n);

     for i=1:1:n
         k= R_list(i);
         for j=1:1:n
            sortM(i,j)=M(k,j);
            sortC(i,j)=C(k,j);
         end
     end   
M= sortM;
C=sortC;

end

