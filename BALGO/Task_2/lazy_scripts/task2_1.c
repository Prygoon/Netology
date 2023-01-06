#include <stdint.h>
#include <stdio.h>

uint8_t first(uint8_t a, uint8_t b, uint8_t c, uint8_t d) {
    return (!(a | b & c)) & (a & b);
}

uint8_t second(uint8_t a, uint8_t b, uint8_t c, uint8_t d) {
    return !a | !c & !b;
}

uint8_t third(uint8_t a, uint8_t b, uint8_t c, uint8_t d) {
    return a & b & c | d;
}

uint8_t fourth(uint8_t a, uint8_t b, uint8_t c, uint8_t d) {
    return !(a & !b & c);
}

uint8_t fifth(uint8_t a, uint8_t b, uint8_t c, uint8_t d) {
    return (!(a | b)) | c;
}

uint8_t calculate_table(uint8_t num,
                        uint8_t (*func)(uint8_t, uint8_t, uint8_t, uint8_t)) {
    uint8_t a = (num & (1 << 3)) >> 3;
    uint8_t b = (num & (1 << 2)) >> 2;
    uint8_t c = (num & (1 << 1)) >> 1;
    uint8_t d = num & 1;

    return func(a, b, c, d);
}

void print_header() {
    for (uint8_t i = 0; i < 0x10; ++i) {
        printf("%d ", i);
    }
    printf("\n");
}

void print_results(uint8_t (*func)(uint8_t, uint8_t, uint8_t, uint8_t)) {
    for (uint8_t i = 0; i < 0x10; ++i) {
        printf("%d ", calculate_table(i, func));
        if (i > 8) {
            printf(" ");
        }
    }
    printf("\n");
}

int main() {
    print_header();
    print_results(first);
    print_results(second);
    print_results(third);
    print_results(fourth);
    print_results(fifth);
}
