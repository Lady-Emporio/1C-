﻿
&НаКлиенте
Перем глобал_ПараметрыОчисткиРегистров;

#Область Конвеер_Кэширование

Функция Кэш_СоздатьОбъектКэша()
	Кэш = Новый Структура("ТекущийОтбор,Значения",Новый ТаблицаЗначений,Новый Соответствие);
	Кэш.ТекущийОтбор.Колонки.Добавить("Имя",Новый ОписаниеТипов("Строка"));
	Кэш.ТекущийОтбор.Колонки.Добавить("Значение");
	Возврат Кэш;
КонецФункции

Функция Кэш_УстановитьОтбор(Кэш,Ключ,Значение)
	Стр = Кэш.ТекущийОтбор.Добавить(); 
	Стр.Имя = Ключ;
	Стр.Значение = Значение;
КонецФункции   

Функция Кэш_ПолучитьПоТекущемуОтбору(Кэш) 
	
	СтрокаОтбора = Кэш_Служебное_ОтборВСтроку(Кэш);
	Возврат Кэш.Значения[СтрокаОтбора];	
	
КонецФункции

Функция Кэш_СброситьОтбор(Кэш) 
	Кэш.ТекущийОтбор.Очистить();	
КонецФункции

Функция Кэш_ПолучитьЗначения(Кэш)
	Значения = Новый Массив;
	Для каждого КлючЗнач из Кэш.Значения цикл
		Значения.Добавить(КлючЗнач.Значение);	
	КонецЦикла;
	Возврат Значения;
КонецФункции


Функция Кэш_ДобавитьПоТекущемуОтбору(Кэш, Значение)
	СтрокаОтбора = Кэш_Служебное_ОтборВСтроку(Кэш);
	Кэш.Значения.Вставить(СтрокаОтбора,Значение);
КонецФункции

Функция Кэш_Служебное_ОтборВСтроку(Кэш) 
	
	КлючОтбора = "";      
	Разделитель = "|||";  
	
	Кэш.ТекущийОтбор.Сортировать("Имя");
	
	Для счетчик = 0 по Кэш.ТекущийОтбор.Количество()-1 цикл 
		СтруктураОтбора = Кэш.ТекущийОтбор[счетчик];
		КлючОтбора = КлючОтбора + "" + СтруктураОтбора.Имя + XMLСтрока(СтруктураОтбора.Значение);
		
		Если счетчик <> Кэш.ТекущийОтбор.Количество()-1 тогда
			КлючОтбора = КлючОтбора+ Разделитель;	                                   
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат КлючОтбора; 
	
КонецФункции

#КонецОбласти


&НаСервере
Процедура ЗаписатьНаСервере()
	
	//Для каждого стр из рфДанные цикл
	//	НаборЗаписей = РегистрыСведений[рфИмяРегистра].СоздатьНаборЗаписей();
	//	Для каждого ЭлемОтбора из НаборЗаписей.Отбор цикл
	//		ЭлемОтбора.Установить(стр[ЭлемОтбора.Имя]);	
	//	КонецЦикла;      
	//	НоваяСтр = НаборЗаписей.Добавить();
	//	ЗаполнитьЗначенияСвойств(НоваяСтр,стр);
	//	НаборЗаписей.Записать(рфЗамещать);
	//КонецЦикла;
	
	КэшНаборов = Кэш_СоздатьОбъектКэша();   
	НаборЗаписейДляОтбора = РегистрыСведений[рфИмяРегистра].СоздатьНаборЗаписей();
	Для каждого стр из рфДанные цикл
		
		Кэш_СброситьОтбор(КэшНаборов);
		
		Для каждого ЭлемОтбора из НаборЗаписейДляОтбора.Отбор цикл
			Кэш_УстановитьОтбор(КэшНаборов, ЭлемОтбора.Имя, стр[ЭлемОтбора.Имя]);	
		КонецЦикла; 
		
		НаборЗаписей = Кэш_ПолучитьПоТекущемуОтбору(КэшНаборов); 
		Если НаборЗаписей = Неопределено тогда
			НаборЗаписей = РегистрыСведений[рфИмяРегистра].СоздатьНаборЗаписей();
			Для каждого ЭлемОтбора из НаборЗаписей.Отбор цикл
				ЭлемОтбора.Установить(стр[ЭлемОтбора.Имя]);	
			КонецЦикла; 
			Кэш_ДобавитьПоТекущемуОтбору(КэшНаборов, НаборЗаписей);
		КонецЕсли;
		
		НоваяСтр = НаборЗаписей.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтр,стр);
		//НаборЗаписей.Записать(рфЗамещать);
	КонецЦикла;
	
	НаборыЗаписей = Кэш_ПолучитьЗначения(КэшНаборов);
	Для каждого Набор из НаборыЗаписей цикл
		Набор.Записать(рфЗамещать);	
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура Записать(Команда)
	ЗаписатьНаСервере();
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка) 
	
	рфЗамещать = Истина;
	
	Элементы.рфИмяРегистра.СписокВыбора.Очистить();
	Для каждого МетаМенеджер из Метаданные.РегистрыСведений цикл
		Элементы.рфИмяРегистра.СписокВыбора.Добавить(МетаМенеджер.Имя, МетаМенеджер.Имя + " | " + МетаМенеджер.Представление());		
	КонецЦикла;
	
	
