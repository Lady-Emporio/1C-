﻿

#Область ОписаниеПеременных

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	рфЗамещать = Истина;
	
	Элементы.рфИмяРегистра.СписокВыбора.Очистить();
	СписокМенеджеров = Новый Массив;
	СписокМенеджеров.Добавить(Метаданные.РегистрыСведений);
	СписокМенеджеров.Добавить(Метаданные.РегистрыНакопления);
	СписокМенеджеров.Добавить(Метаданные.РегистрыБухгалтерии);
	Для каждого Менеджер из СписокМенеджеров цикл
		Для каждого МетаМенеджер из Менеджер цикл
			Элементы.рфИмяРегистра.СписокВыбора.Добавить(МетаМенеджер.ПолноеИмя(), МетаМенеджер.ПолноеИмя() + " | " + МетаМенеджер.Представление());		
		КонецЦикла;   
	КонецЦикла; 
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура рфИмяРегистраНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	СтруктураПараметров = Новый Структура("Регистры",Истина);
	ОткрытьФорму(Объект.ПутьКФормам+".ФормаВыбораТипа", СтруктураПараметров,Элементы.рфИмяРегистра,,,,,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура рфИмяРегистраАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	Если Ожидание > 0 тогда
		СтандартнаяОбработка = ложь;
		ДанныеВыбора = Новый СписокЗначений;    
		лТекст = нрег(Текст);
		Для каждого стр из Элементы.рфИмяРегистра.СписокВыбора цикл
			Если СтрНайти(нрег(стр.Представление),лТекст)=0 тогда
				Продолжить;
			КонецЕсли;        
			ДанныеВыбора.Добавить(стр.Значение,стр.Представление);	
		КонецЦикла;
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура рфИмяРегистраОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Структура") тогда
		рфИмяРегистра = ВыбранноеЗначение.ИменаТипов[0];
		Если СтрНачинаетсяС(рфИмяРегистра, ".") тогда
			рфИмяРегистра = Сред(рфИмяРегистра, 2);	
		КонецЕсли;
		
		рфИмяТаблицы = ВыбранноеЗначение.ИмяТаблицы;
		
	ИначеЕсли ТипЗнч(ВыбранноеЗначение) = Тип("Строка") тогда
		М = СтрРазделить(ВыбранноеЗначение, ".");  
		рфИмяТаблицы = М[0];
		рфИмяРегистра = М[1];
	Иначе
		ВызватьИсключение "Невозможная ошибка. рфИмяРегистраОбработкаВыбора 202302241101";
	КонецЕсли;	
	рфИмяТаблицы = СтрЗаменить(рфИмяТаблицы, "Регистр", "Регистры");
	
	ОчиститьСтарыеЭлементыФормы();
	ОчиститьСоздатьРеквизиты();
КонецПроцедуры

&НаКлиенте
Процедура рфДанныеНабораПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Если Копирование тогда
		Возврат;
	КонецЕсли;
	
	Отказ = Истина; 
	Стр = рфДанныеНабора.Добавить();
	Для каждого стрОтбора из рфОтбор цикл
		
		Если НЕ стрОтбора.Использовать тогда
			Продолжить;			
		КонецЕсли;
		
		Стр[стрОтбора.ИмяРеквизита] = стрОтбора.ЗначениеОтбора;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы
// Код процедур и функций
#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПрочитатьПоНабору(Команда) 
	
	Если ПустаяСтрока(рфИмяТаблицы) ИЛИ ПустаяСтрока(рфИмяРегистра) тогда
		Сообщить(Формат(ТекущаяДата(),"ДЛФ=T") + ". Не выбран регистр.");
		Возврат;
	КонецЕсли;
	
	ПрочитатьПоНаборуНаСервере(); 
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьПоНабору(Команда) 
	
	Если ПустаяСтрока(рфИмяТаблицы) ИЛИ ПустаяСтрока(рфИмяРегистра) тогда
		Сообщить(Формат(ТекущаяДата(),"ДЛФ=T") + ". Не выбран регистр.");
		Возврат;
	КонецЕсли;
	
	ЗаписатьПоНаборуНаСервере(); 
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ОчиститьСтарыеЭлементыФормы() 
	рфДанныеНабора.Очистить();
	рфОтбор.Очистить();
	
	ГруппыДляОчистки = СтрРазделить("рфДанныеНабора",","); 
	Для каждого ИмяГруппы из ГруппыДляОчистки цикл
		Пока Элементы[ИмяГруппы].ПодчиненныеЭлементы.Количество()>0 цикл
			ЭтаФорма.Элементы.Удалить(Элементы[ИмяГруппы].ПодчиненныеЭлементы[0]);	
		КонецЦикла;  	
	КонецЦикла;
	
КонецПроцедуры

Процедура ОчиститьСоздатьРеквизиты()
	
	ПоддерживаемыеРегистры = Новый Структура();
	ПоддерживаемыеРегистры.Вставить("РегистрыСведений", РегистрыСведений); 
	ПоддерживаемыеРегистры.Вставить("РегистрыНакопления", РегистрыНакопления);
	ПоддерживаемыеРегистры.Вставить("РегистрыБухгалтерии", РегистрыБухгалтерии);
	
	Менеджер = ПоддерживаемыеРегистры[рфИмяТаблицы][рфИмяРегистра];
	Набор = Менеджер.СоздатьНаборЗаписей();
	
	УдаляемыеРеквизиты = Новый Массив;
	#Область УдаляюСтарыеРеквизиты_УдаляюСтарыеЭлементыФормы
	Для каждого РодительскийРеквизит из СтрРазделить("рфДанныеНабора",",") цикл
		СписокРеквизитов = ПолучитьРеквизиты(РодительскийРеквизит);
		Для каждого Рекв из СписокРеквизитов цикл
			Если Рекв.Имя = "рфДочернийНаборЗаписей" тогда
				Продолжить;
			КонецЕсли;
			УдаляемыеРеквизиты.Добавить(Рекв.Путь + "." + Рекв.Имя);
		КонецЦикла;
	КонецЦикла;
	
	#КонецОбласти //УдаляюСтарыеРеквизиты_УдаляюСтарыеЭлементыФормы
	
	НовыеРеквизиты = Новый Массив; 
	
	#Область СозданиеРеквизитов  
	ДанныеПоРеквизитам = Новый Массив;
	МетаРегистр = Набор.Метаданные();
	Для каждого ДанныеПоРазделам из СтрРазделить("СтРек.СтандартныеРеквизиты,Изм.Измерения,Рес.Ресурсы,Рес.Реквизиты", ",") цикл
		ДанныеПоРазделу = СтрРазделить(ДанныеПоРазделам, "."); 
		Для каждого ОписаниеРеквизита из МетаРегистр[ДанныеПоРазделу[1]] цикл
			ДанныеПоРеквизитам.Добавить(Новый Структура("ПрефиксЗаголовка,ОписаниеРеквизита", ДанныеПоРазделу[0], ОписаниеРеквизита));	
		КонецЦикла;
	КонецЦикла;
	
	//Регистр бухгалтерии счетДт и счетКТ не стандартные реквизиты
	СписокКолонок = Набор.ВыгрузитьКолонки().Колонки;
	Для каждого Колонка из СписокКолонок цикл
		НеНашел = Истина;
		Для каждого ДанныеПоРеквизиту из ДанныеПоРеквизитам цикл	
			Если ДанныеПоРеквизиту.ОписаниеРеквизита.Имя = Колонка.Имя тогда
				НеНашел = Ложь;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
		Если НеНашел тогда
			ДанныеПоРеквизитам.Добавить(Новый Структура("ПрефиксЗаголовка,ОписаниеРеквизита", "Уник", Новый Структура("Имя,Тип", Колонка.Имя, Колонка.ТипЗначения)));	
		КонецЕсли;
		
	КонецЦикла;
	
	Для каждого ДанныеПоРеквизиту из ДанныеПоРеквизитам цикл  
		Колонка = ДанныеПоРеквизиту.ОписаниеРеквизита; 
		НужноПропустить = Ложь;
		Если Колонка.Тип.СодержитТип(Тип("МоментВремени")) тогда
			НужноПропустить = Истина;
		КонецЕсли; 
		Если Колонка.Тип.СодержитТип(Тип("ХранилищеЗначения")) тогда
			НужноПропустить = Истина;
		КонецЕсли;
		Если Колонка.Тип.Типы().Количество() = 0 тогда
			НужноПропустить = Истина;	
		КонецЕсли;
		
		Если НужноПропустить тогда 
			МассивСтрокТипов = Новый Массив;
			Для каждого Тип из Колонка.Тип.Типы() цикл
				МассивСтрокТипов.Добавить(Строка(Тип));	
			КонецЦикла;
			Сообщить( Формат(ТекущаяДата(), "ДЛФ=T") + ". Пропущен: " + Строка(Колонка.Имя) + " содержит: " + СтрСоединить(МассивСтрокТипов, ",") + "."); 
			Продолжить;
		КонецЕсли;
		лЗаголовок = ДанныеПоРеквизиту.ПрефиксЗаголовка + "_" + Колонка.Имя;
		НовыеРеквизиты.Добавить(Новый РеквизитФормы(Колонка.Имя, Колонка.Тип , "рфДанныеНабора", лЗаголовок));
	КонецЦикла;
	
	Для каждого ЭлементОтбора из Набор.Отбор цикл
		//НовыеРеквизиты.Добавить(Новый РеквизитФормы(ЭлементОтбора.Имя, ЭлементОтбора.ТипЗначения, "рфОтбор"));
		Стр = рфОтбор.Добавить();
		Стр.ИмяРеквизита = ЭлементОтбора.Имя;
		Стр.Тип = ЭлементОтбора.ТипЗначения;
		Стр.Использовать = Истина;
	КонецЦикла; 
	#КонецОбласти //СозданиеРеквизитов
	
	ИзменитьРеквизиты(НовыеРеквизиты, УдаляемыеРеквизиты);
	
	ИмяРеквизитаТЗ = "рфДанныеНабора";
	ТЗ = РеквизитФормыВЗначение(ИмяРеквизитаТЗ); 
	Для каждого колонка из ТЗ.Колонки цикл
		НовыйЭлемент = Элементы.Добавить(ИмяРеквизитаТЗ + "_" + Колонка.Имя, Тип("ПолеФормы"), Элементы[ИмяРеквизитаТЗ]);
		НовыйЭлемент.Вид = ВидПоляФормы.ПолеВвода;
		НовыйЭлемент.ПутьКДанным = ИмяРеквизитаТЗ + "." + Колонка.Имя;
		НовыйЭлемент.Видимость = Истина;
	КонецЦикла;
	
	//ИмяРеквизитаТЗ = "рфОтбор";
	//ТЗ = РеквизитФормыВЗначение(ИмяРеквизитаТЗ); 
	//Для каждого колонка из ТЗ.Колонки цикл
	//	НовыйЭлемент = Элементы.Добавить(ИмяРеквизитаТЗ + "_" + Колонка.Имя, Тип("ПолеФормы"), Элементы["ГруппаОтбор"]);
	//	НовыйЭлемент.Вид = ВидПоляФормы.ПолеВвода;
	//	НовыйЭлемент.ПутьКДанным = ИмяРеквизитаТЗ + "[0]." + Колонка.Имя;
	//	НовыйЭлемент.Видимость = Истина;
	//КонецЦикла;
	
	
КонецПроцедуры

&НаСервере
Процедура ПрочитатьПоНаборуНаСервере()  
	
	рфДанныеНабора.Очистить();
	
	ПоддерживаемыеРегистры = Новый Структура();
	ПоддерживаемыеРегистры.Вставить("РегистрыСведений", РегистрыСведений); 
	ПоддерживаемыеРегистры.Вставить("РегистрыНакопления", РегистрыНакопления);
	ПоддерживаемыеРегистры.Вставить("РегистрыБухгалтерии", РегистрыБухгалтерии);
	
	Менеджер = ПоддерживаемыеРегистры[рфИмяТаблицы][рфИмяРегистра];
	Набор = Менеджер.СоздатьНаборЗаписей();
	Набор.Прочитать();
	Для каждого стрОтбора из рфОтбор цикл
		
		Если НЕ стрОтбора.Использовать тогда
			Продолжить;			
		КонецЕсли;
		
		Набор.Отбор[стрОтбора.ИмяРеквизита].Установить(стрОтбора.ЗначениеОтбора);
	КонецЦикла; 
	Набор.Прочитать();
	Для каждого СтрНабора из Набор цикл
		СтрТз = рфДанныеНабора.Добавить();
		ЗаполнитьЗначенияСвойств(СтрТз, СтрНабора);
	КонецЦикла;  
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьПоНаборуНаСервере()
	
	ПоддерживаемыеРегистры = Новый Структура();
	ПоддерживаемыеРегистры.Вставить("РегистрыСведений", РегистрыСведений); 
	ПоддерживаемыеРегистры.Вставить("РегистрыНакопления", РегистрыНакопления);
	ПоддерживаемыеРегистры.Вставить("РегистрыБухгалтерии", РегистрыБухгалтерии);
	
	Менеджер = ПоддерживаемыеРегистры[рфИмяТаблицы][рфИмяРегистра];
	Набор = Менеджер.СоздатьНаборЗаписей();
	
	Для каждого стрОтбора из рфОтбор цикл
		
		Если НЕ стрОтбора.Использовать тогда
			Продолжить;			
		КонецЕсли;
		
		Набор.Отбор[стрОтбора.ИмяРеквизита].Установить(стрОтбора.ЗначениеОтбора);
	КонецЦикла;
	
	Для каждого СтрТз из рфДанныеНабора цикл
		СтрНабора = Набор.Добавить();
		ЗаполнитьЗначенияСвойств(СтрНабора, СтрТз);
	КонецЦикла; 
	
	Набор.Записать(рфЗамещать);
	
КонецПроцедуры

#КонецОбласти