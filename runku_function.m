function [ result] = runku_function(x,runk_u)

format short;
%call input function
[number_of_tasks,R_req,number_of_processors,W,M,C,lambda_max,d] = input_function( );
 % number of tasks   
n= number_of_tasks;
    
max_runk_u=0;
% for each task we need to calculate the WECT mean (on all processors)
        var =0;
        for j=1:1:number_of_processors
        var  = var + W(x,j); 
        end
        w_mean =var/number_of_processors;
     % the ranku law
          for k=x+1:1:n
             if(M(x,k)==1) 
               var1= C(x,k)+ runku_function(k,runk_u);
                   if(var1> max_runk_u)
                    max_runk_u=var1;
                   end
             end
           end
    runk_u(x)=w_mean+ max_runk_u;
    result=runk_u(x);
    
end