КонецПроцедуры

&НаСервере
Процедура рфИмяРегистраПриИзмененииНаСервере()  
	
	рфОтбор.Очистить();   
	
	
	УдаляемыеРеквизиты = Новый Массив; 
	Для каждого ИмяРеквизита из СтрРазделить("рфДанные,рфОтборУстановка",",") цикл
		ТЗ = РеквизитФормыВЗначение(ИмяРеквизита); 
		Для каждого Колонка из ТЗ.Колонки цикл
			УдаляемыеРеквизиты.Добавить(ИмяРеквизита + "." + Колонка.Имя);		
		КонецЦикла; 	
	КонецЦикла;
	ИзменитьРеквизиты(,УдаляемыеРеквизиты);
	
	Для каждого ИмяРеквизита из СтрРазделить("рфДанные,рфОтборУстановка",",") цикл	
		Пока Элементы[ИмяРеквизита].ПодчиненныеЭлементы.Количество()<>0 цикл
			Элементы.Удалить(Элементы[ИмяРеквизита].ПодчиненныеЭлементы.Получить(0));
		КонецЦикла;
	КонецЦикла;
	
	
	Если ПустаяСтрока(рфИмяРегистра) тогда
		Возврат;
	КонецЕсли;
	
	МетаОб = Метаданные.РегистрыСведений.Найти(рфИмяРегистра);
	Если МетаОб = Неопределено тогда     
		Сообщить("Такого регистра нет.");
		Возврат;
	КонецЕсли;
	
	//ЭтоНуженПериод 		= МетаОб.ПериодичностьРегистраСведений <> Метаданные.СвойстваОбъектов.ПериодичностьРегистраСведений.Непериодический;
	//ЭтоНуженРегистратор = МетаОб.РежимЗаписи = Метаданные.СвойстваОбъектов.РежимЗаписиРегистра.ПодчинениеРегистратору; 
	
	СписокКоллекций = Новый Массив;           
	СписокКоллекций.Добавить("СтандартныеРеквизиты");
	СписокКоллекций.Добавить("Измерения");
	СписокКоллекций.Добавить("Ресурсы");
	СписокКоллекций.Добавить("Реквизиты");
	
	НовыеРеквизиты = Новый Массив;    	
	Для каждого ИмяКоллекции из СписокКоллекций цикл
		СписокРеквизитов = МетаОб[ИмяКоллекции];
		Для каждого ДанныеРеквизит из СписокРеквизитов цикл          
			Если ДанныеРеквизит.Тип.Типы().Найти(Тип("ХранилищеЗначения")) = Неопределено тогда
				НовыеРеквизиты.Добавить(Новый РеквизитФормы(ДанныеРеквизит.Имя, ДанныеРеквизит.Тип,"рфДанные",Лев(ИмяКоллекции,6)+"_"+ДанныеРеквизит.Имя));
			Иначе
				Сообщить("В реквизите: " + ДанныеРеквизит.Имя + " есть хранилище значения. Он пропущен.");	
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;                    
	
	
	НаборЗаписей = РегистрыСведений[рфИмяРегистра].СоздатьНаборЗаписей();
	Для каждого ЭлемОтбора из НаборЗаписей.Отбор цикл
		рфОтбор.Добавить(ЭлемОтбора.Имя);	
		НовыеРеквизиты.Добавить(Новый РеквизитФормы(ЭлемОтбора.Имя, ЭлемОтбора.ТипЗначения,"рфОтборУстановка"));
	КонецЦикла; 
	
	
	
	ИзменитьРеквизиты(НовыеРеквизиты);
	
	Для каждого ИмяРеквизита из СтрРазделить("рфДанные,рфОтборУстановка",",") цикл
		ТЗ = РеквизитФормыВЗначение(ИмяРеквизита);
		Для каждого колонка из ТЗ.Колонки цикл
			НовыйЭлемент = Элементы.Добавить(
			ИмяРеквизита + "_" + Колонка.Имя, Тип("ПолеФормы"), Элементы[ИмяРеквизита]
			);
			НовыйЭлемент.Вид = ВидПоляФормы.ПолеВвода;
			НовыйЭлемент.ПутьКДанным = ИмяРеквизита + "." + Колонка.Имя;
		КонецЦикла;
	КонецЦикла;
	
	
