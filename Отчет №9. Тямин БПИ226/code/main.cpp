#include <iostream>
#include "task_threads.cpp"

int main() {
    SolveTheTask();

    for (const auto& element : data) {
        std::cout << "Ответ: " << element;
    }

    return 0;
}
