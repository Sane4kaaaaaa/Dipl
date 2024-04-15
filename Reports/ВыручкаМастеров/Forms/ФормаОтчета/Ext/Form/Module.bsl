﻿
&НаКлиенте
Процедура КомандаСформироватьОтчет(Команда)
	Отчет();
КонецПроцедуры   

&НаСервере
Процедура Отчет()   
	
//1. Предварительный этап
	ТабДок = ТабличныйДокумент; // указываем тип выходных данных
	ТабДок.Очистить(); // очищаем на случай повторной формировки
	ТабДок.ТолькоПросмотр = Истина;//даем право только на просмотр

//2. Получаем созданный ранее макет с помощью вспомогательной процедуры
	Макет = ПолучитьМакетНаСервере ("Макет");

//2.1. Получаем области макета и выводим их
	ОбластьЗаголовок = Макет.ПолучитьОбласть ("ОбластьЗаголовок");
	ТабДок.Вывести(ОбластьЗаголовок);

	
	ОбластьШапка = Макет.ПолучитьОбласть ("ОбластьШапка");
	ТабДок.Вывести (ОбластьШапка) ;

	ОбластьМастер = Макет.ПолучитьОбласть ("ОбластьМастер");
	ОбластьПериод = Макет.ПолучитьОбласть ("ОбластьПериод");
	ОбластьДанные = Макет.ПолучитьОбласть ("ОбластьДанные");
	ОбластьИтоги = Макет. ПолучитьОбласть ("ОбластьИтоги") ;

 
   

//2.1.1 Получаем данные для вывода в отчет
	ЗапросДанных = Новый Запрос;
	ЗапросДанных.Текст =  
      "ВЫБРАТЬ
      |	ПродажиОбороты.Водитель КАК Водитель,
      |	ПродажиОбороты.Период КАК Период,
      |	ПродажиОбороты.Клиент КАК Клиент,
      |	ПродажиОбороты.ВыручкаОборот КАК Выручка
      |ИЗ
      |	РегистрНакопления.Продажи.Обороты(&НачалоПериода, &КонецПериода, День, ) КАК ПродажиОбороты
      |
      |УПОРЯДОЧИТЬ ПО
      |	Водитель,
      |	Период
      |ИТОГИ
      |	СУММА(Выручка)
      |ПО
      |	ОБЩИЕ,
      |	Водитель,
      |	Период Периодами(День, &НачалоПериода, &КонецПериода),
      |	Клиент";
	//2.1.1.1 Определяем значения параметров запроса
	ЗапросДанных.УстановитьПараметр ("НачалоПериода", ЭтаФорма.НачалоПериода) ;
 	ЗапросДанных.УстановитьПараметр ("КонецПериода", КонецДня(ЭтаФорма .КонецПериода) );

 

	//2.1.1.2 Получаем выборку данных
	ВыборкаМастер = ЗапросДанных.Выполнить ().Выбрать (ОбходРезультатаЗапроса.ПоГруппировкам, "Водитель") ;
	ВыборкаОбщийИтог = ЗапросДанных.Выполнить ().Выбрать (ОбходРезультатаЗапроса.ПоГруппировкам) ;

//2.1.2 Проводим заполнение данных в цикле по уровням группировки
	Табдок.НачатьАвтогруппировкустрок ();
	//2.1.2.1 Совершаем обход результата запроса по групперовке "Водитель"
	Пока ВыборкаМастер.Следующий() Цикл
		ОбластьМастер.Параметры.Водитель = ВыборкаМастер.Водитель;
		ОбластьМастер.Параметры.Выручка = ВыборкаМастер.Выручка;
		Табдок.Вывести (ОбластьМастер, ВыборкаМастер.Уровень (),,Ложь);//Ложь - группировка "закрыта"

		//2.1.2.2 Совершаем обход результата запроса по групперовке "Период" (внутри "Водитель")
		ВыборкаПериод = ВыборкаМастер. Выбрать (ОбходРезультатаЗапроса.ПоГруппировкам, "Период","Все") ;
		Пока ВыборкаПериод.Следующий() Цикл
		ОбластьПериод.Параметры.Период = ВыборкаПериод. Период;
		ОбластьПериод.Параметры.Выручка = ВыборкаПериод. Выручка;
		Табдок.Вывести (ОбластьПериод, ВыборкаПериод.Уровень (),,Ложь);


			//2.1.2.3 Совершаем обход результата запроса по групперовке "Клиент" (внутри "Период")
			ВыборкаДанных = ВыборкаПериод.Выбрать (ОбходРезультатаЗапроса .ПоГруппировкам, "Клиент") ;
			Пока ВыборкаДанных.Следующий() Цикл
				ОбластьДанные.Параметры.Период = ВыборкаДанных.Период;
				ОбластьДанные.Параметры.Клиент = ВыборкаДанных.Клиент;
				ОбластьДанные.Параметры.Выручка = ВыборкаДанных.Выручка;
				ТабДок.Вывести(ОбластьДанные, ВыборкаДанных.Уровень (),,Ложь);
			КонецЦикла;
		КонецЦикла;
	КонецЦикла;
	Табдок.ЗакончитьАвтогруппировкуСтрок(); 

//2.1.3 Проводим вывод итогов
	Выборкаобщийитог. Следующий () ;
	ОбластьИтоги.Параметры.Выручка = ВыборкаОбщийИтог. Выручка;
	ТабДок. Вывести (ОбластьИтоги) ;

//3. Заключительный этап - настройка вывода табличного документа

	ТабДок.ОриентацияСтраницы = ОриентацияСтраницы. Портрет;
	Табдок.МасштабПечати = 100; // это значит что масштаб будет 100 процентов

	Табдок.РазмерСтраницы = "A4";
	Табдок.ТочностьПечати = ТочностьПечати.Точная;

 
	
КонецПроцедуры

//ВСПОМОГАТЕЛЬНЫЕ
&НаСервере
Функция ПолучитьМакетНаСервере(ИмяМакета)
	
	ЭО=РеквизитФормыВЗначение("Отчет");
	Макет=ЭО.ПолучитьМакет(ИмяМакета);
	Возврат Макет;               
	
КонецФункции
