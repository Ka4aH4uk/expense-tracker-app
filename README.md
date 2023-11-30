# Expense Tracker App

##### Expense Tracker - your reliable app for tracking expenses and income that will help you monitor your finances and effectively manage your budget. 

____
### Описание 

Expense Tracker - это надежное и интуитивно понятное приложение, которое поможет вам эффективно управлять вашими финансами. Ведите учет всех доходов и расходов, а также анализируйте свои финансовые траты с помощью информативных графиков. Давайте ближе ознакомимся с его возможностями:

____

### Технологии

Стек технологий включает в себя:
- **SwiftUI**: Используется для построения пользовательского интерфейса.
- **MVVM**: Архитектурный подход Model-View-ViewModel для более чистой структуры кода.
- **UserDefaults**: Хранение данных
- **Charts:** Интегрированная библиотека для отображения информативных графиков.
- **Lottie**: Интегрирован для воспроизведения анимаций.

____

### Основные экраны

#### 1. Отслеживание доходов

На этом экране вы найдете текущий баланс вашего кошелька и сможете удобно отслеживать свои доходы. Здесь собран список ваших доходов, разделенный по датам, что позволяет вам легко отслеживать вашу финансовую историю. Если вы хотите добавить новый доход, просто нажмите соответствующую кнопку. Ваши доходы будут автоматически сохраняться на вашем устройстве.

![Первый экран](https://github.com/Ka4aH4uk/expense-tracker-app/blob/master/firstView.png)

#### 2. Анализ бюджета

Здесь вы можете анализировать свои расходы и доходы в удобном графическом формате. Выбирайте интересующий вас период: неделя, месяц, квартал или все время, и просматривайте графики, отображающие вашу финансовую активность. Можно также выбрать тип графика – линейный или столбцовый – в зависимости от ваших предпочтений.

![Второй экран](https://github.com/Ka4aH4uk/expense-tracker-app/blob/master/secondView.png)

#### 3. Категории расходов

Третий экран посвящен категориям расходов, где вы можете создавать собственные категории, присваивать им уникальные иконки и названия. Это поможет вам легко группировать свои расходы по типам. В каждой категории вы увидите количество платежей, совершенных в ней. Вы также можете удалять категории или менять их местами по необходимости.

![Третий экран](https://github.com/Ka4aH4uk/expense-tracker-app/blob/master/thierdView.png)

#### Экран с платежами расходов
Если вам нужно посмотреть подробности по расходам в какой-то конкретной категории, вы можете перейти на экран с платежами. Здесь отображаются все расходы в выбранной категории с указанием даты. Вы также можете добавить новые расходы и просматривать график платежей конкретной категории для разных периодов времени.

![Экран платежей](https://github.com/Ka4aH4uk/expense-tracker-app/blob/master/detailView.png)
___

**Дополнительные фичи**:
- Onboarding: При первом запуске приложения вы увидите информативное вступление, которое поможет вам быстро освоиться.
- Кастомные UI-элементы: Персонализированный TabBar и Segmented Controls для удобной навигации и выбора интервала.
- Dark Mode: Переключайтесь между темной и светлой темами в зависимости от ваших предпочтений. 
- Анимации Lottie: Приложение оживлено анимациями, добавляя визуальное удовольствие в каждое взаимодействие.
- Интерактивные графики: Графики, которые реагируют на ваши действия, делая анализ данных более интересным. 
- Локализация: Приложение поддерживает русский и английский языки, обеспечивая доступность и удобство использования для максимально широкой аудитории.

![Фичи](https://github.com/Ka4aH4uk/expense-tracker-app/blob/master/feature.png)

#### Проблемы и решения

- В ходе разработки столкнулся с необходимостью управления удалением расходов, связанных с конкретной категорией. Решение: был изменен метод `deleteCategory` в `ExpenseViewModel`, чтобы правильно удалять категорию и ее расходы из UserDefaults, а также сохранять обновленные "allExpenses".

___

**Демонстрация работы приложения:**

<p align="center">
  <img src="https://github.com/Ka4aH4uk/expense-tracker-app/blob/master/reviewApp.gif" alt="Gif">
  
  <img src="https://github.com/Ka4aH4uk/expense-tracker-app/blob/master/moveDelete.gif" alt="Gif">
  
  <img src="https://github.com/Ka4aH4uk/expense-tracker-app/blob/master/switchTheme.gif" alt="Gif">
</p>
