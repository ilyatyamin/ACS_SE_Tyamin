#include <thread>

struct ThreadPackage {
    double *array1;
    double *array2;
    int threadNum;  // Номер потока
    int allThreads;
    int N; // кол-во элементов
    double sum;     // Формируемая частичная сумма
};

void *startFunc(void *package) {
    auto *pack = (ThreadPackage *) package;
    pack->sum = 0.0;
    for (int startCounter = (pack->N / pack->allThreads) * pack->threadNum; startCounter < (pack->N / pack->allThreads) * (pack->threadNum+1); ++startCounter) {
        pack->sum += pack->array1[startCounter] * pack->array2[startCounter];
    }
    return nullptr;
}

void TestWithThreads(double A[], double B[], int N, int threadsNum) {
    std::ofstream out;
    out.open("data.txt", std::ios::app);

    pthread_t threads[threadsNum];
    ThreadPackage threadPackages[threadsNum];

    auto start = std::chrono::high_resolution_clock::now();

    // Создаем дочерние потоки
    for (int i = 0; i < threadsNum; ++i) {
        threadPackages[i].array1 = A;
        threadPackages[i].array2 = B;
        threadPackages[i].threadNum = i;
        threadPackages[i].N = N;
        threadPackages[i].allThreads = threadsNum;
        pthread_create(&threads[i], nullptr, startFunc, (void *) &threadPackages[i]);
    }
    double resultSum = 0;

    for (int i = 0; i < threadsNum; ++i) {
        pthread_join(threads[i], nullptr);
        resultSum += threadPackages[i].sum;
    }

    auto elapsed = std::chrono::high_resolution_clock::now() - start;
    double millisec =
            static_cast<double>(std::chrono::duration_cast<std::chrono::microseconds>(elapsed).count()) / 1000.0;

    std::cout << "Result is " << resultSum << "\n";
    out << N << ";" << threadsNum << ";" << millisec << "\n";

    out.close();
}

