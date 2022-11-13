# Тестовое задание на позицию стажёра в iOS

### Общее описание задания
Написать приложение для iOS. Приложение должно состоять из одного экрана со списком. Список данных в формате JSON приложение загружает из интернета по [ссылке](https://run.mocky.io/v3/1d1cb4ec-73db-4762-8c4b-0b8aa3cecd4c), необходимо распарсить эти данные и отобразить их в списке. 

[Пример](https://github.com/avito-tech/ios-trainee-problem-2021/blob/main/response_example.json) возвращаемых данных.

### Требование к реализации:
- Приложение работает на iOS 13 и выше
- Реализована поддержка iPhone и iPad
- Список отсортирован по алфавиту
- Кэширование ответа на 1 час
- Обработаны случаи потери сети / отсутствия соединения

Внешний вид приложения: по возможности, лаконичный, но, в целом, на усмотрение кандидата.

### Требования к коду:
 - Приложение написано на языке Swift
 - Пользовательский интерфейс приложения настроен в InterfaceBuilder (в Storiboard или Xib файлы) или кодом без использования SwiftUI
 - Для отображения списка используется UITableView, либо UICollectionView
 - Для запроса данных используется URLSession


## Использованный стэк:
 - UIKit
 - Storyboards
 - MVC

## Внешний вид приложения:

![](https://github.com/zzzarya/AvitoTest/blob/main/AvitoTest/Image/AppScreen.png)

## Проверка интернет соединения 

![](https://github.com/zzzarya/AvitoTest/blob/main/AvitoTest/Image/No%20internet.png)

![](<img src="https://github.com/zzzarya/AvitoTest/blob/main/AvitoTest/Image/No%20internet.png" width="131" height="284" />)

## Видео 

https://github.com/zzzarya/AvitoTest/blob/main/AvitoTest/Image/Check%20internet.mp4

