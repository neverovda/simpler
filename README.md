# Simpler

**Simpler** is a little web framework written in [Ruby](https://www.ruby-lang.org) language. It's compatible with [Rack](https://rack.github.io) interface and intended to **learn** how web frameworks work in general.

## The application overview

Simpler application is a singleton instance of the `Simpler::Application` class. For convenience it can be obtained by calling `Simpler.application` method. This instance holds all the routes and responds to `call` method which is required by the Rack interface.

## Задание к уроку "Устройство и создание веб-фреймворка"

Создайте на гитхабе форк учебного проекта из скринкаста (ссылки в дополнительных материалах), в полученном новом репозитории, в новой ветке выполните следующие задания:

- Реализуйте расширенные возможности метода render которые позволят возвращать ответ в других форматах, например:  
render plain: "Plain text response"
 
- Реализуйте возможность устанавливать в методе контроллера статус ответа, например:  
status 201
 
- Реализуйте возможность устанавливать в методе контроллера заголовки, например:  
headers['Content-Type'] = 'text/plain'
 
- Реализуйте механизм обработки исключения когда маршрут для запрашиваемого URL не был найден. В этом случае клиенту должен отдаваться ответ со статусом 404

- Напишите механизм разбора route-параметров. Например, при добавлении маршрута  
get '/tests/:id', 'tests#show'
 
  - Маршрут должен корректно обрабатывать GET запрос  
/tests/101
 
  - В методе show контроллера при вызове метода params должен быть доступен параметр :id со значением 101

- Напишите middleware для логирования HTTP-запросов и ответов:
  - Лог должен записываться в файл log/app.log
  - Для запросов необходимо записывать HTTP-метод запроса, URL, контроллер и метод который будет обрабатывать запрос, хэш параметров который будет доступен при вызове метода params
  - Для ответов необходимо записывать код статуса ответа, тип тела ответа и название шаблона (если ответ рендерился с помощью шаблона представления)
            
  Пример:
 
  Request: GET /tests?category=Backend  
  Handler: TestsController#index  
  Parameters: {'category' => 'Backend'}  
  Response: 200 OK [text/html] tests/index.html.erb  
 
В качестве ответа приложите ссылку на Pull Request  с выполненными заданиями. Pull Request должен быть открыт в ВАШ репозиторий.
