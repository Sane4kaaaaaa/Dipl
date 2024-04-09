﻿
Процедура Печать(ТабДок, Ссылка) Экспорт
	//{{_КОНСТРУКТОР_ПЕЧАТИ(Печать)
	Макет = Документы.РасходнаяНакладная.ПолучитьМакет("Печать");
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	РасходнаяНакладная.Валюта,
	|	РасходнаяНакладная.ВидОплаты,
	|	РасходнаяНакладная.Дата,
	|	РасходнаяНакладная.ДокументОснование,
	|	РасходнаяНакладная.Контрагент,
	|	РасходнаяНакладная.Курс,
	|	РасходнаяНакладная.Номер,
	|	РасходнаяНакладная.РасчетныйСчет,
	|	РасходнаяНакладная.Склад,
	|	РасходнаяНакладная.СуммаДокумента,
	|	РасходнаяНакладная.ТЧ_Материалы.(
	|		НомерСтроки,
	|		Материал, 
	|       Материал.Ссылка КАК Ссылка,
	|		Цена,
	|		Количество,
	|		Сумма,
	|		Себестоимость
	|	)
	|ИЗ
	|	Документ.РасходнаяНакладная КАК РасходнаяНакладная
	|ГДЕ
	|	РасходнаяНакладная.Ссылка В (&Ссылка)";
	Запрос.Параметры.Вставить("Ссылка", Ссылка);
	Выборка = Запрос.Выполнить().Выбрать();

	ОбластьЗаголовок = Макет.ПолучитьОбласть("Заголовок");
	Шапка = Макет.ПолучитьОбласть("Шапка");
	ОбластьТЧ_МатериалыШапка = Макет.ПолучитьОбласть("ТЧ_МатериалыШапка");
	ОбластьТЧ_Материалы = Макет.ПолучитьОбласть("ТЧ_Материалы");
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

		ТабДок.Вывести(ОбластьТЧ_МатериалыШапка);
		ВыборкаТЧ_Материалы = Выборка.ТЧ_Материалы.Выбрать();
		Пока ВыборкаТЧ_Материалы.Следующий() Цикл
			ОбластьТЧ_Материалы.Параметры.Заполнить(ВыборкаТЧ_Материалы);
			
			//Расшифровка ячейки "Материал"
			ОбластьТЧ_материалы.Параметры.Ссылка=ВыборкаТЧ_Материалы.Ссылка;    
			
			ТабДок.Вывести(ОбластьТЧ_Материалы, ВыборкаТЧ_Материалы.Уровень());
		КонецЦикла;

		Подвал.Параметры.Заполнить(Выборка);    
		
		//Вывод сумы документа прописью
		ПараметрыПредметаИсчисления="рубль,рубля,рублей,м,копейка,копейки,копеек,ж,2";
		ФорматнаяСтрока="Л=ru_RU";
		Подвал.Параметры.СуммаПрописью=ЧислоПрописью(Подвал.Параметры.СуммаДокумента, ФорматнаяСтрока, ПараметрыПредметаИсчисления);
		
		ТабДок.Вывести(Подвал);

		ВставлятьРазделительСтраниц = Истина;
	КонецЦикла;
	//}}
КонецПроцедуры
