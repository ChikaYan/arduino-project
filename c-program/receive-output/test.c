#include <stdio.h>

int main() {
    int a = 0;

    while (1) {
        scanf("%d ", &a);
        printf("The number read was: %d\n", a);
        if (a == 0) break;
    }
    return 0;
}