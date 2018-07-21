
#include <stdio.h>

int rest(int page,int startp,int jumpp,int restnum,int restp[]){
  int i,j,count = 0;
  for(i=0;i<restnum;i++){
    if(restp[i]>=startp){
      restp[i] -= startp;
      if((restp[i] % (jumpp+1) == 0)) count++;
    }
  }
  return count;
}

int main(){
  int tc,page,startp,jumpp,restnum,i,j = 0;

  scanf("%d",&tc);

  int result[tc];

  for(int i=0;i<tc;i++){
    scanf("%d",&page);
    scanf("%d",&startp);
    scanf("%d",&jumpp);
    scanf("%d",&restnum);
    int restp[restnum];
    for(j=0;j<restnum;j++){
      scanf("%d",&restp[j]);
    }
    result[i]=rest(page,startp,jumpp,restnum,restp);
  }
  for(i=0;i<tc;i++){
    printf("#%d %d\n",i+1,result[i]);
  }
}
