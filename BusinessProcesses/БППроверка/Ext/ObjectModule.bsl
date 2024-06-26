﻿
Процедура СтартПередСтартом(ТочкаМаршрутаБизнесПроцесса, Отказ)
	// Вставить содержимое обработчика.  
	// Проверка заполнения полей БП
	НужноЗаписать=Ложь;
	Если ЭтотОбъект.ПриходныйКассовыйОрдер.Пустая() Тогда
		ПриходныйКассовыйОрдерОбъект = Документы.ПриходныйКассовыйОрдер.СоздатьДокумент();
		ПриходныйКассовыйОрдерОбъект.Дата = ТекущаяДата();
		ПриходныйКассовыйОрдерОбъект.Записать();
		
		ЭтотОбъект.ПриходныйКассовыйОрдер=ПриходныйКассовыйОрдерОбъект.Ссылка;
		НужноЗаписать = Истина;
	КонецЕсли;
	
	Если НужноЗаписать Тогда 
		ПриходныйКассовыйОрдер=ПриходныйКассовыйОрдерОбъект.Ссылка;
		Записать();
	КонецЕсли; 
	
	Сообщить("Старт бизнес-процесса:"+""""+ЭтотОбъект.Метаданные().Синоним+"""");
КонецПроцедуры
Процедура ПолучениеПредоплатыПередСозданиемЗадач(ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи, СтандартнаяОбработка)
		СтандартнаяОбработка = Ложь;
	ФормированиеЗадачиПолучениеПредоплаты (ФормируемыеЗадачи, СтандартнаяОбработка);


КонецПроцедуры



Процедура ФормированиеЗадачиПолучениеПредоплаты (ФормируемыеЗадачи, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	// Формирование задачи получение предоплаты
	Задача = Задачи.ПроверкаОплаты.СоздатьЗадачу();
	Задача.Дата = ТекущаяДата();
	Задача.БизнесПроцесс = Ссылка;
	Задача.ТочкаМаршрута=БизнесПроцессы.БППроверка.ТочкиМаршрута.ПолучениеПредоплаты;
	Задача.Наименование = "Получение предоплаты"; 
	
	Задача.ПриходныйКассовыйОрдер=ПриходныйКассовыйОрдер;
	
	Задача.Должность = Справочники.Должности.Кассир;
	Задача.Записать();
		
    //Задача.Клиент=ПриходныйКассовыйОрдер.КонтактноеЛицо;
	//Задача.Предоплата=ПриходныйКассовыйОрдер.СуммаДокумента;

	ФормируемыеЗадачи.Добавить(Задача);


	ЭтотОбъект.Записать();

	Задача.Записать();    
	
КонецПроцедуры

 Процедура ПолучениеПредоплатыПередВыполнением(ТочкаМаршрутаБизнесПроцесса, Задача, Отказ)
	// Вставить содержимое обработчика.       
	
	Если НЕ ПриходныйКассовыйОрдер.Проведен Тогда	
	СтандартнаяОбработка= Ложь;
	Сообщить("Приходный КО не проведен --- невозможно выполнить задачу!!!");
	Отказ=Истина;
	КонецЕсли;   

   КонецПроцедуры


Процедура ВыпискаСчетаПередСозданиемЗадач(ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ФормированиеЗадачиВыпискаСчета (ФормируемыеЗадачи, СтандартнаяОбработка);

КонецПроцедуры

Процедура ФормированиеЗадачиВыпискаСчета (ФормируемыеЗадачи, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	// Формирование задачи ВЫПИСКА СЧЕТА
	Задача = Задачи.ПроверкаОплаты.СоздатьЗадачу();
	Задача.Дата = ТекущаяДата();
	Задача.БизнесПроцесс = Ссылка;
	Задача.ТочкаМаршрута=БизнесПроцессы.БППроверка.ТочкиМаршрута.ВыпискаСчета;
	Задача.Наименование = "Выписка счета";
	
	Задача.Клиент=ПриходныйКассовыйОрдер.КонтактноеЛицо;
	Задача.Предоплата=ПриходныйКассовыйОрдер.СуммаДокумента;
    Задача.ДатаВнесения=ПриходныйКассовыйОрдер.Дата;
	Задача.ПриходныйКассовыйОрдер=ПриходныйКассовыйОрдер;
		
   	Задача.Подразделение = Справочники.Подразделения.ОтделПродаж; 
	Задача.Должность = Справочники.Должности.Менеджер;
	Задача.Записать();

	ФормируемыеЗадачи.Добавить(Задача);

	// создание ДОКУМЕНТА "Счет"

	Документ = Документы.Счет.СоздатьДокумент();
	Документ.Дата = ТекущаяДата();
	Документ.Контрагент=Задача.Клиент;
	Документ.Склад=Справочники.Склады="Основной";

	
	Документ.Записать();
		
	// Запись ссылки на СЧЕТ в текущем БП
	Счет = Документ.Ссылка;
	ЭтотОбъект.Записать();
	  
	
	// Запись ссылки на СЧЕТ в текущей задаче 
	Задача.Счет= Документ.Ссылка;
	Задача.Записать(); 
	
КонецПроцедуры



Процедура Условие1ПроверкаУсловия(ТочкаМаршрутаБизнесПроцесса, Результат) 
	
	 ПредоплатыХватает=Ложь;
	 Если ПриходныйКассовыйОрдер.СуммаДокумента >  Счет.СуммаДокумента Тогда
		 ПредоплатыХватает=Истина;
	
	 КонецЕсли;
	 
	 Результат=ПредоплатыХватает;

КонецПроцедуры


Процедура ОтгрузкаТовараПередСозданиемЗадач(ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи, СтандартнаяОбработка)
	// Вставить содержимое обработчика. 
	СтандартнаяОбработка = Ложь;
	ФормированиеЗадачиОтгрузкиТовара(ФормируемыеЗадачи, СтандартнаяОбработка);

КонецПроцедуры   

Процедура ФормированиеЗадачиОтгрузкиТовара (ФормируемыеЗадачи, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;

	// Формирование задачи ОТГРУЗКИ ТОВАРА

	Задача = Задачи.ПроверкаОплаты.СоздатьЗадачу() ;
	Задача.Дата = ТекущаяДата();
   	Задача.БизнесПроцесс = Ссылка;
	Задача.ТочкаМаршрута = БизнесПроцессы.БППроверка.ТочкиМаршрута.ОтгрузкаТовара;
	Задача.Наименование = "Отгрузка товара со склада";
	
	Задача.Подразделение = Справочники.Подразделения.Склад;
	Задача.Должность = Справочники.Должности.Кладовщик; 
	
	Задача.Счет = Счет;
    Задача.Клиент=ПриходныйКассовыйОрдер.КонтактноеЛицо;
	Задача.Предоплата=ПриходныйКассовыйОрдер.СуммаДокумента;
    Задача.ДатаВнесения=ПриходныйКассовыйОрдер.Дата;
	Задача.ПриходныйКассовыйОрдер=ПриходныйКассовыйОрдер;
	
	 //сохдание документа РАСХОДНАЯ НАКЛАДНАЯ
	Документ = Документы.РасходнаяНакладная.СоздатьДокумент();
	Документ.Дата = ТекущаяДата();
	Документ.Контрагент=Задача.Клиент;
	Документ.Склад=Справочники.Склады="Основной";
	ТЧ_Материалы=Документ.ТЧ_Материалы;
	Для Каждого ТекСтрокаТЧ_Материалы Из Задача.Счет.ТЧ_Материалы Цикл
			НоваяСтрока = ТЧ_Материалы.Добавить();
			НоваяСтрока.Количество = ТекСтрокаТЧ_Материалы.Количество;
			НоваяСтрока.Материал = ТекСтрокаТЧ_Материалы.Материал;
			НоваяСтрока.Сумма = ТекСтрокаТЧ_Материалы.Сумма;
			НоваяСтрока.Цена = ТекСтрокаТЧ_Материалы.Цена; 
			НоваяСтрока.Скидка=ТекСтрокаТЧ_Материалы.Скидка;
		КонецЦикла;
	Документ.Записать();
	////////	
	РасходнаяНакладная=Документ.Ссылка;
	ЭтотОбъект.Записать(); 
	///////
	Задача.РасходнаяНакладная = Документ.Ссылка;
	Задача.Записать();

	ФормируемыеЗадачи.Добавить(Задача);

КонецПроцедуры

Процедура ОтгрузкаТовараПередВыполнением(ТочкаМаршрутаБизнесПроцесса, Задача, Отказ)
	// Вставить содержимое обработчика.
	Если НЕ РасходнаяНакладная.Проведен Тогда
		
		СтандартнаяОбработка= Ложь;
		Сообщить("Расходная накладная не проведен --- невозможно выполнить задачу!!!");
		Отказ=Истина;
		
	КонецЕсли;
КонецПроцедуры

Процедура ВыпискаСчетаПередВыполнением(ТочкаМаршрутаБизнесПроцесса, Задача, Отказ)
		
	Если НЕ Счет.Проведен Тогда	
	СтандартнаяОбработка= Ложь;
	Сообщить("Счет не проведен --- невозможно выполнить задачу!!!");
	Отказ=Истина;
	КонецЕсли;   


КонецПроцедуры







