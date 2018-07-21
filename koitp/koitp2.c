#include <stdio.h>

int check(int size, int ground[][size]){
  int i,j,k,l,count=0;
  for(i=0;i<size;i++){
    for(j=0;j<size;j++){
      scanf("%d", &ground[i][j]);
    }
  }

  for(i=0;i<size;i++){
    for(j=0;j<size;j++){
      int deadg=0;
      int water=0;
      int mountain=0;
      int grass=0;

      for(k=i-1;k<=i+1;k++){
        for(l=j-1;l<=j+1;l++){
          if(k>=0 & l>= 0 & k<size & l<size){
            //printf("%d %d\n",k,l);
            if(ground[k][l] == 0) deadg = 1;
            else if(ground[k][l] == 1) water = 1;
            else if(ground[k][l] == 2) mountain = 1;
            else grass = 1;
          }
        }
      }
      //printf("%d %d %d %d\n",deadg,water,mountain,grass);
      if(deadg == 0 & water == 1 & mountain == 1 & grass == 1) count++;
      //printf("---count: %d\n",count);
    }
  }

  return count;
}

int main() {
  int tc,size,i = 0;
  scanf("%d",&tc);
  int result[tc];

  for(i=0;i<tc;i++){
    scanf("%d",&size);
    int ground[size][size];
    result[i] = check(size,ground);
  }

  for(i=0;i<tc;i++){
    printf("#%d %d\n",i+1,result[i]);
  }
  return 0;
}
