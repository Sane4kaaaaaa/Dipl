﻿
&НаСервере
Процедура КомандаСформироватьНаСервере()  
	
	//Запретим обновление диаграммы
	ДиаграммаГанта.Очистить();
	ДиаграммаГанта.Обновление = Ложь;

	// Запрашиваем данные для заполнения диаграммы

	Запрос = Новый Запрос ("ВЫБРАТЬ

	|  НачисленияФактическийПериоддействия.Сотрудник,
	|  НачисленияФактическийПериоддействия.ВидРасчета,
	|  НачисленияФактическийПериодДействия.ПериодДействияНачало,
	|  НачисленияФактическийПериоддействия.ПериодДействияКонец,
	|  НачисленияфактическийПериодДействия.Результат,
	|  НачисленияФактическийПериоддействия.Регистратор,
	|  НачисленияфактическийПериоддействия.Регистратор.Представление
	|ИЗ
	|	РегистрРасчета.Начисления.ФактическийПериоддействия КАК НачисленияФактическийПериоддействия");

	 

	Выборка = Запрос.Выполнить().Выбрать() ;

	//Заполним диаграмму
	Пока Выборка.Следующий () Цикл

		//получаем серию, точку н значение для них

		Точка = ДиаграммаГанта.УстановитьТочку(Выборка.Сотрудник);
		Серия = ДиаграммаГанта.УстановитьСерию(Выборка.ВидРасчета);
		Значение = ДиаграммаГанта.ПолучитьЗначение(Точка, Серия);

		//создаем нужные интервалы в значении

		Интервал = Значение.Добавить();
		Интервал.Начало = Выборка.ПериоддействияНачало;
		Интервал.Конец = Выборка.ПериоддействияКонец;
		Интервал.Текст = Выборка.РегистраторПредставление;
		Интервал.Расшифровка = Выборка.Регистратор;

	КонецЦикла;

	//Раскрасим серии своими цветами
	Для Каждого Серия Из ДиаграммаГанта.Серии Цикл
		Если Серия.Значение = ПланыВидовРасчета.ОсновныеНачисления.Оклад Тогда
			Серия.Цвет = WEBЦвета.Желтый;
		ИначеЕсли Серия.Значение = ПланыВидовРасчета.ОсновныеНачисления.Премия Тогда
			Серия.Цвет = WEBЦвета. Зеленый;
		ИначеЕсли Серия.Значение = ПланыВидовРасчета.ОсновныеНачисления.Невыход Тогда
			Серия.Цвет = WEBЦвета.Красный;
		ИначеЕсли Серия.Значение = ПланыВидовРасчета.ОсновныеНачисления.Больничный Тогда
			Серия.Цвет = WEBЦвета.Розовый;
		КонецЕсли;
	КонецЦикла;

	 

	//Разрешить обновление диаграммы
	ДиаграммаГанта.Обновление = Истина;

КонецПроцедуры

&НаКлиенте
Процедура КомандаСформировать(Команда)
	КомандаСформироватьНаСервере();
КонецПроцедуры
