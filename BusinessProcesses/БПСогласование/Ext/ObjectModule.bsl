﻿
Процедура СтартПередСтартом(ТочкаМаршрутаБизнесПроцесса, Отказ)
	// Проверка заполнения полей БП
	НужноЗаписать=Ложь;
	Если ЭтотОбъект.Счет.Пустая() Тогда
		СчетОбъект = Документы.Счет.СоздатьДокумент();
		СчетОбъект.Дата = ТекущаяДата();
		СчетОбъект.Записать();
		
		ЭтотОбъект.Счет=СчетОбъект.Ссылка;
		НужноЗаписать = Истина;
	КонецЕсли;
	
	Если НужноЗаписать Тогда
		Записать();
	КонецЕсли;
	
	Сообщить("Старт бизнес-процесса:"+""""+ЭтотОбъект.Метаданные().Синоним+"""");
	
КонецПроцедуры

Процедура ВыпискаСчетаПередСозданиемЗадач(ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ФормированиеЗадачиВыпискаСчета (ФормируемыеЗадачи, СтандартнаяОбработка);

КонецПроцедуры

Процедура ФормированиеЗадачиВыпискаСчета (ФормируемыеЗадачи, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	// Формирование задачи ВЫПИСКА СЧЕТА
	Задача = Задачи.Согласование.СоздатьЗадачу();
	Задача.Дата = ТекущаяДата();
	Задача.БизнесПроцесс = Ссылка;
	Задача.ТочкаМаршрута=БизнесПроцессы.БПСогласование.ТочкиМаршрута.ВыпискаСчета;
	Задача.Наименование = "Выписка счета"; 

	 
	Задача.Подразделение = Справочники.Подразделения.ОтделПродаж; 
	Задача.Должность = Справочники.Должности.Менеджер;
	Задача.Записать();

	ФормируемыеЗадачи.Добавить(Задача);

	// создание ДОКУМЕНТА "Счет"

	//Документ = Документы.Счет.СоздатьДокумент();
	//Документ.Дата = ТекущаяДата();
	//Документ.Записать();

	// Запись ссылки на СЧЕТ в текущем БП
	//Счет = Документ.Ссылка;
	ЭтотОбъект.Записать();

	// Запись ссылки на СЧЕТ в текущей задаче 
	//Задача.Счет= Документ.Ссылка;
	Задача.Записать();  

КонецПроцедуры

Процедура Условие1ПроверкаУсловия(ТочкаМаршрутаБизнесПроцесса, Результат)    
	
	СкидкаБольшеОбычной = Ложь;
	ОбычнаяСкидка = Константы.ОбычнаяСкидка.Получить();

	//проверяем, что скидка не превышает обычную
	Для каждого стр Из Счет.ТЧ_Материалы Цикл 
		Если стр.Скидка > ОбычнаяСкидка Тогда
			СкидкаБольшеОбычной = Истина;
			Прервать;
		КонецЕсли;
	КонецЦикла;

	Результат = СкидкаБольшеОбычной;	
КонецПроцедуры

Процедура УтверждениеСчетаПередСозданиемЗадач(ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ФормированиеЗадачиУтверждениеСчета (ФормируемыеЗадачи, СтандартнаяОбработка);

КонецПроцедуры  

Процедура ФормированиеЗадачиУтверждениеСчета (ФормируемыеЗадачи, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;

	// Формирование задачи УТВЕРЖДЕНИЕ СЧЕТА

	Задача = Задачи.Согласование.СоздатьЗадачу();

	Задача.Дата = ТекущаяДата();

	Задача.БизнесПроцесс = Ссылка;

	Задача.ТочкаМаршрута = БизнесПроцессы.БПСогласование.ТочкиМаршрута.УтверждениеСчета;
	Задача.Наименование = "Утверждение счета";

	Задача.Должность = Справочники.Должности.РуководительОтдела;

	Задача.Счет = Счет;

	Задача.Записать();

	ФормируемыеЗадачи.Добавить(Задача);
КонецПроцедуры

Процедура УтверждениеСчетаПередВыполнением(ТочкаМаршрутаБизнесПроцесса, Задача, Отказ)
	
	Если НЕ Счет.Проведен Тогда
		
		СтандартнаяОбработка= Ложь;
		Сообщить("Документ-счет не проведен --- невозможно выполнить задачу!!!");
		Отказ=Истина;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура Условие2ПроверкаУсловия(ТочкаМаршрутаБизнесПроцесса, Результат)

	Результат=Счет.СкидкаСогласована;	
	
КонецПроцедуры

Процедура ПолучениеНаличнойОплатыПередСозданиемЗадач(ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ФормированиеЗадачиПолученияНаличнойОплаты (ФормируемыеЗадачи, СтандартнаяОбработка);

КонецПроцедуры

Процедура ФормированиеЗадачиПолученияНаличнойОплаты (ФормируемыеЗадачи, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	// Формирование задачи НАЛИЧНОЙ ОПЛАТЫ
	Задача = Задачи.Согласование.СоздатьЗадачу();
	Задача.Дата = ТекущаяДата();
	Задача.БизнесПроцесс = Ссылка;
	Задача.ТочкаМаршрута = БизнесПроцессы.БПСогласование.ТочкиМаршрута.ПолучениеНаличнойОплаты;
	Задача.Наименование = "Получение наличной оплаты";
	Задача.Должность = Справочники.Должности.Кассир;
	Задача.Счет = Счет;
	Задача.Записать();

	ФормируемыеЗадачи.Добавить(Задача);

	// создание ДОКУМЕНТА "Расходная накладная"

	Документ = Документы.РасходнаяНакладная.СоздатьДокумент();

	Документ.Дата = ТекущаяДата();

	Документ.Склад = Счет.Склад;

	Документ.ДокументОснование = Счет.Ссылка;

	Документ.СуммаДокумента = Счет.СуммаДокумента; 
	Документ.Контрагент=Счет.Контрагент;
	
	Документ.Валюта = Счет.Валюта;

	Документ.Курс = Счет.Курс;

	Для Каждого ТекСтрокаТЧ_Материалы Из Счет.ТЧ_Материалы Цикл
		НоваяСтрока = Документ.ТЧ_Материалы.Добавить();
		НоваяСтрока.Материал = ТекСтрокаТЧ_Материалы.Материал;
		НоваяСтрока.Количество = ТекСтрокаТЧ_Материалы.Количество;
		НоваяСтрока.Сумма = ТекСтрокаТЧ_Материалы.Сумма;
		НоваяСтрока.Цена = ТекСтрокаТЧ_Материалы.Цена;
		НоваяСтрока.Скидка = ТекСтрокаТЧ_Материалы.Скидка;

	КонецЦикла;	 

	Документ.Записать();

	// запись ссылки на РН в текущем БП
	РасходнаяНакладная = Документ.Ссылка;
	ЭтотОбъект.Записать();

	// запись ссылки на РН в текущей задаче
	Задача.РасходнаяНакладная = Документ.Ссылка;
	Задача.Записать();
КонецПроцедуры

Процедура ОтгрузкаТовараСоСкладаПередСозданиемЗадач(ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ФормированиеЗадачиОтгрузкиТовара(ФормируемыеЗадачи, СтандартнаяОбработка);

КонецПроцедуры
Процедура ФормированиеЗадачиОтгрузкиТовара (ФормируемыеЗадачи, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;

	// Формирование задачи ОТГРУЗКИ ТОВАРА

	Задача = Задачи.Согласование.СоздатьЗадачу() ;

	Задача.Дата = ТекущаяДата();

	Задача.БизнесПроцесс = Ссылка;

	Задача.ТочкаМаршрута = БизнесПроцессы.БПСогласование.ТочкиМаршрута.ОтгрузкаТовараСоСклада;
	Задача.Наименование = "Отгрузка товара со склада";

	Задача.Подразделение = Справочники.Подразделения.Склад;
	Задача.Должность = Справочники.Должности.Кладовщик;
	Задача.Счет = Счет;

	Задача.РасходнаяНакладная = РасходнаяНакладная;

	Задача.Записать();

	ФормируемыеЗадачи.Добавить(Задача);

КонецПроцедуры

Процедура ОтгрузкаТовараСоСкладаПередВыполнением(ТочкаМаршрутаБизнесПроцесса, Задача, Отказ)
		
	Если НЕ РасходнаяНакладная.Проведен Тогда
		
		СтандартнаяОбработка= Ложь;
		Сообщить("Расходная накладная не проведен --- невозможно выполнить задачу!!!");
		Отказ=Истина;
		
	КонецЕсли;
КонецПроцедуры

