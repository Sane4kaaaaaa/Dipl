﻿
Процедура ПередВыполнением(Отказ)
	
	ДатаВыполнения = ТекущаяДата();
	
	Если Исполнитель.Пустая() Тогда
		Исполнитель = ПараметрыСеанса.ТекущийИсполнитель;
	КонецЕсли;
	
КонецПроцедуры
