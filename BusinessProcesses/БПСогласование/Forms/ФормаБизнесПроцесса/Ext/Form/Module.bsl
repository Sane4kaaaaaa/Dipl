﻿
&НаКлиенте
Процедура КомандаОбновитьКартуМаршрута(Команда)
	ОбновитьКартуМаршрута();
КонецПроцедуры    

&НаСервере
Процедура ОбновитьКартуМаршрута()
	ОбъектБП=РеквизитФормыВЗначение("Объект");
	КартаБП=ОбъектБП.ПолучитьКартуМаршрута();
КонецПроцедуры   

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	КартаМаршрута=ТекущийОбъект.ПолучитьКартуМаршрута();   
	ОбновитьКартуМаршрута();
	
КонецПроцедуры
