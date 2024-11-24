# Використовуємо базовий образ для C++
FROM gcc:latest

# Встановлюємо необхідні пакети
RUN apt-get update && apt-get install -y \
    make \
    && rm -rf /var/lib/apt/lists/*

# Створюємо робочу директорію
WORKDIR /app

# Копіюємо файли проекту в контейнер
COPY . /app

# Компілюємо проект
RUN make

# Встановлюємо команду за замовчуванням для запуску програми
CMD ["./snake"]
