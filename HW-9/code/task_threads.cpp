#include <random>
#include <unistd.h>
#include "pthread.h"

// Генератор случайных чисел на C++
static std::random_device rd;
static std::mt19937 gen(rd());
static std::uniform_int_distribution<int> numberGen(1, 20 + 1);
static std::uniform_int_distribution<int> timeGen(1, 7 + 1);

static std::vector<int> data;

pthread_mutex_t mutex;

void Log(_opaque_pthread_t*  threadId) {
    printf("Изменение вектора потоком %d. Текущее состояние вектора: ", threadId);
    for (const auto& element : data) {
        std::cout << element << " ";
    }
    printf("\n");
}

void* SumTwoNum(void* args) {
    int firstNum = data.back();
    data.pop_back();
    int secondNum = data.back();
    data.pop_back();
    data.emplace_back(firstNum + secondNum);

    Log(pthread_self());
    return nullptr;
}

void* MakeTheNumber(void* args) {
    // Получаем случайное число [1; 20]
    int number = numberGen(gen);

    // Получаем задержку во времени
    int timeWait = timeGen(gen);
    sleep(timeWait);

    // Добавляем в вектор
    // Здесь нам нужна блокировка мьютексом, чтобы другой поток
    // в это время не обратился к вектору и не перезатер что либо еще
    pthread_mutex_lock(&mutex);

    data.emplace_back(number);
    Log(pthread_self());

    // Если в векторе 2 элемента, то нужно их просуммировать с помощью отдельного потока
    if (data.size() == 2) {
        // Создаем новый поток
        pthread_t thread_for_sum;
        pthread_create(&thread_for_sum, nullptr, SumTwoNum, nullptr);
        pthread_join(thread_for_sum, nullptr);
    }

    pthread_mutex_unlock(&mutex);

    return nullptr;
}

void SolveTheTask() {
    pthread_mutex_init(&mutex, nullptr);

    pthread_t threads[20];
    for (auto & thread : threads) {
        pthread_create(&thread, nullptr, MakeTheNumber, nullptr);
    }

    for (auto & thread : threads) {
        pthread_join(thread, nullptr);
    }
}