КонецПроцедуры

&НаКлиенте
Процедура рфИмяРегистраПриИзменении(Элемент)
	рфИмяРегистраПриИзмененииНаСервере();
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

&НаСервере
Функция ОчиститьРегистрыКонфигуратора__Заполнить()
	
	ВРежимеОтладкиПоправить = Истина;
	
	//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	//!!!!!!!!!!!!!!! точка остановки !!!!!!!!!!!!!!!!!
	//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	Если ВРежимеОтладкиПоправить тогда   
		Сообщить("Нужно точкой остановки включить.");
		Возврат Неопределено;
	КонецЕсли;
	
	МетаданныеПодчиненныхРегистратору = Новый Массив; 
	МетаданныеПодчиненныхРегистратору.Добавить(Новый Структура("ИмяМета,ДанныеПоРегистрам","РегистрыБухгалтерии", Новый Массив)); 
	МетаданныеПодчиненныхРегистратору.Добавить(Новый Структура("ИмяМета,ДанныеПоРегистрам","РегистрыНакопления", Новый Массив));
	
	Для каждого МетаОписание из МетаданныеПодчиненныхРегистратору цикл
		Для каждого МетаРег из Метаданные[МетаОписание.ИмяМета] цикл
			МетаОписание.ДанныеПоРегистрам.Добавить(Новый Структура("ПолноеИмя,Имя,КолУд",МетаРег.ПолноеИмя(),МетаРег.Имя,0));
		КонецЦикла;      
	КонецЦикла;
	
	Возврат МетаданныеПодчиненныхРегистратору;
	
КонецФункции

Функция КонкретныйРегистрОчистить(МетаОписание, КонкретныйРегДанные)  
	
	Если МетаОписание.ИмяМета = "РегистрыБухгалтерии" тогда
		МенеджерВсех = РегистрыБухгалтерии;		
	ИначеЕсли МетаОписание.ИмяМета = "РегистрыНакопления" тогда
		МенеджерВсех = РегистрыНакопления;		
	Иначе
		ВызватьИсключение МетаОписание.ИмяМета + " не обрабатывается.";	
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Регистр.Регистратор
	|ИЗ
	|	" + КонкретныйРегДанные.ПолноеИмя + " КАК Регистр";
	
	Выборка = Запрос.Выполнить().Выбрать();	
	Менеджер = МенеджерВсех[КонкретныйРегДанные.Имя]; 
	Пока Выборка.Следующий() Цикл          
		НаборЗаписей = Менеджер.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Регистратор.Установить(Выборка.Регистратор);   
		НаборЗаписей.Записать();
	КонецЦикла; 
	
	КонкретныйРегДанные.КолУд = Выборка.Количество();
	
КонецФункции

