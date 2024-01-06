#include <iostream>
#include <cmath>
#include <vector>

double LibraryRoot(double num) {
    return std::cbrt(num);
}

double IterationRoot(double num) {
    // Дано
    int rootDegree = 3; // кубический корень
    double eps = 0.0001;

    double root = num / rootDegree;
    double copy = num;

    while (std::abs(root - copy) >= eps) {
        copy = num;
        for (int i = 1; i < rootDegree; ++i) {
            copy = copy / root;
        }

        root = 0.5 * (copy + root);
    }

    return root;
}

void Compare(double num1, double num2) {
    std::cout << "Библиотечный метод: " << num1 << "\n";
    std::cout << "Итерационный метод: " << num2 << "\n";
    std::cout << "Разница в процентах: " << 100 - (num2 / num1) * 100 << "\n\n";
}

int main() {
    std::vector<double> tests{0, 8, -8, 15, -91};

    for (const double number : tests) {
        Compare(LibraryRoot(number), IterationRoot(number));
    }
}
