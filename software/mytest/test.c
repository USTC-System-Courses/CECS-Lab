void bubble_sort(int a[], int n){
    int i, j, temp;
    for(i = 0; i < n; i++){
        for(j = 0; j < n - i - 1; j++){
            if(a[j] > a[j+1]){
                temp = a[j+1];
                a[j+1] = a[j];
                a[j] = temp;
            }
        }
    }
}
int main(){
    int a[10] = {1, 3, 5, 7, 9, 2, 4, 6, 8, 0};
    bubble_sort(a, 10);
    return 0;
}