&НаКлиенте
Процедура ОчиститьРегистрыКонфигуратор(Команда)
	
	ИмяОбработчика = "ОбработкиОжидания_ОчисткаРегистров";
	ОтключитьОбработчикОжидания(ИмяОбработчика);
	глобал_ПараметрыОчисткиРегистров = ОчиститьРегистрыКонфигуратора__Заполнить(); 
	
	Если глобал_ПараметрыОчисткиРегистров = Неопределено тогда
		Возврат;
	КонецЕсли;
	//Для каждого МетаОписание из глобал_ПараметрыОчисткиРегистров цикл  
	//	
	//	Сообщить("Начато: " + МетаОписание.ИмяМета); 
	//	
	//	Для каждого КонкретныйРегДанные из МетаОписание.ДанныеПоРегистрам цикл
	//		КонкретныйРегистрОчистить(МетаОписание, КонкретныйРегДанные);
	//		Сообщить("Очищен: " + МетаОписание.ПолноеИмя + " в количестве: " + Строка(МетаОписание.КолУд) + ".");    
	//	КонецЦикла;  
	//	
	//КонецЦикла; 
	
	ПодключитьОбработчикОжидания(ИмяОбработчика, 0.2, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкиОжидания_ОчисткаРегистров() Экспорт 
	
	Если глобал_ПараметрыОчисткиРегистров.Количество()=0 тогда
		Сообщить("Завершено");
		Возврат;
	КонецЕсли;  
	
	ДанныеПоМенеджеру = глобал_ПараметрыОчисткиРегистров[0];
	Если ДанныеПоМенеджеру.ДанныеПоРегистрам.Количество() = 0 тогда
		глобал_ПараметрыОчисткиРегистров.Удалить(0);
	Иначе
		КонкретныйРегДанные = ДанныеПоМенеджеру.ДанныеПоРегистрам[0];
		КонкретныйРегистрОчистить(ДанныеПоМенеджеру, КонкретныйРегДанные);  
		глобал_ПараметрыОчисткиРегистров[0].ДанныеПоРегистрам.Удалить(0);                    
		Сообщить("Очищен: " + КонкретныйРегДанные.ПолноеИмя + " в количестве: " + Строка(КонкретныйРегДанные.КолУд) + ".");
	КонецЕсли;
	
	ПодключитьОбработчикОжидания("ОбработкиОжидания_ОчисткаРегистров", 0.2, Истина);
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьКолСтрокНаСервере()
	рфКоличествоСтрокРегистров.Очистить();
	СписокРегистров = Новый Массив;
	СписокРегистров.Добавить("РегистрыБухгалтерии");
	СписокРегистров.Добавить("РегистрыНакопления");
	СписокРегистров.Добавить("РегистрыСведений");
	Для каждого МетаТипРегистра из СписокРегистров цикл 
		
		Для каждого МетаРегистр из Метаданные[МетаТипРегистра] цикл  
			ЭтоЕстьРегистратор = Истина;
			Если МетаТипРегистра = "РегистрыСведений" тогда 
				ЭтоЕстьРегистратор = Метаданные["РегистрыСведений"][МетаРегистр.Имя].РежимЗаписи = Метаданные.СвойстваОбъектов.РежимЗаписиРегистра.ПодчинениеРегистратору;
			КонецЕсли; 
			
			Запрос = Новый Запрос;
			Запрос.Текст = 
			"ВЫБРАТЬ
			|	СУММА(1) КАК КоличествоСтрок
			|ИЗ
			|	" + МетаРегистр.ПолноеИмя() + " КАК Регистр";
			
			РезультатЗапроса = Запрос.Выполнить();
			
			ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
			
			ВыборкаДетальныеЗаписи.Следующий();
			
			Стр = рфКоличествоСтрокРегистров.Добавить();
			Стр.ИмяРегистра = МетаРегистр.ПолноеИмя();
			Стр.Представление = МетаРегистр.Синоним;
			Стр.Количество = ВыборкаДетальныеЗаписи.КоличествоСтрок;
		КонецЦикла;    
	КонецЦикла;
	рфКоличествоСтрокРегистров.Сортировать("Количество Desc");	
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьКолСтрок(Команда)
	ОбновитьКолСтрокНаСервере();
КонецПроцедуры

&НаСервере
Процедура ПрочитатьЗаписиНаСервере()  
	
	МетаОб = Метаданные.РегистрыСведений.Найти(рфИмяРегистра);
	Если МетаОб = Неопределено тогда     
		Сообщить("Такого регистра нет.");
		Возврат;
	КонецЕсли;  
	
	рфДанные.Очистить();
	
	СписокНаборов = Новый Массив;
	ВыводитьПоРегистратору = МетаОб.РежимЗаписи = Метаданные.СвойстваОбъектов.РежимЗаписиРегистра.ПодчинениеРегистратору;
	
	Если рфОтборУстановка.Количество() = 0 тогда
		Если НЕ ВыводитьПоРегистратору тогда  
			
			Набор = РегистрыСведений[рфИмяРегистра].СоздатьНаборЗаписей();	
			Набор.Прочитать();
			СписокНаборов.Добавить(Набор); 
			
		Иначе  
			
			Запрос = Новый Запрос;
			Запрос.Текст = 
			"ВЫБРАТЬ Различные
			|	Регистратор КАК Регистратор
			|ИЗ
			|	" + МетаОб.ПолноеИмя() + " КАК Регистр";
			
			РезультатЗапроса = Запрос.Выполнить();
			
			ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
			
			Пока ВыборкаДетальныеЗаписи.Следующий() цикл
				Набор = РегистрыСведений[рфИмяРегистра].СоздатьНаборЗаписей();
				Набор.Отбор.Регистратор.Установить(ВыборкаДетальныеЗаписи.Регистратор);
				Набор.Прочитать();
				СписокНаборов.Добавить(Набор);
			КонецЦикла;
			
		КонецЕсли; 
		
	Иначе 
		ТЗ = РеквизитФормыВЗначение("рфОтборУстановка");
		Для каждого стр из ТЗ цикл 
			Набор = РегистрыСведений[рфИмяРегистра].СоздатьНаборЗаписей();
			Для каждого колонка из ТЗ.Колонки цикл 
				Набор.Отбор[колонка.Имя].Установить(стр[колонка.Имя]);   
			КонецЦикла;
			Набор.Прочитать();
			СписокНаборов.Добавить(Набор);
		КонецЦикла;	
	КонецЕсли;
	
	Для каждого Набор из СписокНаборов цикл
		
		Для каждого Стр из Набор цикл
			СтрВывод = рфДанные.Добавить();
			ЗаполнитьЗначенияСвойств(СтрВывод, Стр);
		КонецЦикла;  
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПрочитатьЗаписи(Команда)
	ПрочитатьЗаписиНаСервере();
КонецПроцедуры
