# recursion 递归  
fibs <- function(n){  
  if(n==1 | n==2){  
    return(1)  
  }  
  else{  
    return(fibs(n-1)+fibs(n-2))  
  }  
}  













