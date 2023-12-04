#include <iostream>
#include <fstream>
#include "pthread.h"
#include "testWithThreads.cpp"

double ScalarProduct(double A[], double B[], int N);
void TestWithoutThreads(double A[], double B[], int N);

int main() {
    std::vector<long long> sizes{10'000'000, 500'000'000, 1'000'000'000};
    std::vector<int> threadsSizes{2, 4, 8, 1000};

    for (const auto& size : sizes) {
        double *A = new double[size];
        double *B = new double[size];

        // A generating
        for (int i = 0; i < size; ++i) {
            A[i] = i + 1;
        }

        // B generating
        for (int i = 0; i < size; ++i) {
            B[i] = static_cast<double>(size) - i;
        }
        TestWithoutThreads(A, B, size);
        for (const auto& threadSize : threadsSizes) {
            TestWithThreads(A, B, size, threadSize);

        }
        delete[] A;
        delete[] B;
    }
    return 0;
}

double ScalarProduct(double A[], double B[], int N) {
    double result;
    for (int i = 0; i < N; ++i) {
        result += A[i] * B[i];
    }
    return result;
}

void TestWithoutThreads(double A[], double B[], int N) {
    std::ofstream out;
    out.open("data.txt", std::ios::app);

    auto start = std::chrono::high_resolution_clock::now();
    double result = ScalarProduct(A, B, N);
    auto elapsed = std::chrono::high_resolution_clock::now() - start;
    double millisec =
            static_cast<double>(std::chrono::duration_cast<std::chrono::microseconds>(elapsed).count()) / 1000.0;

    std::cout << "Result is " << result << "\n";
    out << N << ";" << 1 << ";" << millisec << "\n";

    out.close();
}
