﻿

#Область ОписаниеПеременных

&НаКлиенте
Перем глобал_ВыделеннаяСтрока;

#КонецОбласти

#Область ОбработчикиСобытийФормы

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура рфУзелПриИзменении(Элемент)
	
	ОбновитьДанныеДляОтправкиНаСервере();   
	Для каждого стрУровень1 из рфМетаСостав.ПолучитьЭлементы() цикл
		Элементы.рфМетаСостав.Развернуть(стрУровень1.ПолучитьИдентификатор(), Истина);	
	КонецЦикла;      
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы

&НаКлиенте
Процедура рфМетаСоставПриАктивизацииСтроки(Элемент)
	
	Если Элементы.рфМетаСостав.ТекущаяСтрока = Неопределено тогда
		Возврат;
	КонецЕсли;  
	СтрокаДерева = рфМетаСостав.НайтиПоИдентификатору(Элементы.рфМетаСостав.ТекущаяСтрока);
	Если СтрокаДерева = Неопределено тогда
		Возврат;
	КонецЕсли;
	Если СтрокаДерева.ПолучитьРодителя() = Неопределено тогда
		Возврат;//Первый уровень мета об
	КонецЕсли;  
	Если Элементы.рфМетаСостав.ТекущаяСтрока <> глобал_ВыделеннаяСтрока тогда
		глобал_ВыделеннаяСтрока = Элементы.рфМетаСостав.ТекущаяСтрока;
		ПодключитьОбработчикОжидания("Обработчик_ОбновитьОтправляемыйСостав",0.1,Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура рфОтправляемыеОбъектыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Элемент.ТекущиеДанные = Неопределено тогда
		Возврат;
	КонецЕсли;
	ИмяРеквизитаПоля = Сред(Поле.Имя, СтрДлина(Элемент.Имя)+1);
	ДанныеРеквизита = Неопределено;
	Если Элемент.ТекущиеДанные.Свойство(ИмяРеквизитаПоля, ДанныеРеквизита) тогда
		ПоказатьЗначение(, ДанныеРеквизита);	
	КонецЕсли;

КонецПроцедуры


#КонецОбласти

#Область ОбработчикиКомандФормы
// Код процедур и функций
#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ОбновитьДанныеДляОтправкиНаСервере()
	
	Состав = рфУзел.Метаданные().Состав; 	  
	
	ШаблонТеста = 
	"ВЫБРАТЬ
	|	""&ИмяТаблицы"" КАК МетаПолноеИмя,
	|	ИмяТаблицыМетаданных.Узел КАК УзелОбмена,
	|	КОЛИЧЕСТВО(*) КАК КоличествоИзменений,
	|	КОЛИЧЕСТВО(ИмяТаблицыМетаданных.НомерСообщения) КАК КоличествоВыгруженных,
	|	КОЛИЧЕСТВО(*) - КОЛИЧЕСТВО(ИмяТаблицыМетаданных.НомерСообщения) КАК КоличествоНеВыгруженных
	|ИЗ
	|	&ИмяТаблицы.Изменения КАК ИмяТаблицыМетаданных
	|ГДЕ
	|	ИмяТаблицыМетаданных.Узел = &Узел
	|
	|СГРУППИРОВАТЬ ПО
	|	ИмяТаблицыМетаданных.Узел";
	
	МассивТекстовЗапроса = Новый Массив;
	Для каждого Элемент Из Состав Цикл
		
		ПолноеИмяМетаОб = Элемент.Метаданные.ПолноеИмя();
		ТекстЗапроса = СтрЗаменить(ШаблонТеста, "&ИмяТаблицы", ПолноеИмяМетаОб);
		МассивТекстовЗапроса.Добавить(ТекстЗапроса);
	КонецЦикла;
	
	ФинальныйТекстЗапроса = СтрСоединить(МассивТекстовЗапроса, Символы.ПС + " Объединить все " + Символы.ПС);
	
	Запрос = Новый Запрос;
	Запрос.Текст = ФинальныйТекстЗапроса;
	Запрос.УстановитьПараметр("Узел", рфУзел);
	
	РезультатЗапроса = Запрос.Выполнить();
	Выборка = РезультатЗапроса.Выбрать();
	
	рфМетаСостав.ПолучитьЭлементы().Очистить();
	ПоискПоТипамМетаданных = Новый Соответствие;
	Для каждого Элемент Из Состав Цикл
		ТипТаблицыМета = Лев(Элемент.Метаданные.ПолноеИмя(), СтрНайти(Элемент.Метаданные.ПолноеИмя(),".")-1);
		РодСтр = ПоискПоТипамМетаданных[ТипТаблицыМета];	
		Если РодСтр = Неопределено тогда
			РодСтр = рфМетаСостав.ПолучитьЭлементы().Добавить();
			РодСтр.ПолноеИмя = ТипТаблицыМета;
			ПоискПоТипамМетаданных.Вставить(ТипТаблицыМета, РодСтр);
		КонецЕсли; 
		
		Выборка.Сбросить();
		ДочерняяСтрока = РодСтр.ПолучитьЭлементы().Добавить();
		ДочерняяСтрока.ПолноеИмя = Элемент.Метаданные.ПолноеИмя();
		ДочерняяСтрока.Авторегистрация = Строка(Элемент.АвтоРегистрация);
		ДочерняяСтрока.Всего = 0;
		ДочерняяСтрока.Выгружено = 0;
		ДочерняяСтрока.НеВыгружено = 0;
		Если Выборка.НайтиСледующий(Новый Структура("МетаПолноеИмя",Элемент.Метаданные.ПолноеИмя())) тогда
			ДочерняяСтрока.Всего = Выборка.КоличествоИзменений;
			ДочерняяСтрока.Выгружено = Выборка.КоличествоВыгруженных;
			ДочерняяСтрока.НеВыгружено = Выборка.КоличествоНеВыгруженных;
		КонецЕсли;
		
	КонецЦикла;	
	
КонецПроцедуры

&НаКлиенте
Процедура Обработчик_ОбновитьОтправляемыйСостав()  
	
	Ид = Элементы.рфМетаСостав.ТекущаяСтрока;
	Если Ид = Неопределено тогда
		Возврат;
	КонецЕсли;
	СтрокаДерева = рфМетаСостав.НайтиПоИдентификатору(Ид);
	Если СтрокаДерева = Неопределено тогда
		Возврат;
	КонецЕсли;
	Если СтрокаДерева.ПолучитьРодителя() = Неопределено тогда
		Возврат;//Первый уровень мета об
	КонецЕсли;
	
	ПолноеИмяМета = СтрокаДерева.ПолноеИмя; 
	ЗапускГенерацияДинСписка("рфОтправляемыеОбъекты", ПолноеИмяМета);

КонецПроцедуры

Процедура ЗапускГенерацияДинСписка(ИмяДинСписка, ПолноеИмяМета)
	
	реквизитДинСписок = ЭтаФорма[ИмяДинСписка];  

	ШаблонТеста = 
	"ВЫБРАТЬ
	|	*
	|ИЗ
	|	&ИмяТаблицы.Изменения КАК ИмяТаблицыМетаданных
	|ГДЕ
	|	ИмяТаблицыМетаданных.Узел = &Узел";
	//
	ФинальныйТекстЗапроса = СтрЗаменить(ШаблонТеста, "&ИмяТаблицы", ПолноеИмяМета); 
	реквизитДинСписок.ТекстЗапроса = ФинальныйТекстЗапроса;
	реквизитДинСписок.ПроизвольныйЗапрос = Истина;
	//реквизитДинСписок.ОсновнаяТаблица = рфТипОбъекта;
	реквизитДинСписок.ДинамическоеСчитываниеДанных = Истина;  
	
	реквизитДинСписок.Параметры.УстановитьЗначениеПараметра("Узел", рфУзел);
	Пока Элементы[ИмяДинСписка].ПодчиненныеЭлементы.Количество()>0 цикл
		ЭтаФорма.Элементы.Удалить(Элементы[ИмяДинСписка].ПодчиненныеЭлементы[0]);	
	КонецЦикла; 
	
	Для каждого Элем из реквизитДинСписок.КомпоновщикНастроек.Настройки.ДоступныеПоляВыбора.Элементы цикл
		
		Если Элем.ТипЗначения.СодержитТип(Тип("МоментВремени")) тогда
			Продолжить;
		КонецЕсли; 
		Если Элем.ТипЗначения.СодержитТип(Тип("ХранилищеЗначения")) тогда
			Продолжить;
		КонецЕсли;
		Если Элем.ТипЗначения.Типы().Количество() = 0 тогда
			Продолжить;		
		КонецЕсли;
		
		ИмяРеквизитаТаблицы = ИмяДинСписка;	
		Префикс = ИмяРеквизитаТаблицы;
		Родитель = Элементы[ИмяДинСписка];
		ТекИмя = Строка(Элем.Поле);
		ЭлементФормы = Элементы.Вставить(Префикс + ТекИмя, Тип("ПолеФормы"), Родитель);
		ЭлементФормы.Вид = ВидПоляФормы.ПолеВвода;
		ЭлементФормы.ПутьКДанным = ИмяРеквизитаТаблицы + "." + ТекИмя;
		ЭлементФормы.Заголовок = Элем.Заголовок;  
		ЭлементФормы.КнопкаОткрытия = Истина;  
		
	КонецЦикла;
	
	Для каждого ТипНастроек из реквизитДинСписок.КомпоновщикНастроек.ПользовательскиеНастройки.Элементы цикл
		Если ТипЗнч(ТипНастроек) = Тип("ОтборКомпоновкиДанных") ИЛИ 
			ТипЗнч(ТипНастроек) = Тип("ПорядокКомпоновкиДанных") ИЛИ 
			ТипЗнч(ТипНастроек) = Тип("УсловноеОформлениеКомпоновкиДанных") тогда
			ТипНастроек.Элементы.Очистить();	
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

