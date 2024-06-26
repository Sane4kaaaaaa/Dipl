﻿

Процедура Печать(ТабДок, Ссылка) Экспорт
	//{{_КОНСТРУКТОР_ПЕЧАТИ(Печать1)
	Макет = Документы.ДМаршрутныйЛист.ПолучитьМакет("Печать");
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ДМаршрутныйЛист.АдресДоставки,
	|	ДМаршрутныйЛист.АдресОтправки,
	|	ДМаршрутныйЛист.Водитель,
	|	ДМаршрутныйЛист.Дата,
	|	ДМаршрутныйЛист.Клиент,
	|	ДМаршрутныйЛист.Номер,
	|	ДМаршрутныйЛист.ТранспортноеСредство
	|ИЗ
	|	Документ.ДМаршрутныйЛист КАК ДМаршрутныйЛист
	|ГДЕ
	|	ДМаршрутныйЛист.Ссылка В (&Ссылка)";
	Запрос.Параметры.Вставить("Ссылка", Ссылка);
	Выборка = Запрос.Выполнить().Выбрать();

	ОбластьЗаголовок = Макет.ПолучитьОбласть("Заголовок");
	Шапка = Макет.ПолучитьОбласть("Шапка");
	Подвал = Макет.ПолучитьОбласть("Подвал");
	ТабДок.Очистить();

	ВставлятьРазделительСтраниц = Ложь;
	Пока Выборка.Следующий() Цикл
		Если ВставлятьРазделительСтраниц Тогда
			ТабДок.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;

		ТабДок.Вывести(ОбластьЗаголовок);

		Шапка.Параметры.Заполнить(Выборка);
		ТабДок.Вывести(Шапка, Выборка.Уровень());
		
		ТабДок.Вывести(Подвал);

		ВставлятьРазделительСтраниц = Истина;
	КонецЦикла;
	//}}
КонецПроцедуры

